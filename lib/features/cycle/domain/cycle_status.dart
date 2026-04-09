import 'package:perla_app/features/cycle/domain/cycle_phase.dart';

class CycleStatus {
  final DateTime startDate; // first day of last period (reference)
  final DateTime endDate; // end of period window (inclusive)
  final int cycleLengthDays;
  final int periodLengthDays;

  final DateTime now;
  final bool isInPeriod;
  final int dayOfCycle; // 1..cycleLengthDays
  final CyclePhase phase;

  final DateTime nextPeriodStart;
  final DateTime ovulationDate;
  final DateTime fertileWindowStart;
  final DateTime fertileWindowEnd;

  final int daysUntilNextPeriod;

  const CycleStatus({
    required this.startDate,
    required this.endDate,
    required this.cycleLengthDays,
    required this.periodLengthDays,
    required this.now,
    required this.isInPeriod,
    required this.dayOfCycle,
    required this.phase,
    required this.nextPeriodStart,
    required this.ovulationDate,
    required this.fertileWindowStart,
    required this.fertileWindowEnd,
    required this.daysUntilNextPeriod,
  });
}
