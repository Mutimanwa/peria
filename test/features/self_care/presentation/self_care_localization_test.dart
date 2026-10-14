import 'package:flutter_test/flutter_test.dart';
import 'package:peria_app/features/self_care/presentation/screens/self_care_localization.dart';
import 'package:peria_app/l10n/app_localizations_en.dart';
import 'package:peria_app/l10n/app_localizations_fr.dart';

void main() {
  group('Self Care localization', () {
    final english = AppLocalizationsEn();
    final french = AppLocalizationsFr();

    test('maps shared content to each supported language', () {
      expect(localizeSelfCareData('Gentle movement for cramps', english),
          'Gentle movement for cramps');
      expect(localizeSelfCareData('Gentle movement for cramps', french),
          'Mouvements doux contre les crampes');
      expect(localizeSelfCareData('Chin to Chest', french),
          'Menton vers la poitrine');
      expect(localizeSelfCareData('Brath of Life', french),
          'Le souffle de la vie');
    });

    test('localizes durations and counts without losing their values', () {
      expect(localizeSelfCareData('5 min', english), '5 min');
      expect(localizeSelfCareData('5 min', french), '5 min');
      expect(localizeSelfCareData('4 min read', french), '4 min de lecture');
      expect(localizeSelfCareData('7 low-impact exercises', french),
          '7 exercices à faible impact');
    });

    test('leaves unknown content unchanged instead of inventing a translation',
        () {
      expect(localizeSelfCareData('User-created content', french),
          'User-created content');
    });
  });
}
