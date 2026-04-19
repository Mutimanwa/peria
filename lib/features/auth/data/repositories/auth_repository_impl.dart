import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:perla_app/core/services/firebase_service.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_profile.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<UserEntity?> getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;
      final profileSnap = await _firestore.collection('users').doc(user.uid).get();
      if (!profileSnap.exists) return null;
      final profile = UserProfile.fromFirestore(profileSnap);
      return profile.toEntity();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<UserEntity> signInAnonymously() async {
    // Ensure Firebase initialized
    await FirebaseService.initialize();

    UserCredential result = await _auth.signInAnonymously();
    User firebaseUser = result.user!;
    
    // Create/update Firestore profile
    UserProfile profile = UserProfile(
      uid: firebaseUser.uid,
      isAnonymous: true,
      createdAt: DateTime.now(),
      lastLogin: DateTime.now(),
    );

    await _firestore.collection('users').doc(firebaseUser.uid).set(
      profile.toFirestore(),
      SetOptions(merge: true),
    );

    return profile.toEntity();
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  @override
  Stream<UserEntity?> authStateChanges() {
    return _auth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;
      final profileSnap = await _firestore.collection('users').doc(firebaseUser.uid).get();
      if (!profileSnap.exists) return null;
      final profile = UserProfile.fromFirestore(profileSnap);
      return profile.toEntity();
    });
  }

  @override
  Future<bool> linkWithEmail(String email, String password) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return false;

      final credentials = EmailAuthProvider.credential(email: email, password: password);
      await currentUser.linkWithCredential(credentials);
      
      // Update profile
      await _firestore.collection('users').doc(currentUser.uid).update({
        'email': email,
        'isAnonymous': false,
        'lastLogin': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}
