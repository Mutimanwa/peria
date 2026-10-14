import 'package:flutter_test/flutter_test.dart';
import 'package:peria_app/features/profile/data/models/partner_settings.dart';

void main() {
  test('partner data sharing choices default to off', () {
    const settings = PartnerSettings();
    final restoredLegacySettings = PartnerSettings.fromJson({});

    expect(settings.shareCyclePredictions, isFalse);
    expect(settings.shareLoggedSymptoms, isFalse);
    expect(settings.sharePeriodDates, isFalse);
    expect(settings.shareMoodEntries, isFalse);
    expect(restoredLegacySettings.shareLoggedSymptoms, isFalse);
    expect(restoredLegacySettings.shareMoodEntries, isFalse);
  });
}
