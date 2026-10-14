import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:peria_app/core/repositories/user_repository.dart';
import 'package:peria_app/core/services/privacy_policy_consent_service.dart';
import 'package:peria_app/core/storage/hive_boxes.dart';
import 'package:peria_app/core/storage/journal_sync_preferences.dart';
import 'package:peria_app/features/journal/data/models/journal_entry.dart';

/// Encrypted local journal storage with consent-gated, optional Firestore sync.
///
/// The local Hive boxes are the source of truth. Firestore is never read or
/// written until the user has explicitly enabled cloud sync for the current
/// account on this device.
class JournalFirestoreRepository {
  JournalFirestoreRepository({
    UserRepository? userRepository,
    JournalSyncPreferences? syncPreferences,
    FirebaseFirestore? firestore,
  })  : _userRepository = userRepository ?? UserRepository(),
        _syncPreferences = syncPreferences ?? const JournalSyncPreferences(),
        _firestore = firestore ?? FirebaseFirestore.instance;

  static const String _clearAllTombstoneKey = '__journal_clear_all__';
  static const int _maxBatchOperations = 450;
  static const Duration _cloudRequestTimeout = Duration(seconds: 20);

  final UserRepository _userRepository;
  final JournalSyncPreferences _syncPreferences;
  final FirebaseFirestore _firestore;

  Future<void> _localQueue = Future<void>.value();
  Future<void> _cloudQueue = Future<void>.value();
  final Map<String, Future<List<JournalEntry>>> _syncsInFlight = {};

  void _log(String message) {
    if (kDebugMode) {
      debugPrint('[JournalFirestoreRepository] $message');
    }
  }

  Box<JournalEntry> get _entriesBox =>
      Hive.box<JournalEntry>(HiveBoxes.journalEntries);

  Box<String> get _tombstonesBox =>
      Hive.box<String>(HiveBoxes.journalTombstones);

  Future<void> initHive() async {
    if (!Hive.isBoxOpen(HiveBoxes.journalEntries) ||
        !Hive.isBoxOpen(HiveBoxes.journalTombstones)) {
      throw StateError(
        'Journal Hive boxes are not open. Call HiveSetup.init() before using the journal.',
      );
    }
  }

  /// Reads only the encrypted local cache. This method never contacts Firebase.
  Future<List<JournalEntry>> loadEntries() async {
    await initHive();
    return _withLocalLock(_loadFromHive);
  }

  Future<bool> isCloudSyncEnabled() async {
    final userId = _currentUserIdOrNull();
    if (userId == null) return false;
    return _hasCloudConsent(userId);
  }

  Future<DateTime?> lastSyncedAt() async {
    final userId = _currentUserIdOrNull();
    if (userId == null) return null;
    return _syncPreferences.lastSyncedAt(userId);
  }

  Future<bool> lastSyncAttemptFailed() async {
    final userId = _currentUserIdOrNull();
    if (userId == null) return false;
    return _syncPreferences.lastAttemptFailed(userId);
  }

  /// Saves local consent for the currently signed-in account.
  Future<void> enableCloudSync() async {
    PrivacyPolicyConsentService.requireCurrentPolicyAcceptance();
    final userId = _userRepository.currentUid;
    await _syncPreferences.enable(userId: userId);
  }

  /// Reconciles local and remote entries after the user has opted in.
  ///
  /// Local entries win ties. Remote entries win only when their updatedAt is
  /// newer. Local edits and deletion tombstones are then uploaded/deleted.
  Future<List<JournalEntry>> syncWithCloud() async {
    final userId = _currentUserIdOrNull();
    if (userId == null) {
      throw StateError('Journal cloud sync requires a signed-in account.');
    }
    return _syncWithCloudFor(userId);
  }

  Future<List<JournalEntry>> _syncWithCloudFor(String userId) {
    final currentSync = _syncsInFlight[userId];
    if (currentSync != null) return currentSync;

    late Future<List<JournalEntry>> trackedSync;
    trackedSync = _performCloudSync(userId).whenComplete(() {
      if (identical(_syncsInFlight[userId], trackedSync)) {
        _syncsInFlight.remove(userId);
      }
    });
    _syncsInFlight[userId] = trackedSync;
    return trackedSync;
  }

