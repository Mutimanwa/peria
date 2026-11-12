/// Spoken description of a calendar day.
///
/// Screen readers announce one sentence per cell instead of the bare number,
/// so the phase and the markers are reachable without seeing the colours.
String calendarDaySemanticsLabel({
  required String dateLabel,
  required bool isToday,
  required bool isLoggedPeriod,
  required bool isPredictedPeriod,
  required bool isFertileWindow,
  required bool isPms,
  required bool hasSymptoms,
  required bool hasJournal,
  required String todayLabel,
  required String loggedPeriodLabel,
  required String predictedPeriodLabel,
  required String fertilityWindowLabel,
  required String pmsLabel,
  required String symptomsLabel,
  required String journalLabel,
}) {
  final parts = <String>[dateLabel];
  if (isToday) parts.add(todayLabel);
  if (isLoggedPeriod) {
    parts.add(loggedPeriodLabel);
  } else if (isPredictedPeriod) {
    // A logged day already says "recorded period": predicting it again would
    // make the announcement contradictory.
    parts.add(predictedPeriodLabel);
  }
  if (isFertileWindow) parts.add(fertilityWindowLabel);
  if (isPms) parts.add(pmsLabel);
  if (hasSymptoms) parts.add(symptomsLabel);
  if (hasJournal) parts.add(journalLabel);
  return parts.join(', ');
}
