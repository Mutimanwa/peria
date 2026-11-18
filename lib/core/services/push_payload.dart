import 'package:peria_app/core/services/app_notification.dart';
import 'package:peria_app/core/services/notification_schedule_planner.dart';

/// A reminder sent by the server over FCM.
///
/// Pushes are **data-only**: the notification text is written by the phone, in
/// the user's language, so the lock screen never shows a cycle detail. The
/// payload therefore carries only the kind of reminder and when it was meant to
/// fire.
///
/// Everything coming from the network is untrusted: an unknown kind, a missing
/// date or a date outside the accepted window is rejected instead of being
/// displayed.
class PushPayload {
  const PushPayload({required this.kind, required this.scheduledAt});

  final LocalReminderKind kind;
  final DateTime scheduledAt;

  /// How far in the past or in the future a pushed reminder may be dated.
  ///
  /// A push is always "now", so a wrong or malicious timestamp must not move an
  /// entry to the bottom of the feed or invent a future one.
  static const Duration _tolerance = Duration(days: 2);

  /// Builds a payload from the FCM data map, or returns `null` when it is not
  /// usable.
  ///
  /// [sentAt] is the delivery time reported by Firebase and [now] the local
  /// clock; both are only used as a fallback for a missing timestamp.
  static PushPayload? fromData(
    Map<String, dynamic> data, {
    DateTime? sentAt,
    DateTime? now,
  }) {
    final kindName = (data['kind'] as String?)?.trim();
    if (kindName == null || kindName.isEmpty) return null;

    LocalReminderKind? kind;
    for (final value in LocalReminderKind.values) {
      if (value.name == kindName) {
        kind = value;
        break;
      }
    }
    if (kind == null) return null;

    final reference = now ?? DateTime.now();
    final rawDate = (data['scheduledAt'] as String?)?.trim();
    final parsed = rawDate == null || rawDate.isEmpty
        ? null
        : DateTime.tryParse(rawDate);

    final candidate = (parsed ?? sentAt ?? reference).toLocal();
    final scheduledAt = candidate.isAfter(reference.add(_tolerance))
        ? reference
        : candidate;

    return PushPayload(kind: kind, scheduledAt: scheduledAt);
  }

  /// The inbox entry this push becomes.
  ///
  /// The same kind and day already produce the same id as a locally planned
  /// reminder, so a push cannot duplicate a message the phone created itself.
  AppNotification toAppNotification() => AppNotification(
        id: AppNotification.idFor(kind, scheduledAt),
        kind: kind,
        scheduledAt: scheduledAt,
      );
}
