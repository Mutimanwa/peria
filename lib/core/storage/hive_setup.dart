import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:peria_app/core/storage/hive_boxes.dart';
import 'package:peria_app/core/storage/secure_storage_service.dart';
import 'package:peria_app/features/cycle/data/models/period_log.dart';
import 'package:peria_app/features/journal/data/models/journal_entry.dart';
import 'package:peria_app/features/profile/data/models/user_profile.dart';

class HiveSetup {
  HiveSetup._();

  static const _legacyJournalBoxName = HiveBoxes.legacyJournalEntries;

  static Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(JournalEntryAdapter());
    Hive.registerAdapter(PeriodLogAdapter());
    Hive.registerAdapter(UserProfileAdapter());

    final encryptionKey = await SecureStorageService.getEncryptionKey();

    final journalBox = await Hive.openBox<JournalEntry>(
      HiveBoxes.journalEntries,
      encryptionCipher: HiveAesCipher(encryptionKey),
    );
    await _migrateLegacyJournalEntries(journalBox);

    // Deletion markers are encrypted too. They prevent an offline deletion
    // from being undone the next time the user opts in to cloud sync.
    await Hive.openBox<String>(
      HiveBoxes.journalTombstones,
      encryptionCipher: HiveAesCipher(encryptionKey),
    );
    await Hive.openBox<PeriodLog>(
      HiveBoxes.periodLogs,
      encryptionCipher: HiveAesCipher(encryptionKey),
    );
    await Hive.openBox<UserProfile>(
      HiveBoxes.userProfile,
      encryptionCipher: HiveAesCipher(encryptionKey),
    );
  }

  /// Migrates the old, unencrypted map cache into the encrypted typed box.
  /// The old box is removed only when every entry has been migrated safely.
  static Future<void> _migrateLegacyJournalEntries(
    Box<JournalEntry> encryptedBox,
  ) async {
    try {
      if (!await Hive.boxExists(_legacyJournalBoxName)) return;

      final legacyBox = await Hive.openBox<dynamic>(_legacyJournalBoxName);
      var migrationComplete = true;

      for (final value in legacyBox.values) {
        if (value is! Map) {
          migrationComplete = false;
          continue;
        }

        try {
          final entry = JournalEntry.fromJson(
            Map<String, dynamic>.from(value),
          );
          final existing = encryptedBox.get(entry.id);
          if (existing == null || entry.updatedAt.isAfter(existing.updatedAt)) {
            await encryptedBox.put(entry.id, entry);
          }
        } catch (error) {
          migrationComplete = false;
          debugPrint('[HiveSetup] Could not migrate a legacy journal entry: $error');
        }
      }

      await legacyBox.close();
      if (migrationComplete) {
        await Hive.deleteBoxFromDisk(_legacyJournalBoxName);
        debugPrint('[HiveSetup] Migrated legacy journal cache to encrypted Hive.');
      } else {
        debugPrint(
          '[HiveSetup] Legacy journal cache was kept because some entries could not be migrated.',
        );
      }
    } catch (error) {
      // Do not discard the legacy box on failure; preserving notes is safer
      // than forcing a destructive migration.
      debugPrint('[HiveSetup] Journal cache migration failed: $error');
    }
  }
}
