import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peria_app/core/services/app_locale_provider.dart';
import 'package:peria_app/core/services/notification_inbox_provider.dart';
import 'package:peria_app/core/services/privacy_policy_consent_service.dart';
import 'package:peria_app/core/services/push_notification_service.dart';
import 'package:peria_app/core/storage/app_settings_provider.dart';

final _pushAuthStateProvider = StreamProvider<User?>(
  (ref) => FirebaseAuth.instance.authStateChanges(),
);

/// Keeps `users/{uid}/devices` aligned with the signed-in account and the
/// "notifications push" switch.
///
/// Nothing is registered before the policy is accepted, and the device entry is
/// removed on sign-out: a push must never reach the next account opened on the
/// same phone.
final pushRegistrationProvider = Provider<void>((ref) {
  final service = PushNotificationService.instance;

  // A push that lands while Peria is open arrives as an inbox entry; the feed
  // has to show it without waiting for the next restart.
  service.onInboxChanged = () =>
      ref.read(notificationInboxProvider.notifier).refresh();

  ref.listen(_pushAuthStateProvider, (previous, next) {
    final previousUid = previous?.value?.uid;
    final nextUid = next.value?.uid;
    if (previousUid != null && nextUid == null) {
      unawaited(service.detach());
    }
  });

  final locale = ref.watch(appLocaleProvider);
  final uid = ref.watch(_pushAuthStateProvider).value?.uid;

  if (!PrivacyPolicyConsentService.hasAcceptedCurrentVersion) return;
  if (uid == null) return;

  final settings = ref.watch(appSettingsProvider).value;
  if (settings == null) return;

  unawaited(
    service.syncForUser(
      uid: uid,
      enabled: settings.pushEnabled,
      locale: locale?.languageCode ?? 'fr',
    ),
  );
});
