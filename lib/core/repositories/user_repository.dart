import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:peria_app/core/services/privacy_policy_consent_service.dart';

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
    return userCollectionFor(currentUid, module);
  }

  /// Creates a reference scoped to a previously captured UID, so an
  /// authentication change cannot redirect an in-flight operation to another
  /// account.
  CollectionReference<Map<String, dynamic>> userCollectionFor(
    String uid,
    String module,
  ) {
    if (uid.isEmpty) {
      throw ArgumentError.value(uid, 'uid', 'Must not be empty.');
    }
    return _firestore.collection('users').doc(uid).collection(module);
  }

  Future<void> ensureUserDocument({
    Map<String, dynamic> additionalData = const {},
  }) async {
    PrivacyPolicyConsentService.requireCurrentPolicyAcceptance();
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

  /// Subcollections that belong to a user, kept in one place so the deletion
  /// cannot silently skip a module.
  static const List<String> userDataModules = <String>[
    'settings',
    'partner',
    'journal',
    'period_logs',
    'symptoms',
    // Devices registered for push notifications.
    'devices',
  ];

  /// Deletes the whole `users/{uid}` subtree.
  ///
  /// Firestore has no cascade delete and the Flutter SDK cannot list
  /// subcollections, so every known module is emptied page by page before the
  /// profile document itself is removed. A new module must be added to
  /// [userDataModules] to be erased with the account.
  Future<void> deleteAllUserData() async {
    final uid = currentUid;
    _log('deleteAllUserData start uid=$uid');
    for (final module in userDataModules) {
      await _deleteCollection(userCollectionFor(uid, module));
    }
    await _firestore.collection('users').doc(uid).delete();
    _log('deleteAllUserData done uid=$uid');
  }

  Future<void> _deleteCollection(
    CollectionReference<Map<String, dynamic>> collection,
  ) async {
    const pageSize = 200;
    while (true) {
      final snapshot = await collection.limit(pageSize).get();
      if (snapshot.docs.isEmpty) return;
      final batch = _firestore.batch();
      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
      if (snapshot.docs.length < pageSize) return;
    }
  }

  CollectionReference<Map<String, dynamic>> deviceCollectionFor(String uid) {
    return userCollectionFor(uid, 'devices');
  }

  /// Stable document id for a device, so the same phone updates its own entry
  /// instead of stacking a new one on every launch.
  ///
  /// The token itself is hashed: a document id ends up in logs and in the
  /// Firebase console, and a raw FCM token would be enough to send pushes.
  static String pushDeviceId(String token) {
    return sha256.convert(utf8.encode(token)).toString().substring(0, 32);
  }

  /// Registers (or refreshes) the push destination of a device.
  ///
  /// The uid is passed explicitly because the token can arrive from a Firebase
  /// callback after a sign-out, and a push must never be attached to the next
  /// account signed in on the same phone.
  Future<void> savePushDevice({
    required String uid,
    required String token,
    required String platform,
    required String locale,
  }) async {
    if (uid.isEmpty || token.isEmpty) return;
    _log('saving push device uid=$uid platform=$platform');
    await deviceCollectionFor(uid).doc(pushDeviceId(token)).set(
      {
        'token': token,
        'platform': platform,
        'locale': locale,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  Future<void> removePushDevice({
    required String uid,
    required String token,
  }) async {
    if (uid.isEmpty || token.isEmpty) return;
    _log('removing push device uid=$uid');
    await deviceCollectionFor(uid).doc(pushDeviceId(token)).delete();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserProfile() async {
    _log('getUserProfile called');
    await ensureUserDocument();
    final snapshot = await userDocument.get();
    _log('getUserProfile completed exists=${snapshot.exists}');
    return snapshot;
  }
}
