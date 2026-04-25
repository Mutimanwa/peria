import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:perla_app/core/repositories/user_repository.dart';
import 'package:perla_app/features/calendar/data/models/symptom_log.dart';

class SymptomRepository {
  SymptomRepository({
    UserRepository? userRepository,
  }) : _userRepository = userRepository ?? UserRepository();

  final UserRepository _userRepository;

  void _log(String message) {
    if (kDebugMode) {
      debugPrint('[SymptomRepository] $message');
    }
  }

  CollectionReference<Map<String, dynamic>> get _symptomsCollection {
    return _userRepository.userCollection('symptoms');
  }

  String documentIdForDate(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    return normalized.toIso8601String().split('T').first;
  }

  Future<SymptomLog?> loadForDate(DateTime date) async {
    await _userRepository.ensureUserDocument();
    final docId = documentIdForDate(date);
    _log('loading symptom log docId=$docId');
    final doc = await _symptomsCollection.doc(docId).get();
    final data = doc.data();
    _log('symptom log load completed exists=${data != null} docId=$docId');
    if (data == null) return null;
    return SymptomLog.fromJson(data);
  }

  Future<List<SymptomLog>> loadAll() async {
    await _userRepository.ensureUserDocument();
    _log('loading all symptom logs from users/${_userRepository.currentUid}/symptoms');
    final snap = await _symptomsCollection.orderBy('date', descending: true).get();
    _log('loaded ${snap.docs.length} symptom logs');
    return snap.docs.map((doc) => SymptomLog.fromJson(doc.data())).toList();
  }

  Future<void> saveForDate(SymptomLog log) async {
    await _userRepository.ensureUserDocument();
    _log('saving symptom log docId=${log.id} categories=${log.selections.keys.toList()}');
    await _symptomsCollection.doc(log.id).set(log.toJson());
    _log('saved symptom log docId=${log.id}');
  }
}
