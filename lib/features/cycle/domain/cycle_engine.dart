import 'dart:math' as math;

import 'package:peria_app/features/cycle/data/models/period_log.dart';
import 'package:peria_app/features/cycle/domain/cycle_phase.dart';
import 'package:peria_app/features/cycle/domain/cycle_regularity.dart';
import 'package:peria_app/features/cycle/domain/cycle_statistics.dart';
import 'package:peria_app/features/cycle/domain/cycle_status.dart';

class CycleEngine {
  const CycleEngine._();

  /// Number of complete cycles needed before the confidence can reach
  /// [reliableConfidenceScore]. Four regular cycles are enough to stop calling
  /// the prediction an estimate.
  static const int cyclesForFullConfidence = 4;

  /// Below this score the dates are shown as an estimate (`isEstimated`).
  static const double reliableConfidenceScore = 0.7;

  /// Extra days allowed after the predicted start before the calendar flags the
  /// period as overdue. A couple of days of variation is normal and stays quiet.
  static const int overdueToleranceDays = 2;

  /// The fertile window starts five days before the estimated ovulation: sperm
  /// can survive that long. It ends on the last day of the ±2 ovulation range.
  static const int fertileDaysBeforeOvulation = 5;

  static const int _maxPeriodLengthDays = 14;

  static DateTime _startOfDay(DateTime value) =>
      DateTime(value.year, value.month, value.day);

  static DateTime _addCalendarDays(DateTime value, int days) =>
      DateTime(value.year, value.month, value.day + days);

  static int _calendarDayDifference(DateTime a, DateTime b) {
    final utcA = DateTime.utc(a.year, a.month, a.day);
    final utcB = DateTime.utc(b.year, b.month, b.day);
    return utcA.difference(utcB).inDays;
  }

  static DateTime _endOfDay(DateTime value) => DateTime(
        value.year,
        value.month,
        value.day,
        23,
        59,
        59,
        999,
      );

  /// Confidence in the predicted dates, between 0.05 and 0.95.
  ///
  /// The score grows with the amount of history (0.2 with a single saved period,
  /// 0.9 once four complete cycles are known) and is scaled down when the cycle
  /// lengths vary around the average. A well tracked, regular history therefore
  /// reaches [reliableConfidenceScore] instead of being capped below it.
  static double _calculateConfidenceScore({
    required int completedCycles,
    required int cycleVariance,
    required bool isIrregular,
  }) {
    final coverage =
        (completedCycles / cyclesForFullConfidence).clamp(0.0, 1.0).toDouble();
    final historyConfidence = 0.2 + 0.7 * coverage;

    // Standard deviation of 0 days keeps the full score; 14 days or more keeps
    // only 40 % of it.
    final regularity =
        1 - (cycleVariance / 14).clamp(0.0, 0.6).toDouble();

    // A cycle that is irregular by the app's own definition loses a bit more.
    final irregularityPenalty = isIrregular ? 0.1 : 0.0;

    return (historyConfidence * regularity - irregularityPenalty)
        .clamp(0.05, 0.95)
        .toDouble();
  }

  /// Average length of the periods the user actually recorded.
  ///
  /// Only saved periods (never predictions) that are already over are counted,
  /// so an ongoing period or a range drawn on the calendar cannot shrink the
  /// average. [fallback] is the profile setting, used until a period is known.
  static int resolvePeriodLength({
    required List<PeriodLog> logs,
    required int fallback,
    required DateTime today,
  }) {
    final lengths = <int>[];
    for (final log in logs) {
      if (log.isEstimated) continue;
      // A period that ends today (or later) may still be running.
      if (!_startOfDay(log.endDate).isBefore(_startOfDay(today))) continue;
      final length = _calendarDayDifference(log.endDate, log.startDate) + 1;
      if (length < 1 || length > _maxPeriodLengthDays) continue;
      lengths.add(length);
    }

    if (lengths.isEmpty) {
      return fallback.clamp(1, _maxPeriodLengthDays).toInt();
    }

    final recent = lengths.take(6).toList();
    final average = recent.reduce((a, b) => a + b) / recent.length;
    return average.round().clamp(1, _maxPeriodLengthDays).toInt();
  }

