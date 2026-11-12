/// Portable description of an authentication failure.
///
/// The domain never exposes Firebase error codes to the UI: they are mapped
/// here once, so screens (and tests) can rely on a small, stable set.
enum AuthErrorCode {
  invalidEmail,
  wrongPassword,
  userNotFound,
  userDisabled,
  emailAlreadyInUse,
  weakPassword,
  tooManyRequests,
  network,
  requiresRecentLogin,
  operationNotAllowed,
  alreadySignedIn,
  notSignedIn,
  unknown;

  /// Maps a Firebase Auth error code (with or without the `auth/` prefix).
  static AuthErrorCode fromFirebaseCode(String? code) {
    final normalized =
        (code ?? '').trim().toLowerCase().replaceFirst('auth/', '');
    switch (normalized) {
      case 'invalid-email':
        return AuthErrorCode.invalidEmail;
      case 'wrong-password':
      case 'invalid-credential':
      case 'invalid-login-credentials':
        return AuthErrorCode.wrongPassword;
      case 'user-not-found':
        return AuthErrorCode.userNotFound;
      case 'user-disabled':
        return AuthErrorCode.userDisabled;
      case 'email-already-in-use':
      case 'credential-already-in-use':
        return AuthErrorCode.emailAlreadyInUse;
      case 'weak-password':
        return AuthErrorCode.weakPassword;
      case 'too-many-requests':
        return AuthErrorCode.tooManyRequests;
      case 'network-request-failed':
        return AuthErrorCode.network;
      case 'requires-recent-login':
        return AuthErrorCode.requiresRecentLogin;
      case 'operation-not-allowed':
        return AuthErrorCode.operationNotAllowed;
      default:
        return AuthErrorCode.unknown;
    }
  }
}

/// Thrown by [AuthRepository] implementations so the UI can show a message
/// that matches the real cause instead of a generic "something failed".
class AuthException implements Exception {
  final AuthErrorCode code;

  const AuthException(this.code);

  @override
  String toString() => 'AuthException($code)';
}
