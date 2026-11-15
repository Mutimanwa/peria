import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:peria_app/core/services/security_service.dart';
import 'package:peria_app/features/profile/presentation/providers/security_provider.dart';
import 'package:peria_app/l10n/app_localizations.dart';
import 'package:peria_app/shared/widgets/app_lock_gate.dart';
import 'package:peria_app/shared/widgets/lock_screen.dart';

/// In-memory notifier: keeps real listener registration so Riverpod can
/// subscribe to it, without touching secure storage.
class _FakeSecurityNotifier extends StateNotifier<AsyncValue<SecurityState>>
    implements SecurityNotifier {
  _FakeSecurityNotifier(SecurityState seed) : super(AsyncValue.data(seed));

  int endSessionCalls = 0;

  @override
  Future<void> createPin(String pin) async {}

  @override
  Future<void> changePin(String oldPin, String newPin) async {}

  @override
  Future<void> deletePin() async {}

  @override
  Future<AuthResult> authenticate() async => AuthResult.pinRequired();

  @override
  Future<AuthResult> authenticateWithPin(String pin) async =>
      AuthResult.pinRequired();

  @override
  Future<void> setAppLockEnabled(bool enabled) async {}

  @override
  Future<void> setJournalLockEnabled(bool enabled) async {}

  @override
  Future<void> setBiometricsEnabled(bool enabled) async {}

  @override
  Future<void> setMultitaskProtectionEnabled(bool enabled) async {}

  @override
  Future<void> endSession() async {
    endSessionCalls++;
    final current = state.valueOrNull;
    if (current != null) {
      state = AsyncValue.data(current.copyWith(isSessionValid: false));
    }
  }

  @override
  Future<void> refreshSessionStatus() async {}

  @override
  Future<void> clearAllLocalData() async {}
}

void main() {
  const protectedContent = Text('contenu protege');

  Widget buildApp(_FakeSecurityNotifier notifier, {Duration? backgroundTime}) {
    return ProviderScope(
      overrides: [securityProvider.overrideWith((ref) => notifier)],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: AppLockGate(
          minimumBackgroundTime: backgroundTime ?? const Duration(seconds: 1),
          child: protectedContent,
        ),
      ),
    );
  }

  testWidgets('app lock disabled: the content is shown as is', (tester) async {
    await tester.pumpWidget(buildApp(_FakeSecurityNotifier(
      const SecurityState(appLockEnabled: false, isSessionValid: false),
    )));

    expect(find.text('contenu protege'), findsOneWidget);
    expect(find.byType(LockScreen), findsNothing);
  });

  testWidgets('app lock enabled with a valid session: no lock screen',
      (tester) async {
    await tester.pumpWidget(buildApp(_FakeSecurityNotifier(
      const SecurityState(appLockEnabled: true, isSessionValid: true),
    )));

    expect(find.text('contenu protege'), findsOneWidget);
    expect(find.byType(LockScreen), findsNothing);
  });

  testWidgets('app lock enabled without a session: the lock screen is shown',
      (tester) async {
    await tester.pumpWidget(buildApp(_FakeSecurityNotifier(
      const SecurityState(appLockEnabled: true, isSessionValid: false),
    )));
    await tester.pump();

    // The security icon is not bundled in widget tests.
    tester.takeException();
    expect(find.byType(LockScreen), findsOneWidget);
    expect(find.text('contenu protege'), findsNothing);
  });

  testWidgets('coming back from the background locks the app again',
      (tester) async {
    final notifier = _FakeSecurityNotifier(
      const SecurityState(appLockEnabled: true, isSessionValid: true),
    );

    await tester.pumpWidget(
      buildApp(notifier, backgroundTime: Duration.zero),
    );
    expect(find.text('contenu protege'), findsOneWidget);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();

    tester.takeException();
    expect(notifier.endSessionCalls, 1);
    expect(find.byType(LockScreen), findsOneWidget);
  });

  testWidgets('a very short background stay keeps the session open',
      (tester) async {
    final notifier = _FakeSecurityNotifier(
      const SecurityState(appLockEnabled: true, isSessionValid: true),
    );

    await tester.pumpWidget(
      buildApp(notifier, backgroundTime: const Duration(minutes: 1)),
    );

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();

    expect(notifier.endSessionCalls, 0);
    expect(find.text('contenu protege'), findsOneWidget);
  });

  testWidgets('the session is kept when the app lock is off', (tester) async {
    final notifier = _FakeSecurityNotifier(
      const SecurityState(appLockEnabled: false, isSessionValid: true),
    );

    await tester.pumpWidget(
      buildApp(notifier, backgroundTime: Duration.zero),
    );

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();

    expect(notifier.endSessionCalls, 0);
  });
}
