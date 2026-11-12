import 'package:peria_app/features/auth/domain/auth_error_code.dart';
import 'package:peria_app/l10n/app_localizations.dart';

/// Turns a failure into a sentence the user can act on.
String authErrorText(AppLocalizations l10n, AuthErrorCode code) {
  switch (code) {
    case AuthErrorCode.invalidEmail:
      return l10n.authErrorInvalidEmail;
    case AuthErrorCode.wrongPassword:
      return l10n.authErrorWrongPassword;
    case AuthErrorCode.userNotFound:
      return l10n.authErrorUserNotFound;
    case AuthErrorCode.userDisabled:
      return l10n.authErrorUserDisabled;
    case AuthErrorCode.emailAlreadyInUse:
      return l10n.authErrorEmailInUse;
    case AuthErrorCode.weakPassword:
      return l10n.authErrorWeakPassword;
    case AuthErrorCode.tooManyRequests:
      return l10n.authErrorTooManyRequests;
    case AuthErrorCode.network:
      return l10n.authErrorNetwork;
    case AuthErrorCode.requiresRecentLogin:
      return l10n.authErrorRecentLogin;
    case AuthErrorCode.alreadySignedIn:
      return l10n.authErrorAlreadySignedIn;
    case AuthErrorCode.notSignedIn:
      return l10n.authErrorNotSignedIn;
    case AuthErrorCode.operationNotAllowed:
    case AuthErrorCode.unknown:
      return l10n.authErrorUnknown;
  }
}

/// Extracts a code from any thrown object, so callers never have to guess.
AuthErrorCode authErrorCodeFrom(Object error) {
  if (error is AuthException) return error.code;
  return AuthErrorCode.unknown;
}
