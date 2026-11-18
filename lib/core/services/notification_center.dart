import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:peria_app/core/services/app_notification.dart';
import 'package:peria_app/core/services/notification_schedule_planner.dart';
import 'package:peria_app/core/storage/hive_boxes.dart';

/// Local feed of the reminders that were due on this device.
///
/// The operating system keeps no notification history and the planner only
/// returns upcoming dates, so Peria remembers the reminders it saw: each one is
/// stored when first planned and becomes readable once its time has passed.
/// Everything lives in the encrypted Hive box, as JSON strings: a reminder
/// reveals cycle information, so it must not sit in plain text.
class NotificationCenter {
  NotificationCenter._();

  static final NotificationCenter instance = NotificationCenter._();

  Box<String>? get _box =>
      Hive.isBoxOpen(HiveBoxes.appNotifications)
          ? Hive.box<String>(HiveBoxes.appNotifications)
          : null;

  /// Every stored reminder, most recent first, including the upcoming ones.
  List<AppNotification> all() => _read();

  /// The reminders that already happened, most recent first: the feed.
  List<AppNotification> due({DateTime? now}) {
    final current = now ?? DateTime.now();
    return _read()
        .where((item) => item.isDue(current))
        .toList(growable: false);
  }

  /// Stores the reminders of the latest [plan] and drops the obsolete ones.
  Future<void> syncFromPlan(
    List<PlannedLocalNotification> plan, {
    DateTime? now,
  }) async {
    final box = _box;
    if (box == null) return;

    final current = now ?? DateTime.now();

    try {
      final existing = box.keys.map((key) => key.toString()).toSet();

      for (final item in AppNotification.fromPlan(plan)) {
        if (existing.contains(item.id)) continue;
        await box.put(item.id, jsonEncode(item.toJson()));
      }

      final obsolete = AppNotification.obsoleteIds(
        _read(),
        plan,
        now: current,
      );
      for (final id in obsolete) {
        await box.delete(id);
      }
    } catch (error) {
      debugPrint('[NotificationCenter] sync failed: $error');
    }
  }

  Future<void> markRead(String id) async {
    final box = _box;
    if (box == null) return;
    final current = _decode(box.get(id));
    if (current == null || current.read) return;
    await box.put(id, jsonEncode(current.copyWith(read: true).toJson()));
  }

  /// Marks the readable reminders as read. Upcoming ones keep their unread
  /// state: they are not on screen yet and must still flag themselves later.
  Future<void> markAllRead() async {
    final box = _box;
    if (box == null) return;
    final now = DateTime.now();
    for (final key in box.keys.toList()) {
      final current = _decode(box.get(key.toString()));
      if (current == null || current.read || !current.isDue(now)) continue;
      await box.put(key, jsonEncode(current.copyWith(read: true).toJson()));
    }
  }

  /// Puts back a message the user deleted by mistake.
  Future<void> restore(AppNotification notification) async {
    final box = _box;
    if (box == null) return;
    await box.put(notification.id, jsonEncode(notification.toJson()));
  }

  Future<void> delete(String id) async {
    final box = _box;
    if (box == null) return;
    await box.delete(id);
  }

  Future<void> clear() async {
    final box = _box;
    if (box == null) return;
    await box.clear();
  }

  List<AppNotification> _read() {
    final box = _box;
    if (box == null) return const [];
    final items = <AppNotification>[];
    for (final raw in box.values) {
      final parsed = _decode(raw);
      if (parsed != null) items.add(parsed);
    }
    items.sort((a, b) => b.scheduledAt.compareTo(a.scheduledAt));
    return items;
  }

  AppNotification? _decode(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      final json = jsonDecode(raw);
      if (json is! Map<String, dynamic>) return null;
      return AppNotification.fromJson(json);
    } catch (_) {
      return null;
    }
  }
}
