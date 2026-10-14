import 'package:flutter_test/flutter_test.dart';
import 'package:peria_app/features/cycle/data/models/period_log.dart';
import 'package:peria_app/features/cycle/domain/cycle_engine.dart';
import 'package:peria_app/features/cycle/presentation/models/cycle_day_info.dart';

void main() {
  group('CycleDayInfo', () {
    test('a saved period day takes precedence over a predicted day', () {
      final loggedPeriod = PeriodLog(
        id: 'logged',
        startDate: DateTime(2024, 1, 1),
        endDate: DateTime(2024, 1, 5),
      );
      final status = CycleEngine.computeFromLogs(
        logs: [loggedPeriod],
        userCycleLengthDays: 28,
        userPeriodLengthDays: 5,
        pmsDaysSetting: 5,
        now: DateTime(2024, 1, 3),
      );

      final info = CycleDayInfo.forDate(
        date: DateTime(2024, 1, 3, 16),
        status: status,
        periodLogs: [loggedPeriod],
        today: DateTime(2024, 1, 3),
      );

      expect(info.isLoggedPeriod, isTrue);
      expect(info.isPredictedPeriod, isFalse);
      expect(info.isPeriodDay, isTrue);
    });

    test('a predicted period day is distinguished from saved days', () {
      final savedPeriod = PeriodLog(
        id: 'saved',
        startDate: DateTime(2024, 1, 1),
        endDate: DateTime(2024, 1, 5),
      );
      final predictedDate = DateTime(2024, 1, 29);
      final status = CycleEngine.computeFromLogs(
        logs: [savedPeriod],
        userCycleLengthDays: 28,
        userPeriodLengthDays: 5,
        pmsDaysSetting: 5,
        now: predictedDate,
      );

      final info = CycleDayInfo.forDate(
        date: predictedDate,
        status: status,
        periodLogs: [savedPeriod],
        today: predictedDate,
      );

      expect(info.isLoggedPeriod, isFalse);
      expect(info.isPredictedPeriod, isTrue);
      expect(info.isPeriodDay, isTrue);
    });

    test('does not re-predict days after a logged period has ended', () {
      final shortLoggedPeriod = PeriodLog(
        id: 'short',
        startDate: DateTime(2024, 1, 1),
        endDate: DateTime(2024, 1, 2),
      );
      final dayAfterLoggedEnd = DateTime(2024, 1, 3);
      final status = CycleEngine.computeFromLogs(
        logs: [shortLoggedPeriod],
        userCycleLengthDays: 28,
        userPeriodLengthDays: 5,
        pmsDaysSetting: 5,
        now: dayAfterLoggedEnd,
      );

      final info = CycleDayInfo.forDate(
        date: dayAfterLoggedEnd,
        status: status,
        periodLogs: [shortLoggedPeriod],
        today: dayAfterLoggedEnd,
      );

      expect(info.isLoggedPeriod, isFalse);
      expect(info.isPredictedPeriod, isFalse);
      expect(info.isPeriodDay, isFalse);
    });

  });
}
