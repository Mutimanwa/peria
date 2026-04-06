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
  final int periodLengthDays;
  final int cycleLengthDays;

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
    this.periodLengthDays = 7,
    this.cycleLengthDays = 28,
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
    int? periodLengthDays,
    int? cycleLengthDays,
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
      periodLengthDays: periodLengthDays ?? this.periodLengthDays,
      cycleLengthDays: cycleLengthDays ?? this.cycleLengthDays,
    );
  }
}
