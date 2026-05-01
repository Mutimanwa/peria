import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:peria_app/core/repositories/user_repository.dart';
import 'package:peria_app/features/journal/data/models/journal_entry.dart';

class JournalFirestoreRepository {
  JournalFirestoreRepository({
    UserRepository? userRepository,
  }) : _userRepository = userRepository ?? UserRepository();

  final UserRepository _userRepository;
  static const String _hiveBoxName = 'journal_entries';
  late Box<Map<String, dynamic>> _hiveBox;

  void _log(String message) {
    if (kDebugMode) {
      debugPrint('[JournalFirestoreRepository] $message');
    }
  }

  /// Initialize Hive box for offline storage
  Future<void> initHive() async {
    if (!Hive.isBoxOpen(_hiveBoxName)) {
      _hiveBox = await Hive.openBox<Map<String, dynamic>>(_hiveBoxName);
      _log('Hive box opened: $_hiveBoxName');
    } else {
      _hiveBox = Hive.box(_hiveBoxName);
    }
  }

  CollectionReference<Map<String, dynamic>> get _journalCollection {
    return _userRepository.userCollection('journal');
  }

  Future<void> ensureInitialized() {
    _log('ensureInitialized');
    return _userRepository.ensureUserDocument();
  }

  /// Load from Hive cache first (instant), then sync with Firestore
  Future<List<JournalEntry>> loadEntries() async {
    await ensureInitialized();
    await initHive();
    
    _log('loading entries from Hive cache');
    final cachedEntries = _loadFromHive();
    if (cachedEntries.isNotEmpty) {
      _log('loaded ${cachedEntries.length} entries from cache');
    }
    
    // Then fetch from Firestore in background
    _log('fetching entries from Firestore: users/${_userRepository.currentUid}/journal');
    try {
      final snap = await _journalCollection
          .orderBy('updatedAt', descending: true)
          .get();
      _log('fetched ${snap.docs.length} entries from Firestore');
      
      final entries = snap.docs
          .map((doc) => JournalEntry.fromJson(doc.data()))
          .toList();
      
      // Persist to Hive
      await _saveToHive(entries);
      _log('synced ${entries.length} entries to Hive cache');
      
      return entries;
    } catch (e) {
      _log('Firestore fetch failed, returning cached entries: $e');
      return cachedEntries;
    }
  }

  /// Load all entries from Hive (synchronous within async context)
  List<JournalEntry> _loadFromHive() {
    try {
      final keys = _hiveBox.keys.toList();
      final entries = <JournalEntry>[];
      for (final key in keys) {
        final json = _hiveBox.get(key);
        if (json != null) {
          entries.add(JournalEntry.fromJson(json));
        }
      }
      entries.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      return entries;
    } catch (e) {
      _log('Error loading from Hive: $e');
      return [];
    }
  }

  /// Save entries to Hive cache
  Future<void> _saveToHive(List<JournalEntry> entries) async {
    try {
      final map = <String, Map<String, dynamic>>{};
      for (final entry in entries) {
        map[entry.id] = entry.toJson();
      }
      await _hiveBox.putAll(map);
    } catch (e) {
      _log('Error saving to Hive: $e');
    }
  }

  Future<void> saveEntry(JournalEntry entry) async {
    await ensureInitialized();
    await initHive();
    
    _log('saving journal entry id=${entry.id}');
    
    // Save to Hive immediately (offline-first)
    await _hiveBox.put(entry.id, entry.toJson());
    _log('saved to Hive cache: id=${entry.id}');
    
    // Then sync to Firestore
    try {
      await _journalCollection.doc(entry.id).set(entry.toJson());
      _log('synced to Firestore: id=${entry.id}');
    } catch (e) {
      _log('Firestore sync failed (will retry): $e');
    }
  }

  Future<void> upsert(JournalEntry entry) async {
    await saveEntry(entry);
  }

  Future<void> delete(String id) async {
    await ensureInitialized();
    await initHive();
    
    _log('deleting journal entry id=$id');
    
    // Remove from Hive immediately
    await _hiveBox.delete(id);
    _log('deleted from Hive: id=$id');
    
    // Then sync deletion to Firestore
    try {
      await _journalCollection.doc(id).delete();
      _log('synced deletion to Firestore: id=$id');
    } catch (e) {
      _log('Firestore deletion failed (will retry): $e');
    }
  }

  Future<void> clearAll() async {
    await ensureInitialized();
    await initHive();
    
    _log('clearing all journal entries');
    
    // Clear Hive
    await _hiveBox.clear();
    _log('cleared Hive cache');
    
    // Then clear Firestore
    try {
      final snap = await _journalCollection.get();
      final batch = FirebaseFirestore.instance.batch();
      for (final doc in snap.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
      _log('cleared ${snap.docs.length} entries from Firestore');
    } catch (e) {
      _log('Firestore clear failed: $e');
    }
  }

  Stream<List<JournalEntry>> watchEntries() async* {
    await ensureInitialized();
    yield* _journalCollection
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => JournalEntry.fromJson(doc.data()))
            .toList());
  }
}
