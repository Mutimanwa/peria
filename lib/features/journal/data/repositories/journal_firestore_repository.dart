import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:peria_app/core/repositories/user_repository.dart';
import 'package:peria_app/features/journal/data/models/journal_entry.dart';

class JournalFirestoreRepository {
  JournalFirestoreRepository({
    UserRepository? userRepository,
  }) : _userRepository = userRepository ?? UserRepository();

  final UserRepository _userRepository;

  void _log(String message) {
    if (kDebugMode) {
      debugPrint('[JournalFirestoreRepository] $message');
    }
  }

  CollectionReference<Map<String, dynamic>> get _journalCollection {
    return _userRepository.userCollection('journal');
  }

  Future<void> ensureInitialized() {
    _log('ensureInitialized');
    return _userRepository.ensureUserDocument();
  }

  Future<List<JournalEntry>> loadEntries() async {
    await ensureInitialized();
    _log('loading entries from users/${_userRepository.currentUid}/journal');
    final snap =
        await _journalCollection.orderBy('updatedAt', descending: true).get();
    _log('loaded ${snap.docs.length} journal entries');
    return snap.docs.map((doc) => JournalEntry.fromJson(doc.data())).toList();
  }

  Future<void> saveEntry(JournalEntry entry) async {
    await ensureInitialized();
    _log('saving journal entry id=${entry.id}');
    await _journalCollection.doc(entry.id).set(entry.toJson());
    _log('saved journal entry id=${entry.id}');
  }

  Future<void> upsert(JournalEntry entry) async {
    await saveEntry(entry);
  }

  Future<void> delete(String id) async {
    await ensureInitialized();
    _log('deleting journal entry id=$id');
    await _journalCollection.doc(id).delete();
    _log('deleted journal entry id=$id');
  }

  Future<void> clearAll() async {
    await ensureInitialized();
    _log('clearing all journal entries');
    final snap = await _journalCollection.get();
    final batch = FirebaseFirestore.instance.batch();
    for (final doc in snap.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
    _log('cleared ${snap.docs.length} journal entries');
  }

  Stream<List<JournalEntry>> watchEntries() async* {
    await ensureInitialized();
    yield* _journalCollection
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => JournalEntry.fromJson(doc.data())).toList());
  }
}
