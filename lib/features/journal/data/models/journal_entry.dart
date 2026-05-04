import 'package:hive/hive.dart';

part 'journal_entry.g.dart';

@HiveType(typeId: 1)
class JournalEntry {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final DateTime createdAt;
  @HiveField(2)
  final DateTime updatedAt;
  @HiveField(3)
  final String title;
  @HiveField(4)
  final String content;
  @HiveField(5)
  final String mood;
  @HiveField(6)
  final List<String> tags;
  @HiveField(7)
  final int intensity;
  @HiveField(8)
  final bool isFavorite;
  @HiveField(9)
  final bool isPrivate;
  @HiveField(10)
  final String? location;
  @HiveField(11)
  final List<String> attachments;
  @HiveField(12)
  final int energyLevel;
  @HiveField(13)
  final int stressLevel;

  const JournalEntry({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.title,
    required this.content,
    required this.mood,
    this.tags = const [],
    this.intensity = 3,
    this.isFavorite = false,
    this.isPrivate = false,
    this.location,
    this.attachments = const [],
    this.energyLevel = 3,
    this.stressLevel = 3,
  });

  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      mood: json['mood'] as String? ?? 'calm',
      tags: (json['tags'] as List? ?? []).cast<String>(),
      intensity: json['intensity'] as int? ?? 3,
      isFavorite: json['isFavorite'] as bool? ?? false,
      isPrivate: json['isPrivate'] as bool? ?? false,
      location: json['location'] as String?,
      attachments: (json['attachments'] as List? ?? []).cast<String>(),
      energyLevel: json['energyLevel'] as int? ?? 3,
      stressLevel: json['stressLevel'] as int? ?? 3,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'title': title,
      'content': content,
      'mood': mood,
      'tags': tags,
      'intensity': intensity,
      'isFavorite': isFavorite,
      'isPrivate': isPrivate,
      'location': location,
      'attachments': attachments,
      'energyLevel': energyLevel,
      'stressLevel': stressLevel,
    };
  }

  JournalEntry copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? title,
    String? content,
    String? mood,
  }) {
    return JournalEntry(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      title: title ?? this.title,
      content: content ?? this.content,
      mood: mood ?? this.mood,
      tags: tags ?? this.tags,
      intensity: intensity ?? this.intensity,
      isFavorite: isFavorite ?? this.isFavorite,
      isPrivate: isPrivate ?? this.isPrivate,
      location: location ?? this.location,
      attachments: attachments ?? this.attachments,
      energyLevel: energyLevel ?? this.energyLevel,
      stressLevel: stressLevel ?? this.stressLevel,
    );
  }
}
