/// Peria is not available to children under this age.
const int minimumAccountAgeYears = 10;

/// Calendar age on [on], ignoring the time of day.
int ageInYears(DateTime dateOfBirth, DateTime on) {
  var years = on.year - dateOfBirth.year;
  final birthdayReached = on.month > dateOfBirth.month ||
      (on.month == dateOfBirth.month && on.day >= dateOfBirth.day);
  if (!birthdayReached) years -= 1;
  return years;
}

bool isAtLeastMinimumAge(
  DateTime dateOfBirth,
  DateTime on, {
  int minimumAge = minimumAccountAgeYears,
}) {
  return ageInYears(dateOfBirth, on) >= minimumAge;
}

/// Builds a real calendar date, clamping days that do not exist in [month].
DateTime calendarDate(int year, int month, int day) {
  final lastDay = DateTime(year, month + 1, 0).day;
  final safeDay = day < 1 ? 1 : (day > lastDay ? lastDay : day);
  return DateTime(year, month, safeDay);
}