  Future<List<JournalEntry>> _performCloudSync(String userId) async {
    PrivacyPolicyConsentService.requireCurrentPolicyAcceptance();
    await initHive();
    if (!await _hasCloudConsent(userId)) {
      throw StateError('Journal cloud sync has not been enabled for this account.');
    }

    final collection = _journalCollectionFor(userId);
    try {
      // A server read avoids presenting a stale Firestore cache as a completed
      // sync. If the device is offline, the caller keeps using the Hive copy.
      final snapshot = await collection.get(
        const GetOptions(source: Source.server),
      );
      if (!await _hasCloudConsent(userId)) return loadEntries();

      late List<JournalEntry> mergedEntries;
      late Future<void> cloudChanges;

      // Merge against the latest local state, not the state from before the
      // network request. The lock also orders a concurrent save/delete safely.
      await _withLocalLock(() async {
        if (!await _hasCloudConsent(userId)) {
          mergedEntries = _loadFromHive();
          cloudChanges = Future<void>.value();
          return;
        }

        final localEntries = _loadFromHive();
        final tombstonesAtStart = _readTombstones();
        final clearAllAt = _parseDate(
          tombstonesAtStart[_clearAllTombstoneKey],
        );
        final individuallyDeleted = tombstonesAtStart.keys
            .where((key) => key != _clearAllTombstoneKey)
            .toSet();
        final remoteEntries = <String, JournalEntry>{};
        final remoteDocumentsToDelete =
            <DocumentReference<Map<String, dynamic>>>[];

        for (final document in snapshot.docs) {
          if (individuallyDeleted.contains(document.id)) {
            remoteDocumentsToDelete.add(document.reference);
            continue;
          }

          try {
            final data = Map<String, dynamic>.from(document.data())
              ..['id'] = document.id;
            final entry = JournalEntry.fromJson(data);
            if (clearAllAt != null && !entry.updatedAt.isAfter(clearAllAt)) {
              remoteDocumentsToDelete.add(document.reference);
              continue;
            }
            remoteEntries[entry.id] = entry;
          } catch (error) {
            // Do not let one malformed legacy document hide valid local notes.
            _log('ignoring malformed cloud entry ${document.id}: $error');
          }
        }

        final localById = {for (final entry in localEntries) entry.id: entry};
        final mergedById = Map<String, JournalEntry>.from(localById);
        final entriesToUpload = <JournalEntry>[];

        for (final remoteEntry in remoteEntries.values) {
          final localEntry = localById[remoteEntry.id];
          if (localEntry == null ||
              remoteEntry.updatedAt.isAfter(localEntry.updatedAt)) {
            mergedById[remoteEntry.id] = remoteEntry;
          }
        }

        for (final localEntry in localEntries) {
          final remoteEntry = remoteEntries[localEntry.id];
          if (remoteEntry == null ||
              (!remoteEntry.updatedAt.isAfter(localEntry.updatedAt) &&
                  jsonEncode(remoteEntry.toJson()) !=
                      jsonEncode(localEntry.toJson()))) {
            entriesToUpload.add(localEntry);
          }
        }

        mergedEntries = mergedById.values.toList()
          ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        await _saveToHive(mergedEntries);

        // Enqueue cloud changes while holding the local lock. Any subsequent
        // user edit is queued after this reconciliation and cannot be replaced
        // by an older batch upload.
        cloudChanges = _enqueueCloudOperation(
          'journal reconciliation',
          userId,
          () async {
            if (!await _hasCloudConsent(userId)) return;

            await _commitCloudDeletes(
              userId,
              remoteDocumentsToDelete,
            );
            if (!await _hasCloudConsent(userId)) return;

            await _commitCloudWrites(
              userId,
              collection,
              entriesToUpload,
            );
            if (!await _hasCloudConsent(userId)) return;

            await _withLocalLock(() async {
              for (final tombstone in tombstonesAtStart.entries) {
                if (_tombstonesBox.get(tombstone.key) == tombstone.value) {
                  await _tombstonesBox.delete(tombstone.key);
                }
              }
            });
            await _syncPreferences.markSynced(userId, DateTime.now());
          },
        );
      });

      await cloudChanges;
      _log('cloud sync completed for ${mergedEntries.length} journal entries');
      // A local edit can have happened while Firestore was processing the
      // batch. Return the current encrypted cache so the UI never rolls it back.
      return loadEntries();
    } catch (error) {
      await _syncPreferences.markSyncFailed(userId);
      _log('cloud sync failed; encrypted local journal remains available: $error');
      rethrow;
    }
  }

  /// Saves to encrypted Hive first; cloud upload is detached and only runs
  /// after the user has opted in. The editor can return as soon as Hive saves.
  Future<void> saveEntry(JournalEntry entry) async {
    await initHive();
    final userId = await _consentedUserId();

    await _withLocalLock(() async {
      await _tombstonesBox.delete(entry.id);
      await _entriesBox.put(entry.id, entry);

      if (userId == null) return;
      final collection = _journalCollectionFor(userId);
      _scheduleCloudOperation('entry upload ${entry.id}', userId, () async {
        if (!await _hasCloudConsent(userId)) return;
        await collection.doc(entry.id).set(entry.toJson());
        if (await _hasCloudConsent(userId)) {
          await _syncPreferences.markSynced(userId, DateTime.now());
        }
      });
    });
  }

