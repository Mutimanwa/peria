import 'package:peria_app/features/cycle/domain/cycle_phase.dart';
import 'package:peria_app/features/cycle/domain/cycle_regularity.dart';

class CycleStatus {
  final DateTime startDate;
  final DateTime endDate;
  final int cycleLengthDays;
  final int periodLengthDays;
  final DateTime now;
  final bool isInPeriod;
  final int dayOfCycle;
  final CyclePhase phase;
  final DateTime nextPeriodStart;
  final DateTime ovulationDate;
  final DateTime ovulationRangeStart;
  final DateTime ovulationRangeEnd;
  final DateTime fertileWindowStart;
  final DateTime fertileWindowEnd;
  final List<DateTime> fertileWindow;
  final List<DateTime> periodDays;
  final List<DateTime> pmsDays;
  final bool isOverdue;
  final int daysUntilNextPeriod;
  
  // New fields
  final double confidenceScore;
  final bool isEstimated;
  final CycleRegularity cycleRegularity;
  final int cycleVariance;
  final bool useRealData;

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
    required this.ovulationRangeStart,
    required this.ovulationRangeEnd,
    required this.fertileWindowStart,
    required this.fertileWindowEnd,
    required this.fertileWindow,
    required this.periodDays,
    required this.pmsDays,
    required this.isOverdue,
    required this.daysUntilNextPeriod,
    required this.confidenceScore,
    required this.isEstimated,
    required this.cycleRegularity,
    required this.cycleVariance,
    required this.useRealData,
  });
}