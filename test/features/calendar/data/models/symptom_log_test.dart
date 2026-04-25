import 'package:flutter_test/flutter_test.dart';
import 'package:perla_app/features/calendar/data/models/symptom_log.dart';

void main() {
  group('SymptomLog', () {
    test('exposes hasContent when selections are present', () {
      final log = SymptomLog(
        id: '1',
        date: DateTime(2026, 4, 25),
        selections: const {
          'Mood': ['Anxious'],
        },
        updatedAt: DateTime(2026, 4, 25, 10),
      );

      expect(log.hasSelections, isTrue);
      expect(log.hasContent, isTrue);
      expect(log.tags, contains(SymptomTag.mood));
    });

    test('keeps backward compatibility for empty legacy records', () {
      final log = SymptomLog.fromJson({
        'id': '2',
        'date': '2026-04-25T00:00:00.000',
        'selections': <String, dynamic>{},
        'updatedAt': '2026-04-25T12:00:00.000',
      });

      expect(log.freeNotes, '');
      expect(log.intensity, isNull);
      expect(log.hasContent, isFalse);
      expect(log.tags, isEmpty);
    });
  });
}