  /// Aggregate statistics over all logged cycle intervals.
  static CycleStatistics? computeStatistics({
    required List<PeriodLog> logs,
  }) {
    if (logs.length < 2) return null;

    final sortedLogs = [...logs]
      ..sort((a, b) => b.startDate.compareTo(a.startDate));
    final cycleLengths = <int>[];
    for (var i = 0; i < sortedLogs.length - 1; i++) {
      cycleLengths.add(_calendarDayDifference(
        sortedLogs[i].startDate,
        sortedLogs[i + 1].startDate,
      ));
    }
    if (cycleLengths.isEmpty) return null;

    final average = cycleLengths.reduce((a, b) => a + b) / cycleLengths.length;
    final variance = cycleLengths
            .map((length) => math.pow(length - average, 2))
            .reduce((a, b) => a + b) /
        cycleLengths.length;
    final standardDeviation = math.sqrt(variance);

    return CycleStatistics(
      averageCycleLength: average.round(),
      minCycleLength: cycleLengths.reduce((a, b) => a < b ? a : b),
      maxCycleLength: cycleLengths.reduce((a, b) => a > b ? a : b),
      stdDeviation: standardDeviation,
      // One cycle is the interval between two saved periods: n periods describe
      // n-1 complete cycles.
      totalCyclesLogged: cycleLengths.length,
      isRegular: standardDeviation <= 5,
    );
  }

  static CycleStatus? computeFromLogs({
    required List<PeriodLog> logs,
    required int userCycleLengthDays,
    required int userPeriodLengthDays,
    required int pmsDaysSetting,
    DateTime? now,
    DateTime? today,
  }) {
    final requestedDate = _startOfDay(now ?? DateTime.now());
    final currentDate = _startOfDay(today ?? now ?? DateTime.now());
    final logsOnOrBeforeDate = logs
        .where((log) => !_startOfDay(log.startDate).isAfter(requestedDate))
        .toList();
    if (logsOnOrBeforeDate.isEmpty) return null;

    final sortedLogs = [...logsOnOrBeforeDate]
      ..sort((a, b) => b.startDate.compareTo(a.startDate));
    final latestLog = sortedLogs.first;
    final predictionLogs = sortedLogs.take(6).toList();
    final predictionStatistics =
        computeStatistics(logs: predictionLogs);
    final averageCycleLength =
        predictionStatistics?.averageCycleLength ?? userCycleLengthDays;
    final cycleVariance = predictionStatistics?.stdDeviation.round() ?? 0;
    final isIrregular = predictionStatistics?.isRegular == false;
    final completedCycles = predictionStatistics?.totalCyclesLogged ?? 0;
    final confidenceScore = _calculateConfidenceScore(
      completedCycles: completedCycles,
      cycleVariance: cycleVariance,
      isIrregular: isIrregular,
    );
    final periodLengthDays = resolvePeriodLength(
      logs: sortedLogs,
      fallback: userPeriodLengthDays,
      today: currentDate,
    );

    return compute(
      startDate: latestLog.startDate,
      endDate: latestLog.endDate,
      cycleLengthDays: averageCycleLength,
      periodLengthDays: periodLengthDays,
      pmsDaysSetting: pmsDaysSetting,
      cycleVariance: cycleVariance,
      confidenceScore: confidenceScore,
      isEstimated: confidenceScore < reliableConfidenceScore,
      cycleRegularity: isIrregular
          ? CycleRegularity.irregular
          : CycleRegularity.regular,
      now: now,
      today: currentDate,
    );
  }

