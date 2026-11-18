import 'package:peria_app/core/services/notification_schedule_planner.dart';

/// Which group a reminder belongs to in the inbox.
enum NotificationPeriod { today, yesterday, earlier }

/// A reminder that was already due on this device.
///
/// The operating system does not expose a notification history, so Peria keeps
/// its own: every planned reminder whose time has passed becomes an inbox item,
/// with the screen it should open and a read/unread flag.
class AppNotification {
  const AppNotification({
    required this.id,
    required this.kind,
    required this.scheduledAt,
    this.read = false,
  });

  /// Stable identifier: one entry per reminder type and day.
  final String id;
  final LocalReminderKind kind;
  final DateTime scheduledAt;
  final bool read;

  /// Where a tap on this notification should lead.
  String get route => routeForKind(kind);

  static String routeForKind(LocalReminderKind kind) {
    switch (kind) {
      case LocalReminderKind.period:
        return '/cycle';
      case LocalReminderKind.fertileWindow:
      case LocalReminderKind.ovulation:
        return '/calendar';
      case LocalReminderKind.dailyCheckIn:
        return '/symptoms';
    }
  }

  /// Groups a reminder under Aujourd'hui / Hier / Plus tôt.
  static NotificationPeriod periodFor(DateTime scheduledAt, DateTime now) {
    final day = DateTime(scheduledAt.year, scheduledAt.month, scheduledAt.day);
    final today = DateTime(now.year, now.month, now.day);
    if (!day.isBefore(today)) return NotificationPeriod.today;
    if (day == today.subtract(const Duration(days: 1))) {
      return NotificationPeriod.yesterday;
    }
    return NotificationPeriod.earlier;
  }

  static String idFor(LocalReminderKind kind, DateTime at) =>
      '${kind.name}-${at.year}-${at.month.toString().padLeft(2, '0')}-'
      '${at.day.toString().padLeft(2, '0')}';

  AppNotification copyWith({bool? read}) => AppNotification(
        id: id,
        kind: kind,
        scheduledAt: scheduledAt,
        read: read ?? this.read,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'kind': kind.name,
        'scheduledAt': scheduledAt.toIso8601String(),
        'read': read,
      };

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    final kindName = json['kind'] as String? ?? '';
    return AppNotification(
      id: json['id'] as String,
      kind: LocalReminderKind.values.firstWhere(
        (value) => value.name == kindName,
        orElse: () => LocalReminderKind.dailyCheckIn,
      ),
      scheduledAt: DateTime.parse(json['scheduledAt'] as String),
      read: json['read'] as bool? ?? false,
    );
  }

  /// Whether this reminder is already part of the feed.
  bool isDue(DateTime now) => !scheduledAt.isAfter(now);

  /// The reminders of [plan], past or future.
  ///
  /// The planner only produces upcoming dates, so every entry is stored when it
  /// is first seen: once its time comes, it shows up in the feed without the app
  /// needing to be running.
  static List<AppNotification> fromPlan(List<PlannedLocalNotification> plan) =>
      [
        for (final item in plan)
          AppNotification(
            id: idFor(item.kind, item.scheduledAt),
            kind: item.kind,
            scheduledAt: item.scheduledAt,
          ),
      ];

  /// How long a past reminder stays readable in the feed.
  static const Duration retention = Duration(days: 30);

  /// Ids that can be dropped from the store.
  ///
  /// Two cases: a past reminder older than [retention], and a *future* reminder
  /// the latest prediction no longer contains (the period came early, the cycle
  /// length changed) which would otherwise surface as a ghost.
  static Set<String> obsoleteIds(
    Iterable<AppNotification> stored,
    List<PlannedLocalNotification> plan, {
    required DateTime now,
    Duration? keepFor,
  }) {
    final retentionWindow = keepFor ?? retention;
    final oldest = now.subtract(retentionWindow);
    final plannedIds = fromPlan(plan).map((item) => item.id).toSet();

    return {
      for (final item in stored)
        if (item.scheduledAt.isBefore(oldest) ||
            (item.scheduledAt.isAfter(now) && !plannedIds.contains(item.id)))
          item.id,
    };
  }
}
