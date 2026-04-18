import 'package:hive/hive.dart';
import 'package:perla_app/core/storage/hive_boxes.dart';
import 'package:perla_app/features/cycle/data/models/period_log.dart';

class PeriodRepository {
  Future<List<PeriodLog>> load() async {
    final box = Hive.box<PeriodLog>(HiveBoxes.periodLogs);
    return box.values.toList()
      ..sort((a, b) => b.startDate.compareTo(a.startDate));
  }

  Future<void> save(List<PeriodLog> logs) async {
    final box = Hive.box<PeriodLog>(HiveBoxes.periodLogs);
    await box.clear();
    await box.addAll(logs);
  }

  Future<void> addLog(PeriodLog log) async {
    final box = Hive.box<PeriodLog>(HiveBoxes.periodLogs);
    await box.add(log);
  }

  Future<void> updateLog(String id, PeriodLog updated) async {
    final box = Hive.box<PeriodLog>(HiveBoxes.periodLogs);
    final index = box.values.toList().indexWhere((e) => e.id == id);
    if (index != -1) {
      await box.putAt(index, updated);
    }
  }

  Future<void> deleteLog(String id) async {
    final box = Hive.box<PeriodLog>(HiveBoxes.periodLogs);
    final index = box.values.toList().indexWhere((e) => e.id == id);
    if (index != -1) {
      await box.deleteAt(index);
    }
  }
}
