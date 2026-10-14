import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:peria_app/core/services/app_locale_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('AppLocaleNotifier', () {
    test('restores the saved supported language', () async {
      SharedPreferences.setMockInitialValues({'peria_app_locale': 'fr'});
      final notifier = AppLocaleNotifier();

      await notifier.loadSavedLocale();

      expect(notifier.state, const Locale('fr'));
    });

    test('persists a selected language locally', () async {
      final notifier = AppLocaleNotifier();

      await notifier.setLanguageCode('en');

      final preferences = await SharedPreferences.getInstance();
      expect(notifier.state, const Locale('en'));
      expect(preferences.getString('peria_app_locale'), 'en');
    });

    test('ignores an unsupported saved language', () async {
      SharedPreferences.setMockInitialValues({'peria_app_locale': 'sw'});
      final notifier = AppLocaleNotifier();

      await notifier.loadSavedLocale();

      expect(notifier.state, isNull);
    });

    test('rejects unsupported language selections', () async {
      final notifier = AppLocaleNotifier();

      await expectLater(
        notifier.setLanguageCode('sw'),
        throwsArgumentError,
      );
      expect(notifier.state, isNull);
    });
  });
}
