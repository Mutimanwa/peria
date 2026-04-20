import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  User? get currentUser => _auth.currentUser;

  String get currentUid {
    final uid = currentUser?.uid;
    if (uid == null || uid.isEmpty) {
      throw StateError('No authenticated Firebase user available.');
    }
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
      throw StateError('Cannot initialize Firestore user document without auth.');
    }

    final snapshot = await userDocument.get();
    final baseData = {
      'uid': user.uid,
      'isAnonymous': user.isAnonymous,
      'email': user.email,
      'lastLogin': FieldValue.serverTimestamp(),
      ...additionalData,
    };

    if (!snapshot.exists) {
      await userDocument.set({
        ...baseData,
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      return;
    }

    await userDocument.set(baseData, SetOptions(merge: true));
  }

  Future<void> saveUserProfile({
    required Map<String, dynamic> userData,
  }) async {
    await ensureUserDocument(additionalData: userData);
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserProfile() async {
    await ensureUserDocument();
    return userDocument.get();
  }
}
