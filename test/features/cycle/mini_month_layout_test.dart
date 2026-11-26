import 'package:flutter_test/flutter_test.dart';
import 'package:peria_app/features/cycle/presentation/widgets/mini_month_calendar.dart';

void main() {
  group('MiniMonthLayout', () {
    test('indexes weekdays with Sunday at 0', () {
      // 2026-03-01 is a Sunday.
      expect(MiniMonthLayout.weekdayIndex(DateTime(2026, 3, 1)), 0);
      expect(MiniMonthLayout.weekdayIndex(DateTime(2026, 3, 2)), 1);
      expect(MiniMonthLayout.weekdayIndex(DateTime(2026, 3, 7)), 6);
    });

    test('offsets the first day according to the locale', () {
      // March 2026 starts on a Sunday: six blanks before it in a Monday-first
      // calendar, none in a Sunday-first one.
      expect(
        MiniMonthLayout.leadingBlanks(
          firstDayOfMonth: DateTime(2026, 3, 1),
          firstDayOfWeekIndex: 1,
        ),
        6,
      );
      expect(
        MiniMonthLayout.leadingBlanks(
          firstDayOfMonth: DateTime(2026, 3, 1),
          firstDayOfWeekIndex: 0,
        ),
        0,
      );
    });

    test('counts the right number of days, leap years included', () {
      expect(MiniMonthLayout.daysInMonth(DateTime(2026, 2)), 28);
      expect(MiniMonthLayout.daysInMonth(DateTime(2024, 2)), 29);
      expect(MiniMonthLayout.daysInMonth(DateTime(2026, 4)), 30);
      expect(MiniMonthLayout.daysInMonth(DateTime(2026, 12)), 31);
    });

    test('lays a month out exactly once, in order', () {
      final weeks = MiniMonthLayout.weeks(
        month: DateTime(2026, 3),
        firstDayOfWeekIndex: 1,
      );

      expect(weeks.length, 6);
      expect(weeks.every((week) => week.length == 7), isTrue);

      final days = weeks.expand((week) => week).whereType<DateTime>().toList();
      expect(days.length, 31);
      for (var index = 0; index < days.length; index++) {
        expect(days[index].day, index + 1);
        expect(days[index].month, 3);
        expect(days[index].year, 2026);
      }

      // First cell of the grid is empty, the 1st sits in the last column.
      expect(weeks.first.take(6).every((day) => day == null), isTrue);
      expect(weeks.first.last?.day, 1);
    });

    test('a month that starts on the first column needs fewer rows', () {
      final weeks = MiniMonthLayout.weeks(
        month: DateTime(2026, 2),
        firstDayOfWeekIndex: 0,
      );

      expect(weeks.length, 4);
      expect(weeks.first.first?.day, 1);
      expect(weeks.last.last?.day, 28);
      expect(
        weeks.expand((week) => week).whereType<DateTime>().length,
        28,
      );
    });

    test('never places a date outside the displayed month', () {
      for (var month = 1; month <= 12; month++) {
        final weeks = MiniMonthLayout.weeks(
          month: DateTime(2026, month),
          firstDayOfWeekIndex: 1,
        );
        for (final day in weeks.expand((week) => week).whereType<DateTime>()) {
          expect(day.month, month);
          expect(day.year, 2026);
        }
      }
    });
  });
}
