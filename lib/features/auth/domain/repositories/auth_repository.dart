import '../entities/user.dart';

abstract class AuthRepository {
  Future<UserEntity?> getCurrentUser();
  Future<UserEntity> signInAnonymously();
  Future<void> signOut();
  Stream<UserEntity?> authStateChanges();
  Future<bool> linkWithEmail(String email, String password);
}
