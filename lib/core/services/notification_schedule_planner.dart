import 'package:peria_app/core/storage/app_settings.dart';
import 'package:peria_app/features/cycle/domain/cycle_status.dart';

enum LocalReminderKind {
  period,
  fertileWindow,
  ovulation,
  dailyCheckIn,
}

class PlannedLocalNotification {
  const PlannedLocalNotification({
    required this.id,
    required this.kind,
    required this.scheduledAt,
    this.repeatsDaily = false,
  });

  final int id;
  final LocalReminderKind kind;
  final DateTime scheduledAt;
  final bool repeatsDaily;
}

/// Produces local reminder dates without touching the notifications plugin.
///
/// Cycle reminders are scheduled for three predicted cycles. The daily check-in
/// is a local-time recurrence at 20:00. Generic notification text is supplied
/// separately by the local notification service to keep lock-screen content
/// discreet.
class NotificationSchedulePlanner {
  NotificationSchedulePlanner._();

  static const int cycleReminderHour = 9;
  static const int dailyCheckInHour = 20;
  static const int cycleHorizon = 3;

  static const int periodIdBase = 3100;
  static const int fertileWindowIdBase = 3200;
  static const int ovulationIdBase = 3300;
  static const int dailyCheckInId = 3400;

  static const List<int> managedNotificationIds = [
    periodIdBase,
    periodIdBase + 1,
    periodIdBase + 2,
    fertileWindowIdBase,
    fertileWindowIdBase + 1,
    fertileWindowIdBase + 2,
    ovulationIdBase,
    ovulationIdBase + 1,
    ovulationIdBase + 2,
    dailyCheckInId,
  ];

  static List<PlannedLocalNotification> createPlan({
    required AppSettings settings,
    required CycleStatus? cycleStatus,
    DateTime? now,
  }) {
    if (!settings.allowNotifications) return const [];

    final current = now ?? DateTime.now();
    final planned = <PlannedLocalNotification>[];

    if (settings.remindLogSymptoms) {
      planned.add(
        PlannedLocalNotification(
          id: dailyCheckInId,
          kind: LocalReminderKind.dailyCheckIn,
          scheduledAt: _nextLocalTime(current, dailyCheckInHour),
          repeatsDaily: true,
        ),
      );
    }

    final status = cycleStatus;
    if (status == null || status.cycleLengthDays <= 0) return planned;

    if (settings.notifyPeriodStarting) {
      _addCycleReminders(
        planned,
        kind: LocalReminderKind.period,
        idBase: periodIdBase,
        firstDate: status.nextPeriodStart,
        cycleLengthDays: status.cycleLengthDays,
        now: current,
      );
    }
    if (settings.notifyFertileWindow) {
      _addCycleReminders(
        planned,
        kind: LocalReminderKind.fertileWindow,
        idBase: fertileWindowIdBase,
        firstDate: status.fertileWindowStart,
        cycleLengthDays: status.cycleLengthDays,
        now: current,
      );
    }
    if (settings.notifyOvulationDay) {
      _addCycleReminders(
        planned,
        kind: LocalReminderKind.ovulation,
        idBase: ovulationIdBase,
        firstDate: status.ovulationDate,
        cycleLengthDays: status.cycleLengthDays,
        now: current,
      );
    }

    return planned;
  }

  static void _addCycleReminders(
    List<PlannedLocalNotification> planned, {
    required LocalReminderKind kind,
    required int idBase,
    required DateTime firstDate,
    required int cycleLengthDays,
    required DateTime now,
  }) {
    var nextDate = _dateOnly(firstDate);
    while (!_atLocalTime(nextDate, cycleReminderHour).isAfter(now)) {
      nextDate = _addCalendarDays(nextDate, cycleLengthDays);
    }

    for (var cycle = 0; cycle < cycleHorizon; cycle++) {
      final date = _addCalendarDays(nextDate, cycleLengthDays * cycle);
      planned.add(
        PlannedLocalNotification(
          id: idBase + cycle,
          kind: kind,
          scheduledAt: _atLocalTime(date, cycleReminderHour),
        ),
      );
    }
  }

  static DateTime _nextLocalTime(DateTime now, int hour) {
    var scheduled = _atLocalTime(_dateOnly(now), hour);
    if (!scheduled.isAfter(now)) {
      scheduled = _atLocalTime(_addCalendarDays(_dateOnly(now), 1), hour);
    }
    return scheduled;
  }

  static DateTime _dateOnly(DateTime value) =>
      DateTime(value.year, value.month, value.day);

  static DateTime _atLocalTime(DateTime date, int hour) =>
      DateTime(date.year, date.month, date.day, hour);

  /// Constructs each target date in local time instead of adding 24-hour
  /// durations, so the 09:00 reminder remains at 09:00 over daylight changes.
  static DateTime _addCalendarDays(DateTime date, int days) =>
      DateTime(date.year, date.month, date.day + days);
}
