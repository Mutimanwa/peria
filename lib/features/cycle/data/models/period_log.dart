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
}
