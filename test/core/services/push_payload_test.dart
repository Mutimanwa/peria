import 'package:flutter_test/flutter_test.dart';
import 'package:peria_app/core/services/app_notification.dart';
import 'package:peria_app/core/services/notification_schedule_planner.dart';
import 'package:peria_app/core/services/push_payload.dart';

void main() {
  final now = DateTime(2026, 3, 10, 12);

  group('PushPayload', () {
    test('accepts a known kind with a readable date', () {
      final payload = PushPayload.fromData(
        {
          'kind': 'period',
          'scheduledAt': DateTime(2026, 3, 10, 9).toIso8601String(),
        },
        now: now,
      );

      expect(payload, isNotNull);
      expect(payload!.kind, LocalReminderKind.period);
      expect(payload.scheduledAt, DateTime(2026, 3, 10, 9));
    });

    test('sends the push to the screen of its kind', () {
      final payload = PushPayload.fromData(
        {
          'kind': 'fertile_window',
          'scheduledAt': DateTime(2026, 3, 10, 9).toIso8601String(),
        },
        now: now,
      );

      // Unknown names are rejected instead of falling back to another kind.
      expect(payload, isNull);

      final fertile = PushPayload.fromData(
        {
          'kind': LocalReminderKind.fertileWindow.name,
          'scheduledAt': DateTime(2026, 3, 10, 9).toIso8601String(),
        },
        now: now,
      );
      expect(fertile!.toAppNotification().route, '/calendar');
    });

    test('rejects a payload without a usable kind', () {
      expect(PushPayload.fromData(const {}, now: now), isNull);
      expect(PushPayload.fromData(const {'kind': '  '}, now: now), isNull);
      expect(PushPayload.fromData(const {'kind': 'unknown'}, now: now), isNull);
    });

    test('falls back to now when the date is missing or unreadable', () {
      final missing = PushPayload.fromData(
        {'kind': LocalReminderKind.ovulation.name},
        now: now,
      );
      final broken = PushPayload.fromData(
        {'kind': LocalReminderKind.ovulation.name, 'scheduledAt': 'hier'},
        now: now,
      );

      expect(missing!.scheduledAt, now);
      expect(broken!.scheduledAt, now);
    });

    test('clamps a date in the future back to now', () {
      final payload = PushPayload.fromData(
        {
          'kind': LocalReminderKind.period.name,
          'scheduledAt': now.add(const Duration(days: 10)).toIso8601String(),
        },
        now: now,
      );

      expect(payload!.scheduledAt, now);
    });

    test('keeps the id of a locally planned reminder', () {
      final at = DateTime(2026, 3, 10, 9);
      final payload = PushPayload.fromData(
        {
          'kind': LocalReminderKind.period.name,
          'scheduledAt': at.toIso8601String(),
        },
        now: now,
      );

      expect(
        payload!.toAppNotification().id,
        AppNotification.idFor(LocalReminderKind.period, at),
      );
    });
  });
}
