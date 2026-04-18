import 'package:hive/hive.dart';
import 'package:perla_app/core/storage/hive_boxes.dart';
import 'package:perla_app/features/journal/data/models/journal_entry.dart';

class JournalRepository {
  Future<List<JournalEntry>> loadEntries() async {
    final box = Hive.box<JournalEntry>(HiveBoxes.journalEntries);
    return box.values.toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  Future<void> saveEntries(List<JournalEntry> entries) async {
    final box = Hive.box<JournalEntry>(HiveBoxes.journalEntries);
    await box.clear();
    await box.addAll(entries);
  }

  Future<void> addEntry(JournalEntry entry) async {
    final box = Hive.box<JournalEntry>(HiveBoxes.journalEntries);
    await box.add(entry);
  }

  Future<void> updateEntry(String id, JournalEntry updated) async {
    final box = Hive.box<JournalEntry>(HiveBoxes.journalEntries);
    final index = box.values.toList().indexWhere((e) => e.id == id);
    if (index != -1) {
      await box.putAt(index, updated);
    }
  }

  Future<void> deleteEntry(String id) async {
    final box = Hive.box<JournalEntry>(HiveBoxes.journalEntries);
    final index = box.values.toList().indexWhere((e) => e.id == id);
    if (index != -1) {
      await box.deleteAt(index);
    }
  }
}