  static CycleStatus? computeFromSingleLog({
    required DateTime startDate,
    required DateTime endDate,
    required int userCycleLengthDays,
    required int userPeriodLengthDays,
    required int pmsDaysSetting,
    DateTime? now,
    DateTime? today,
  }) {
    final requestedDate = _startOfDay(now ?? DateTime.now());
    if (requestedDate.isBefore(_startOfDay(startDate))) return null;

    return compute(
      startDate: startDate,
      endDate: endDate,
      cycleLengthDays: userCycleLengthDays,
      periodLengthDays: userPeriodLengthDays,
      pmsDaysSetting: pmsDaysSetting,
      cycleVariance: 0,
      confidenceScore: 0.2,
      isEstimated: true,
      cycleRegularity: CycleRegularity.regular,
      now: now,
      today: today,
    );
  }

  /// Builds the status for [now] from the last saved period.
  ///
  /// Two clocks are used on purpose:
  /// * [now] is the date being described (the calendar asks about any date);
  /// * [today] is the real current day, which decides whether the period is late.
  ///
  /// The cycle day never restarts on its own: while a period is late, the open
  /// cycle keeps counting (day 32, not "day 4 of a cycle that never started").
  /// Dates after [today] are still projected cycle by cycle so the calendar
  /// keeps showing the next periods, fertile windows and PMS.
  static CycleStatus? compute({
    required DateTime startDate,
    required DateTime endDate,
    required int cycleLengthDays,
    required int periodLengthDays,
    required int pmsDaysSetting,
    required int cycleVariance,
    required double confidenceScore,
    required bool isEstimated,
    required CycleRegularity cycleRegularity,
    DateTime? now,
    DateTime? today,
  }) {
    if (cycleLengthDays <= 0 || periodLengthDays <= 0) return null;

    final current = now ?? DateTime.now();
    final normalizedStartDate = _startOfDay(startDate);
    final requestedDate = _startOfDay(current);
    final todayDate = _startOfDay(today ?? current);

    // Check if there's a real log covering the requested date or today.
    final isInRealPeriod = _isInRealPeriod(current, startDate, endDate);
    final isPeriodToday = _isInRealPeriod(todayDate, startDate, endDate);

    final daysSinceStartToday =
        _calendarDayDifference(todayDate, normalizedStartDate);
    final lateDaysToday = math.max(0, daysSinceStartToday - cycleLengthDays);
    final isLate = !isPeriodToday && lateDaysToday > 0;
    final isOverdue = isLate && lateDaysToday > overdueToleranceDays;

    // The open cycle is the last saved one; a projected cycle starts only for
    // dates that are still in the future.
    final daysSinceStart =
        _calendarDayDifference(requestedDate, normalizedStartDate);
    final cyclesElapsed =
        daysSinceStart >= 0 ? daysSinceStart ~/ cycleLengthDays : 0;
    final currentCycleStart =
        _addCalendarDays(normalizedStartDate, cyclesElapsed * cycleLengthDays);
    final projectedDayOfCycle =
        _calendarDayDifference(requestedDate, currentCycleStart) + 1;

    final keepOpenCycle = isLate && !requestedDate.isAfter(todayDate);
    final dayOfCycle =
        keepOpenCycle ? daysSinceStart + 1 : projectedDayOfCycle;

    final useRealPeriodForCycle = isInRealPeriod;
    final computedEndDate = useRealPeriodForCycle
        ? _endOfDay(endDate)
        : _endOfDay(_addCalendarDays(currentCycleStart, periodLengthDays - 1));

    // Ovulation range (±2 days) around the estimated ovulation.
    final predictedOvulationDay =
        (cycleLengthDays - 14).clamp(1, cycleLengthDays).toInt();
    final ovulationRangeStartDay =
        (predictedOvulationDay - 2).clamp(1, cycleLengthDays).toInt();
    final ovulationRangeEndDay =
        (predictedOvulationDay + 2).clamp(1, cycleLengthDays).toInt();

    final ovulationDateStart =
        _addCalendarDays(currentCycleStart, ovulationRangeStartDay - 1);
    final ovulationDateEnd =
        _addCalendarDays(currentCycleStart, ovulationRangeEndDay - 1);
    final ovulationEstimateMid =
        _addCalendarDays(currentCycleStart, predictedOvulationDay - 1);

    // Fertile window: J-5 (sperm survival), the ovulation day itself and the
    // two days after it that belong to the ovulation uncertainty range. It can
    // never start before the first day of the cycle.
    final fertileStart = _laterOf(
      currentCycleStart,
      _addCalendarDays(ovulationEstimateMid, -fertileDaysBeforeOvulation),
    );
    final fertileEnd = ovulationDateEnd;

    final fertileWindow = List.generate(
      _calendarDayDifference(fertileEnd, fertileStart) + 1,
      (index) => _addCalendarDays(fertileStart, index),
    );

    final periodDays = List.generate(
      periodLengthDays,
      (index) => _addCalendarDays(currentCycleStart, index),
    );

    final nextPeriodStart = _addCalendarDays(currentCycleStart, cycleLengthDays);
    final pmsDays = _computePmsDays(nextPeriodStart, pmsDaysSetting);

    // The phase follows [dayOfCycle]: a late period is luteal, never menstrual
    // when nothing was logged.
    CyclePhase phase;
    if (useRealPeriodForCycle) {
      phase = CyclePhase.menstrual;
    } else if (dayOfCycle >= 1 && dayOfCycle <= periodLengthDays) {
      phase = CyclePhase.menstrual;
    } else if (dayOfCycle >= ovulationRangeStartDay &&
        dayOfCycle <= ovulationRangeEndDay) {
      phase = CyclePhase.ovulation;
    } else if (dayOfCycle > ovulationRangeEndDay) {
      phase = CyclePhase.luteal;
    } else {
      phase = CyclePhase.follicular;
    }

    final daysUntilNextPeriod =
        _calendarDayDifference(nextPeriodStart, todayDate);

    return CycleStatus(
      startDate: currentCycleStart,
      endDate: computedEndDate,
      cycleLengthDays: cycleLengthDays,
      periodLengthDays: periodLengthDays,
      now: current,
      isInPeriod: isInRealPeriod,
      dayOfCycle: dayOfCycle,
      phase: phase,
      nextPeriodStart: nextPeriodStart,
      ovulationDate: ovulationEstimateMid,
      ovulationRangeStart: ovulationDateStart,
      ovulationRangeEnd: ovulationDateEnd,
      fertileWindowStart: fertileStart,
      fertileWindowEnd: fertileEnd,
      fertileWindow: fertileWindow,
      periodDays: periodDays,
      pmsDays: pmsDays,
      isOverdue: isOverdue,
      // Kept even within the tolerance: one day late is worth saying out loud,
      // it is only the calendar warning that waits a couple of days.
      overdueDays: isLate ? lateDaysToday : 0,
      daysUntilNextPeriod: daysUntilNextPeriod,
      confidenceScore: confidenceScore,
      isEstimated: isEstimated,
      cycleRegularity: cycleRegularity,
      cycleVariance: cycleVariance,
      useRealData: useRealPeriodForCycle,
    );
  }

  static DateTime _laterOf(DateTime a, DateTime b) => a.isAfter(b) ? a : b;

  static List<DateTime> _computePmsDays(
    DateTime nextPeriodStart,
    int pmsDaysSetting,
  ) {
    return List.generate(
      pmsDaysSetting,
      (index) => _addCalendarDays(nextPeriodStart, -(pmsDaysSetting - index)),
    );
  }

  static bool _isInRealPeriod(
    DateTime current,
    DateTime periodStart,
    DateTime periodEnd,
  ) {
    final normalizedCurrent = _startOfDay(current);
    final normalizedStart = _startOfDay(periodStart);
    final normalizedEnd = _startOfDay(periodEnd);
    return !normalizedCurrent.isBefore(normalizedStart) &&
        !normalizedCurrent.isAfter(normalizedEnd);
  }
}
