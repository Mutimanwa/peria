/// Bornes partagées par tout ce qui écrit une période de règles.
///
/// Sans borne, un enchaînement de « la règle continue aujourd'hui » et de
/// corrections dans l'éditeur structuré étire un même enregistrement sur des
/// semaines : le calendrier finit par peindre quarante jours de règles, et les
/// statistiques de cycle deviennent fausses.
class PeriodRules {
  const PeriodRules._();

  /// Durée maximale d'une période enregistrée, en jours (bornes incluses).
  ///
  /// Une période plus longue n'est pas physiologique ; au-delà, c'est une
  /// saisie à corriger, pas un cycle à peindre.
  static const int maxPeriodLengthDays = 10;

  /// Nombre de mois consultables dans l'édition structurée, mois courant inclus.
  static const int maxLookBackMonths = 12;

  static DateTime dayOnly(DateTime value) =>
      DateTime(value.year, value.month, value.day);

  static DateTime addDays(DateTime value, int days) =>
      DateTime(value.year, value.month, value.day + days);

  /// Nombre de jours couverts par une plage, bornes incluses.
  static int spanDays(DateTime start, DateTime end) =>
      dayOnly(end).difference(dayOnly(start)).inDays + 1;

  /// Vrai si [day] est postérieur à [today] (comparaison au jour près).
  static bool isAfterToday(DateTime day, DateTime today) =>
      dayOnly(day).isAfter(dayOnly(today));

  /// Ramène une plage dans les bornes : fin ≥ début, fin jamais dans le futur,
  /// longueur ≤ [maxPeriodLengthDays].
  static PeriodRange clampRange({
    required DateTime start,
    required DateTime end,
    required DateTime today,
  }) {
    final normalizedStart = dayOnly(start);
    final todayDay = dayOnly(today);

    var normalizedEnd = dayOnly(end);
    if (normalizedEnd.isBefore(normalizedStart)) normalizedEnd = normalizedStart;
    if (normalizedEnd.isAfter(todayDay)) {
      normalizedEnd =
          todayDay.isBefore(normalizedStart) ? normalizedStart : todayDay;
    }

    final latestEnd = addDays(normalizedStart, maxPeriodLengthDays - 1);
    if (normalizedEnd.isAfter(latestEnd)) normalizedEnd = latestEnd;

    return PeriodRange(start: normalizedStart, end: normalizedEnd);
  }

  /// Dernier jour sélectionnable après un début donné : borne de durée et
  /// borne du jour courant, la plus contraignante des deux.
  static DateTime latestSelectableEnd(DateTime start, DateTime today) {
    final byLength = addDays(dayOnly(start), maxPeriodLengthDays - 1);
    final todayDay = dayOnly(today);
    return byLength.isAfter(todayDay) ? todayDay : byLength;
  }
}

/// Plage de jours normalisée, bornes incluses.
class PeriodRange {
  const PeriodRange({required this.start, required this.end});

  final DateTime start;
  final DateTime end;

  int get lengthInDays => PeriodRules.spanDays(start, end);

  bool contains(DateTime day) {
    final normalized = PeriodRules.dayOnly(day);
    return !normalized.isBefore(start) && !normalized.isAfter(end);
  }

  @override
  String toString() => '$start → $end ($lengthInDays j)';
}
