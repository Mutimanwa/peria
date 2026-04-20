import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:perla_app/core/repositories/user_repository.dart';
import 'package:perla_app/features/journal/data/models/journal_entry.dart';

class JournalFirestoreRepository {
  JournalFirestoreRepository({
    UserRepository? userRepository,
  }) : _userRepository = userRepository ?? UserRepository();

  final UserRepository _userRepository;

  CollectionReference<Map<String, dynamic>> get _journalCollection {
    return _userRepository.userCollection('journal');
  }

  Future<void> ensureInitialized() {
    return _userRepository.ensureUserDocument();
  }

  Future<List<JournalEntry>> loadEntries() async {
    await ensureInitialized();
    final snap =
        await _journalCollection.orderBy('updatedAt', descending: true).get();
    return snap.docs.map((doc) => JournalEntry.fromJson(doc.data())).toList();
  }

  Future<void> saveEntry(JournalEntry entry) async {
    await ensureInitialized();
    await _journalCollection.doc(entry.id).set(entry.toJson());
  }

  Future<void> upsert(JournalEntry entry) async {
    await saveEntry(entry);
  }

  Future<void> delete(String id) async {
    await ensureInitialized();
    await _journalCollection.doc(id).delete();
  }

  Future<void> clearAll() async {
    await ensureInitialized();
    final snap = await _journalCollection.get();
    final batch = FirebaseFirestore.instance.batch();
    for (final doc in snap.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  Stream<List<JournalEntry>> watchEntries() async* {
    await ensureInitialized();
    yield* _journalCollection
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => JournalEntry.fromJson(doc.data())).toList());
  }
}
