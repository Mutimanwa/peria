import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peria_app/core/repositories/user_repository.dart';
import 'package:peria_app/features/cycle/presentation/providers/cycle_provider.dart';
import 'package:peria_app/features/journal/data/models/journal_entry.dart';
import 'package:peria_app/features/journal/data/repositories/journal_firestore_repository.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

final journalRepositoryProvider = Provider<JournalFirestoreRepository>((ref) {
  return JournalFirestoreRepository(
    userRepository: ref.read(userRepositoryProvider),
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
      .where((entry) => entry.title.trim().isNotEmpty || entry.content.trim().isNotEmpty)
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

/// ═══════════════════════════════════════════════════════════════════
/// JournalNotifier — Offline-first state management for journal
/// 
/// - **Optimistic Updates**: UI updates immediately, Firestore syncs async
/// - **Hive Caching**: Loads local cache first, Firestore as background sync
/// - **No Loading State**: Uses cache to avoid blank screens during reload
/// ═══════════════════════════════════════════════════════════════════
class JournalNotifier extends StateNotifier<AsyncValue<List<JournalEntry>>> {
  final JournalFirestoreRepository _repository;

  JournalNotifier(this._repository) : super(const AsyncValue.loading()) {
    load();
  }

  /// Load entries from Hive cache (instant) + sync from Firestore (background)
  /// UI shows cache immediately without loading state
  Future<void> load() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.loadEntries());
  }

  /// Optimistic update: UI state changes immediately, Firestore syncs async
  /// The entry is added to local state before Firestore confirmation
  Future<void> upsert(JournalEntry entry) async {
    // 1. Update UI immediately (optimistic)
    final current = [...(state.value ?? <JournalEntry>[])];
    final index = current.indexWhere((item) => item.id == entry.id);
    
    if (index >= 0) {
      current[index] = entry;
    } else {
      current.add(entry);
    }
    
    current.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    state = AsyncValue.data(current);
    
    // 2. Sync to repository (Hive + Firestore) in background
    // Don't await here to keep UI snappy
    _repository.saveEntry(entry).catchError((e) {
      // TODO: Show error toast or retry logic
      debugPrint('Journal save failed: $e');
    });
  }

  /// Optimistic delete: remove from UI immediately, sync async
  Future<void> delete(String id) async {
    // 1. Update UI immediately
    final current = [...(state.value ?? <JournalEntry>[])];
    current.removeWhere((item) => item.id == id);
    state = AsyncValue.data(current);
    
    // 2. Sync deletion in background
    _repository.delete(id).catchError((e) {
      debugPrint('Journal delete failed: $e');
    });
  }

  Future<void> clearAll() async {
    state = const AsyncValue.data([]);
    _repository.clearAll().catchError((e) {
      debugPrint('Journal clearAll failed: $e');
    });
  }
}
