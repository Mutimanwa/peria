import 'package:hive_flutter/hive_flutter.dart';
import 'package:peria_app/core/storage/hive_boxes.dart';
import 'package:peria_app/core/storage/secure_storage_service.dart';
import 'package:peria_app/features/cycle/data/models/period_log.dart';
import 'package:peria_app/features/journal/data/models/journal_entry.dart';
import 'package:peria_app/features/profile/data/models/user_profile.dart';

class HiveSetup {
  HiveSetup._();

  static Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(JournalEntryAdapter());
    Hive.registerAdapter(PeriodLogAdapter());
    Hive.registerAdapter(UserProfileAdapter());

    final encryptionKey = await SecureStorageService.getEncryptionKey();

    await Hive.openBox<JournalEntry>(
      HiveBoxes.journalEntries,
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
}