  Future<void> upsert(JournalEntry entry) => saveEntry(entry);

  /// Persists an encrypted deletion marker even while offline or opted out so
  /// a later opt-in cannot restore a note the user deliberately deleted.
  Future<void> delete(String id) async {
    await initHive();
    final userId = await _consentedUserId();
    await _withLocalLock(() async {
      await _tombstonesBox.put(id, DateTime.now().toIso8601String());
      await _entriesBox.delete(id);

      if (userId == null) return;
      final collection = _journalCollectionFor(userId);
      _scheduleCloudOperation('entry deletion $id', userId, () async {
        if (!await _hasCloudConsent(userId)) return;
        await collection.doc(id).delete();
        if (await _hasCloudConsent(userId)) {
          await _withLocalLock(() => _tombstonesBox.delete(id));
          await _syncPreferences.markSynced(userId, DateTime.now());
        }
      });
    });
  }

  Future<void> clearAll() async {
    await initHive();
    final userId = await _consentedUserId();
    await _withLocalLock(() async {
      await _tombstonesBox.put(
        _clearAllTombstoneKey,
        DateTime.now().toIso8601String(),
      );
      await _entriesBox.clear();
    });

    if (userId != null) {
      unawaited(_syncInBackground(userId));
    }
  }

  Future<void> _syncInBackground(String userId) async {
    final activeSync = _syncsInFlight[userId];
    if (activeSync != null) {
      try {
        await activeSync;
      } catch (_) {
        // A second attempt below can succeed after the user's latest action.
      }
    }

    if (!await _hasCloudConsent(userId)) return;
    try {
      await _syncWithCloudFor(userId);
    } catch (error) {
      _log('background journal reconciliation failed: $error');
    }
  }

  /// Deletes Firestore copies only when directly requested by the user.
  /// This is intentionally allowed when sync is off, so someone upgrading
  /// from a previous build can remove any old, previously uploaded copy.
  Future<void> deleteCloudEntries() async {
    await initHive();
    final userId = _userRepository.currentUid;
    final collection = _journalCollectionFor(userId);
    await _cloudQueue.timeout(_cloudRequestTimeout);
    _ensureSameCurrentUser(userId);
    // Wait for any Firestore SDK write queued before this explicit deletion,
    // including writes restored from disk after an app restart.
    await _firestore.waitForPendingWrites().timeout(_cloudRequestTimeout);
    _ensureSameCurrentUser(userId);

    final snapshot = await collection
        .get(const GetOptions(source: Source.server))
        .timeout(_cloudRequestTimeout);
    final documents = snapshot.docs;

    for (var start = 0; start < documents.length; start += _maxBatchOperations) {
      _ensureSameCurrentUser(userId);
      final end = (start + _maxBatchOperations < documents.length)
          ? start + _maxBatchOperations
          : documents.length;
      final batch = _firestore.batch();
      for (final document in documents.sublist(start, end)) {
        batch.delete(document.reference);
      }
      await batch.commit().timeout(_cloudRequestTimeout);
    }

    _ensureSameCurrentUser(userId);
    await _syncPreferences.markCloudCopyDeleted(userId);
    _log('deleted ${documents.length} journal documents from Firestore');
  }

  Future<void> _commitCloudDeletes(
    String userId,
    List<DocumentReference<Map<String, dynamic>>> documents,
  ) async {
    for (var start = 0; start < documents.length; start += _maxBatchOperations) {
      if (!await _hasCloudConsent(userId)) return;
      final end = (start + _maxBatchOperations < documents.length)
          ? start + _maxBatchOperations
          : documents.length;
      final batch = _firestore.batch();
      for (final document in documents.sublist(start, end)) {
        batch.delete(document);
      }
      await batch.commit();
    }
  }

  Future<void> _commitCloudWrites(
    String userId,
    CollectionReference<Map<String, dynamic>> collection,
    List<JournalEntry> entries,
  ) async {
    for (var start = 0; start < entries.length; start += _maxBatchOperations) {
      if (!await _hasCloudConsent(userId)) return;
      final end = (start + _maxBatchOperations < entries.length)
          ? start + _maxBatchOperations
          : entries.length;
      final batch = _firestore.batch();
      for (final entry in entries.sublist(start, end)) {
        batch.set(collection.doc(entry.id), entry.toJson());
      }
      await batch.commit();
    }
  }

