import 'package:peria_app/features/cycle/data/models/period_log.dart';

/// Builds safe one-tap period-log changes for the Cycle Home quick actions.
///
/// The structured calendar remains available for corrections to older dates.
class PeriodLogQuickActions {
  const PeriodLogQuickActions._();

  static PeriodLog? recordToday({
    required List<PeriodLog> logs,
    required DateTime today,
  }) {
    final day = _dateOnly(today);
    final containing = logs.where((log) => log.contains(day)).toList()
      ..sort((a, b) => b.startDate.compareTo(a.startDate));

    if (containing.isNotEmpty) {
      final existing = containing.first;
      if (!existing.isEstimated) return null;
      return PeriodLog(
        id: existing.id,
        startDate: _dateOnly(existing.startDate),
        endDate: _dateOnly(existing.endDate),
        isEstimated: false,
      );
    }

    final yesterday = _addDays(day, -1);
    final previousDayLogs = logs
        .where((log) =>
            !_dateOnly(log.startDate).isAfter(day) &&
            _dateOnly(log.endDate).isAtSameMomentAs(yesterday))
        .toList()
      ..sort((a, b) => b.startDate.compareTo(a.startDate));

    if (previousDayLogs.isNotEmpty) {
      final previous = previousDayLogs.first;
      return PeriodLog(
        id: previous.id,
        startDate: _dateOnly(previous.startDate),
        endDate: day,
        isEstimated: false,
      );
    }

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
    final day = _dateOnly(today);
    final yesterday = _addDays(day, -1);
    final recentLogs = logs
        .where((log) =>
            !_dateOnly(log.startDate).isAfter(day) &&
            !_dateOnly(log.endDate).isBefore(yesterday))
        .toList()
      ..sort((a, b) {
        final startComparison = b.startDate.compareTo(a.startDate);
        if (startComparison != 0) return startComparison;
        return b.endDate.compareTo(a.endDate);
      });

    if (recentLogs.isEmpty) return null;

    final latest = recentLogs.first;
    if (_dateOnly(latest.endDate).isAtSameMomentAs(day) &&
        !latest.isEstimated) {
      return null;
    }

    return PeriodLog(
      id: latest.id,
      startDate: _dateOnly(latest.startDate),
      endDate: day,
      isEstimated: false,
    );
  }

  static DateTime _dateOnly(DateTime value) =>
      DateTime(value.year, value.month, value.day);

  static DateTime _addDays(DateTime date, int days) =>
      DateTime(date.year, date.month, date.day + days);

  static String _dateKey(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}
