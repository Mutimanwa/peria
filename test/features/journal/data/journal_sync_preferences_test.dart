import 'package:flutter_test/flutter_test.dart';
import 'package:peria_app/core/storage/journal_sync_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('JournalSyncPreferences', () {
    test('cloud sync is off by default', () async {
      const preferences = JournalSyncPreferences();

      expect(await preferences.isEnabledFor('user-a'), isFalse);
      expect(await preferences.consentedAt(), isNull);
      expect(await preferences.lastSyncedAt('user-a'), isNull);
    });

    test('consent is scoped to the account and can be revoked', () async {
      const preferences = JournalSyncPreferences();
      final consentedAt = DateTime.utc(2026, 10, 12, 8, 30);

      await preferences.enable(userId: 'user-a', consentedAt: consentedAt);
      expect(await preferences.isEnabledFor('user-a'), isTrue);
      expect(await preferences.isEnabledFor('user-b'), isFalse);
      expect(await preferences.consentedAt(), consentedAt);

      await preferences.disable();
      expect(await preferences.isEnabledFor('user-a'), isFalse);
      // Revoking sync does not erase the local consent audit timestamp.
      expect(await preferences.consentedAt(), consentedAt);
    });

    test(
      'a previous account cannot overwrite the current account status',
      () async {
        const preferences = JournalSyncPreferences();
        final userAConsentAt = DateTime.utc(2026, 10, 12, 8);
        final userBConsentAt = DateTime.utc(2026, 10, 12, 9);

        await preferences.enable(userId: 'user-a', consentedAt: userAConsentAt);
        await preferences.markSynced('user-a', userAConsentAt);
        await preferences.markSyncFailed('user-a');
        await preferences.enable(userId: 'user-b', consentedAt: userBConsentAt);
        await preferences.markSynced('user-a', userBConsentAt);

        expect(await preferences.isEnabledFor('user-a'), isFalse);
        expect(await preferences.isEnabledFor('user-b'), isTrue);
        expect(await preferences.lastSyncedAt('user-b'), isNull);
        expect(await preferences.lastAttemptFailed('user-b'), isFalse);
      },
    );

    test('sync health is recorded and reset clears the local opt-in', () async {
      const preferences = JournalSyncPreferences();
      final syncedAt = DateTime.utc(2026, 10, 12, 9);

      await preferences.enable(userId: 'user-a', consentedAt: syncedAt);
      await preferences.markSynced('user-a', syncedAt);
      expect(await preferences.lastSyncedAt('user-a'), syncedAt);
      expect(await preferences.lastAttemptFailed('user-a'), isFalse);
      expect(await preferences.lastSyncedAt('user-b'), isNull);

      await preferences.markSyncFailed('user-a');
      expect(await preferences.lastAttemptFailed('user-a'), isTrue);

      await preferences.reset();
      expect(await preferences.isEnabledFor('user-a'), isFalse);
      expect(await preferences.consentedAt(), isNull);
      expect(await preferences.lastSyncedAt('user-a'), isNull);
      expect(await preferences.lastAttemptFailed('user-a'), isFalse);
    });
  });
}
