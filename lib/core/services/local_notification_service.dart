import 'dart:async';
import 'dart:ui' show Locale;

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:peria_app/core/services/notification_schedule_planner.dart';
import 'package:peria_app/core/storage/app_settings.dart';
import 'package:peria_app/features/cycle/domain/cycle_status.dart';
import 'package:peria_app/l10n/app_localizations.dart';
import 'package:timezone/data/latest.dart' as timezone_data;
import 'package:timezone/timezone.dart' as tz;

/// Schedules privacy-preserving reminders on this device only.
class LocalNotificationService {
  LocalNotificationService._();

  static final LocalNotificationService instance =
      LocalNotificationService._();
  static const String _channelId = 'peria_local_reminders';

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  Future<void> _scheduleQueue = Future<void>.value();
  bool _initialized = false;

  bool get _isSupportedPlatform =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  Future<void> initialize() async {
    if (!_isSupportedPlatform || _initialized) return;

    try {
      timezone_data.initializeTimeZones();
      final timeZoneName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timeZoneName));

      final initialized = await _plugin.initialize(
        const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
          iOS: DarwinInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
          ),
        ),
      );
      _initialized = initialized ?? true;
    } catch (error) {
      _initialized = false;
      _log('local notification setup failed: $error');
    }
  }

  /// Requests OS permission only after the user enables the master switch.
  Future<bool> requestPermission() async {
    if (!_isSupportedPlatform || !_initialized) return false;

    if (defaultTargetPlatform == TargetPlatform.android) {
      final android = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      if (android == null) return false;
      // Android versions below 13 do not show a runtime permission dialog.
      return await android.requestNotificationsPermission() ?? true;
    }

    final ios = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    if (ios == null) return false;
    return await ios.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        ) ??
        false;
  }

  /// Replaces Peria's managed reminder schedule with the latest preferences
  /// and cycle prediction. Other notification IDs are never touched.
  Future<void> synchronize({
    required AppSettings? settings,
    required CycleStatus? cycleStatus,
    Locale? locale,
    DateTime? now,
  }) {
    final next = _scheduleQueue.then<void>((_) async {
      await _synchronize(
        settings: settings,
        cycleStatus: cycleStatus,
        locale: locale,
        now: now,
      );
    });
    _scheduleQueue = next.catchError((Object error, StackTrace stackTrace) {
      _log('could not update the local reminder schedule: $error\n$stackTrace');
    });
    return _scheduleQueue;
  }

  Future<void> cancelManagedNotifications() {
    if (!_isSupportedPlatform || !_initialized) return Future<void>.value();

    final next = _scheduleQueue.then<void>(
      (_) => _cancelManagedNotifications(),
    );
    _scheduleQueue = next.catchError((Object error, StackTrace stackTrace) {
      _log('could not cancel the local reminder schedule: $error\n$stackTrace');
    });
    return _scheduleQueue;
  }

  Future<void> _synchronize({
    required AppSettings? settings,
    required CycleStatus? cycleStatus,
    required Locale? locale,
    required DateTime? now,
  }) async {
    if (!_isSupportedPlatform || !_initialized) return;

    await _cancelManagedNotifications();
    if (settings == null || !settings.allowNotifications) return;

    final plan = NotificationSchedulePlanner.createPlan(
      settings: settings,
      cycleStatus: cycleStatus,
      now: now,
    );
    if (plan.isEmpty) return;

    final preferredLocale = locale ?? PlatformDispatcher.instance.locale;
    final notificationLocale = AppLocalizations.supportedLocales.firstWhere(
      (supportedLocale) =>
          supportedLocale.languageCode == preferredLocale.languageCode,
      orElse: () => const Locale('en'),
    );
    final text = lookupAppLocalizations(notificationLocale);
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        text.notificationChannelName,
        channelDescription: text.notificationChannelDescription,
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
        visibility: NotificationVisibility.private,
        category: AndroidNotificationCategory.reminder,
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: false,
        presentSound: true,
      ),
    );

    for (final notification in plan) {
      await _plugin.zonedSchedule(
        notification.id,
        text.notificationGenericTitle,
        text.notificationGenericBody,
        tz.TZDateTime.from(notification.scheduledAt, tz.local),
        details,
        // Avoid Android's special exact-alarm permission for non-urgent reminders.
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: notification.repeatsDaily
            ? DateTimeComponents.time
            : null,
      );
    }
  }

  Future<void> _cancelManagedNotifications() async {
    for (final id in NotificationSchedulePlanner.managedNotificationIds) {
      await _plugin.cancel(id);
    }
  }

  void _log(String message) {
    if (kDebugMode) {
      debugPrint('[LocalNotificationService] $message');
    }
  }
}
