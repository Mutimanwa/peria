import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:peria_app/shared/widgets/app_language_selector.dart';

void main() {
  testWidgets(
    'shows language codes and selects French in compact mode',
    (tester) async {
      String? selectedLanguageCode;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: AppLanguageSelector(
                currentLanguageCode: 'en',
                englishLabel: 'English',
                frenchLabel: 'Français',
                compact: true,
                onSelected: (languageCode) {
                  selectedLanguageCode = languageCode;
                },
              ),
            ),
          ),
        ),
      );

      expect(find.text('EN'), findsOneWidget);
      expect(find.text('FR'), findsOneWidget);

      await tester.tap(find.text('FR'));
      expect(selectedLanguageCode, 'fr');
    },
  );
}
