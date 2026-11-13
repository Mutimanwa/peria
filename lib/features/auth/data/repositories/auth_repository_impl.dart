import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:peria_app/core/repositories/user_repository.dart';
import 'package:peria_app/core/services/firebase_service.dart';
import 'package:peria_app/core/services/privacy_policy_consent_service.dart';
import '../../domain/auth_error_code.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_profile.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({FirebaseAuth? auth, UserRepository? userRepository})
      : _auth = auth ?? FirebaseAuth.instance,
        _userRepository = userRepository ?? UserRepository();

  final FirebaseAuth _auth;
  final UserRepository _userRepository;

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
    PrivacyPolicyConsentService.requireCurrentPolicyAcceptance();
    _log('signInAnonymously start');
    await FirebaseService.initialize();

    final UserCredential result = await _auth.signInAnonymously();
    final User firebaseUser = result.user!;
    _log('anonymous sign-in success uid=${firebaseUser.uid}');

    // Create/update Firestore profile
    final UserProfile profile = UserProfile(
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
  Future<UserEntity> createAccount({
    required String email,
    required String password,
  }) async {
    PrivacyPolicyConsentService.requireCurrentPolicyAcceptance();
    await FirebaseService.initialize();

    final User? current = _auth.currentUser;
    if (current != null && !current.isAnonymous) {
      throw const AuthException(AuthErrorCode.alreadySignedIn);
    }

    try {
      _log('createAccount start anonymous=${current?.isAnonymous}');
      final UserCredential result;
      if (current != null) {
        // Link instead of creating: the anonymous UID (and all the data
        // stored under it) is preserved.
        result = await current.linkWithCredential(
          EmailAuthProvider.credential(email: email, password: password),
        );
      } else {
        result = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      }

      final User? firebaseUser = result.user;
      if (firebaseUser == null) {
        throw const AuthException(AuthErrorCode.unknown);
      }

      await _userRepository.saveUserProfile(
        userData: {
          'email': email,
          'isAnonymous': false,
          'lastLogin': FieldValue.serverTimestamp(),
        },
      );
      await firebaseUser.sendEmailVerification();
      _log('createAccount success uid=${firebaseUser.uid}');

      return UserEntity(
        uid: firebaseUser.uid,
        email: email,
        isAnonymous: false,
        createdAt: DateTime.now(),
        lastLogin: DateTime.now(),
      );
    } on FirebaseAuthException catch (e) {
      _log('createAccount failed: ${e.code}');
      throw AuthException(AuthErrorCode.fromFirebaseCode(e.code));
    }
  }

  @override
  Future<UserEntity> signInWithEmail({
    required String email,
    required String password,
  }) async {
    await FirebaseService.initialize();
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? firebaseUser = result.user;
      if (firebaseUser == null) {
        throw const AuthException(AuthErrorCode.unknown);
      }
      _log('signInWithEmail success uid=${firebaseUser.uid}');

      // Read the profile directly: the privacy policy gate guards *creation*,
      // not signing back into an existing account.
      final snapshot = await _userRepository.userDocument.get();
      if (snapshot.exists) {
        return UserProfile.fromFirestore(snapshot).toEntity();
      }
      return UserEntity(
        uid: firebaseUser.uid,
        email: firebaseUser.email ?? email,
        isAnonymous: false,
        createdAt: DateTime.now(),
        lastLogin: DateTime.now(),
      );
    } on FirebaseAuthException catch (e) {
      _log('signInWithEmail failed: ${e.code}');
      throw AuthException(AuthErrorCode.fromFirebaseCode(e.code));
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await FirebaseService.initialize();
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      _log('sendPasswordResetEmail sent');
    } on FirebaseAuthException catch (e) {
      _log('sendPasswordResetEmail failed: ${e.code}');
      throw AuthException(AuthErrorCode.fromFirebaseCode(e.code));
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final User? user = _auth.currentUser;
    if (user == null) {
      throw const AuthException(AuthErrorCode.notSignedIn);
    }
    if (user.emailVerified) return;
    try {
      await user.sendEmailVerification();
      _log('sendEmailVerification sent uid=${user.uid}');
    } on FirebaseAuthException catch (e) {
      _log('sendEmailVerification failed: ${e.code}');
      throw AuthException(AuthErrorCode.fromFirebaseCode(e.code));
    }
  }

  @override
  Future<bool> reloadEmailVerified() async {
    final User? user = _auth.currentUser;
    if (user == null) return false;
    await user.reload();
    return _auth.currentUser?.emailVerified ?? false;
  }

  @override
  Future<void> deleteAccount({String? password}) async {
    final User? user = _auth.currentUser;
    if (user == null) {
      throw const AuthException(AuthErrorCode.notSignedIn);
    }
    try {
      final String? email = user.email;
      if (email != null && !user.isAnonymous && password != null && password.isNotEmpty) {
        // Re-authenticate first: deletion must not leave orphaned data
        // behind when the session is too old for a destructive operation.
        await user.reauthenticateWithCredential(
          EmailAuthProvider.credential(email: email, password: password),
        );
      }
      await _userRepository.deleteAllUserData();
      await user.delete();
      _log('deleteAccount success');
    } on FirebaseAuthException catch (e) {
      _log('deleteAccount failed: ${e.code}');
      throw AuthException(AuthErrorCode.fromFirebaseCode(e.code));
    }
  }
}
