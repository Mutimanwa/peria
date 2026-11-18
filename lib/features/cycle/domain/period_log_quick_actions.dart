import 'package:peria_app/features/cycle/data/models/period_log.dart';
import 'package:peria_app/features/cycle/domain/period_rules.dart';

/// Builds safe one-tap period-log changes for the Cycle Home quick actions.
///
/// The structured calendar remains available for corrections to older dates.
class PeriodLogQuickActions {
  const PeriodLogQuickActions._();

  /// Enregistre aujourd'hui comme jour de règles.
  ///
  /// Prolonge une période en cours (finie hier au plus tôt) tant qu'elle reste
  /// sous [PeriodRules.maxPeriodLengthDays] ; au-delà, une nouvelle période
  /// démarre aujourd'hui plutôt que d'étirer l'ancienne sur des semaines.
  static PeriodLog? recordToday({
    required List<PeriodLog> logs,
    required DateTime today,
  }) {
    final day = PeriodRules.dayOnly(today);
    final containing = logs.where((log) => log.contains(day)).toList()
      ..sort((a, b) => b.startDate.compareTo(a.startDate));

    if (containing.isNotEmpty) {
      final existing = containing.first;
      if (!existing.isEstimated) return null;
      final range = PeriodRules.clampRange(
        start: existing.startDate,
        end: existing.endDate,
        today: day,
      );
      return PeriodLog(
        id: existing.id,
        startDate: range.start,
        endDate: range.end,
        isEstimated: false,
      );
    }

    final yesterday = PeriodRules.addDays(day, -1);
    final previousDayLogs = logs
        .where((log) =>
            !PeriodRules.dayOnly(log.startDate).isAfter(day) &&
            PeriodRules.dayOnly(log.endDate).isAtSameMomentAs(yesterday))
        .toList()
      ..sort((a, b) => b.startDate.compareTo(a.startDate));

    if (previousDayLogs.isNotEmpty) {
      final previous = previousDayLogs.first;
      final continuesOngoingPeriod = PeriodRules.spanDays(
            previous.startDate,
            day,
          ) <=
          PeriodRules.maxPeriodLengthDays;
      if (continuesOngoingPeriod) {
        return PeriodLog(
          id: previous.id,
          startDate: PeriodRules.dayOnly(previous.startDate),
          endDate: day,
          isEstimated: false,
        );
      }
    }

    return PeriodLog(
      id: 'manual_period_${_dateKey(day)}',
      startDate: day,
      endDate: day,
      isEstimated: false,
    );
  }

  /// Démarre une période aujourd'hui.
  ///
  /// Renvoie `null` quand aujourd'hui est déjà enregistré : rien à ajouter.
  static PeriodLog? startToday({
    required List<PeriodLog> logs,
    required DateTime today,
  }) {
    final day = PeriodRules.dayOnly(today);
    final alreadyLogged = logs.any((log) => log.contains(day) && !log.isEstimated);
    if (alreadyLogged) return null;

    return PeriodLog(
      id: 'manual_period_${_dateKey(day)}',
      startDate: day,
      endDate: day,
      isEstimated: false,
    );
  }

  /// Ends a period only when its last recorded day is today or yesterday.
  /// Older gaps are left untouched so a quick action cannot silently turn
  /// several non-period days into one long period.
  static PeriodLog? endToday({
    required List<PeriodLog> logs,
    required DateTime today,
  }) {
    final day = PeriodRules.dayOnly(today);
    final yesterday = PeriodRules.addDays(day, -1);
    final recentLogs = logs
        .where((log) =>
            !PeriodRules.dayOnly(log.startDate).isAfter(day) &&
            !PeriodRules.dayOnly(log.endDate).isBefore(yesterday))
        .toList()
      ..sort((a, b) {
        final startComparison = b.startDate.compareTo(a.startDate);
        if (startComparison != 0) return startComparison;
        return b.endDate.compareTo(a.endDate);
      });

    if (recentLogs.isEmpty) return null;

    final latest = recentLogs.first;
    if (PeriodRules.dayOnly(latest.endDate).isAtSameMomentAs(day) &&
        !latest.isEstimated) {
      return null;
    }

    // Clore une période ouverte depuis des semaines produirait exactement la
    // plage démesurée qu'on cherche à éviter : on laisse la correction à
    // l'édition structurée.
    if (PeriodRules.spanDays(latest.startDate, day) >
        PeriodRules.maxPeriodLengthDays) {
      return null;
    }

    return PeriodLog(
      id: latest.id,
      startDate: PeriodRules.dayOnly(latest.startDate),
      endDate: day,
      isEstimated: false,
    );
  }

  static String _dateKey(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}
