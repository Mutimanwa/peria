import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peria_app/core/repositories/user_repository.dart';
import 'package:peria_app/core/storage/journal_sync_preferences.dart';
import 'package:peria_app/features/cycle/presentation/providers/cycle_provider.dart';
import 'package:peria_app/features/journal/data/models/journal_entry.dart';
import 'package:peria_app/features/journal/data/repositories/journal_firestore_repository.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

final journalSyncPreferencesProvider = Provider<JournalSyncPreferences>((ref) {
  return const JournalSyncPreferences();
});

final journalRepositoryProvider = Provider<JournalFirestoreRepository>((ref) {
  return JournalFirestoreRepository(
    userRepository: ref.read(userRepositoryProvider),
    syncPreferences: ref.read(journalSyncPreferencesProvider),
  );
});

final journalProvider =
    StateNotifierProvider<JournalNotifier, AsyncValue<List<JournalEntry>>>(
        (ref) {
  final repository = ref.read(journalRepositoryProvider);
  return JournalNotifier(repository);
});

DateTime _normalizeJournalDay(DateTime value) =>
    DateTime(value.year, value.month, value.day);

final journalDaysProvider = Provider<Set<DateTime>>((ref) {
  final entries = ref.watch(journalProvider).value ?? const <JournalEntry>[];
  return entries
      .where((entry) =>
          entry.title.trim().isNotEmpty || entry.content.trim().isNotEmpty)
      .map((entry) => _normalizeJournalDay(entry.createdAt))
      .toSet();
});

class JournalEntryContext {
  const JournalEntryContext({
    required this.entry,
    required this.cycleDay,
  });

  final JournalEntry entry;
  final int? cycleDay;
}

final journalEntryContextsProvider = Provider<List<JournalEntryContext>>((ref) {
  final entries = ref.watch(journalProvider).value ?? const <JournalEntry>[];
  return entries
      .map(
        (entry) => JournalEntryContext(
          entry: entry,
          cycleDay: ref.watch(cycleDayForDateProvider(entry.createdAt)),
        ),
      )
      .toList();
});

final journalEntryContextByIdProvider =
    Provider.family<JournalEntryContext?, String>((ref, entryId) {
  final contexts = ref.watch(journalEntryContextsProvider);
  for (final context in contexts) {
    if (context.entry.id == entryId) {
      return context;
    }
  }
  return null;
});

/// Local-first journal state management.
///
/// Hive is read before any optional cloud request. When the user has explicitly
/// enabled sync, Firestore reconciliation runs after local entries are visible.
class JournalNotifier extends StateNotifier<AsyncValue<List<JournalEntry>>> {
  JournalNotifier(this._repository) : super(const AsyncValue.loading()) {
    load();
  }

  final JournalFirestoreRepository _repository;

  Future<void> load() async {
    if (state.value == null) {
      state = const AsyncValue.loading();
    }

    try {
      final localEntries = await _repository.loadEntries();
      if (!mounted) return;
      state = AsyncValue.data(localEntries);
    } catch (error, stackTrace) {
      if (mounted) state = AsyncValue.error(error, stackTrace);
      return;
    }

    try {
      if (!await _repository.isCloudSyncEnabled()) return;
      await syncWithCloud();
    } catch (error) {
      // The local encrypted copy remains available when Firebase is offline.
      debugPrint('Journal cloud refresh failed; keeping Hive data: $error');
    }
  }

  /// Reconciles after an explicit opt-in or a user-requested refresh.
  Future<void> syncWithCloud() async {
    if (!await _repository.isCloudSyncEnabled()) {
      throw StateError('Journal cloud sync is disabled.');
    }
    final entries = await _repository.syncWithCloud();
    if (mounted) state = AsyncValue.data(entries);
  }

  /// Updates the list immediately, then persists the encrypted local copy.
  /// The repository queues cloud writes only when sync consent is enabled.
  Future<void> upsert(JournalEntry entry) async {
    final current = [...(state.value ?? <JournalEntry>[])];
    final index = current.indexWhere((item) => item.id == entry.id);

    if (index >= 0) {
      current[index] = entry;
    } else {
      current.add(entry);
    }

    current.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    state = AsyncValue.data(current);

    try {
      await _repository.saveEntry(entry);
    } catch (error) {
      await _restoreFromLocalCache();
      rethrow;
    }
  }

  /// Removes from the UI and encrypted cache immediately; any opted-in cloud
  /// deletion is queued separately and protected by a local tombstone.
  Future<void> delete(String id) async {
    final current = [...(state.value ?? <JournalEntry>[])];
    current.removeWhere((item) => item.id == id);
    state = AsyncValue.data(current);

    try {
      await _repository.delete(id);
    } catch (error) {
      await _restoreFromLocalCache();
      rethrow;
    }
  }

  Future<void> clearAll() async {
    final previous = state.value ?? const <JournalEntry>[];
    state = const AsyncValue.data([]);
    try {
      await _repository.clearAll();
    } catch (error) {
      state = AsyncValue.data(previous);
      rethrow;
    }
  }

  Future<void> _restoreFromLocalCache() async {
    try {
      final entries = await _repository.loadEntries();
      if (mounted) state = AsyncValue.data(entries);
    } catch (error, stackTrace) {
      if (mounted) state = AsyncValue.error(error, stackTrace);
    }
  }
}
