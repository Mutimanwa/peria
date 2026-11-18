import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peria_app/core/services/app_notification.dart';
import 'package:peria_app/core/services/notification_center.dart';
import 'package:peria_app/core/services/notification_schedule_planner.dart';

/// The feed: reminders that already happened, newest first.
class NotificationInboxNotifier extends StateNotifier<List<AppNotification>> {
  /// [initial] lets a test start from a known inbox; production reads the box.
  NotificationInboxNotifier({List<AppNotification>? initial})
      : super(initial ?? NotificationCenter.instance.due());

  void refresh() {
    if (!mounted) return;
    state = NotificationCenter.instance.due();
  }

  Future<void> sync(List<PlannedLocalNotification> plan) async {
    await NotificationCenter.instance.syncFromPlan(plan);
    refresh();
  }

  /// Read state changes are applied to the list first so a tap feels
  /// immediate, then written to the encrypted box.
  Future<void> markRead(String id) async {
    if (!state.any((item) => item.id == id && !item.read)) return;
    state = [
      for (final item in state) item.id == id ? item.copyWith(read: true) : item,
    ];
    await NotificationCenter.instance.markRead(id);
  }

  Future<void> markAllRead() async {
    if (state.every((item) => item.read)) return;
    state = [for (final item in state) item.copyWith(read: true)];
    await NotificationCenter.instance.markAllRead();
  }

  Future<void> restore(AppNotification notification) async {
    if (state.any((item) => item.id == notification.id)) return;
    // Optimistic: the undo action must put the card back before it is written.
    state = [...state, notification]..sort(
        (a, b) => b.scheduledAt.compareTo(a.scheduledAt),
      );
    await NotificationCenter.instance.restore(notification);
  }

  Future<void> delete(String id) async {
    if (!state.any((item) => item.id == id)) return;
    // Removed from the list first: a dismissed card must leave the tree
    // immediately or Flutter complains about a dismissed Dismissible.
    state = state.where((item) => item.id != id).toList();
    await NotificationCenter.instance.delete(id);
  }

  Future<void> clear() async {
    if (state.isEmpty) return;
    state = const [];
    await NotificationCenter.instance.clear();
  }
}

final notificationInboxProvider =
    StateNotifierProvider<NotificationInboxNotifier, List<AppNotification>>(
  (ref) => NotificationInboxNotifier(),
);

/// Number of reminders the user has not opened yet, used by the home bell.
final unreadNotificationCountProvider = Provider<int>(
  (ref) => ref
      .watch(notificationInboxProvider)
      .where((notification) => !notification.read)
      .length,
);
