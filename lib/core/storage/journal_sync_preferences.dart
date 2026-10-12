import 'package:shared_preferences/shared_preferences.dart';

/// Stores the user's journal-cloud-sync consent on this device only.
///
/// Sync is disabled unless the user explicitly enables it for the currently
/// signed-in account. Keeping this flag local prevents another account or a
/// reinstall from silently opting the user back in.
class JournalSyncPreferences {
  const JournalSyncPreferences();

  static const _enabledKey = 'journal.cloud_sync.enabled.v1';
  static const _userIdKey = 'journal.cloud_sync.consented_user_id.v1';
  static const _consentedAtKey = 'journal.cloud_sync.consented_at.v1';
  static const _lastSyncedAtKey = 'journal.cloud_sync.last_synced_at.v1';
  static const _syncFailedKey = 'journal.cloud_sync.last_attempt_failed.v1';

  Future<bool> isEnabledFor(String userId) async {
    if (userId.isEmpty) return false;
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(_enabledKey) == true &&
        preferences.getString(_userIdKey) == userId;
  }

  Future<DateTime?> consentedAt() async {
    final preferences = await SharedPreferences.getInstance();
    return _parseDate(preferences.getString(_consentedAtKey));
  }

  Future<DateTime?> lastSyncedAt(String userId) async {
    final preferences = await SharedPreferences.getInstance();
    if (preferences.getString(_userIdKey) != userId) return null;
    return _parseDate(preferences.getString(_lastSyncedAtKeyFor(userId)));
  }

  Future<bool> lastAttemptFailed(String userId) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(_userIdKey) == userId &&
        preferences.getBool(_syncFailedKeyFor(userId)) == true;
  }

  /// Call only after the user has accepted the consent dialog.
  Future<void> enable({
    required String userId,
    DateTime? consentedAt,
  }) async {
    if (userId.isEmpty) {
      throw ArgumentError.value(userId, 'userId', 'Must not be empty.');
    }

    final preferences = await SharedPreferences.getInstance();
    // Disable first so a failed update cannot carry a previous account's
    // enabled flag over to a newly selected account.
    final disabled = await preferences.setBool(_enabledKey, false);
    if (!disabled) {
      throw StateError('Could not prepare journal cloud-sync consent.');
    }

    final userSaved = await preferences.setString(_userIdKey, userId);
    if (!userSaved) {
      throw StateError('Could not save the account for journal sync consent.');
    }
    final consentSaved = await preferences.setString(
      _consentedAtKey,
      (consentedAt ?? DateTime.now()).toIso8601String(),
    );
    if (!consentSaved) {
      throw StateError('Could not save journal cloud-sync consent.');
    }

    final enabledSaved = await preferences.setBool(_enabledKey, true);
    if (!enabledSaved) {
      throw StateError('Could not enable journal cloud sync.');
    }

    await preferences.remove(_syncFailedKeyFor(userId));
  }

  Future<void> disable() async {
    final preferences = await SharedPreferences.getInstance();
    final saved = await preferences.setBool(_enabledKey, false);
    if (!saved) {
      throw StateError('Could not disable journal cloud sync.');
    }
  }

  Future<void> markSynced(String userId, DateTime timestamp) async {
    final preferences = await SharedPreferences.getInstance();
    if (preferences.getString(_userIdKey) != userId) return;

    final saved = await preferences.setString(
      _lastSyncedAtKeyFor(userId),
      timestamp.toIso8601String(),
    );
    if (!saved) {
      throw StateError('Could not save the journal sync timestamp.');
    }
    await preferences.remove(_syncFailedKeyFor(userId));
  }

  Future<void> markSyncFailed(String userId) async {
    final preferences = await SharedPreferences.getInstance();
    if (preferences.getString(_userIdKey) == userId) {
      await preferences.setBool(_syncFailedKeyFor(userId), true);
    }
  }

  /// Records that the remote copy was removed, without changing local entries.
  Future<void> markCloudCopyDeleted(String userId) async {
    final preferences = await SharedPreferences.getInstance();
    if (preferences.getString(_userIdKey) != userId) return;
    await preferences.remove(_lastSyncedAtKeyFor(userId));
    await preferences.remove(_syncFailedKeyFor(userId));
  }

  /// Used when the user clears all app data on this device.
  Future<void> reset() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_enabledKey);
    await preferences.remove(_userIdKey);
    await preferences.remove(_consentedAtKey);
    await preferences.remove(_lastSyncedAtKey);
    await preferences.remove(_syncFailedKey);
    for (final key in preferences.getKeys().toList()) {
      if (key.startsWith('$_lastSyncedAtKey.') ||
          key.startsWith('$_syncFailedKey.')) {
        await preferences.remove(key);
      }
    }
  }

  String _lastSyncedAtKeyFor(String userId) =>
      '$_lastSyncedAtKey.$userId';

  String _syncFailedKeyFor(String userId) => '$_syncFailedKey.$userId';

  DateTime? _parseDate(String? value) {
    if (value == null) return null;
    return DateTime.tryParse(value);
  }
}
