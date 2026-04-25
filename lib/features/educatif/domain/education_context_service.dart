import 'package:peria_app/features/calendar/data/models/symptom_log.dart';
import 'package:peria_app/features/cycle/domain/cycle_phase.dart';
import 'package:peria_app/features/cycle/domain/cycle_status.dart';
import 'package:peria_app/features/journal/data/models/journal_entry.dart';

class EducationContextService {
  const EducationContextService._();

  static List<String> buildTags({
    required CycleStatus? cycleStatus,
    required List<SymptomLog> symptomLogs,
    required List<JournalEntry> journalEntries,
  }) {
    final tags = <String>{};

    if (cycleStatus != null) {
      tags.add('cycle');
      switch (cycleStatus.phase) {
        case CyclePhase.menstrual:
          tags.addAll(['menstruation', 'douleur']);
          break;
        case CyclePhase.follicular:
          tags.addAll(['cycle', 'phases']);
          break;
        case CyclePhase.ovulation:
          tags.addAll(['ovulation', 'fertilité', 'fenêtre-fertile']);
          break;
        case CyclePhase.luteal:
          tags.addAll(['SPM', 'fatigue', 'humeur']);
          break;
      }
    }

    for (final log in symptomLogs) {
      for (final tag in log.tags) {
        switch (tag) {
          case SymptomTag.pain:
            tags.addAll(['douleur', 'crampes']);
            break;
          case SymptomTag.fatigue:
            tags.addAll(['fatigue', 'sommeil']);
            break;
          case SymptomTag.mood:
            tags.addAll(['humeur', 'SPM']);
            break;
          case SymptomTag.digestion:
            tags.addAll(['symptômes', 'normal']);
            break;
          case SymptomTag.breastTenderness:
            tags.addAll(['symptômes', 'SPM']);
            break;
          case SymptomTag.sleep:
            tags.addAll(['sommeil', 'bien-être']);
            break;
        }
      }
    }

    for (final entry in journalEntries.take(10)) {
      switch (entry.mood) {
        case 'anxious':
          tags.addAll(['humeur', 'stress']);
          break;
        case 'sad':
          tags.addAll(['humeur', 'SPM']);
          break;
        case 'tired':
          tags.addAll(['fatigue', 'sommeil']);
          break;
        default:
          break;
      }
    }

    return tags.toList()..sort();
  }
}
