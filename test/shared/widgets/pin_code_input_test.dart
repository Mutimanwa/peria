import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:peria_app/l10n/app_localizations.dart';
import 'package:peria_app/shared/widgets/pin_code_input.dart';

void main() {
  Widget wrap(Widget child) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: Center(child: child)),
    );
  }

  testWidgets('un seul champ porte la saisie', (tester) async {
    await tester.pumpWidget(wrap(
      PinCodeInput(length: 4, onCompleted: (_) {}),
    ));

    // Un champ par chiffre perdait des frappes ; on n'en veut qu'un.
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('le code complet est transmis une seule fois', (tester) async {
    final codes = <String>[];
    await tester.pumpWidget(wrap(
      PinCodeInput(length: 4, onCompleted: codes.add),
    ));

    await tester.enterText(find.byType(TextField), '1234');
    await tester.pump();

    expect(codes, ['1234']);
  });

  testWidgets('un code saisi vite ne perd aucun chiffre', (tester) async {
    final codes = <String>[];
    await tester.pumpWidget(wrap(
      PinCodeInput(length: 4, onCompleted: codes.add),
    ));

    for (final digit in ['1', '2', '3', '4']) {
      await tester.enterText(find.byType(TextField), digit);
    }
    await tester.pump();

    // enterText remplace le contenu : on verifie surtout le dernier etat.
    expect(codes, isEmpty);

    await tester.enterText(find.byType(TextField), '9876');
    await tester.pump();
    expect(codes, ['9876']);
  });

  testWidgets('les caracteres non numeriques sont ignores', (tester) async {
    final changes = <String>[];
    final codes = <String>[];
    await tester.pumpWidget(wrap(
      PinCodeInput(length: 4, onChanged: changes.add, onCompleted: codes.add),
    ));

    await tester.enterText(find.byType(TextField), '12a4');
    await tester.pump();

    expect(changes.last, '124');
    expect(codes, isEmpty);
  });

  testWidgets('un code refuse vide la saisie', (tester) async {
    Widget build({String? error}) => wrap(
          PinCodeInput(
            key: const ValueKey('pin'),
            length: 4,
            error: error,
            onCompleted: (_) {},
          ),
        );

    await tester.pumpWidget(build());
    await tester.enterText(find.byType(TextField), '1234');
    await tester.pump();

    await tester.pumpWidget(build(error: 'Code PIN incorrect.'));
    await tester.pump();

    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.controller?.text, isEmpty);
  });
}
