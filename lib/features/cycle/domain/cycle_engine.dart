import 'dart:math' as math;

import 'package:peria_app/features/cycle/data/models/period_log.dart';
import 'package:peria_app/features/cycle/domain/cycle_phase.dart';
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

  static int _positiveModulo(int value, int modulo) {
    return ((value % modulo) + modulo) % modulo;
  }

  static DateTime _computeFutureNextPeriodStart({
    required DateTime startDate,
    required DateTime current,
    required int cycleLengthDays,
  }){
    final daysElapsed = _startOfDay(current).difference(_startOfDay(startDate)).inDays;
    if (daysElapsed < cycleLengthDays) {
      return startDate.add(Duration(days: cycleLengthDays));
    }
    final cyclesElapsed = daysElapsed ~/ cycleLengthDays;
    return startDate.add(Duration(days: (cyclesElapsed + 1) * cycleLengthDays));
  }

  static List<DateTime> _computePmsDays(DateTime nextPeriodStart) {
    return List.generate(
      5,
      (index) => _startOfDay(nextPeriodStart.subtract(Duration(days: 5 - index))),
    );
  }

  static CycleStatus? computeFromLogs({
    required List<PeriodLog> logs,
    required int cycleLengthDays,
    required int periodLengthDays,
    DateTime? now,
  }) {
    if (logs.isEmpty) return null;
    final sortedLogs = [...logs]..sort((a, b) => b.startDate.compareTo(a.startDate));
    final latestLog = sortedLogs.first;
    return compute(
      startDate: latestLog.startDate,
      periodEndDate: latestLog.endDate,
      cycleLengthDays: cycleLengthDays,
      periodLengthDays: periodLengthDays,
      now: now,
    );
  }

  static CycleStatus? compute({
    required DateTime? startDate,
    DateTime? periodEndDate,
    required int cycleLengthDays,
    required int periodLengthDays,
    DateTime? now,
  }) {
    if (startDate == null) return null;
    if (cycleLengthDays <= 0 || periodLengthDays <= 0) return null;
    final current = now ?? DateTime.now();
    final normalizedStartDate = _startOfDay(startDate);

    final daysElapsed = _startOfDay(current).difference(normalizedStartDate).inDays;
    final cyclesElapsed = daysElapsed >= 0 ? daysElapsed ~/ cycleLengthDays : 0;
    final currentCycleStart = normalizedStartDate.add(
      Duration(days: cyclesElapsed * cycleLengthDays),
    );

    final computedEndDate = (periodEndDate != null && cyclesElapsed == 0)
        ? _endOfDay(periodEndDate)
        : currentCycleStart.add(
            Duration(
              days: math.max(periodLengthDays - 1, 0),
              hours: 23,
              minutes: 59,
              seconds: 59,
              milliseconds: 999,
            ),
          );

    final isInPeriod =
        (current.isAtSameMomentAs(currentCycleStart) || current.isAfter(currentCycleStart)) &&
            (current.isAtSameMomentAs(computedEndDate) || current.isBefore(computedEndDate));

    final dayOfCycle = _startOfDay(current).difference(currentCycleStart).inDays + 1;
    final nextPeriodStart = currentCycleStart.add(Duration(days: cycleLengthDays));
    final ovulationDate = currentCycleStart.add(Duration(days: (cycleLengthDays - 14).clamp(0, cycleLengthDays)));
    final fertileStart = ovulationDate.subtract(const Duration(days: 5));
    final fertileEnd = ovulationDate.add(const Duration(days: 1));
    final pmsDays = _computePmsDays(nextPeriodStart);
    final fertileWindow = List.generate(
      fertileEnd.difference(fertileStart).inDays + 1,
      (index) => _startOfDay(fertileStart.add(Duration(days: index))),
    );
    final periodDays = List.generate(
      periodLengthDays,
      (index) => _startOfDay(currentCycleStart.add(Duration(days: index))),
    );

    final ovulationCycleDay = (cycleLengthDays - 14).clamp(1, cycleLengthDays);

    CyclePhase phase;
    if (isInPeriod) {
      phase = CyclePhase.menstrual;
    } else if (dayOfCycle >= ovulationCycleDay - 5 && dayOfCycle <= ovulationCycleDay + 1) {
      phase = CyclePhase.ovulation;
    } else if (dayOfCycle > ovulationCycleDay + 1) {
      phase = CyclePhase.luteal;
    } else {
      phase = CyclePhase.follicular;
    }

    final daysUntilNextPeriod = nextPeriodStart.difference(current).inDays;
    final isOverdue = current.isAfter(nextPeriodStart) && !isInPeriod;

    return CycleStatus(
      startDate: normalizedStartDate,
      endDate: computedEndDate,
      cycleLengthDays: cycleLengthDays,
      periodLengthDays: periodLengthDays,
      now: current,
      isInPeriod: isInPeriod,
      dayOfCycle: dayOfCycle,
      phase: phase,
      nextPeriodStart: nextPeriodStart,
      ovulationDate: ovulationDate,
      fertileWindowStart: fertileStart,
      fertileWindowEnd: fertileEnd,
      fertileWindow: fertileWindow,
      periodDays: periodDays,
      pmsDays: pmsDays,
      isOverdue: isOverdue,
      daysUntilNextPeriod: daysUntilNextPeriod,
    );
  }
}
