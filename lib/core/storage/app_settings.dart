class AppSettings {
  final bool allowNotifications;
  final bool notifyPeriodStarting;
  final bool notifyFertileWindow;
  final bool notifyOvulationDay;
  final bool remindLogSymptoms;
  final bool notifyPartnerUpdates;
  final bool twoFactorEnabled;
  final bool faceIdEnabled;
  final bool discreetModeEnabled;

  const AppSettings({
    this.allowNotifications = false,
    this.notifyPeriodStarting = false,
    this.notifyFertileWindow = true,
    this.notifyOvulationDay = false,
    this.remindLogSymptoms = false,
    this.notifyPartnerUpdates = true,
    this.twoFactorEnabled = false,
    this.faceIdEnabled = true,
    this.discreetModeEnabled = false,
  });

  AppSettings copyWith({
    bool? allowNotifications,
    bool? notifyPeriodStarting,
    bool? notifyFertileWindow,
    bool? notifyOvulationDay,
    bool? remindLogSymptoms,
    bool? notifyPartnerUpdates,
    bool? twoFactorEnabled,
    bool? faceIdEnabled,
    bool? discreetModeEnabled,
  }) {
    return AppSettings(
      allowNotifications: allowNotifications ?? this.allowNotifications,
      notifyPeriodStarting: notifyPeriodStarting ?? this.notifyPeriodStarting,
      notifyFertileWindow: notifyFertileWindow ?? this.notifyFertileWindow,
      notifyOvulationDay: notifyOvulationDay ?? this.notifyOvulationDay,
      remindLogSymptoms: remindLogSymptoms ?? this.remindLogSymptoms,
      notifyPartnerUpdates: notifyPartnerUpdates ?? this.notifyPartnerUpdates,
      twoFactorEnabled: twoFactorEnabled ?? this.twoFactorEnabled,
      faceIdEnabled: faceIdEnabled ?? this.faceIdEnabled,
      discreetModeEnabled: discreetModeEnabled ?? this.discreetModeEnabled,
    );
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      allowNotifications: json['allowNotifications'] as bool? ?? false,
      notifyPeriodStarting: json['notifyPeriodStarting'] as bool? ?? false,
      notifyFertileWindow: json['notifyFertileWindow'] as bool? ?? true,
      notifyOvulationDay: json['notifyOvulationDay'] as bool? ?? false,
      remindLogSymptoms: json['remindLogSymptoms'] as bool? ?? false,
      notifyPartnerUpdates: json['notifyPartnerUpdates'] as bool? ?? true,
      twoFactorEnabled: json['twoFactorEnabled'] as bool? ?? false,
      faceIdEnabled: json['faceIdEnabled'] as bool? ?? true,
      discreetModeEnabled: json['discreetModeEnabled'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'allowNotifications': allowNotifications,
      'notifyPeriodStarting': notifyPeriodStarting,
      'notifyFertileWindow': notifyFertileWindow,
      'notifyOvulationDay': notifyOvulationDay,
      'remindLogSymptoms': remindLogSymptoms,
      'notifyPartnerUpdates': notifyPartnerUpdates,
      'twoFactorEnabled': twoFactorEnabled,
      'faceIdEnabled': faceIdEnabled,
      'discreetModeEnabled': discreetModeEnabled,
    };
  }
}
