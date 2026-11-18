import 'package:flutter_test/flutter_test.dart';
import 'package:peria_app/features/cycle/data/models/period_log.dart';
import 'package:peria_app/features/cycle/domain/cycle_engine.dart';
import 'package:peria_app/features/cycle/domain/cycle_phase.dart';
import 'package:peria_app/features/cycle/domain/cycle_regularity.dart';
import 'package:peria_app/features/cycle/domain/cycle_status.dart';

PeriodLog _log(String id, DateTime start, DateTime end, {bool estimated = false}) =>
    PeriodLog(
      id: id,
      startDate: start,
      endDate: end,
      isEstimated: estimated,
    );

/// Seven saved periods, one every 28 days, the first starting on 1 January.
List<PeriodLog> _regularLogs({int count = 7, int everyDays = 28}) => [
      for (var i = 0; i < count; i++)
        _log(
          '$i',
          DateTime(2024, 1, 1 + everyDays * i),
          DateTime(2024, 1, 5 + everyDays * i),
        ),
    ];

void main() {
  group('CycleEngine - Regular Cycles', () {
    test('should correctly predict next period for regular 28-day cycle', () {
      final logs = [
        _log('1', DateTime(2024, 1, 1), DateTime(2024, 1, 5)),
        _log('2', DateTime(2024, 1, 29), DateTime(2024, 2, 2)),
        _log('3', DateTime(2024, 2, 26), DateTime(2024, 3, 1)),
      ];

      final status = CycleEngine.computeFromLogs(
        logs: logs,
        userCycleLengthDays: 28,
        userPeriodLengthDays: 5,
        pmsDaysSetting: 5,
        now: DateTime(2024, 3, 15),
      );

      expect(status, isNotNull);
      expect(status!.cycleRegularity, CycleRegularity.regular);
      // Two complete cycles are still an estimate: 0.2 base + 0.175 history.
      expect(status.confidenceScore, closeTo(0.55, 0.01));
      expect(status.isEstimated, true);
      expect(status.nextPeriodStart, DateTime(2024, 3, 25));
    });
  });

  group('CycleEngine - Confidence', () {
    test('six regular cycles are no longer flagged as an estimate', () {
      final status = CycleEngine.computeFromLogs(
        logs: _regularLogs(),
        userCycleLengthDays: 28,
        userPeriodLengthDays: 5,
        pmsDaysSetting: 5,
        now: DateTime(2024, 7, 1),
      );

      expect(status, isNotNull);
      expect(status!.confidenceScore, greaterThanOrEqualTo(0.7));
      expect(status.isEstimated, isFalse);
      expect(status.cycleRegularity, CycleRegularity.regular);
    });

    test('three complete cycles are enough to become reliable', () {
      final status = CycleEngine.computeFromLogs(
        logs: _regularLogs(count: 4),
        userCycleLengthDays: 28,
        userPeriodLengthDays: 5,
        pmsDaysSetting: 5,
        now: DateTime(2024, 4, 20),
      );

      expect(status, isNotNull);
      expect(status!.confidenceScore, greaterThanOrEqualTo(0.7));
      expect(status.isEstimated, isFalse);
    });

    test('two intervals stay an estimate', () {
      final status = CycleEngine.computeFromLogs(
        logs: _regularLogs(count: 3),
        userCycleLengthDays: 28,
        userPeriodLengthDays: 5,
        pmsDaysSetting: 5,
        now: DateTime(2024, 3, 15),
      );

      expect(status!.confidenceScore, lessThan(0.7));
      expect(status.isEstimated, isTrue);
    });

    test('a long but irregular history is penalised', () {
      final logs = [
        _log('1', DateTime(2024, 1, 1), DateTime(2024, 1, 5)),
        _log('2', DateTime(2024, 1, 22), DateTime(2024, 1, 26)), // 21 days
        _log('3', DateTime(2024, 2, 20), DateTime(2024, 2, 24)), // 29 days
        _log('4', DateTime(2024, 3, 25), DateTime(2024, 3, 29)), // 34 days
        _log('5', DateTime(2024, 4, 20), DateTime(2024, 4, 24)), // 26 days
        _log('6', DateTime(2024, 5, 25), DateTime(2024, 5, 29)), // 35 days
      ];

      final status = CycleEngine.computeFromLogs(
        logs: logs,
        userCycleLengthDays: 28,
        userPeriodLengthDays: 5,
        pmsDaysSetting: 5,
        now: DateTime(2024, 6, 10),
      );

      expect(status, isNotNull);
      expect(status!.cycleRegularity, CycleRegularity.irregular);
      expect(status.confidenceScore, lessThan(0.7));
      expect(status.isEstimated, isTrue);
    });
  });

  group('CycleEngine - Irregular Cycles', () {
    test('should detect irregular cycles and reduce confidence', () {
      final logs = [
        _log('1', DateTime(2024, 1, 1), DateTime(2024, 1, 5)),
        _log('2', DateTime(2024, 1, 22), DateTime(2024, 1, 26)), // 21 days
        _log('3', DateTime(2024, 2, 26), DateTime(2024, 3, 1)), // 35 days
      ];

      final status = CycleEngine.computeFromLogs(
        logs: logs,
        userCycleLengthDays: 28,
        userPeriodLengthDays: 5,
        pmsDaysSetting: 5,
        now: DateTime(2024, 3, 10),
      );

      expect(status, isNotNull);
      expect(status!.cycleRegularity, CycleRegularity.irregular);
      expect(status.cycleVariance, greaterThan(5));
      expect(status.confidenceScore, lessThan(0.6));
    });
  });

  group('CycleEngine - Missing Logs', () {
    test('keeps the user cycle length but learns the period length', () {
      final logs = [
        _log('1', DateTime(2024, 1, 1), DateTime(2024, 1, 5)),
      ];

      final status = CycleEngine.computeFromLogs(
        logs: logs,
        userCycleLengthDays: 30,
        userPeriodLengthDays: 6,
        pmsDaysSetting: 4,
        now: DateTime(2024, 1, 20),
      );

      expect(status, isNotNull);
      expect(status!.cycleLengthDays, 30); // Fallback to the user value
      // The saved period lasted five days, so the setting is no longer used.
      expect(status.periodLengthDays, 5);
      expect(status.confidenceScore, lessThan(0.4));
      expect(status.isEstimated, true);
    });

    test('should return null when no logs exist', () {
      final status = CycleEngine.computeFromLogs(
        logs: [],
        userCycleLengthDays: 28,
        userPeriodLengthDays: 5,
        pmsDaysSetting: 5,
      );

      expect(status, isNull);
    });
  });

  group('CycleEngine - Period length', () {
    test('averages the recorded periods instead of the profile setting', () {
      final logs = [
        _log('1', DateTime(2024, 1, 1), DateTime(2024, 1, 5)), // 5 days
        _log('2', DateTime(2024, 1, 29), DateTime(2024, 2, 1)), // 4 days
        _log('3', DateTime(2024, 2, 26), DateTime(2024, 2, 29)), // 4 days
      ];

      final status = CycleEngine.computeFromLogs(
        logs: logs,
        userCycleLengthDays: 28,
        userPeriodLengthDays: 7,
        pmsDaysSetting: 5,
        now: DateTime(2024, 3, 15),
      );

      // (5 + 4 + 4) / 3 = 4.33 -> 4
      expect(status!.periodLengthDays, 4);
      expect(status.periodDays, hasLength(4));
    });

    test('ignores a period that may still be running', () {
      final logs = [
        _log('1', DateTime(2024, 1, 1), DateTime(2024, 1, 5)),
        _log('2', DateTime(2024, 1, 29), DateTime(2024, 1, 29)),
      ];

      final status = CycleEngine.computeFromLogs(
        logs: logs,
        userCycleLengthDays: 28,
        userPeriodLengthDays: 6,
        pmsDaysSetting: 5,
        now: DateTime(2024, 1, 29),
      );

      expect(status!.periodLengthDays, 5);
    });

    test('falls back to the setting when no period is complete yet', () {
      final logs = [
        _log('1', DateTime(2024, 1, 1), DateTime(2024, 1, 3)),
      ];

      final status = CycleEngine.computeFromLogs(
        logs: logs,
        userCycleLengthDays: 28,
        userPeriodLengthDays: 6,
        pmsDaysSetting: 5,
        now: DateTime(2024, 1, 2),
      );

      expect(status!.periodLengthDays, 6);
    });

    test('ignores impossible ranges and predicted periods', () {
      final logs = [
        _log('1', DateTime(2024, 1, 1), DateTime(2024, 1, 25)), // 25 days
        _log('2', DateTime(2024, 1, 29), DateTime(2024, 2, 2), estimated: true),
        _log('3', DateTime(2024, 2, 26), DateTime(2024, 3, 1)), // 5 days
      ];

      final status = CycleEngine.computeFromLogs(
        logs: logs,
        userCycleLengthDays: 28,
        userPeriodLengthDays: 5,
        pmsDaysSetting: 5,
        now: DateTime(2024, 3, 15),
      );

      expect(status!.periodLengthDays, 5);
    });
  });

  group('CycleEngine - Fertile window', () {
    late CycleStatus status;

    setUp(() {
      status = CycleEngine.computeFromLogs(
        logs: [_log('1', DateTime(2024, 1, 1), DateTime(2024, 1, 5))],
        userCycleLengthDays: 28,
        userPeriodLengthDays: 5,
        pmsDaysSetting: 5,
        now: DateTime(2024, 1, 10),
      )!;
    });

    test('runs from five days before ovulation to the range end', () {
      expect(status.fertileWindowStart, DateTime(2024, 1, 9));
      expect(status.fertileWindowEnd, status.ovulationRangeEnd);
      expect(status.fertileWindow, hasLength(8));
      expect(status.fertileWindow.first, status.fertileWindowStart);
      expect(status.fertileWindow.last, status.fertileWindowEnd);
    });

    test('contains the whole ovulation range', () {
      expect(
        status.fertileWindow.contains(status.ovulationRangeStart),
        isTrue,
      );
      expect(status.fertileWindow.contains(status.ovulationDate), isTrue);
      expect(status.fertileWindow.contains(status.ovulationRangeEnd), isTrue);
    });

    test('stays inside a short cycle', () {
      final short = CycleEngine.computeFromLogs(
        logs: [_log('1', DateTime(2024, 1, 1), DateTime(2024, 1, 4))],
        userCycleLengthDays: 21,
        userPeriodLengthDays: 4,
        pmsDaysSetting: 5,
        now: DateTime(2024, 1, 10),
      )!;

      // Ovulation on day 7: the window opens on day 2 (J-5), not before day 1.
      expect(short.fertileWindowStart, DateTime(2024, 1, 2));
      expect(short.fertileWindow.last, short.ovulationRangeEnd);
      expect(short.fertileWindow.length, lessThan(short.cycleLengthDays));
    });

    test('never starts before the first day of the cycle', () {
      final veryShort = CycleEngine.computeFromLogs(
        logs: [_log('1', DateTime(2024, 1, 1), DateTime(2024, 1, 3))],
        userCycleLengthDays: 16,
        userPeriodLengthDays: 3,
        pmsDaysSetting: 5,
        now: DateTime(2024, 1, 5),
      )!;

      expect(veryShort.fertileWindowStart, DateTime(2024, 1, 1));
      expect(veryShort.fertileWindowEnd, veryShort.ovulationRangeEnd);
    });
  });

  group('CycleEngine - Overdue Detection', () {
    final log = _log('1', DateTime(2024, 1, 1), DateTime(2024, 1, 5));

    CycleStatus statusOn(DateTime date, {DateTime? today}) =>
        CycleEngine.computeFromLogs(
          logs: [log],
          userCycleLengthDays: 28,
          userPeriodLengthDays: 5,
          pmsDaysSetting: 5,
          now: date,
          today: today,
        )!;

    test('should not mark as overdue when within tolerance period', () {
      final status = statusOn(DateTime(2024, 1, 30)); // 1 day late

      expect(status.isOverdue, false);
      expect(status.overdueDays, 1);
      expect(status.dayOfCycle, 30);
    });

    test('two days late do not raise the calendar warning yet', () {
      final status = statusOn(DateTime(2024, 1, 31));

      expect(status.isOverdue, false);
      expect(status.overdueDays, 2);
    });

    test('should mark as overdue after tolerance period', () {
      final status = statusOn(DateTime(2024, 2, 1)); // 3 days late

      expect(status.isOverdue, true);
      expect(status.overdueDays, 3);
    });

    test('a late period keeps counting instead of restarting the cycle', () {
      final status = statusOn(DateTime(2024, 2, 1));

      expect(status.dayOfCycle, 32);
      expect(status.phase, CyclePhase.luteal);
      expect(status.isInPeriod, isFalse);
    });

    test('the expected day still predicts the period', () {
      final status = statusOn(DateTime(2024, 1, 29));

      expect(status.isOverdue, false);
      expect(status.dayOfCycle, 1);
      expect(status.phase, CyclePhase.menstrual);
    });

    test('logging the period clears the delay', () {
      final status = CycleEngine.computeFromLogs(
        logs: [
          log,
          _log('2', DateTime(2024, 2, 2), DateTime(2024, 2, 6)),
        ],
        userCycleLengthDays: 28,
        userPeriodLengthDays: 5,
        pmsDaysSetting: 5,
        now: DateTime(2024, 2, 2),
      );

      expect(status, isNotNull);
      expect(status!.overdueDays, 0);
      expect(status.dayOfCycle, 1);
      expect(status.phase, CyclePhase.menstrual);
      expect(status.isInPeriod, isTrue);
    });

    test('a future date is still projected cycle by cycle', () {
      final status = statusOn(
        DateTime(2024, 2, 28),
        today: DateTime(2024, 2, 1),
      );

      // The delay is about today, but February 28th belongs to the next
      // projected cycle: day 3, predicted as menstrual.
      expect(status.isOverdue, isTrue);
      expect(status.dayOfCycle, 3);
      expect(status.phase, CyclePhase.menstrual);
      expect(status.periodDays.contains(DateTime(2024, 2, 28)), isTrue);
    });

    test('should not mark as overdue when in active period', () {
      final status = CycleEngine.computeFromLogs(
        logs: [_log('1', DateTime(2024, 2, 26), DateTime(2024, 3, 2))],
        userCycleLengthDays: 28,
        userPeriodLengthDays: 5,
        pmsDaysSetting: 5,
        now: DateTime(2024, 2, 28),
      );

      expect(status, isNotNull);
      expect(status!.isInPeriod, true);
      expect(status.isOverdue, false);
      expect(status.overdueDays, 0);
    });
  });

  group('CycleEngine - Data Priority', () {
    test('should prioritize real logs over predictions', () {
      final logs = [
        _log('1', DateTime(2024, 2, 1), DateTime(2024, 2, 5)),
      ];

      final status = CycleEngine.computeFromLogs(
        logs: logs,
        userCycleLengthDays: 28,
        userPeriodLengthDays: 5,
        pmsDaysSetting: 5,
        now: DateTime(2024, 2, 3), // During real period
      );

      expect(status, isNotNull);
      expect(status!.useRealData, true);
      expect(status.isInPeriod, true);
    });
  });

  group('CycleEngine - Ovulation Range', () {
    test('should return ovulation range instead of fixed date', () {
      final logs = [
        _log('1', DateTime(2024, 1, 1), DateTime(2024, 1, 5)),
        _log('2', DateTime(2024, 1, 29), DateTime(2024, 2, 2)),
      ];

      final status = CycleEngine.computeFromLogs(
        logs: logs,
        userCycleLengthDays: 28,
        userPeriodLengthDays: 5,
        pmsDaysSetting: 5,
        now: DateTime(2024, 2, 10),
      );

      expect(status, isNotNull);
      expect(status!.ovulationRangeStart, isNotNull);
      expect(status.ovulationRangeEnd, isNotNull);
      expect(
        status.ovulationRangeEnd.difference(status.ovulationRangeStart).inDays,
        equals(4), // ±2 days = 5 day range
      );
    });
  });

  group('CycleEngine - PMS Configurability', () {
    test('should use custom PMS days from user settings', () {
      final logs = [
        _log('1', DateTime(2024, 1, 1), DateTime(2024, 1, 5)),
      ];

      final status = CycleEngine.computeFromLogs(
        logs: logs,
        userCycleLengthDays: 28,
        userPeriodLengthDays: 5,
        pmsDaysSetting: 3, // User wants 3 days of PMS
        now: DateTime(2024, 1, 20),
      );

      expect(status, isNotNull);
      expect(status!.pmsDays.length, equals(3));
    });
  });

  group('CycleEngine - Calendar dates', () {
    test('includes both the first and last days of a saved period', () {
      final log = _log(
        'single-day',
        DateTime(2024, 3, 1),
        DateTime(2024, 3, 1),
      );

      final status = CycleEngine.computeFromLogs(
        logs: [log],
        userCycleLengthDays: 28,
        userPeriodLengthDays: 5,
        pmsDaysSetting: 5,
        now: DateTime(2024, 3, 1),
      );

      expect(status, isNotNull);
      expect(status!.useRealData, isTrue);
      expect(status.isInPeriod, isTrue);
      expect(status.phase, CyclePhase.menstrual);
    });

    test('uses only logs on or before the requested date', () {
      final logs = [
        _log('future', DateTime(2024, 3, 1), DateTime(2024, 3, 5)),
        _log('past', DateTime(2024, 2, 1), DateTime(2024, 2, 5)),
      ];

      final status = CycleEngine.computeFromLogs(
        logs: logs,
        userCycleLengthDays: 28,
        userPeriodLengthDays: 5,
        pmsDaysSetting: 5,
        now: DateTime(2024, 2, 15),
      );

      expect(status, isNotNull);
      expect(status!.startDate, DateTime(2024, 2, 1));
      expect(status.dayOfCycle, 15);
    });
  });

  group('CycleEngine - Statistics', () {
    test('computes aggregate cycle statistics from saved logs', () {
      final logs = [
        _log('1', DateTime(2024, 1, 1), DateTime(2024, 1, 5)),
        _log('2', DateTime(2024, 1, 29), DateTime(2024, 2, 2)),
        _log('3', DateTime(2024, 2, 26), DateTime(2024, 3, 1)),
      ];

      final statistics = CycleEngine.computeStatistics(logs: logs);

      expect(statistics, isNotNull);
      expect(statistics!.averageCycleLength, 28);
      expect(statistics.minCycleLength, 28);
      expect(statistics.maxCycleLength, 28);
      expect(statistics.stdDeviation, 0);
      // Three saved periods describe two complete cycles.
      expect(statistics.totalCyclesLogged, 2);
      expect(statistics.isRegular, isTrue);
    });

    test('returns null with a single saved period', () {
      expect(
        CycleEngine.computeStatistics(
          logs: [_log('1', DateTime(2024, 1, 1), DateTime(2024, 1, 5))],
        ),
        isNull,
      );
    });
  });

  group('CycleEngine - phase coverage', () {
    test('assigns all four phases across one projected cycle', () {
      final log = _log('anchor', DateTime(2024, 1, 1), DateTime(2024, 1, 5));

      CyclePhase phaseOn(DateTime date) {
        return CycleEngine.computeFromLogs(
          logs: [log],
          userCycleLengthDays: 28,
          userPeriodLengthDays: 5,
          pmsDaysSetting: 5,
          now: date,
        )!.phase;
      }

      expect(phaseOn(DateTime(2024, 1, 3)), CyclePhase.menstrual);
      expect(phaseOn(DateTime(2024, 1, 29)), CyclePhase.menstrual);
      expect(phaseOn(DateTime(2024, 1, 10)), CyclePhase.follicular);
      expect(phaseOn(DateTime(2024, 1, 14)), CyclePhase.ovulation);
      expect(phaseOn(DateTime(2024, 1, 22)), CyclePhase.luteal);
    });
  });
}
