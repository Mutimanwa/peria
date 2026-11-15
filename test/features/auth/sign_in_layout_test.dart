import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:peria_app/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:peria_app/l10n/app_localizations.dart';

void main() {
  testWidgets('le formulaire se reduit quand le clavier s ouvre',
      (tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const SignInScreen(),
        ),
      ),
    );
    await tester.pump();

    final withoutKeyboard =
        tester.getSize(find.byType(SingleChildScrollView)).height;

    // Clavier ouvert : le corps doit se reduire, sinon les champs restent
    // dessous et la zone defilable ne sait pas qu'il faut defiler.
    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    await tester.pump();

    final withKeyboard =
        tester.getSize(find.byType(SingleChildScrollView)).height;

    expect(withKeyboard, lessThan(withoutKeyboard));
    expect(withKeyboard, lessThanOrEqualTo(340 + 1));
  });
}
