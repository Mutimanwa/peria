class SymptomLog {
  const SymptomLog({
    required this.id,
    required this.date,
    required this.selections,
    required this.updatedAt,
  });

  final String id;
  final DateTime date;
  final Map<String, List<String>> selections;
  final DateTime updatedAt;

  factory SymptomLog.fromJson(Map<String, dynamic> json) {
    final rawSelections = (json['selections'] as Map<String, dynamic>? ?? {});
    return SymptomLog(
      id: json['id'] as String? ?? '',
      date: DateTime.parse(json['date'] as String),
      selections: rawSelections.map(
        (key, value) => MapEntry(
          key,
          (value as List<dynamic>? ?? const []).map((e) => e.toString()).toList(),
        ),
      ),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'selections': selections,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  SymptomLog copyWith({
    String? id,
    DateTime? date,
    Map<String, List<String>>? selections,
    DateTime? updatedAt,
  }) {
    return SymptomLog(
      id: id ?? this.id,
      date: date ?? this.date,
      selections: selections ?? this.selections,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
