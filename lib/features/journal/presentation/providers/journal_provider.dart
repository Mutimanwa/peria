import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:perla_app/core/repositories/user_repository.dart';
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
