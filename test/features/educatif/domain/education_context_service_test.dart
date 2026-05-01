import 'package:flutter_test/flutter_test.dart';
import 'package:peria_app/features/calendar/data/models/symptom_log.dart';
import 'package:peria_app/features/cycle/domain/cycle_phase.dart';
<<<<<<< ours
=======
import 'package:peria_app/features/cycle/domain/cycle_regularity.dart';
>>>>>>> theirs
import 'package:peria_app/features/cycle/domain/cycle_status.dart';
import 'package:peria_app/features/educatif/domain/education_context_service.dart';
import 'package:peria_app/features/journal/data/models/journal_entry.dart';

void main() {
  group('EducationContextService', () {
    test('builds contextual tags from cycle, symptoms and journal mood', () {
      final tags = EducationContextService.buildTags(
        cycleStatus: CycleStatus(
          startDate: DateTime(2026, 4, 1),
          endDate: DateTime(2026, 4, 5, 23, 59, 59, 999),
          cycleLengthDays: 28,
          periodLengthDays: 5,
          now: DateTime(2026, 4, 23),
          isInPeriod: false,
          dayOfCycle: 23,
          phase: CyclePhase.luteal,
          nextPeriodStart: DateTime(2026, 4, 29),
          ovulationDate: DateTime(2026, 4, 15),
<<<<<<< ours
          fertileWindowStart: DateTime(2026, 4, 10),
          fertileWindowEnd: DateTime(2026, 4, 16),
          pmsDays: const [],
          daysUntilNextPeriod: 6, 
          fertileWindow: [], 
          periodDays: [],
          isOverdue: false,
=======
          ovulationRangeStart: DateTime(2026, 4, 13),
          ovulationRangeEnd: DateTime(2026, 4, 17),
          fertileWindowStart: DateTime(2026, 4, 10),
          fertileWindowEnd: DateTime(2026, 4, 16),
          fertileWindow: const [],
          periodDays: const [],
          pmsDays: const [],
          isOverdue: false,
          daysUntilNextPeriod: 6,
          confidenceScore: 0.8,
          isEstimated: false,
          cycleRegularity: CycleRegularity.regular,
>>>>>>> theirs
        ),
        symptomLogs: [
          SymptomLog(
            id: '1',
            date: DateTime(2026, 4, 23),
            selections: const {
              'Mood': ['Anxious'],
            },
            updatedAt: DateTime(2026, 4, 23, 10),
          ),
        ],
        journalEntries: [
          JournalEntry(
            id: 'j1',
            createdAt: DateTime(2026, 4, 23, 11),
            updatedAt: DateTime(2026, 4, 23, 11),
            title: 'Entry',
            content: 'Feeling off today',
            mood: 'anxious',
          ),
        ],
      );

      expect(tags, contains('SPM'));
      expect(tags, contains('humeur'));
      expect(tags, contains('stress'));
      expect(tags, contains('fatigue'));
    });
  });
}