  List<JournalEntry> _loadFromHive() {
    final clearAllAt = _parseDate(_tombstonesBox.get(_clearAllTombstoneKey));
    final entries = _entriesBox.values.where((entry) {
      if (_tombstonesBox.containsKey(entry.id)) return false;
      if (clearAllAt != null && !entry.updatedAt.isAfter(clearAllAt)) {
        return false;
      }
      return true;
    }).toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return entries;
  }

  Future<void> _saveToHive(List<JournalEntry> entries) async {
    final retainedIds = entries.map((entry) => entry.id).toSet();
    final staleIds = _entriesBox.keys
        .map((key) => key.toString())
        .where((id) => !retainedIds.contains(id))
        .toList();
    if (staleIds.isNotEmpty) {
      await _entriesBox.deleteAll(staleIds);
    }
    if (entries.isNotEmpty) {
      await _entriesBox.putAll({
        for (final entry in entries) entry.id: entry,
      });
    }
  }

  Stream<List<JournalEntry>> watchEntries() async* {
    await initHive();
    final userId = _currentUserIdOrNull();
    if (userId == null || !await _hasCloudConsent(userId)) {
      yield await loadEntries();
      return;
    }

    final collection = _journalCollectionFor(userId);
    await for (final snapshot in collection
        .orderBy('updatedAt', descending: true)
        .snapshots()) {
      if (!await _hasCloudConsent(userId)) {
        yield await loadEntries();
        return;
      }
      final entries = snapshot.docs
          .where((document) => !_tombstonesBox.containsKey(document.id))
          .map((document) {
            final data = Map<String, dynamic>.from(document.data())
              ..['id'] = document.id;
            return JournalEntry.fromJson(data);
          })
          .where((entry) => !_isOlderThanClearAll(entry))
          .toList();
      yield entries;
    }
  }

  CollectionReference<Map<String, dynamic>> _journalCollectionFor(
    String userId,
  ) =>
      _userRepository.userCollectionFor(userId, 'journal');

  String? _currentUserIdOrNull() {
    try {
      return _userRepository.currentUid;
    } on StateError {
      return null;
    }
  }

  Future<String?> _consentedUserId() async {
    final userId = _currentUserIdOrNull();
    if (userId == null || !await _hasCloudConsent(userId)) return null;
    return userId;
  }

  Future<bool> _hasCloudConsent(String userId) async {
    if (_currentUserIdOrNull() != userId) return false;
    final hasConsent = await _syncPreferences.isEnabledFor(userId);
    return hasConsent && _currentUserIdOrNull() == userId;
  }

  void _ensureSameCurrentUser(String userId) {
    if (_currentUserIdOrNull() != userId) {
      throw StateError('The active account changed during journal cloud sync.');
    }
  }

  bool _isOlderThanClearAll(JournalEntry entry) {
    final clearAllAt = _parseDate(_tombstonesBox.get(_clearAllTombstoneKey));
    return clearAllAt != null && !entry.updatedAt.isAfter(clearAllAt);
  }

  Map<String, String> _readTombstones() {
    final tombstones = <String, String>{};
    for (final key in _tombstonesBox.keys) {
      final value = _tombstonesBox.get(key);
      if (value is String) {
        tombstones[key.toString()] = value;
      }
    }
    return tombstones;
  }

  DateTime? _parseDate(String? value) {
    if (value == null) return null;
    return DateTime.tryParse(value);
  }

  Future<T> _withLocalLock<T>(FutureOr<T> Function() action) async {
    final previous = _localQueue;
    final release = Completer<void>();
    _localQueue = release.future;
    await previous;
    try {
      return await action();
    } finally {
      release.complete();
    }
  }

  Future<void> _enqueueCloudOperation(
    String label,
    String userId,
    Future<void> Function() operation,
  ) {
    final previous = _cloudQueue;
    final result = _runCloudOperation(previous, label, userId, operation);
    _cloudQueue = result.then<void>(
      (_) {},
      onError: (Object error, StackTrace stackTrace) {
        // Keep the queue usable after an individual Firebase error.
      },
    );
    return result;
  }

  Future<void> _runCloudOperation(
    Future<void> previous,
    String label,
    String userId,
    Future<void> Function() operation,
  ) async {
    await previous;
    try {
      await operation();
    } catch (error) {
      await _syncPreferences.markSyncFailed(userId);
      _log('$label failed: $error');
      rethrow;
    }
  }

  void _scheduleCloudOperation(
    String label,
    String userId,
    Future<void> Function() operation,
  ) {
    unawaited(_enqueueCloudOperation(label, userId, operation).catchError(
      (Object error, StackTrace stackTrace) {
        // The repository persists a generic sync-failed flag for the settings
        // screen; avoid leaking entry text or Firestore payloads to the UI.
      },
    ));
  }
}
