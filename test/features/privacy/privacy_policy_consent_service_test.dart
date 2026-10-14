import 'package:flutter_test/flutter_test.dart';
import 'package:peria_app/core/services/privacy_policy_consent_service.dart';
import 'package:peria_app/core/storage/journal_sync_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  final service = PrivacyPolicyConsentService();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await service.loadCurrentAcceptance();
  });

  test('the consent gate is closed before acceptance', () {
    expect(
      PrivacyPolicyConsentService.requireCurrentPolicyAcceptance,
      throwsStateError,
    );
  });

  test('acceptance is persisted for the current policy version', () async {
    expect(PrivacyPolicyConsentService.hasAcceptedCurrentVersion, isFalse);

    await service.acceptCurrentPolicy();

    expect(PrivacyPolicyConsentService.hasAcceptedCurrentVersion, isTrue);
    expect(await service.loadCurrentAcceptance(), isTrue);
  });

  test('an acceptance of an older version must be renewed', () async {
    SharedPreferences.setMockInitialValues({
      'privacy.policy.accepted_version': '1.0',
    });

    expect(await service.loadCurrentAcceptance(), isFalse);
  });

  test('policy acceptance does not enable optional journal sync', () async {
    await service.acceptCurrentPolicy();

    expect(
      await const JournalSyncPreferences().isEnabledFor('test-user'),
      isFalse,
    );
  });
}
