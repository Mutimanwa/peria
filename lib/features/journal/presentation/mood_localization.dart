import 'package:peria_app/features/journal/data/models/mood.dart';
import 'package:peria_app/l10n/app_localizations.dart';

extension JournalMoodLocalization on Mood {
  String localizedLabel(AppLocalizations l10n) {
    switch (id) {
      case 'happy':
        return l10n.moodHappy;
      case 'excited':
        return l10n.moodExcited;
      case 'anxious':
        return l10n.moodAnxious;
      case 'sad':
        return l10n.moodSad;
      case 'tired':
        return l10n.moodTired;
      case 'calm':
      default:
        return l10n.moodCalm;
    }
  }
}
