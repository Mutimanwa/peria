import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:perla_app/features/journal/data/models/journal_entry.dart';
import 'package:perla_app/features/journal/data/repositories/journal_repository.dart';

final journalRepositoryProvider = Provider<JournalRepository>((ref) {
  return JournalRepository();
});

final journalProvider =
    StateNotifierProvider<JournalNotifier, AsyncValue<List<JournalEntry>>>(
        (ref) {
  final notifier = JournalNotifier(ref.read(journalRepositoryProvider));
  notifier.load();
  return notifier;
});

class JournalNotifier extends StateNotifier<AsyncValue<List<JournalEntry>>> {
  JournalNotifier(this._repository) : super(const AsyncValue.loading());

  final JournalRepository _repository;

  Future<void> load() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_repository.loadEntries);
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
    await _repository.saveEntries(current);
  }

  Future<void> delete(String id) async {
    final current = [...(state.value ?? <JournalEntry>[])];
    current.removeWhere((item) => item.id == id);
    state = AsyncValue.data(current);
    await _repository.saveEntries(current);
  }

  Future<void> clearAll() async {
    state = const AsyncValue.data([]);
    await _repository.saveEntries(const []);
  }
}
