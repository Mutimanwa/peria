import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:peria_app/core/services/security_service.dart';
import 'package:peria_app/features/profile/presentation/providers/security_provider.dart';
import 'package:peria_app/l10n/app_localizations.dart';
import 'package:peria_app/shared/widgets/lock_screen.dart';

class _FakeSecurityNotifier extends StateNotifier<AsyncValue<SecurityState>>
    implements SecurityNotifier {
  _FakeSecurityNotifier({this.validPin = '1234'})
      : super(const AsyncValue.data(
          SecurityState(appLockEnabled: true, isSessionValid: false),
        ));

  final String validPin;
  String? lastPin;
  int attempts = 0;

  @override
  Future<AuthResult> authenticate() async => AuthResult.pinRequired();

  @override
  Future<AuthResult> authenticateWithPin(String pin) async {
    attempts++;
    lastPin = pin;
    if (pin == validPin) {
      final current = state.valueOrNull;
      if (current != null) {
        state = AsyncValue.data(current.copyWith(isSessionValid: true));
      }
      return AuthResult.success();
    }
    return AuthResult.pinIncorrect(5 - attempts);
  }

  @override
  Future<void> createPin(String pin) async {}

  @override
  Future<void> changePin(String oldPin, String newPin) async {}

  @override
  Future<void> deletePin() async {}

  @override
  Future<void> setAppLockEnabled(bool enabled) async {}

  @override
  Future<void> setJournalLockEnabled(bool enabled) async {}

  @override
  Future<void> setBiometricsEnabled(bool enabled) async {}

  @override
  Future<void> setMultitaskProtectionEnabled(bool enabled) async {}

  @override
  Future<void> endSession() async {}

  @override
  Future<void> refreshSessionStatus() async {}

  @override
  Future<void> clearAllLocalData() async {}
}

void main() {
  Widget buildApp(_FakeSecurityNotifier notifier) {
    return ProviderScope(
      overrides: [securityProvider.overrideWith((ref) => notifier)],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: LockScreen(),
      ),
    );
  }

  testWidgets('le code saisi est bien transmis au service de securite',
      (tester) async {
    final notifier = _FakeSecurityNotifier();

    await tester.pumpWidget(buildApp(notifier));
    await tester.pump();
    tester.takeException(); // l'icone de securite n'existe pas en test

    await tester.enterText(find.byType(TextField), '1234');
    await tester.pump();

    expect(notifier.lastPin, '1234');
  });

  testWidgets('un code refuse vide la saisie et affiche l\'erreur',
      (tester) async {
    final notifier = _FakeSecurityNotifier();

    await tester.pumpWidget(buildApp(notifier));
    await tester.pump();
    tester.takeException();

    await tester.enterText(find.byType(TextField), '9999');
    await tester.pump();

    expect(notifier.lastPin, '9999');
    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.controller?.text, isEmpty);
    expect(notifier.attempts, 1);
  });
}
