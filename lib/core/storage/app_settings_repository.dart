import 'package:shared_preferences/shared_preferences.dart';
import 'app_settings.dart';

class AppSettingsRepository {
  static const _allowNotifications = 'settings.allow_notifications';
  static const _notifyPeriodStarting = 'settings.notify_period_starting';
  static const _notifyFertileWindow = 'settings.notify_fertile_window';
  static const _notifyOvulationDay = 'settings.notify_ovulation_day';
  static const _remindLogSymptoms = 'settings.remind_log_symptoms';
  static const _notifyPartnerUpdates = 'settings.notify_partner_updates';
  static const _twoFactorEnabled = 'settings.two_factor_enabled';
  static const _faceIdEnabled = 'settings.face_id_enabled';
  static const _discreetModeEnabled = 'settings.discreet_mode_enabled';
  static const _periodLengthDays = 'settings.period_length_days';
  static const _cycleLengthDays = 'settings.cycle_length_days';

  Future<AppSettings> load() async {
    final prefs = await SharedPreferences.getInstance();
    return AppSettings(
      allowNotifications: prefs.getBool(_allowNotifications) ?? false,
      notifyPeriodStarting: prefs.getBool(_notifyPeriodStarting) ?? false,
      notifyFertileWindow: prefs.getBool(_notifyFertileWindow) ?? true,
      notifyOvulationDay: prefs.getBool(_notifyOvulationDay) ?? false,
      remindLogSymptoms: prefs.getBool(_remindLogSymptoms) ?? false,
      notifyPartnerUpdates: prefs.getBool(_notifyPartnerUpdates) ?? true,
      twoFactorEnabled: prefs.getBool(_twoFactorEnabled) ?? false,
      faceIdEnabled: prefs.getBool(_faceIdEnabled) ?? true,
      discreetModeEnabled: prefs.getBool(_discreetModeEnabled) ?? false,
      periodLengthDays: prefs.getInt(_periodLengthDays) ?? 7,
      cycleLengthDays: prefs.getInt(_cycleLengthDays) ?? 28,
    );
  }

  Future<void> save(AppSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_allowNotifications, settings.allowNotifications);
    await prefs.setBool(_notifyPeriodStarting, settings.notifyPeriodStarting);
    await prefs.setBool(_notifyFertileWindow, settings.notifyFertileWindow);
    await prefs.setBool(_notifyOvulationDay, settings.notifyOvulationDay);
    await prefs.setBool(_remindLogSymptoms, settings.remindLogSymptoms);
    await prefs.setBool(_notifyPartnerUpdates, settings.notifyPartnerUpdates);
    await prefs.setBool(_twoFactorEnabled, settings.twoFactorEnabled);
    await prefs.setBool(_faceIdEnabled, settings.faceIdEnabled);
    await prefs.setBool(_discreetModeEnabled, settings.discreetModeEnabled);
    await prefs.setInt(_periodLengthDays, settings.periodLengthDays);
    await prefs.setInt(_cycleLengthDays, settings.cycleLengthDays);
  }
}
