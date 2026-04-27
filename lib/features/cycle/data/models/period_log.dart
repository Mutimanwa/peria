import 'package:hive/hive.dart';

part 'period_log.g.dart';

@HiveType(typeId: 2)
class PeriodLog {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final DateTime startDate;
  @HiveField(2)
  final DateTime endDate;
  @HiveField(3)
  final bool isEstimated;

  const PeriodLog({
    required this.id,
    required this.startDate,
    required this.endDate,
    this.isEstimated = false,
  });

  factory PeriodLog.fromJson(Map<String, dynamic> json) {
    return PeriodLog(
      id: json['id'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      isEstimated: json['isEstimated'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'isEstimated': isEstimated,
    };
  }

  bool contains(DateTime date) {
    final normalized = _normalizeDay(date);
    return !_normalizeDay(startDate).isAfter(normalized) &&
        !_normalizeDay(endDate).isBefore(normalized);
  }

  bool overlapsOrTouches(PeriodLog other) {
    final normalizedStart = _normalizeDay(startDate);
    final normalizedEnd = _normalizeDay(endDate);
    final otherStart = _normalizeDay(other.startDate);
    final otherEnd = _normalizeDay(other.endDate);

    final extendedStart = otherStart.subtract(const Duration(days: 1));
    final extendedEnd = otherEnd.add(const Duration(days: 1));
    return !normalizedStart.isAfter(extendedEnd) && !normalizedEnd.isBefore(extendedStart);
  }

  PeriodLog merge(PeriodLog other) {
    final normalizedStart = _normalizeDay(startDate);
    final normalizedEnd = _normalizeDay(endDate);
    final otherStart = _normalizeDay(other.startDate);
    final otherEnd = _normalizeDay(other.endDate);
    final mergedStart = normalizedStart.isBefore(otherStart) ? normalizedStart : otherStart;
    final mergedEnd = normalizedEnd.isAfter(otherEnd) ? normalizedEnd : otherEnd;
    return PeriodLog(
      id: id == other.id ? id : '$mergedStart-${mergedEnd.toIso8601String()}',
      startDate: mergedStart,
      endDate: mergedEnd,
      isEstimated: isEstimated && other.isEstimated,
    );
  }
  
  static DateTime _normalizeDay(DateTime value) =>
      DateTime(value.year, value.month, value.day);
}
