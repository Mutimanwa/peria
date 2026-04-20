class PartnerSettings {
  final String status;
  final String? partnerEmail;
  final bool shareCyclePredictions;
  final bool shareLoggedSymptoms;
  final bool sharePeriodDates;
  final bool shareMoodEntries;

  const PartnerSettings({
    this.status = 'none',
    this.partnerEmail,
    this.shareCyclePredictions = false,
    this.shareLoggedSymptoms = true,
    this.sharePeriodDates = false,
    this.shareMoodEntries = true,
  });

  bool get isPending => status == 'pending';
  bool get isConnected => status == 'connected';

  PartnerSettings copyWith({
    String? status,
    String? partnerEmail,
    bool? shareCyclePredictions,
    bool? shareLoggedSymptoms,
    bool? sharePeriodDates,
    bool? shareMoodEntries,
  }) {
    return PartnerSettings(
      status: status ?? this.status,
      partnerEmail: partnerEmail ?? this.partnerEmail,
      shareCyclePredictions:
          shareCyclePredictions ?? this.shareCyclePredictions,
      shareLoggedSymptoms: shareLoggedSymptoms ?? this.shareLoggedSymptoms,
      sharePeriodDates: sharePeriodDates ?? this.sharePeriodDates,
      shareMoodEntries: shareMoodEntries ?? this.shareMoodEntries,
    );
  }

  factory PartnerSettings.fromJson(Map<String, dynamic> json) {
    return PartnerSettings(
      status: json['status'] as String? ?? 'none',
      partnerEmail: json['partnerEmail'] as String?,
      shareCyclePredictions: json['shareCyclePredictions'] as bool? ?? false,
      shareLoggedSymptoms: json['shareLoggedSymptoms'] as bool? ?? true,
      sharePeriodDates: json['sharePeriodDates'] as bool? ?? false,
      shareMoodEntries: json['shareMoodEntries'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'partnerEmail': partnerEmail,
      'shareCyclePredictions': shareCyclePredictions,
      'shareLoggedSymptoms': shareLoggedSymptoms,
      'sharePeriodDates': sharePeriodDates,
      'shareMoodEntries': shareMoodEntries,
    };
  }
}
