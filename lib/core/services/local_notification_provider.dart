import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peria_app/core/services/app_locale_provider.dart';
import 'package:peria_app/core/services/local_notification_service.dart';
import 'package:peria_app/core/services/privacy_policy_consent_service.dart';
import 'package:peria_app/core/storage/app_settings_provider.dart';
import 'package:peria_app/features/cycle/presentation/providers/cycle_provider.dart';
import 'package:peria_app/features/profile/presentation/providers/user_profile_provider.dart';

final _notificationAuthStateProvider = StreamProvider<User?>(
  (ref) => FirebaseAuth.instance.authStateChanges(),
);

/// Keeps scheduled reminders aligned with the signed-in account, notification
/// preferences, and current cycle prediction while Peria is running.
final localNotificationScheduleProvider = Provider<void>((ref) {
  final service = LocalNotificationService.instance;
  final locale = ref.watch(appLocaleProvider);

  ref.listen(_notificationAuthStateProvider, (previous, next) {
    if (!PrivacyPolicyConsentService.hasAcceptedCurrentVersion) return;

    final previousUid = previous?.value?.uid;
    final nextUid = next.value?.uid;
    if (previousUid != nextUid) {
      ref.invalidate(appSettingsProvider);
      ref.invalidate(periodLogsProvider);
      ref.invalidate(userProfileProvider);
      unawaited(service.cancelManagedNotifications());
    }
  });

  final authState = ref.watch(_notificationAuthStateProvider);
  if (!PrivacyPolicyConsentService.hasAcceptedCurrentVersion) return;
  if (authState.isLoading) return;
  if (authState.value == null) {
    unawaited(service.cancelManagedNotifications());
    return;
  }

  final settingsState = ref.watch(appSettingsProvider);
  if (settingsState.isLoading && settingsState.value == null) return;

  final settings = settingsState.value;
  if (settings == null) {
    unawaited(service.cancelManagedNotifications());
    return;
  }

  final hasCycleReminders = settings.allowNotifications &&
      (settings.notifyPeriodStarting ||
          settings.notifyFertileWindow ||
          settings.notifyOvulationDay);
  final cycleStatus = hasCycleReminders ? ref.watch(cycleStatusProvider) : null;
  unawaited(
    service.synchronize(
      settings: settings,
      cycleStatus: cycleStatus,
      locale: locale,
    ),
  );
});
