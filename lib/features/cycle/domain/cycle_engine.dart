import 'dart:math' as math;

import 'package:peria_app/features/cycle/data/models/period_log.dart';
import 'package:peria_app/features/cycle/domain/cycle_phase.dart';
import 'package:peria_app/features/cycle/domain/cycle_regularity.dart';
import 'package:peria_app/features/cycle/domain/cycle_statistics.dart';
import 'package:peria_app/features/cycle/domain/cycle_status.dart';

class CycleEngine {
  const CycleEngine._();

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

  static double _calculateConfidenceScore({
    required int logCount,
    required int cycleVariance,
    required bool isIrregular,
    required double irregularityFactor,
  }) {
    // Base confidence from log count (max 0.6 with 6+ logs)
    double logConfidence = (logCount / 6.0).clamp(0.2, 0.6).toDouble();
    
    // Variance penalty (up to -0.3)
    double variancePenalty = 0;
    if (cycleVariance > 5) {
      variancePenalty =
          ((cycleVariance - 5) / 20).clamp(0.0, 0.3).toDouble();
    } else if (cycleVariance > 2) {
      variancePenalty =
          ((cycleVariance - 2) / 30).clamp(0.0, 0.15).toDouble();
    }
    
    // Irregularity penalty
    double irregularityPenalty = isIrregular ? 0.2 : 0.0;
    
    double confidence = logConfidence - variancePenalty - irregularityPenalty;
    return confidence.clamp(0.0, 1.0).toDouble();
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
      totalCyclesLogged: sortedLogs.length,
      isRegular: standardDeviation <= 5,
    );
  }

  static CycleStatus? computeFromLogs({
    required List<PeriodLog> logs,
    required int userCycleLengthDays,
    required int userPeriodLengthDays,
    required int pmsDaysSetting,
    DateTime? now,
  }) {
    final requestedDate = _startOfDay(now ?? DateTime.now());
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
    final irregularityFactor = isIrregular
        ? (cycleVariance / 10.0).clamp(0.0, 0.3).toDouble()
        : 0.0;
    final confidenceScore = _calculateConfidenceScore(
      logCount: sortedLogs.length,
      cycleVariance: cycleVariance,
      isIrregular: isIrregular,
      irregularityFactor: irregularityFactor,
    );
    final isEstimated = confidenceScore < 0.7;
    
    return compute(
      startDate: latestLog.startDate,
      endDate: latestLog.endDate,
      cycleLengthDays: averageCycleLength,
      periodLengthDays: userPeriodLengthDays,
      pmsDaysSetting: pmsDaysSetting,
      cycleVariance: cycleVariance,
      irregularityFactor: irregularityFactor,
      confidenceScore: confidenceScore,
      isEstimated: isEstimated,
      cycleRegularity: isIrregular
          ? CycleRegularity.irregular
          : CycleRegularity.regular,
      now: now,
    );
  }

  static CycleStatus? computeFromSingleLog({
    required DateTime startDate,
    required DateTime endDate,
    required int userCycleLengthDays,
    required int userPeriodLengthDays,
    required int pmsDaysSetting,
    DateTime? now,
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
      irregularityFactor: 0.0,
      confidenceScore: 0.2,
      isEstimated: true,
      cycleRegularity: CycleRegularity.regular,
      now: now,
    );
  }

  static CycleStatus? compute({
    required DateTime startDate,
    required DateTime endDate,
    required int cycleLengthDays,
    required int periodLengthDays,
    required int pmsDaysSetting,
    required int cycleVariance,
    required double irregularityFactor,
    required double confidenceScore,
    required bool isEstimated,
    required CycleRegularity cycleRegularity,
    DateTime? now,
  }) {
    if (cycleLengthDays <= 0 || periodLengthDays <= 0) return null;
    
    final current = now ?? DateTime.now();
    final normalizedStartDate = _startOfDay(startDate);
    final normalizedCurrent = _startOfDay(current);
    
    // Check if there's a real log covering today
    final isInRealPeriod = _isInRealPeriod(current, startDate, endDate);
    
    // For overdue detection: only overdue if no active period
    final expectedNextPeriodStart =
        _addCalendarDays(normalizedStartDate, cycleLengthDays);
    const overdueToleranceDays = 2;
    final isOverdue = !isInRealPeriod && normalizedCurrent.isAfter(
      _addCalendarDays(expectedNextPeriodStart, overdueToleranceDays),
    );
    
    // For prediction, use the most recent log as anchor
    DateTime currentCycleStart;
    bool useRealPeriodForCycle;
    
    if (isInRealPeriod) {
      currentCycleStart = normalizedStartDate;
      useRealPeriodForCycle = true;
    } else {
      // Calculate based on prediction from last log
      final daysSinceLastPeriod =
          _calendarDayDifference(normalizedCurrent, normalizedStartDate);
      final cyclesElapsed =
          daysSinceLastPeriod >= 0 ? daysSinceLastPeriod ~/ cycleLengthDays : 0;
      currentCycleStart =
          _addCalendarDays(normalizedStartDate, cyclesElapsed * cycleLengthDays);
      useRealPeriodForCycle = false;
    }
    
    final computedEndDate = useRealPeriodForCycle
        ? _endOfDay(endDate)
        : _endOfDay(_addCalendarDays(currentCycleStart, periodLengthDays - 1));

    final isInPeriod = useRealPeriodForCycle;

    final dayOfCycle =
        _calendarDayDifference(normalizedCurrent, currentCycleStart) + 1;
    
    // Ovulation range (±2 days)
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

    // Fertile window: 5 days before ovulation + day of ovulation
    final fertileStart = _addCalendarDays(ovulationDateStart, -5);
    final fertileEnd = _addCalendarDays(ovulationDateEnd, 1);

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
    
    // Phase detection with adjusted windows for irregular cycles
    CyclePhase phase;
    if (isInPeriod) {
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
        _calendarDayDifference(nextPeriodStart, normalizedCurrent);
    
    return CycleStatus(
      startDate: currentCycleStart,
      endDate: computedEndDate,
      cycleLengthDays: cycleLengthDays,
      periodLengthDays: periodLengthDays,
      now: current,
      isInPeriod: isInPeriod,
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
      daysUntilNextPeriod: daysUntilNextPeriod,
      confidenceScore: confidenceScore,
      isEstimated: isEstimated,
      cycleRegularity: cycleRegularity,
      cycleVariance: cycleVariance,
      useRealData: useRealPeriodForCycle,
    );
  }

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