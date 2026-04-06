import 'dart:convert';

import 'package:perla_app/features/journal/data/models/journal_entry.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JournalRepository {
  static const _journalEntriesKey = 'journal.entries';

  Future<List<JournalEntry>> loadEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_journalEntriesKey) ?? <String>[];
    final entries = raw
        .map((item) => JournalEntry.fromJson(jsonDecode(item) as Map<String, dynamic>))
        .toList();
    entries.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return entries;
  }

  Future<void> saveEntries(List<JournalEntry> entries) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = entries.map((item) => jsonEncode(item.toJson())).toList();
    await prefs.setStringList(_journalEntriesKey, raw);
  }
}
