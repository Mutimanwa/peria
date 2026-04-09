import 'dart:convert';

import 'package:perla_app/features/cycle/data/models/period_log.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PeriodRepository {
  static const _periodsKey = 'cycle.periods.v1';

  Future<List<PeriodLog>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_periodsKey) ?? <String>[];
    final items = raw
        .map((s) => PeriodLog.fromJson(jsonDecode(s) as Map<String, dynamic>))
        .toList();
    items.sort((a, b) => b.startDate.compareTo(a.startDate));
    return items;
  }

  Future<void> save(List<PeriodLog> logs) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = logs.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_periodsKey, raw);
  }
}
