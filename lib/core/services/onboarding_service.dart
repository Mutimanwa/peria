import 'package:shared_preferences/shared_preferences.dart';

class OnboardingService {
  static const String _keyOnboardingCompleted = 'onboarding_completed';

  static String _keyForUid(String uid) => '${_keyOnboardingCompleted}_$uid';

  /// Persists that onboarding is finished so a cold start does not reopen the
  /// name screen. The unscoped key covers installs that completed onboarding
  /// before the flag was read at startup.
  static Future<void> setOnboardingCompleted({String? uid}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyOnboardingCompleted, true);
    if (uid != null && uid.isNotEmpty) {
      await prefs.setBool(_keyForUid(uid), true);
    }
  }

  static Future<bool> isOnboardingCompleted({String? uid}) async {
    final prefs = await SharedPreferences.getInstance();
    if (uid != null &&
        uid.isNotEmpty &&
        (prefs.getBool(_keyForUid(uid)) ?? false)) {
      return true;
    }
    return prefs.getBool(_keyOnboardingCompleted) ?? false;
  }
}