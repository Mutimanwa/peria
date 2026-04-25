import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:perla_app/core/repositories/user_repository.dart';
import 'package:perla_app/features/cycle/presentation/providers/cycle_provider.dart';
import 'package:perla_app/features/journal/data/models/journal_entry.dart';
import 'package:perla_app/features/journal/data/repositories/journal_firestore_repository.dart';

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

// CLASSE PRINCIPALE DU NOTIFIER
class JournalNotifier extends StateNotifier<AsyncValue<List<JournalEntry>>> {
  final JournalFirestoreRepository _repository;

  JournalNotifier(this._repository) : super(const AsyncValue.loading()) {
    load(); // Charger les données dès l'initialisation
  }

  Future<void> load() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.loadEntries());
  }

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
    
    await _repository.saveEntry(entry);
  }

  Future<void> delete(String id) async {
    final current = [...(state.value ?? <JournalEntry>[])];
    current.removeWhere((item) => item.id == id);
    state = AsyncValue.data(current);
    await _repository.delete(id);
  }

  Future<void> clearAll() async {
    state = const AsyncValue.data([]);
    await _repository.clearAll();
  }
}
