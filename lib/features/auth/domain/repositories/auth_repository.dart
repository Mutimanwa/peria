import '../entities/user.dart';

abstract class AuthRepository {
  Future<UserEntity?> getCurrentUser();

  Future<UserEntity> signInAnonymously();

  Future<void> signOut();

  Stream<UserEntity?> authStateChanges();

  /// Creates a real account.
  ///
  /// When the device is already using an anonymous account, the credentials
  /// are linked to it so the existing cycle, journal and symptom data are
  /// kept. Otherwise a brand new Firebase account is created.
  Future<UserEntity> createAccount({
    required String email,
    required String password,
  });

  Future<UserEntity> signInWithEmail({
    required String email,
    required String password,
  });

  Future<void> sendPasswordResetEmail(String email);

  Future<void> sendEmailVerification();

  /// Reloads the account and reports whether the address is now verified.
  Future<bool> reloadEmailVerified();

  /// Erases every server-side and account-level record, then deletes the
  /// Firebase user. [password] is required to re-authenticate e-mail accounts
  /// whose session is too old for a destructive operation.
  Future<void> deleteAccount({String? password});
}
