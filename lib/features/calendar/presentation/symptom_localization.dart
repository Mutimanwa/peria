import 'package:flutter/material.dart';
import 'package:peria_app/features/calendar/presentation/constants/symptom_constants.dart';
import 'package:peria_app/l10n/app_localizations.dart';

/// Localised label for a category key or an option label coming from
/// [symptomCategories] (the stored values stay in English for compatibility).
String symptomLabel(AppLocalizations l10n, String key) {
  switch (key) {
    case 'Pregnancy test':
      return l10n.pregnancyTest;
    case 'Faint line':
      return l10n.testFaintLine;
    case 'Positive':
      return l10n.testPositive;
    case 'Negative':
      return l10n.testNegative;
    case 'No tests':
      return l10n.testNone;
    case 'Sexual activity':
      return l10n.sexualActivity;
    case 'Protected Sex':
      return l10n.protectedSex;
    case 'Orgasm':
      return l10n.orgasm;
    case 'High activity':
      return l10n.highActivity;
    case 'Unprotected sex':
      return l10n.unprotectedSex;
    case 'Mental':
      return l10n.mental;
    case 'Breathing Exercises':
      return l10n.breathingExercises;
    case 'Stress':
      return l10n.stress;
    case 'Yoga':
      return l10n.yoga;
    case 'Meditation':
      return l10n.meditation;
    case 'Discharge':
      return l10n.discharge;
    case 'Unusual':
      return l10n.unusual;
    case 'Sticky':
      return l10n.sticky;
    case 'Bleeding':
      return l10n.bleeding;
    case 'Heavy Bleeding':
      return l10n.heavyBleeding;
    case 'Low Bleeding':
      return l10n.lowBleeding;
    case 'Physical activity':
      return l10n.physicalActivity;
    case 'No Exercise':
      return l10n.noExercise;
    case 'Team sports':
      return l10n.teamSports;
    case 'Cycling':
      return l10n.cycling;
    case 'Gym':
      return l10n.gym;
    case 'Dancing':
      return l10n.dancing;
    case 'Aerobics':
      return l10n.aerobics;
    case 'Swimming':
      return l10n.swimming;
    case 'Mood':
      return l10n.mood;
    case 'Anxious':
      return l10n.anxious;
    case 'Sad':
      return l10n.sad;
    case 'Happy':
      return l10n.happy;
    case 'Calm':
      return l10n.calm;
    case 'Angry':
      return l10n.angry;
    case 'Energetic':
      return l10n.energetic;
    case 'Confused':
      return l10n.confused;
    case 'Depressed':
      return l10n.depressed;
    default:
      return key;
  }
}

/// Icon declared in [symptomCategories] for the given stored option label.
IconData symptomIcon(String label) {
  for (final options in symptomCategories.values) {
    for (final option in options) {
      if (option.label == label) return option.icon;
    }
  }
  return Icons.circle_outlined;
}
