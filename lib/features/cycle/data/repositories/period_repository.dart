import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:peria_app/core/repositories/user_repository.dart';
import 'package:peria_app/features/cycle/data/models/period_log.dart';

class PeriodRepository {
  PeriodRepository({
    UserRepository? userRepository,
  }) : _userRepository = userRepository ?? UserRepository();

  final UserRepository _userRepository;

  void _log(String message) {
    if (kDebugMode) {
      debugPrint('[PeriodRepository] $message');
    }
  }

  CollectionReference<Map<String, dynamic>> get _periodsCollection {
    return _userRepository.userCollection('period_logs');
  }

  Future<void> ensureInitialized() {
    _log('ensureInitialized');
    return _userRepository.ensureUserDocument();
  }

  Future<List<PeriodLog>> load() async {
    await ensureInitialized();
    _log('loading period logs from users/${_userRepository.currentUid}/period_logs');
    final snap =
        await _periodsCollection.orderBy('startDate', descending: true).get();
    _log('loaded ${snap.docs.length} period logs');
    return snap.docs.map((doc) => PeriodLog.fromJson(doc.data())).toList();
  }

  Future<void> save(List<PeriodLog> logs) async {
    await ensureInitialized();
    _log('saving full period log collection count=${logs.length}');
    final existing = await _periodsCollection.get();
    final batch = FirebaseFirestore.instance.batch();
    for (final doc in existing.docs) {
      batch.delete(doc.reference);
    }
    for (final log in logs) {
      batch.set(_periodsCollection.doc(log.id), log.toJson());
    }
    await batch.commit();
    _log('saved full period log collection');
  }

  Future<void> addLog(PeriodLog log) async {
    await ensureInitialized();
    _log('adding period log id=${log.id}');
    await _periodsCollection.doc(log.id).set(log.toJson());
    _log('added period log id=${log.id}');
  }

  Future<void> updateLog(String id, PeriodLog updated) async {
    await ensureInitialized();
    _log('updating period log id=$id');
    await _periodsCollection.doc(id).set(updated.toJson());
    _log('updated period log id=$id');
  }

  Future<void> deleteLog(String id) async {
    await ensureInitialized();
    _log('deleting period log id=$id');
    await _periodsCollection.doc(id).delete();
    _log('deleted period log id=$id');
  }
}
