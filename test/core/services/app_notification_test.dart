import 'package:flutter_test/flutter_test.dart';
import 'package:peria_app/core/services/app_notification.dart';
import 'package:peria_app/core/services/notification_schedule_planner.dart';

void main() {
  group('AppNotification routing', () {
    test('sends each reminder to the screen it is about', () {
      expect(AppNotification.routeForKind(LocalReminderKind.period), '/cycle');
      expect(
        AppNotification.routeForKind(LocalReminderKind.fertileWindow),
        '/calendar',
      );
      expect(
        AppNotification.routeForKind(LocalReminderKind.ovulation),
        '/calendar',
      );
      expect(
        AppNotification.routeForKind(LocalReminderKind.dailyCheckIn),
        '/symptoms',
      );
    });

    test('route follows the kind of an existing notification', () {
      final notification = AppNotification(
        id: 'x',
        kind: LocalReminderKind.ovulation,
        scheduledAt: DateTime(2026, 5, 10, 9),
      );
      expect(notification.route, '/calendar');
    });
  });

  group('AppNotification ids', () {
    test('uses one stable id per kind and day', () {
      final first = AppNotification.idFor(
        LocalReminderKind.period,
        DateTime(2026, 5, 9, 9),
      );
      final second = AppNotification.idFor(
        LocalReminderKind.period,
        DateTime(2026, 5, 9, 21),
      );
      expect(first, second);
      expect(first, contains('period'));
      expect(first, contains('2026'));
    });

    test('keeps kinds apart on the same day', () {
      expect(
        AppNotification.idFor(LocalReminderKind.period, DateTime(2026, 5, 9)),
        isNot(
          AppNotification.idFor(
            LocalReminderKind.ovulation,
            DateTime(2026, 5, 9),
          ),
        ),
      );
    });
  });

  group('AppNotification.fromPlan', () {
    final plan = [
      PlannedLocalNotification(
        id: 3100,
        kind: LocalReminderKind.period,
        scheduledAt: DateTime(2026, 5, 12, 9),
      ),
      PlannedLocalNotification(
        id: 3400,
        kind: LocalReminderKind.dailyCheckIn,
        scheduledAt: DateTime(2026, 5, 10, 20),
      ),
    ];

    test('keeps upcoming reminders so they can become readable later', () {
      final stored = AppNotification.fromPlan(plan);

      expect(stored, hasLength(2));
      expect(stored.every((item) => !item.read), isTrue);
      expect(stored.first.id, contains('period'));
    });

    test('a stored reminder becomes due once its time has passed', () {
      final reminder = AppNotification.fromPlan(plan).first;

      expect(reminder.isDue(DateTime(2026, 5, 12, 8)), isFalse);
      expect(reminder.isDue(DateTime(2026, 5, 12, 9)), isTrue);
      expect(reminder.isDue(DateTime(2026, 5, 20)), isTrue);
    });
  });

  group('AppNotification.obsoleteIds', () {
    final plan = [
      PlannedLocalNotification(
        id: 3100,
        kind: LocalReminderKind.period,
        scheduledAt: DateTime(2026, 5, 12, 9),
      ),
    ];
    final now = DateTime(2026, 5, 10, 12);

    AppNotification item(
      LocalReminderKind kind,
      DateTime when,
    ) =>
        AppNotification(
          id: AppNotification.idFor(kind, when),
          kind: kind,
          scheduledAt: when,
        );

    test('keeps a recent past reminder', () {
      final stored = [item(LocalReminderKind.dailyCheckIn, DateTime(2026, 5, 9, 20))];

      expect(
        AppNotification.obsoleteIds(stored, plan, now: now),
        isEmpty,
      );
    });

    test('drops a past reminder older than the retention window', () {
      final stored = [item(LocalReminderKind.dailyCheckIn, DateTime(2026, 4, 1, 20))];

      expect(
        AppNotification.obsoleteIds(stored, plan, now: now),
        {stored.single.id},
      );
    });

    test('drops a future reminder the new prediction no longer contains', () {
      final stored = [item(LocalReminderKind.period, DateTime(2026, 5, 20, 9))];

      expect(
        AppNotification.obsoleteIds(stored, plan, now: now),
        {stored.single.id},
      );
    });

    test('keeps a future reminder that is still planned', () {
      final stored = [item(LocalReminderKind.period, DateTime(2026, 5, 12, 9))];

      expect(
        AppNotification.obsoleteIds(stored, plan, now: now),
        isEmpty,
      );
    });
  });

  group('AppNotification JSON', () {
    test('survives a round trip', () {
      final notification = AppNotification(
        id: 'period-2026-05-10',
        kind: LocalReminderKind.period,
        scheduledAt: DateTime(2026, 5, 10, 9),
        read: true,
      );

      final restored = AppNotification.fromJson(notification.toJson());

      expect(restored.id, notification.id);
      expect(restored.kind, notification.kind);
      expect(restored.scheduledAt, notification.scheduledAt);
      expect(restored.read, isTrue);
    });

    test('falls back to the daily check-in for an unknown kind', () {
      final restored = AppNotification.fromJson({
        'id': 'legacy',
        'kind': 'something-removed',
        'scheduledAt': '2026-05-10T09:00:00.000',
      });

      expect(restored.kind, LocalReminderKind.dailyCheckIn);
      expect(restored.read, isFalse);
    });
  });

  group('AppNotification.periodFor', () {
    final now = DateTime(2026, 5, 10, 12);

    test('groups today', () {
      expect(
        AppNotification.periodFor(DateTime(2026, 5, 10, 9), now),
        NotificationPeriod.today,
      );
    });

    test('groups yesterday', () {
      expect(
        AppNotification.periodFor(DateTime(2026, 5, 9, 20), now),
        NotificationPeriod.yesterday,
      );
    });

    test('groups older messages as earlier', () {
      expect(
        AppNotification.periodFor(DateTime(2026, 5, 2, 9), now),
        NotificationPeriod.earlier,
      );
    });
  });
}
