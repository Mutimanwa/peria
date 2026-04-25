import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peria_app/features/auth/domain/auth_navigation_target.dart';

final registerControllerProvider =
    Provider<RegisterController>((ref) => const RegisterController());

class RegisterController {
  const RegisterController();

  AuthNavigationTarget onContinueWithEmailTapped() {
    return AuthNavigationTarget.continueWithEmail;
  }

  void onContinueWithGoogleTapped() {
    // TODO: connect Google auth later (keep logic here, not in UI).
  }

  void onContinueWithAppleTapped() {
    // TODO: connect Apple auth later (keep logic here, not in UI).
  }
}
