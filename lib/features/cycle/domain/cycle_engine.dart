import 'package:perla_app/features/cycle/domain/cycle_phase.dart';
import 'package:perla_app/features/cycle/domain/cycle_status.dart';

class CycleEngine {
  // Source of truth:
  // everything is computed from startDate (first day of last period).
  //
  // - check if today is within the period window: startDate..endDate (inclusive)
  // - otherwise compute dayOfCycle from startDate
  // - derive phase by fixed intervals
  // - nextPeriodStart = startDate + cycleLength
  // - ovulationDate = nextPeriodStart - 14
  static CycleStatus? compute({
    required DateTime? startDate,
    required int cycleLengthDays,
    required int periodLengthDays,
    DateTime? now,
  }) {
    if (startDate == null) return null;
    final current = now ?? DateTime.now();

    final endDate = startDate.add(
      Duration(
        days: (periodLengthDays - 1).clamp(0, 60),
        hours: 23,
        minutes: 59,
        seconds: 59,
        milliseconds: 999,
      ),
    );

    final isInPeriod =
        (current.isAtSameMomentAs(startDate) || current.isAfter(startDate)) &&
            (current.isAtSameMomentAs(endDate) || current.isBefore(endDate));

    final daysElapsed = current.difference(startDate).inDays;
    final dayOfCycle =
        ((daysElapsed % cycleLengthDays) + 1).clamp(1, cycleLengthDays);

    // Phase intervals (fixed MVP logic):
    // - menstrual: day 1..periodLengthDays
    // - ovulation: fertile window (ovulationDate +/-) mapped to ovulation
    // - luteal: after ovulationDay until cycle end
    // - follicular: everything else (post-period, pre-ovulation)
    final nextPeriodStart = startDate.add(Duration(days: cycleLengthDays));
    final ovulationDate = nextPeriodStart.subtract(const Duration(days: 14));
    final fertileStart = ovulationDate.subtract(const Duration(days: 5));
    final fertileEnd = ovulationDate.add(const Duration(days: 1));

    final ovulationCycleDay = (cycleLengthDays - 14).clamp(1, cycleLengthDays);

    CyclePhase phase;
    if (isInPeriod) {
      phase = CyclePhase.menstrual;
    } else if (dayOfCycle >= ovulationCycleDay - 5 &&
        dayOfCycle <= ovulationCycleDay + 1) {
      phase = CyclePhase.ovulation;
    } else if (dayOfCycle > ovulationCycleDay + 1) {
      phase = CyclePhase.luteal;
    } else {
      phase = CyclePhase.follicular;
    }

    final daysUntilNextPeriod = nextPeriodStart.difference(current).inDays;

    return CycleStatus(
      startDate: startDate,
      endDate: endDate,
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
      daysUntilNextPeriod: daysUntilNextPeriod,
    );
  }
}
