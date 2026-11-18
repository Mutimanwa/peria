import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:peria_app/core/repositories/user_repository.dart';
import 'package:peria_app/core/services/notification_center.dart';
import 'package:peria_app/core/services/push_payload.dart';

/// Receives the pushes Firebase delivers while Peria is not in the foreground.
///
/// Firebase starts a separate isolate for this callback, so it must not read the
/// encrypted Hive box: the key only lives in the main isolate. The entry is
/// therefore acknowledged and nothing else; the feed is rebuilt from the plan
/// the next time the app starts.
@pragma('vm:entry-point')
Future<void> periaPushBackgroundHandler(RemoteMessage message) async {
  debugPrint('[push] background message received (${message.messageId})');
}

/// Everything Peria needs before server-sent reminders can work: the OS
/// permission, the device token, and where that token is stored.
///
/// Groundwork only: the app can already register a device and receive a push,
/// but no server sends one yet. The token is kept under
/// `users/{uid}/devices/{hashed token}`, which is deleted with the account.
class PushNotificationService {
  PushNotificationService._();

  static final PushNotificationService instance = PushNotificationService._();

  FirebaseMessaging? _messagingClient;
  StreamSubscription<RemoteMessage>? _messageSubscription;
  StreamSubscription<String>? _tokenSubscription;
  bool _initialized = false;

  String? _token;
  String? _uid;
  bool _enabled = false;
  String _locale = 'fr';

  /// Called after a foreground push was added to the feed, so the inbox can be
  /// refreshed while the app is open.
  VoidCallback? onInboxChanged;

  /// The current token, once Firebase has provided one.
  String? get token => _token;

  FirebaseMessaging? get _messaging {
    // Push is mobile only; a web build must not even touch the plugin.
    if (kIsWeb) return null;
    try {
      return _messagingClient ??= FirebaseMessaging.instance;
    } catch (error) {
      debugPrint('[push] Firebase Messaging unavailable: $error');
      return null;
    }
  }

  /// Routes pushes received while the app is not running to
  /// [periaPushBackgroundHandler]. Must run before `runApp`, and once only.
  void registerBackgroundHandler() {
    if (kIsWeb) return;
    try {
      FirebaseMessaging.onBackgroundMessage(periaPushBackgroundHandler);
    } catch (error) {
      debugPrint('[push] background handler not registered: $error');
    }
  }

  /// Wires the message and token streams. Safe to call once, from `main`.
  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    final messaging = _messaging;
    if (messaging == null) return;

    try {
      // A push that arrives while the app is open is rendered by Peria itself:
      // the OS must not add a second banner on top of it.
      await messaging.setForegroundNotificationPresentationOptions(
        alert: false,
        badge: true,
        sound: false,
      );
    } catch (error) {
      debugPrint('[push] foreground presentation not applied: $error');
    }

    _messageSubscription ??= FirebaseMessaging.onMessage.listen(
      (message) => unawaited(handleForegroundMessage(message)),
    );
    _tokenSubscription ??= messaging.onTokenRefresh.listen(
      (token) => unawaited(_persistToken(token)),
    );

    await _persistToken(await _currentToken());
  }

  Future<String?> _currentToken() async {
    try {
      return await _messaging?.getToken();
    } catch (error) {
      // IOS answers with an error until the APNs token is available; the
      // refresh stream fires as soon as it is.
      debugPrint('[push] token unavailable: $error');
      return null;
    }
  }

  /// Asks the user for the system permission and registers the device.
  ///
  /// Returns `false` when the permission is denied, so the caller can keep the
  /// switch off and explain why.
  Future<bool> requestPermission() async {
    final messaging = _messaging;
    if (messaging == null) return false;

    try {
      final settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      final granted =
          settings.authorizationStatus == AuthorizationStatus.authorized ||
              settings.authorizationStatus == AuthorizationStatus.provisional;
      if (!granted) return false;
    } catch (error) {
      debugPrint('[push] permission request failed: $error');
      return false;
    }

    await _persistToken(await _currentToken());
    return true;
  }

  /// Aligns the stored device with the signed-in account and the user choice.
  ///
  /// Called whenever auth, settings or the token change.
  Future<void> syncForUser({
    required String uid,
    required bool enabled,
    required String locale,
  }) async {
    final previousUid = _uid;
    _uid = uid;
    _enabled = enabled;
    _locale = locale;

    if (!enabled) {
      // Turning the switch off removes the device, whichever account it was
      // registered under on this phone.
      if (previousUid != null && previousUid != uid) {
        await _removeDevice(previousUid);
      }
      await _removeDevice(uid);
      return;
    }

    if (previousUid != null && previousUid != uid) {
      await _removeDevice(previousUid);
    }

    final current = _token ?? await _currentToken();
    if (current == null || current.isEmpty) return;
    _token = current;
    await _saveDevice(uid, current);
  }

  /// Forgets this device when the user signs out.
  Future<void> detach() async {
    final uid = _uid;
    _uid = null;
    _enabled = false;
    if (uid != null) await _removeDevice(uid);
  }

  /// Turns a delivered push into an inbox entry.
  ///
  /// Filtering is already applied server-side; the phone still validates the
  /// payload because it is the last line of defence.
  Future<void> handleForegroundMessage(RemoteMessage message) async {
    final payload = PushPayload.fromData(
      message.data,
      sentAt: message.sentTime,
    );
    if (payload == null) {
      debugPrint('[push] ignored a payload without a known kind');
      return;
    }

    await NotificationCenter.instance.restore(payload.toAppNotification());
    onInboxChanged?.call();
  }

  Future<void> _persistToken(String? token) async {
    if (token == null || token.isEmpty) return;
    _token = token;

    final uid = _uid;
    if (!_enabled || uid == null) return;
    await _saveDevice(uid, token);
  }

  Future<void> _saveDevice(String uid, String token) async {
    try {
      await UserRepository().savePushDevice(
        uid: uid,
        token: token,
        platform: defaultTargetPlatform.name,
        locale: _locale,
      );
    } catch (error) {
      // Offline, or signed out between the check and the write: the next
      // sync retries, nothing here may break the app.
      debugPrint('[push] could not register this device: $error');
    }
  }

  Future<void> _removeDevice(String uid) async {
    final token = _token;
    if (token == null || token.isEmpty) return;
    try {
      await UserRepository().removePushDevice(uid: uid, token: token);
    } catch (error) {
      debugPrint('[push] could not remove this device: $error');
    }
  }
}
