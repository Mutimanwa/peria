import 'package:hive/hive.dart';

part 'user_profile.g.dart';

@HiveType(typeId: 3)
class UserProfile {
  @HiveField(0)
  final String? displayName;
  @HiveField(1)
  final DateTime? dateOfBirth;
  @HiveField(2)
  final int averageCycleLengthDays;
  @HiveField(3)
  final int periodLengthDays;
  @HiveField(4)
  final DateTime? lastPeriodStart;
  @HiveField(5)
  final bool isCycleRegular;
  @HiveField(6)
  final String? email;
  @HiveField(7)
  final List<String>? goals;

  const UserProfile({
    this.displayName,
    this.dateOfBirth,
    this.averageCycleLengthDays = 28,
    this.periodLengthDays = 5,
    this.lastPeriodStart,
    this.isCycleRegular = true,
    this.email,
    this.goals,
  });

  UserProfile copyWith({
    String? displayName,
    DateTime? dateOfBirth,
    int? averageCycleLengthDays,
    int? periodLengthDays,
    DateTime? lastPeriodStart,
    bool? isCycleRegular,
    String? email,
    List<String>? goals,
  }) {
    return UserProfile(
      displayName: displayName ?? this.displayName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      averageCycleLengthDays:
          averageCycleLengthDays ?? this.averageCycleLengthDays,
      periodLengthDays: periodLengthDays ?? this.periodLengthDays,
      lastPeriodStart: lastPeriodStart ?? this.lastPeriodStart,
      isCycleRegular: isCycleRegular ?? this.isCycleRegular,
      email: email ?? this.email,
      goals: goals ?? this.goals,
    );
  }

  int? get ageYears {
    final dob = dateOfBirth;
    if (dob == null) return null;
    final now = DateTime.now();
    var years = now.year - dob.year;
    final hasHadBirthdayThisYear = (now.month > dob.month) ||
        (now.month == dob.month && now.day >= dob.day);
    if (!hasHadBirthdayThisYear) years -= 1;
    return years;
  }

  bool get isMinor {
    final age = ageYears;
    if (age == null) return false;
    return age < 18;
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      displayName: json['displayName'] as String?,
      dateOfBirth: (json['dateOfBirth'] as String?) == null
          ? null
          : DateTime.parse(json['dateOfBirth'] as String),
      lastPeriodStart: (json['lastPeriodStart'] as String?) == null
          ? null
          : DateTime.parse(json['lastPeriodStart'] as String),
      averageCycleLengthDays: json['averageCycleLengthDays'] as int? ?? 28,
      periodLengthDays: json['periodLengthDays'] as int? ?? 5,
      isCycleRegular: json['isCycleRegular'] as bool? ?? true,
      email: json['email'] as String?,
      goals:
          (json['goals'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'displayName': displayName,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'lastPeriodStart': lastPeriodStart?.toIso8601String(),
      'averageCycleLengthDays': averageCycleLengthDays,
      'periodLengthDays': periodLengthDays,
      'isCycleRegular': isCycleRegular,
      'email': email,
      'goals': goals,
    };
  }
}
