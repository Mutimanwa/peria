import 'package:flutter_test/flutter_test.dart';
import 'package:peria_app/features/cycle/domain/period_rules.dart';

void main() {
  final today = DateTime(2026, 10, 14);

  group('PeriodRules.clampRange', () {
    test('keeps a plausible range untouched', () {
      final range = PeriodRules.clampRange(
        start: DateTime(2026, 10, 1),
        end: DateTime(2026, 10, 5),
        today: today,
      );

      expect(range.start, DateTime(2026, 10, 1));
      expect(range.end, DateTime(2026, 10, 5));
      expect(range.lengthInDays, 5);
    });

    test('never creates a period longer than the maximum', () {
      final range = PeriodRules.clampRange(
        start: DateTime(2026, 8, 1),
        end: DateTime(2026, 10, 14),
        today: today,
      );

      expect(range.lengthInDays, PeriodRules.maxPeriodLengthDays);
      expect(range.end, DateTime(2026, 8, 10));
    });

    test('never keeps a future end date', () {
      final range = PeriodRules.clampRange(
        start: DateTime(2026, 10, 12),
        end: DateTime(2026, 11, 20),
        today: today,
      );

      expect(range.end, today);
    });

    test('falls back to the start when the range is reversed', () {
      final range = PeriodRules.clampRange(
        start: DateTime(2026, 10, 8),
        end: DateTime(2026, 10, 2),
        today: today,
      );

      expect(range.start, DateTime(2026, 10, 8));
      expect(range.end, DateTime(2026, 10, 8));
    });
  });

  group('PeriodRules.latestSelectableEnd', () {
    test('is bounded by the maximum duration', () {
      expect(
        PeriodRules.latestSelectableEnd(DateTime(2026, 9, 1), today),
        DateTime(2026, 9, 10),
      );
    });

    test('is bounded by today for a recent start', () {
      expect(
        PeriodRules.latestSelectableEnd(DateTime(2026, 10, 12), today),
        today,
      );
    });
  });

  group('PeriodRules.spanDays', () {
    test('counts both bounds', () {
      expect(
        PeriodRules.spanDays(DateTime(2026, 10, 1), DateTime(2026, 10, 1)),
        1,
      );
      expect(
        PeriodRules.spanDays(DateTime(2026, 10, 1), DateTime(2026, 10, 3)),
        3,
      );
    });
  });
}
