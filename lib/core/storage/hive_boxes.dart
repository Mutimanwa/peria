class HiveBoxes {
  HiveBoxes._();

  static const String journalEntries = 'hive.journal_entries.v1';
  static const String legacyJournalEntries = 'journal_entries';
  static const String journalTombstones = 'hive.journal_tombstones.v1';
  static const String periodLogs = 'hive.period_logs.v1';
  static const String userProfile = 'hive.user_profile.v1';

  /// Reminders that were due on this device, so the inbox survives a restart.
  static const String appNotifications = 'hive.app_notifications.v1';
}
