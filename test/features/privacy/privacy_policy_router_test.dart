import 'package:flutter_test/flutter_test.dart';
import 'package:peria_app/core/router/router.dart';

void main() {
  group('privacy policy router gate', () {
    test('allows the policy itself before acceptance', () {
      expect(
        resolveRouterRedirect(
          location: '/privacy-policy',
          isAuthenticated: false,
          hasAcceptedPrivacyPolicy: false,
          hasCompletedOnboarding: false,
        ),
        isNull,
      );
    });

    test('keeps an existing authenticated user on Welcome until acceptance',
        () {
      expect(
        resolveRouterRedirect(
          location: '/welcome',
          isAuthenticated: true,
          hasAcceptedPrivacyPolicy: false,
          hasCompletedOnboarding: true,
        ),
        isNull,
      );
    });

    test('redirects authenticated deep links to Welcome before acceptance',
        () {
      expect(
        resolveRouterRedirect(
          location: '/cycle',
          isAuthenticated: true,
          hasAcceptedPrivacyPolicy: false,
          hasCompletedOnboarding: true,
        ),
        '/welcome',
      );
    });

    test('redirects unauthenticated deep links to Welcome before acceptance',
        () {
      expect(
        resolveRouterRedirect(
          location: '/profile/settings',
          isAuthenticated: false,
          hasAcceptedPrivacyPolicy: false,
          hasCompletedOnboarding: false,
        ),
        '/welcome',
      );
    });

    // Welcome reste affichable pour une personne connectee : sinon un retour
    // depuis les ecrans d'auth (inscription, email, mot de passe) la projetait
    // dans l'onboarding, qui ne doit commencer qu'apres « creer un compte ».
    test('keeps Welcome reachable while onboarding is not started', () {
      expect(
        resolveRouterRedirect(
          location: '/welcome',
          isAuthenticated: true,
          hasAcceptedPrivacyPolicy: true,
          hasCompletedOnboarding: false,
        ),
        isNull,
      );
    });

    test('keeps the auth screens reachable during the sign-up flow', () {
      for (final location in const [
        '/sign-in',
        '/register',
        '/email',
        '/create-account',
        '/verify-email',
      ]) {
        expect(
          resolveRouterRedirect(
            location: location,
            isAuthenticated: true,
            hasAcceptedPrivacyPolicy: true,
            hasCompletedOnboarding: false,
          ),
          isNull,
          reason: location,
        );
      }
    });

    test('sends an onboarded authenticated user home after acceptance', () {
      expect(
        resolveRouterRedirect(
          location: '/welcome',
          isAuthenticated: true,
          hasAcceptedPrivacyPolicy: true,
          hasCompletedOnboarding: true,
        ),
        '/cycle',
      );
    });

    test('does not reopen the name screen after onboarding is completed', () {
      expect(
        resolveRouterRedirect(
          location: '/ask-name',
          isAuthenticated: true,
          hasAcceptedPrivacyPolicy: true,
          hasCompletedOnboarding: true,
        ),
        '/cycle',
      );
    });

    test('keeps a new user on the name screen until onboarding is finished', () {
      expect(
        resolveRouterRedirect(
          location: '/ask-name',
          isAuthenticated: true,
          hasAcceptedPrivacyPolicy: true,
          hasCompletedOnboarding: false,
        ),
        isNull,
      );
    });
  });
}
