import 'package:flutter_test/flutter_test.dart';
import 'package:peria_app/features/cycle/data/models/period_log.dart';
import 'package:peria_app/features/cycle/domain/period_log_quick_actions.dart';

void main() {
  final today = DateTime(2026, 10, 14);

  group('PeriodLogQuickActions.recordToday', () {
    test('creates a single-day actual log when there is no adjacent log', () {
      final log = PeriodLogQuickActions.recordToday(
        logs: const <PeriodLog>[],
        today: today,
      );

      expect(log, isNotNull);
      final savedLog = log!;
      expect(savedLog.startDate, today);
      expect(savedLog.endDate, today);
      expect(savedLog.isEstimated, isFalse);
    });

    test('extends a log that ended yesterday, preserving its start date', () {
      final previous = PeriodLog(
        id: 'previous',
        startDate: DateTime(2026, 10, 11),
        endDate: DateTime(2026, 10, 13),
      );

      final log = PeriodLogQuickActions.recordToday(
        logs: [previous],
        today: today,
      );

      expect(log?.id, previous.id);
      expect(log?.startDate, previous.startDate);
      expect(log?.endDate, today);
    });

    test('does not extend across a gap of more than one day', () {
      final previous = PeriodLog(
        id: 'previous',
        startDate: DateTime(2026, 10, 10),
        endDate: DateTime(2026, 10, 12),
      );

      final log = PeriodLogQuickActions.recordToday(
        logs: [previous],
        today: today,
      );

      expect(log?.id, 'manual_period_2026-10-14');
      expect(log?.startDate, today);
      expect(log?.endDate, today);
    });

    test('confirms an estimated period day as actual', () {
      final estimated = PeriodLog(
        id: 'estimate',
        startDate: DateTime(2026, 10, 13),
        endDate: DateTime(2026, 10, 15),
        isEstimated: true,
      );

      final log = PeriodLogQuickActions.recordToday(
        logs: [estimated],
        today: today,
      );

      expect(log?.id, estimated.id);
      expect(log?.isEstimated, isFalse);
      expect(log?.startDate, estimated.startDate);
      expect(log?.endDate, estimated.endDate);
    });

    test('does not duplicate a day already recorded as actual', () {
      final actual = PeriodLog(
        id: 'actual',
        startDate: DateTime(2026, 10, 13),
        endDate: DateTime(2026, 10, 14),
      );

      expect(
        PeriodLogQuickActions.recordToday(logs: [actual], today: today),
        isNull,
      );
    });
  });

  group('PeriodLogQuickActions.endToday', () {
    test('closes a period logged through yesterday', () {
      final previous = PeriodLog(
        id: 'previous',
        startDate: DateTime(2026, 10, 11),
        endDate: DateTime(2026, 10, 13),
      );

      final log = PeriodLogQuickActions.endToday(
        logs: [previous],
        today: today,
      );

      expect(log?.id, previous.id);
      expect(log?.startDate, previous.startDate);
      expect(log?.endDate, today);
      expect(log?.isEstimated, isFalse);
    });

    test('does not close an old log across an unlogged gap', () {
      final previous = PeriodLog(
        id: 'previous',
        startDate: DateTime(2026, 10, 9),
        endDate: DateTime(2026, 10, 11),
      );

      expect(
        PeriodLogQuickActions.endToday(logs: [previous], today: today),
        isNull,
      );
    });

    test('does not save an already confirmed end date for today', () {
      final actual = PeriodLog(
        id: 'actual',
        startDate: DateTime(2026, 10, 12),
        endDate: DateTime(2026, 10, 14),
      );

      expect(
        PeriodLogQuickActions.endToday(logs: [actual], today: today),
        isNull,
      );
    });
  });
}
