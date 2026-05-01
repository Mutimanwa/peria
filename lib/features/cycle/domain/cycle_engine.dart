import 'dart:math' as math;

import 'package:peria_app/features/cycle/data/models/period_log.dart';
import 'package:peria_app/features/cycle/domain/cycle_phase.dart';
import 'package:peria_app/features/cycle/domain/cycle_regularity.dart';
import 'package:peria_app/features/cycle/domain/cycle_status.dart';

class CycleEngine {
  const CycleEngine._();

  static DateTime _startOfDay(DateTime value) =>
      DateTime(value.year, value.month, value.day);

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
    double logConfidence = (logCount / 6.0).clamp(0.2, 0.6);
    
    // Variance penalty (up to -0.3)
    double variancePenalty = 0;
    if (cycleVariance > 5) {
      variancePenalty = ((cycleVariance - 5) / 20).clamp(0.0, 0.3);
    } else if (cycleVariance > 2) {
      variancePenalty = ((cycleVariance - 2) / 30).clamp(0.0, 0.15);
    }
    
    // Irregularity penalty
    double irregularityPenalty = isIrregular ? 0.2 : 0.0;
    
    double confidence = logConfidence - variancePenalty - irregularityPenalty;
    return confidence.clamp(0.0, 1.0);
  }

  static int _calculateCycleVariance(List<PeriodLog> logs, int avgCycleLength) {
    if (logs.length < 2) return 0;
    
    final List<int> cycleLengths = [];
    for (int i = 0; i < logs.length - 1; i++) {
      final diff = logs[i].startDate.difference(logs[i + 1].startDate).inDays.abs();
      cycleLengths.add(diff);
    }
    
    if (cycleLengths.isEmpty) return 0;
    
    final mean = cycleLengths.reduce((a, b) => a + b) / cycleLengths.length;
    final variance = cycleLengths.map((l) => math.pow(l - mean, 2)).reduce((a, b) => a + b) / cycleLengths.length;
    return math.sqrt(variance).round();
  }

  static int _computeAverageCycleLength(List<PeriodLog> logs, int userCycleLength) {
    if (logs.length < 2) return userCycleLength;
    
    final logsToUse = logs.length >= 6 ? logs.take(6).toList() : logs;
    final cycleLengths = <int>[];
    
    for (int i = 0; i < logsToUse.length - 1; i++) {
      final length = logsToUse[i].startDate.difference(logsToUse[i + 1].startDate).inDays;
      cycleLengths.add(length);
    }
    
    if (cycleLengths.isEmpty) return userCycleLength;
    
    final sum = cycleLengths.reduce((a, b) => a + b);
    return (sum / cycleLengths.length).round();
  }

  static CycleStatus? computeFromLogs({
    required List<PeriodLog> logs,
    required int userCycleLengthDays,
    required int userPeriodLengthDays,
    required int pmsDaysSetting,
    DateTime? now,
  }) {
    if (logs.isEmpty) return null;
    
    final sortedLogs = [...logs]..sort((a, b) => b.startDate.compareTo(a.startDate));
    final latestLog = sortedLogs.first;
    
    final averageCycleLength = _computeAverageCycleLength(sortedLogs, userCycleLengthDays);
    final cycleVariance = _calculateCycleVariance(sortedLogs, averageCycleLength);
    final isIrregular = cycleVariance > 5;
    final irregularityFactor = isIrregular ? (cycleVariance / 10.0).clamp(0.0, 0.3) : 0.0;
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
      cycleRegularity: isIrregular ? CycleRegularity.irregular : CycleRegularity.regular,
      now: now,
    );
  }

 // À ajouter dans CycleEngine
