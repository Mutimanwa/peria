import 'package:peria_app/features/cycle/data/models/period_log.dart';
import 'package:peria_app/features/cycle/domain/cycle_status.dart';

/// A canonical view of cycle data for one calendar date.
///
/// Real period logs take precedence over generated period predictions, while
/// keeping both classifications available to distinguish them in the UI.
class CycleDayInfo {
  const CycleDayInfo({
    required this.status,
    required this.isLoggedPeriod,
    required this.isPredictedPeriod,
    required this.isFertileWindow,
    required this.isPmsDay,
    required this.isOverdue,
  });

  factory CycleDayInfo.forDate({
    required DateTime date,
    required CycleStatus? status,
    required List<PeriodLog> periodLogs,
    required DateTime today,
  }) {
    final day = DateTime(date.year, date.month, date.day);
    final todayStart = DateTime(today.year, today.month, today.day);
    final isLoggedPeriod = periodLogs.any((log) => log.contains(day));
    final hasLoggedCycleAnchor = status != null &&
        periodLogs.any((log) =>
            log.startDate.year == status.startDate.year &&
            log.startDate.month == status.startDate.month &&
            log.startDate.day == status.startDate.day);

    bool includesDay(List<DateTime>? dates) => dates?.any((candidate) =>
        candidate.year == day.year &&
        candidate.month == day.month &&
        candidate.day == day.day) ?? false;

    final isToday = day.year == todayStart.year &&
        day.month == todayStart.month &&
        day.day == todayStart.day;

    return CycleDayInfo(
      status: status,
      isLoggedPeriod: isLoggedPeriod,
      isPredictedPeriod: !isLoggedPeriod &&
          !hasLoggedCycleAnchor &&
          includesDay(status?.periodDays),
      isFertileWindow: includesDay(status?.fertileWindow),
      isPmsDay: includesDay(status?.pmsDays),
      isOverdue: !isLoggedPeriod && status?.isOverdue == true && isToday,
    );
  }

  /// Calculated cycle status for the requested date, or null without cycle input.
  final CycleStatus? status;

  /// A period day explicitly present in a saved period log.
  final bool isLoggedPeriod;

  /// A predicted period day not already represented by a saved period log.
  final bool isPredictedPeriod;

  final bool isFertileWindow;
  final bool isPmsDay;
  final bool isOverdue;

  bool get isPeriodDay => isLoggedPeriod || isPredictedPeriod;
}
