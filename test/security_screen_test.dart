import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:peria_app/features/profile/presentation/screens/security.dart';
import 'package:peria_app/features/profile/presentation/providers/security_provider.dart';
import 'package:peria_app/core/services/security_service.dart';
import 'package:peria_app/core/storage/app_settings.dart';
import 'package:peria_app/core/storage/app_settings_provider.dart';
import 'package:peria_app/l10n/app_localizations.dart';
import 'package:peria_app/shared/widgets/lock_screen.dart';
import 'package:peria_app/core/repositories/user_repository.dart';
import 'package:peria_app/core/storage/app_settings_repository.dart';
import 'package:peria_app/shared/widgets/profile_widgets.dart';
import 'package:peria_app/shared/widgets/pin_code_input.dart';

// Mock classes
class MockSecurityNotifier extends Mock implements SecurityNotifier {}

class FakeAppSettingsNotifier extends AppSettingsNotifier {
  FakeAppSettingsNotifier() : super(_FakeAppSettingsRepository()) {
    state = const AsyncValue.data(AppSettings());
  }
}

class _FakeAppSettingsRepository extends AppSettingsRepository {
  _FakeAppSettingsRepository() : super(userRepository: _FakeUserRepository());

  @override
  Future<AppSettings> load() async => const AppSettings();

  @override
  Future<void> save(AppSettings settings) async {}
}

class _FakeUserRepository extends UserRepository {
  _FakeUserRepository() : super(firestore: null, auth: null);
  @override
  Future<void> ensureUserDocument(
      {Map<String, dynamic> additionalData = const {}}) async {}
}

void main() {
  late MockSecurityNotifier mockSecurityNotifier;

  setUp(() {
    mockSecurityNotifier = MockSecurityNotifier();
  });

  Widget createTestWidget(SecurityNotifier securityNotifier) {
    return ProviderScope(
      overrides: [
        securityProvider.overrideWith((ref) => securityNotifier),
        appSettingsProvider.overrideWith((ref) => FakeAppSettingsNotifier()),
      ],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: AccountSecurityScreen(),
      ),
    );
  }

  group('Security Screen Widget Tests', () {
    testWidgets('should display security settings when loaded', (tester) async {
      // Mock the state
      const securityState = SecurityState(
        appLockEnabled: true,
        pinConfigured: true,
        journalLockEnabled: false,
        biometricsEnabled: true,
        isSessionValid: true,
      );

      when(() => mockSecurityNotifier.state)
          .thenReturn(const AsyncValue.data(securityState));

      await tester.pumpWidget(createTestWidget(mockSecurityNotifier));
      await tester.pumpAndSettle();

      // Should display security sections
      expect(find.byType(SectionLabel), findsNWidgets(3));
    });

    testWidgets('should show app lock toggle', (tester) async {
      const securityState = SecurityState(
        appLockEnabled: false,
        pinConfigured: false,
        journalLockEnabled: false,
        biometricsEnabled: false,
        isSessionValid: false,
      );

      when(() => mockSecurityNotifier.state)
          .thenReturn(const AsyncValue.data(securityState));

      await tester.pumpWidget(createTestWidget(mockSecurityNotifier));
      await tester.pumpAndSettle();

      expect(find.byType(Switch), findsWidgets);
    });
  });

  group('Lock Screen Widget Tests', () {
    testWidgets('should display lock screen', (tester) async {
      const securityState = SecurityState(
        appLockEnabled: true,
        pinConfigured: true,
        journalLockEnabled: false,
        biometricsEnabled: false,
        isSessionValid: false,
      );

      when(() => mockSecurityNotifier.state)
          .thenReturn(const AsyncValue.data(securityState));
      when(() => mockSecurityNotifier.authenticate())
          .thenAnswer((_) async => AuthResult.pinRequired());

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            securityProvider.overrideWith((ref) => mockSecurityNotifier),
            appSettingsProvider
                .overrideWith((ref) => FakeAppSettingsNotifier()),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: LockScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Should display lock screen and PinCodeInput
      expect(find.byType(PinCodeInput), findsOneWidget);
    });
  });

  // Note: Full widget testing of SecurityScreen is complex due to Riverpod dependencies
  // and platform-specific features. These tests focus on basic widget rendering.
  // Integration tests would be better for full UI interaction testing.
}
