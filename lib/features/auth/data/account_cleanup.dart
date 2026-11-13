import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:peria_app/core/services/app_locale_provider.dart';
import 'package:peria_app/core/services/local_notification_service.dart';
import 'package:peria_app/core/storage/hive_boxes.dart';

/// Removes everything this device kept for the account that is being
/// deleted: local reminders, encrypted journal and period data, preferences
/// and the security material (PIN, encryption key).
///
/// The interface language is preserved so the app does not silently switch
/// back to the device language.
Future<void> clearLocalAccountData() async {
  await LocalNotificationService.instance.cancelManagedNotifications();

  const boxes = <String>[
    HiveBoxes.journalEntries,
    HiveBoxes.journalTombstones,
    HiveBoxes.periodLogs,
    HiveBoxes.legacyJournalEntries,
  ];
  for (final name in boxes) {
    try {
      if (Hive.isBoxOpen(name)) {
        await Hive.box<dynamic>(name).clear();
      } else {
        await Hive.deleteBoxFromDisk(name);
      }
    } catch (_) {
      // A box that cannot be cleared must not block the deletion.
    }
  }

  try {
    final preferences = await SharedPreferences.getInstance();
    final languageCode = preferences.getString(kAppLocalePreferenceKey);
    await preferences.clear();
    if (languageCode != null) {
      await preferences.setString(kAppLocalePreferenceKey, languageCode);
    }
  } catch (_) {
    // Preferences are best-effort: the cloud data is already gone.
  }

  try {
    await const FlutterSecureStorage().deleteAll();
  } catch (_) {
    // Same here: never fail the whole deletion on a storage quirk.
  }
}
