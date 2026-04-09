class PeriodLog {
  final String id;
  final DateTime startDate;
  final DateTime endDate;
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
