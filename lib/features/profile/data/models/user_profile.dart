class UserProfile {
  final String? displayName;
  final DateTime? dateOfBirth;
  final List<String> goals;
  final DateTime? lastPeriodStart;

  const UserProfile({
    this.displayName,
    this.dateOfBirth,
    this.goals = const [],
    this.lastPeriodStart,
  });

  UserProfile copyWith({
    String? displayName,
    DateTime? dateOfBirth,
    List<String>? goals,
    DateTime? lastPeriodStart,
  }) {
    return UserProfile(
      displayName: displayName ?? this.displayName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      goals: goals ?? this.goals,
      lastPeriodStart: lastPeriodStart ?? this.lastPeriodStart,
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
      goals: (json['goals'] as List<dynamic>?)?.cast<String>() ?? const [],
      lastPeriodStart: (json['lastPeriodStart'] as String?) == null
          ? null
          : DateTime.parse(json['lastPeriodStart'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'displayName': displayName,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'goals': goals,
      'lastPeriodStart': lastPeriodStart?.toIso8601String(),
    };
  }
}
