import 'package:flutter_test/flutter_test.dart';
import 'package:peria_app/core/services/app_notification.dart';
import 'package:peria_app/core/services/notification_inbox_provider.dart';
import 'package:peria_app/core/services/notification_schedule_planner.dart';

AppNotification _item(
  String id,
  LocalReminderKind kind,
  DateTime when, {
  bool read = false,
}) =>
    AppNotification(
      id: id,
      kind: kind,
      scheduledAt: when,
      read: read,
    );

void main() {
  group('NotificationInboxNotifier', () {
    late AppNotification period;
    late AppNotification checkIn;

    setUp(() {
      period = _item(
        'period-2026-05-10',
        LocalReminderKind.period,
        DateTime(2026, 5, 10, 9),
      );
      checkIn = _item(
        'dailyCheckIn-2026-05-09',
        LocalReminderKind.dailyCheckIn,
        DateTime(2026, 5, 9, 20),
        read: true,
      );
    });

    test('starts from the messages it is given', () {
      final notifier = NotificationInboxNotifier(initial: [period, checkIn]);

      expect(notifier.state, [period, checkIn]);
    });

    test('marks one message as read', () async {
      final notifier = NotificationInboxNotifier(initial: [period, checkIn]);

      await notifier.markRead(period.id);

      expect(notifier.state.first.read, isTrue);
      expect(notifier.state, hasLength(2));
    });

    test('marks everything as read', () async {
      final notifier = NotificationInboxNotifier(initial: [period, checkIn]);

      await notifier.markAllRead();

      expect(notifier.state.every((item) => item.read), isTrue);
    });

    test('deletes a message before it is written to disk', () async {
      final notifier = NotificationInboxNotifier(initial: [period, checkIn]);

      final pending = notifier.delete(period.id);

      // The card must leave the list immediately: a dismissed Dismissible
      // widget cannot stay in the tree.
      expect(notifier.state, [checkIn]);

      await pending;
      expect(notifier.state, [checkIn]);
    });

    test('restores a deleted message at its chronological place', () async {
      final notifier = NotificationInboxNotifier(initial: [checkIn]);

      await notifier.restore(period);

      expect(notifier.state, [period, checkIn]);
    });

    test('clears every message', () async {
      final notifier = NotificationInboxNotifier(initial: [period, checkIn]);

      await notifier.clear();

      expect(notifier.state, isEmpty);
    });

    test('ignores an unknown id', () async {
      final notifier = NotificationInboxNotifier(initial: [period]);

      await notifier.delete('missing');
      await notifier.markRead('missing');

      expect(notifier.state, [period]);
    });
  });
}
