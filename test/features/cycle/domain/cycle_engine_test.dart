import 'package:flutter_test/flutter_test.dart';
import 'package:perla_app/features/cycle/data/models/period_log.dart';
import 'package:perla_app/features/cycle/domain/cycle_engine.dart';
import 'package:perla_app/features/cycle/domain/cycle_phase.dart';

void main() {
  group('CycleEngine.compute', () {
    test('uses startDate as the only cycle anchor', () {
      final status = CycleEngine.compute(
        startDate: DateTime(2026, 4, 1),
        periodEndDate: DateTime(2026, 4, 5),
        cycleLengthDays: 28,
        periodLengthDays: 5,
        now: DateTime(2026, 4, 10, 12),
      );

      expect(status, isNotNull);
      expect(status!.dayOfCycle, 10);
      expect(status.isInPeriod, isFalse);
      expect(status.phase, CyclePhase.ovulation);
      expect(status.nextPeriodStart, DateTime(2026, 4, 29));
      expect(status.ovulationDate, DateTime(2026, 4, 15));
    });

    test('stays in period when now is between startDate and endDate', () {
      final status = CycleEngine.compute(
        startDate: DateTime(2026, 4, 1),
        periodEndDate: DateTime(2026, 4, 5),
        cycleLengthDays: 28,
        periodLengthDays: 5,
        now: DateTime(2026, 4, 5, 20),
      );

      expect(status, isNotNull);
      expect(status!.isInPeriod, isTrue);
      expect(status.phase, CyclePhase.menstrual);
      expect(status.dayOfCycle, 5);
    });

    test('computes future next period even when several cycles have passed', () {
      final status = CycleEngine.compute(
        startDate: DateTime(2026, 1, 1),
        periodEndDate: DateTime(2026, 1, 5),
        cycleLengthDays: 28,
        periodLengthDays: 5,
        now: DateTime(2026, 4, 25, 10),
      );

      expect(status, isNotNull);
      expect(status!.nextPeriodStart, DateTime(2026, 5, 21));
      expect(status.daysUntilNextPeriod, 25);
    });
  });

  group('CycleEngine.computeFromLogs', () {
    test('uses the latest period log start date as source of truth', () {
      final status = CycleEngine.computeFromLogs(
        logs: [
          PeriodLog(
            id: 'older',
            startDate: DateTime(2026, 3, 1),
            endDate: DateTime(2026, 3, 5),
          ),
          PeriodLog(
            id: 'latest',
            startDate: DateTime(2026, 4, 1),
            endDate: DateTime(2026, 4, 5),
          ),
        ],
        cycleLengthDays: 28,
        periodLengthDays: 5,
        now: DateTime(2026, 4, 10),
      );

      expect(status, isNotNull);
      expect(status!.startDate, DateTime(2026, 4, 1));
      expect(status.endDate, DateTime(2026, 4, 5, 23, 59, 59, 999));
      expect(status.dayOfCycle, 10);
    });
  });
}
