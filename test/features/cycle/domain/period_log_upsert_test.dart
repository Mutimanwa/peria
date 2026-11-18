import 'package:flutter_test/flutter_test.dart';
import 'package:peria_app/features/cycle/data/models/period_log.dart';
import 'package:peria_app/features/cycle/domain/period_log_upsert.dart';
import 'package:peria_app/features/cycle/domain/period_rules.dart';

void main() {
  final today = DateTime(2026, 10, 14);

  PeriodLog log(String id, DateTime start, DateTime end,
          {bool isEstimated = false}) =>
      PeriodLog(
        id: id,
        startDate: start,
        endDate: end,
        isEstimated: isEstimated,
      );

  group('PeriodLogUpsert.apply', () {
    test('adds a log when nothing overlaps', () {
      final result = PeriodLogUpsert.apply(
        logs: [log('a', DateTime(2026, 9, 1), DateTime(2026, 9, 5))],
        log: log('b', DateTime(2026, 10, 10), DateTime(2026, 10, 14)),
        today: today,
      );

      expect(result.map((l) => l.id), containsAll(['a', 'b']));
      // Le plus récent en tête.
      expect(result.first.id, 'b');
    });

    test('replaces an overlapping log instead of stacking two versions', () {
      final result = PeriodLogUpsert.apply(
        logs: [log('a', DateTime(2026, 10, 1), DateTime(2026, 10, 5))],
        log: log('b', DateTime(2026, 10, 3), DateTime(2026, 10, 6)),
        today: today,
      );

      expect(result.length, 1);
      expect(result.single.id, 'b');
      expect(result.single.startDate, DateTime(2026, 10, 3));
      expect(result.single.endDate, DateTime(2026, 10, 6));
    });

    test('extends a log recorded through yesterday', () {
      final result = PeriodLogUpsert.apply(
        logs: [log('a', DateTime(2026, 10, 11), DateTime(2026, 10, 13))],
        log: log('b', today, today),
        today: today,
      );

      expect(result.length, 1);
      expect(result.single.startDate, DateTime(2026, 10, 11));
      expect(result.single.endDate, today);
    });

    test('refuses to merge two logs that would exceed the maximum duration',
        () {
      final result = PeriodLogUpsert.apply(
        logs: [log('a', DateTime(2026, 9, 20), DateTime(2026, 9, 29))],
        log: log('b', DateTime(2026, 10, 1), DateTime(2026, 10, 3)),
        today: today,
      );

      expect(result.length, 2);
      expect(result.every((l) => l.endDate.difference(l.startDate).inDays <
          PeriodRules.maxPeriodLengthDays), isTrue);
    });

    test('truncates an over-long range and drops future days', () {
      final result = PeriodLogUpsert.apply(
        logs: const <PeriodLog>[],
        log: log('a', DateTime(2026, 9, 1), DateTime(2026, 12, 31)),
        today: today,
      );

      expect(result.single.endDate, DateTime(2026, 9, 10));
      expect(result.single.endDate.isAfter(today), isFalse);
    });

    test('keeps the edited log when it is saved twice with the same id', () {
      final existing = log('a', DateTime(2026, 10, 1), DateTime(2026, 10, 5));

      final result = PeriodLogUpsert.apply(
        logs: [existing],
        log: log('a', DateTime(2026, 10, 2), DateTime(2026, 10, 4)),
        today: today,
      );

      expect(result.length, 1);
      expect(result.single.startDate, DateTime(2026, 10, 2));
      expect(result.single.endDate, DateTime(2026, 10, 4));
    });
  });
}
