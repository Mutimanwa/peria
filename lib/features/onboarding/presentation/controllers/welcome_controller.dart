import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:perla_app/features/onboarding/domain/onboarding_navigation_target.dart';

final welcomeControllerProvider =
    Provider<WelcomeController>((ref) => const WelcomeController());

class WelcomeController {
  const WelcomeController();

  // For now, we don't request notification permission in MVP (no dependency wired).
  // We still keep the logic out of the UI and return an explicit navigation target.
  OnboardingNavigationTarget onAnotherTimeTapped() {
    return OnboardingNavigationTarget.register;
  }

  OnboardingNavigationTarget onTurnOnNotificationsTapped() {
    return OnboardingNavigationTarget.register;
  }
}

