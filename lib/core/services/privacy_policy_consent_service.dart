import 'package:shared_preferences/shared_preferences.dart';

/// Stores the user's acknowledgement of the current Privacy Policy on-device.
///
/// Increment [currentPolicyVersion] whenever a policy change requires renewed
/// acknowledgement. The router and data-loading providers use the cached value
/// so they can enforce the gate synchronously.
class PrivacyPolicyConsentService {
  static const String currentPolicyVersion = '1.1';
  static const String _acceptedVersionKey = 'privacy.policy.accepted_version';
  static const String _acceptedAtKey = 'privacy.policy.accepted_at';

  static bool _hasAcceptedCurrentVersion = false;

  static bool get hasAcceptedCurrentVersion => _hasAcceptedCurrentVersion;

  static void requireCurrentPolicyAcceptance() {
    if (!_hasAcceptedCurrentVersion) {
      throw StateError('The current privacy policy must be accepted first.');
    }
  }

  /// Loads the persisted acknowledgement. Any storage failure fails closed.
  Future<bool> loadCurrentAcceptance() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      _hasAcceptedCurrentVersion =
          preferences.getString(_acceptedVersionKey) == currentPolicyVersion;
    } catch (_) {
      _hasAcceptedCurrentVersion = false;
    }
    return _hasAcceptedCurrentVersion;
  }

  /// Persists the acknowledgement before any authenticated account is created.
  Future<void> acceptCurrentPolicy() async {
    final preferences = await SharedPreferences.getInstance();
    final timestampSaved = await preferences.setString(
      _acceptedAtKey,
      DateTime.now().toUtc().toIso8601String(),
    );
    if (!timestampSaved) {
      throw StateError('Could not save the privacy policy acceptance time.');
    }

    final versionSaved = await preferences.setString(
      _acceptedVersionKey,
      currentPolicyVersion,
    );
    if (!versionSaved) {
      await preferences.remove(_acceptedAtKey);
      throw StateError('Could not save the privacy policy acceptance.');
    }

    _hasAcceptedCurrentVersion = true;
  }
}
