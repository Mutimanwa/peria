import 'package:flutter_test/flutter_test.dart';
import 'package:peria_app/features/auth/domain/auth_error_code.dart';

void main() {
  group('AuthErrorCode.fromFirebaseCode', () {
    test('maps the failures the account screens can trigger', () {
      expect(AuthErrorCode.fromFirebaseCode('invalid-email'),
          AuthErrorCode.invalidEmail);
      expect(AuthErrorCode.fromFirebaseCode('auth/invalid-email'),
          AuthErrorCode.invalidEmail);
      expect(AuthErrorCode.fromFirebaseCode('wrong-password'),
          AuthErrorCode.wrongPassword);
      expect(AuthErrorCode.fromFirebaseCode('invalid-credential'),
          AuthErrorCode.wrongPassword);
      expect(AuthErrorCode.fromFirebaseCode('user-not-found'),
          AuthErrorCode.userNotFound);
      expect(AuthErrorCode.fromFirebaseCode('email-already-in-use'),
          AuthErrorCode.emailAlreadyInUse);
      expect(AuthErrorCode.fromFirebaseCode('weak-password'),
          AuthErrorCode.weakPassword);
      expect(AuthErrorCode.fromFirebaseCode('too-many-requests'),
          AuthErrorCode.tooManyRequests);
      expect(AuthErrorCode.fromFirebaseCode('network-request-failed'),
          AuthErrorCode.network);
      expect(AuthErrorCode.fromFirebaseCode('requires-recent-login'),
          AuthErrorCode.requiresRecentLogin);
    });

    test('never leaks an unknown Firebase code to the UI', () {
      expect(AuthErrorCode.fromFirebaseCode('something-new'),
          AuthErrorCode.unknown);
      expect(AuthErrorCode.fromFirebaseCode(null), AuthErrorCode.unknown);
      expect(AuthErrorCode.fromFirebaseCode(''), AuthErrorCode.unknown);
    });

    test('is case and prefix tolerant', () {
      expect(AuthErrorCode.fromFirebaseCode('AUTH/INVALID-EMAIL'),
          AuthErrorCode.invalidEmail);
    });
  });

  test('authErrorCodeFrom unwraps AuthException only', () {
    expect(authErrorCodeFromWith(const AuthException(AuthErrorCode.network)),
        AuthErrorCode.network);
    expect(authErrorCodeFromWith(StateError('boom')), AuthErrorCode.unknown);
  });
}

/// Mirrors `authErrorCodeFrom` without pulling the localization layer in.
AuthErrorCode authErrorCodeFromWith(Object error) =>
    error is AuthException ? error.code : AuthErrorCode.unknown;
