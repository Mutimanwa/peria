import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:perla_app/core/repositories/user_repository.dart';
import 'package:perla_app/core/services/firebase_service.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_profile.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserRepository _userRepository = UserRepository();

  void _log(String message) {
    if (kDebugMode) {
      debugPrint('[AuthRepositoryImpl] $message');
    }
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      _log('getCurrentUser currentUser=${user?.uid}');
      if (user == null) return null;
      await _userRepository.ensureUserDocument();
      final profileSnap = await _userRepository.getUserProfile();
      if (!profileSnap.exists) return null;
      final profile = UserProfile.fromFirestore(profileSnap);
      _log('getCurrentUser resolved profile uid=${profile.uid}');
      return profile.toEntity();
    } catch (e) {
      _log('getCurrentUser failed: $e');
      return null;
    }
  }

  @override
  Future<UserEntity> signInAnonymously() async {
    _log('signInAnonymously start');
    await FirebaseService.initialize();

    UserCredential result = await _auth.signInAnonymously();
    User firebaseUser = result.user!;
    _log('anonymous sign-in success uid=${firebaseUser.uid}');
    
    // Create/update Firestore profile
    UserProfile profile = UserProfile(
      uid: firebaseUser.uid,
      isAnonymous: true,
      createdAt: DateTime.now(),
      lastLogin: DateTime.now(),
    );

    await _userRepository.saveUserProfile(userData: profile.toFirestore());
    _log('anonymous Firestore profile ensured uid=${firebaseUser.uid}');

    return profile.toEntity();
  }

  @override
  Future<void> signOut() async {
    _log('signOut uid=${_auth.currentUser?.uid}');
    await _auth.signOut();
  }

  @override
  Stream<UserEntity?> authStateChanges() {
    return _auth.authStateChanges().asyncMap((firebaseUser) async {
      _log('authStateChanges event uid=${firebaseUser?.uid}');
      if (firebaseUser == null) return null;
      await _userRepository.ensureUserDocument();
      final profileSnap = await _userRepository.getUserProfile();
      if (!profileSnap.exists) return null;
      final profile = UserProfile.fromFirestore(profileSnap);
      _log('authStateChanges resolved profile uid=${profile.uid}');
      return profile.toEntity();
    });
  }

  @override
  Future<bool> linkWithEmail(String email, String password) async {
    try {
      final currentUser = _auth.currentUser;
      _log('linkWithEmail start uid=${currentUser?.uid} email=$email');
      if (currentUser == null) return false;

      final credentials = EmailAuthProvider.credential(email: email, password: password);
      await currentUser.linkWithCredential(credentials);
      
      // Update profile
      await _userRepository.saveUserProfile(
        userData: {
          'email': email,
          'isAnonymous': false,
          'lastLogin': FieldValue.serverTimestamp(),
        },
      );
      _log('linkWithEmail success uid=${currentUser.uid}');
      return true;
    } catch (e) {
      _log('linkWithEmail failed: $e');
      return false;
    }
  }
}
