enum SymptomTag {
  pain,
  fatigue,
  mood,
  digestion,
  breastTenderness,
  sleep,
}

class SymptomLog {
  const SymptomLog({
    required this.id,
    required this.date,
    required this.selections,
    required this.updatedAt,
    this.freeNotes = '',
    this.intensity,
  });

  final String id;
  final DateTime date;
  final Map<String, List<String>> selections;
  final DateTime updatedAt;
  final String freeNotes;
  final int? intensity;

  static final Map<String, SymptomTag> _selectionTagMap = {
    'Stress': SymptomTag.mood,
    'Anxious': SymptomTag.mood,
    'Sad': SymptomTag.mood,
    'Happy': SymptomTag.mood,
    'Calm': SymptomTag.mood,
    'Angry': SymptomTag.mood,
    'Energetic': SymptomTag.mood,
    'Confused': SymptomTag.mood,
    'Depressed': SymptomTag.mood,
    'Bleeding': SymptomTag.pain,
    'Heavy Bleeding': SymptomTag.pain,
    'Low Bleeding': SymptomTag.pain,
    'Unusual': SymptomTag.digestion,
    'Sticky': SymptomTag.digestion,
    'Yoga': SymptomTag.sleep,
    'Meditation': SymptomTag.sleep,
    'Breathing Exercises': SymptomTag.sleep,
    'No Exercise': SymptomTag.fatigue,
    'Gym': SymptomTag.fatigue,
    'Swimming': SymptomTag.fatigue,
  };

  bool get hasSelections => selections.values.any((items) => items.isNotEmpty);

  bool get hasContent => hasSelections || freeNotes.trim().isNotEmpty || intensity != null;

  List<SymptomTag> get tags {
    final normalized = <SymptomTag>{};
    for (final values in selections.values) {
      for (final value in values) {
        final tag = _selectionTagMap[value];
        if (tag != null) {
          normalized.add(tag);
        }
      }
    }
    return normalized.toList()..sort((a, b) => a.index.compareTo(b.index));
  }

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
      freeNotes: json['freeNotes'] as String? ?? '',
      intensity: json['intensity'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'selections': selections,
      'updatedAt': updatedAt.toIso8601String(),
      'freeNotes': freeNotes,
      'intensity': intensity,
    };
  }

  SymptomLog copyWith({
    String? id,
    DateTime? date,
    Map<String, List<String>>? selections,
    DateTime? updatedAt,
    String? freeNotes,
    int? intensity,
  }) {
    return SymptomLog(
      id: id ?? this.id,
      date: date ?? this.date,
      selections: selections ?? this.selections,
      updatedAt: updatedAt ?? this.updatedAt,
      freeNotes: freeNotes ?? this.freeNotes,
      intensity: intensity ?? this.intensity,
    );
  }
}
