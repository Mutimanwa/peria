import 'package:flutter_test/flutter_test.dart';
import 'package:peria_app/core/services/notification_schedule_planner.dart';
import 'package:peria_app/core/storage/app_settings.dart';
import 'package:peria_app/features/cycle/domain/cycle_phase.dart';
import 'package:peria_app/features/cycle/domain/cycle_regularity.dart';
import 'package:peria_app/features/cycle/domain/cycle_status.dart';

void main() {
  group('NotificationSchedulePlanner', () {
    test('does not schedule anything when notifications are disabled', () {
      final plan = NotificationSchedulePlanner.createPlan(
        settings: const AppSettings(
          allowNotifications: false,
          notifyPeriodStarting: true,
          notifyFertileWindow: true,
          notifyOvulationDay: true,
          remindLogSymptoms: true,
        ),
        cycleStatus: _cycleStatus(),
        now: DateTime(2026, 1, 1, 8),
      );

      expect(plan, isEmpty);
    });

    test('schedules enabled cycle reminders at 09:00 for three cycles', () {
      final plan = NotificationSchedulePlanner.createPlan(
        settings: const AppSettings(
          allowNotifications: true,
          notifyPeriodStarting: true,
          notifyFertileWindow: false,
          notifyOvulationDay: true,
        ),
        cycleStatus: _cycleStatus(),
        now: DateTime(2026, 1, 1, 8),
      );

      expect(plan, hasLength(6));
      final periodReminders = plan
          .where((item) => item.kind == LocalReminderKind.period)
          .toList();
      final ovulationReminders = plan
          .where((item) => item.kind == LocalReminderKind.ovulation)
          .toList();

      expect(
        periodReminders.map((item) => item.scheduledAt),
        [
          DateTime(2026, 1, 6, 9),
          DateTime(2026, 2, 3, 9),
          DateTime(2026, 3, 3, 9),
        ],
      );
      expect(
        ovulationReminders.map((item) => item.scheduledAt),
        [
          DateTime(2026, 1, 20, 9),
          DateTime(2026, 2, 17, 9),
          DateTime(2026, 3, 17, 9),
        ],
      );
      expect(plan.every((item) => !item.repeatsDaily), isTrue);
    });

    test('rolls a cycle reminder forward when its 09:00 time has passed', () {
      final plan = NotificationSchedulePlanner.createPlan(
        settings: const AppSettings(
          allowNotifications: true,
          notifyPeriodStarting: true,
          notifyFertileWindow: false,
          notifyOvulationDay: false,
        ),
        cycleStatus: _cycleStatus(nextPeriodStart: DateTime(2026, 1, 1)),
        now: DateTime(2026, 1, 1, 9),
      );

      expect(
        plan.map((item) => item.scheduledAt),
        [
          DateTime(2026, 1, 29, 9),
          DateTime(2026, 2, 26, 9),
          DateTime(2026, 3, 26, 9),
        ],
      );
    });

    test('schedules a repeating daily check-in for 20:00 local time', () {
      final plan = NotificationSchedulePlanner.createPlan(
        settings: const AppSettings(
          allowNotifications: true,
          notifyPeriodStarting: false,
          notifyFertileWindow: false,
          notifyOvulationDay: false,
          remindLogSymptoms: true,
        ),
        cycleStatus: null,
        now: DateTime(2026, 1, 1, 19, 59),
      );

      expect(plan, hasLength(1));
      expect(plan.single.id, NotificationSchedulePlanner.dailyCheckInId);
      expect(plan.single.kind, LocalReminderKind.dailyCheckIn);
      expect(plan.single.scheduledAt, DateTime(2026, 1, 1, 20));
      expect(plan.single.repeatsDaily, isTrue);
    });

    test('moves a 20:00 check-in to tomorrow after today’s reminder time', () {
      final plan = NotificationSchedulePlanner.createPlan(
        settings: const AppSettings(
          allowNotifications: true,
          notifyPeriodStarting: false,
          notifyFertileWindow: false,
          notifyOvulationDay: false,
          remindLogSymptoms: true,
        ),
        cycleStatus: null,
        now: DateTime(2026, 1, 1, 20),
      );

      expect(plan.single.scheduledAt, DateTime(2026, 1, 2, 20));
    });
  });
}

CycleStatus _cycleStatus({DateTime? nextPeriodStart}) {
  final nextPeriod = nextPeriodStart ?? DateTime(2026, 1, 6);
  return CycleStatus(
    startDate: DateTime(2025, 12, 9),
    endDate: DateTime(2025, 12, 13),
    cycleLengthDays: 28,
    periodLengthDays: 5,
    now: DateTime(2026, 1, 1),
    isInPeriod: false,
    dayOfCycle: 24,
    phase: CyclePhase.luteal,
    nextPeriodStart: nextPeriod,
    ovulationDate: DateTime(2025, 12, 23),
    ovulationRangeStart: DateTime(2025, 12, 22),
    ovulationRangeEnd: DateTime(2025, 12, 24),
    fertileWindowStart: DateTime(2025, 12, 18),
    fertileWindowEnd: DateTime(2025, 12, 24),
    fertileWindow: [
      DateTime(2025, 12, 18),
      DateTime(2025, 12, 19),
      DateTime(2025, 12, 20),
      DateTime(2025, 12, 21),
      DateTime(2025, 12, 22),
      DateTime(2025, 12, 23),
      DateTime(2025, 12, 24),
    ],
    periodDays: [
      nextPeriod,
      DateTime(nextPeriod.year, nextPeriod.month, nextPeriod.day + 1),
      DateTime(nextPeriod.year, nextPeriod.month, nextPeriod.day + 2),
      DateTime(nextPeriod.year, nextPeriod.month, nextPeriod.day + 3),
      DateTime(nextPeriod.year, nextPeriod.month, nextPeriod.day + 4),
    ],
    pmsDays: const [],
    isOverdue: false,
    daysUntilNextPeriod: nextPeriod.difference(DateTime(2026, 1, 1)).inDays,
    confidenceScore: 1,
    isEstimated: true,
    cycleRegularity: CycleRegularity.regular,
    cycleVariance: 0,
    useRealData: true,
  );
}
