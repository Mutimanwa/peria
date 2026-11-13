import 'package:flutter_test/flutter_test.dart';
import 'package:peria_app/features/calendar/presentation/day_semantics.dart';

String build({
  bool isToday = false,
  bool isLoggedPeriod = false,
  bool isPredictedPeriod = false,
  bool isFertileWindow = false,
  bool isPms = false,
  bool hasSymptoms = false,
  bool hasJournal = false,
}) {
  return calendarDaySemanticsLabel(
    dateLabel: '12 novembre 2026',
    isToday: isToday,
    isLoggedPeriod: isLoggedPeriod,
    isPredictedPeriod: isPredictedPeriod,
    isFertileWindow: isFertileWindow,
    isPms: isPms,
    hasSymptoms: hasSymptoms,
    hasJournal: hasJournal,
    todayLabel: "Aujourd'hui",
    loggedPeriodLabel: 'Règles enregistrées',
    predictedPeriodLabel: 'Règles prévues',
    fertilityWindowLabel: 'Fenêtre fertile',
    pmsLabel: 'Jour de SPM',
    symptomsLabel: 'Symptômes',
    journalLabel: 'Journal',
  );
}

void main() {
  test('a plain day only announces its date', () {
    expect(build(), '12 novembre 2026');
  });

  test('announces today right after the date', () {
    expect(build(isToday: true), "12 novembre 2026, Aujourd'hui");
  });

  test('lists the markers in a stable order', () {
    expect(
      build(
        isFertileWindow: true,
        hasSymptoms: true,
        hasJournal: true,
      ),
      '12 novembre 2026, Fenêtre fertile, Symptômes, Journal',
    );
  });

  test('a recorded period hides the prediction instead of contradicting it',
      () {
    expect(
      build(isLoggedPeriod: true, isPredictedPeriod: true),
      '12 novembre 2026, Règles enregistrées',
    );
    expect(
      build(isPredictedPeriod: true),
      '12 novembre 2026, Règles prévues',
    );
  });

  test('a fully marked day stays readable', () {
    expect(
      build(
        isToday: true,
        isLoggedPeriod: true,
        isFertileWindow: true,
        isPms: true,
        hasSymptoms: true,
        hasJournal: true,
      ),
      "12 novembre 2026, Aujourd'hui, Règles enregistrées, "
      'Fenêtre fertile, Jour de SPM, Symptômes, Journal',
    );
  });
}
