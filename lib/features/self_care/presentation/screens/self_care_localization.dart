import 'package:peria_app/l10n/app_localizations.dart';

String localizeSelfCareData(String value, AppLocalizations l10n) {
  final minuteMatch = RegExp(r'^(\d+) min$').firstMatch(value);
  if (minuteMatch != null) {
    return l10n.selfCareMinutes(int.parse(minuteMatch.group(1)!));
  }

  final readingMatch = RegExp(r'^(\d+) min read$').firstMatch(value);
  if (readingMatch != null) {
    return l10n.selfCareMinutesRead(int.parse(readingMatch.group(1)!));
  }

  final exerciseCountMatch = RegExp(r'^(\d+) low-impact exercises$').firstMatch(value);
  if (exerciseCountMatch != null) {
    return l10n.selfCareLowImpactExercises(
      int.parse(exerciseCountMatch.group(1)!),
    );
  }

  return switch (value) {
    'Gentle movement for cramps' => l10n.selfCareCategoryCramps,
    'Strength and flexibility' => l10n.selfCareCategoryStrength,
    'Facial Care' => l10n.selfCareCategoryFacial,
    'Relaxing stretching' => l10n.selfCareCategoryStretching,
    'Articles' => l10n.selfCareCategoryArticles,
    'Get started' => l10n.selfCareBadgeGetStarted,
    'Balance' => l10n.selfCareCardBalance,
    'Focus' => l10n.selfCareCardFocus,
    'Strength' => l10n.selfCareCardStrength,
    'Flexibility' => l10n.selfCareCardFlexibility,
    'Gentle facial massage' => l10n.selfCareCardGentleFacialMassage,
    'Glow up your skin' => l10n.selfCareCardGlowSkin,
    'Neck pain relief' => l10n.selfCareCardNeckPainRelief,
    'Lower back stretch' => l10n.selfCareCardLowerBackStretch,
    'Period pain relief' => l10n.selfCareCardPeriodPainRelief,
    'Gentle yoga to ease tension' => l10n.selfCareSubtitleGentleYoga,
    'Breathing and slow release' => l10n.selfCareSubtitleBreathingRelease,
    'Mobility for everyday comfort' => l10n.selfCareSubtitleMobilityComfort,
    'Lift and sculpt softly' => l10n.selfCareSubtitleLiftSculpt,
    'Cleanse and hydrate' => l10n.selfCareSubtitleCleanseHydrate,
    'Release upper-body tension' => l10n.selfCareSubtitleReleaseUpperBody,
    'Slow restorative motion' => l10n.selfCareSubtitleSlowRestorative,
    'Yoga Pillow' => l10n.selfCareNeedYogaPillow,
    'Water Bottle' => l10n.selfCareNeedWaterBottle,
    'Yoga Mat' => l10n.selfCareNeedYogaMat,
    'Chin to Chest' => l10n.selfCareStepChinToChest,
    'Recline Reset' => l10n.selfCareStepReclineReset,
    'Supported Pigeon' => l10n.selfCareStepSupportedPigeon,
    'Butterfly Fold' => l10n.selfCareStepButterflyFold,
    'Lotus Lift' => l10n.selfCareStepLotusLift,
    'Legs Wall' => l10n.selfCareStepLegsUpWall,
    'Neck Lift' => l10n.selfCareStepNeckLift,
    'Gua Sha Massage' => l10n.selfCareStepGuaShaMassage,
    'Facial Cleaning' => l10n.selfCareStepFacialCleansing,
    'Glow Press' => l10n.selfCareStepGlowPress,
    'Hydration Lock' => l10n.selfCareStepHydrationLock,
    'Chin upward' => l10n.selfCareSubtitleChinUpward,
    'Sweep outward gently' => l10n.selfCareSubtitleSweepOutward,
    'Gently cleanse face' => l10n.selfCareSubtitleGentlyCleanse,
    'Light circular motion' => l10n.selfCareSubtitleLightCircular,
    'Seal in moisture' => l10n.selfCareSubtitleSealMoisture,
    'Calm Flow' => l10n.selfCareSleepTrackCalmFlow,
    'Brath of Life' || 'Breath of Life' => l10n.selfCareSleepTrackBreathOfLife,
    'Soul Drift' => l10n.selfCareSleepTrackSoulDrift,
    'Sounds Of Serenity' || 'Sounds of Serenity' =>
      l10n.selfCareSleepTrackSoundsSerenity,
    'Inner Peace' => l10n.selfCareSleepTrackInnerPeace,
    'Mindful Journey' => l10n.selfCareSleepTrackMindfulJourney,
    'Whispering Nature' => l10n.selfCareSleepTrackWhisperingNature,
    "Nature's Rhythm" => l10n.selfCareSleepTrackNaturesRhythm,
    'Golden Dawn' => l10n.selfCareSleepTrackGoldenDawn,
    'Harmony Within' => l10n.selfCareSleepTrackHarmonyWithin,
    'Breathe In Silence' => l10n.selfCareSleepTrackBreatheInSilence,
    'Deep Rest Session' => l10n.selfCareSleepTrackDeepRestSession,
    'Full-body cardio' => l10n.selfCareFullBodyCardio,
    _ => value,
  };
}
