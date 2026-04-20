import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Central access point for user-scoped Firestore data.
///
/// Every repository should go through this class so all reads/writes stay
/// under `users/{uid}/...`.
class UserRepository {
  UserRepository({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  void _log(String message) {
    if (kDebugMode) {
      debugPrint('[UserRepository] $message');
    }
  }

  User? get currentUser => _auth.currentUser;

  String get currentUid {
    final uid = currentUser?.uid;
    if (uid == null || uid.isEmpty) {
      _log('currentUid requested but no authenticated Firebase user was found');
      throw StateError('No authenticated Firebase user available.');
    }
    _log('resolved current uid: $uid');
    return uid;
  }

  DocumentReference<Map<String, dynamic>> get userDocument {
    return _firestore.collection('users').doc(currentUid);
  }

  CollectionReference<Map<String, dynamic>> userCollection(String module) {
    return userDocument.collection(module);
  }

  Future<void> ensureUserDocument({
    Map<String, dynamic> additionalData = const {},
  }) async {
    final user = currentUser;
    if (user == null) {
      _log('ensureUserDocument failed because currentUser is null');
      throw StateError('Cannot initialize Firestore user document without auth.');
    }

    _log(
      'ensureUserDocument start uid=${user.uid} anonymous=${user.isAnonymous} extraKeys=${additionalData.keys.toList()}',
    );

    final snapshot = await userDocument.get();
    final baseData = {
      'uid': user.uid,
      'isAnonymous': user.isAnonymous,
      'email': user.email,
      'lastLogin': FieldValue.serverTimestamp(),
      ...additionalData,
    };

    if (!snapshot.exists) {
      _log('creating Firestore user document at users/${user.uid}');
      await userDocument.set({
        ...baseData,
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      _log('user document created for uid=${user.uid}');
      return;
    }

    _log('updating existing Firestore user document at users/${user.uid}');
    await userDocument.set(baseData, SetOptions(merge: true));
    _log('user document updated for uid=${user.uid}');
  }

  Future<void> saveUserProfile({
    required Map<String, dynamic> userData,
  }) async {
    _log('saveUserProfile called with keys=${userData.keys.toList()}');
    await ensureUserDocument(additionalData: userData);
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserProfile() async {
    _log('getUserProfile called');
    await ensureUserDocument();
    final snapshot = await userDocument.get();
    _log('getUserProfile completed exists=${snapshot.exists}');
    return snapshot;
  }
}