static CycleStatus? computeFromSingleLog({
  required DateTime startDate,
  required DateTime endDate,
  required int userCycleLengthDays,
  required int userPeriodLengthDays,
  required int pmsDaysSetting,
  DateTime? now,
}) {
  return compute(
    startDate: startDate,
    endDate: endDate,
    cycleLengthDays: userCycleLengthDays,
    periodLengthDays: userPeriodLengthDays,
    pmsDaysSetting: pmsDaysSetting,
    cycleVariance: 0,
    irregularityFactor: 0.0,
    confidenceScore: 0.2, // Low confidence with single log
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
    final expectedNextPeriodStart = normalizedStartDate.add(Duration(days: cycleLengthDays));
    const overdueToleranceDays = 2;
    final isOverdue = !isInRealPeriod && 
        normalizedCurrent.isAfter(expectedNextPeriodStart.add(const Duration(days: overdueToleranceDays)));
    
    // For prediction, use the most recent log as anchor
    DateTime currentCycleStart;
    bool useRealPeriodForCycle;
    
    if (isInRealPeriod) {
      currentCycleStart = normalizedStartDate;
      useRealPeriodForCycle = true;
    } else {
      // Calculate based on prediction from last log
      final daysSinceLastPeriod = normalizedCurrent.difference(normalizedStartDate).inDays;
      final cyclesElapsed = daysSinceLastPeriod >= 0 ? daysSinceLastPeriod ~/ cycleLengthDays : 0;
      currentCycleStart = normalizedStartDate.add(Duration(days: cyclesElapsed * cycleLengthDays));
      useRealPeriodForCycle = false;
    }
    
    final computedEndDate = useRealPeriodForCycle && current.isAfter(startDate) && current.isBefore(endDate)
        ? _endOfDay(endDate)
        : currentCycleStart.add(Duration(days: periodLengthDays - 1, hours: 23, minutes: 59, seconds: 59, milliseconds: 999));
    
    final isInPeriod = useRealPeriodForCycle && 
        (current.isAtSameMomentAs(currentCycleStart) || current.isAfter(currentCycleStart)) &&
        (current.isAtSameMomentAs(computedEndDate) || current.isBefore(computedEndDate));
    
    final dayOfCycle = normalizedCurrent.difference(currentCycleStart).inDays + 1;
    
    // Ovulation range (±2 days)
    final predictedOvulationDay = (cycleLengthDays - 14).clamp(1, cycleLengthDays);
    final ovulationRangeStartDay = (predictedOvulationDay - 2).clamp(1, cycleLengthDays);
    final ovulationRangeEndDay = (predictedOvulationDay + 2).clamp(1, cycleLengthDays);
    
    final ovulationDateStart = currentCycleStart.add(Duration(days: ovulationRangeStartDay - 1));
    final ovulationDateEnd = currentCycleStart.add(Duration(days: ovulationRangeEndDay - 1));
    final ovulationEstimateMid = currentCycleStart.add(Duration(days: predictedOvulationDay - 1));
    
    // Fertile window: 5 days before ovulation + day of ovulation
    final fertileStart = ovulationDateStart.subtract(const Duration(days: 5));
    final fertileEnd = ovulationDateEnd.add(const Duration(days: 1));
    
    final fertileWindow = List.generate(
      fertileEnd.difference(fertileStart).inDays + 1,
      (index) => _startOfDay(fertileStart.add(Duration(days: index))),
    );
    
    final periodDays = List.generate(
      periodLengthDays,
      (index) => _startOfDay(currentCycleStart.add(Duration(days: index))),
    );
    
    final nextPeriodStart = currentCycleStart.add(Duration(days: cycleLengthDays));
    final pmsDays = _computePmsDays(nextPeriodStart, pmsDaysSetting);
    
    // Phase detection with adjusted windows for irregular cycles
    CyclePhase phase;
    if (isInPeriod) {
      phase = CyclePhase.menstrual;
    } else if (dayOfCycle >= ovulationRangeStartDay && dayOfCycle <= ovulationRangeEndDay) {
      phase = CyclePhase.ovulation;
    } else if (dayOfCycle > ovulationRangeEndDay) {
      phase = CyclePhase.luteal;
    } else {
      phase = CyclePhase.follicular;
    }
    
    final daysUntilNextPeriod = nextPeriodStart.difference(current).inDays;
    
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

  static List<DateTime> _computePmsDays(DateTime nextPeriodStart, int pmsDaysSetting) {
    return List.generate(
      pmsDaysSetting,
      (index) => _startOfDay(nextPeriodStart.subtract(Duration(days: pmsDaysSetting - index))),
    );
  }

  static bool _isInRealPeriod(DateTime current, DateTime periodStart, DateTime periodEnd) {
    final normalizedCurrent = _startOfDay(current);
    final normalizedStart = _startOfDay(periodStart);
    final normalizedEnd = _endOfDay(periodEnd);
    return normalizedCurrent.isAfter(normalizedStart) && normalizedCurrent.isBefore(normalizedEnd);
  }
}