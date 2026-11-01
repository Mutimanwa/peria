import 'package:flutter_test/flutter_test.dart';
import 'package:peria_app/features/calendar/presentation/calendar_phase_style.dart';
import 'package:peria_app/features/cycle/domain/cycle_phase.dart';

void main() {
  test('every cycle phase has its own calendar color', () {
    final accents = CyclePhase.values
        .map((phase) => CalendarPhaseStyle.of(phase).accent)
        .toSet();
    final backgrounds = CyclePhase.values
        .map((phase) => CalendarPhaseStyle.of(phase).background)
        .toSet();

    expect(accents, hasLength(CyclePhase.values.length));
    expect(backgrounds, hasLength(CyclePhase.values.length));
    expect(CyclePhase.values, contains(CyclePhase.follicular));
    expect(CyclePhase.values, contains(CyclePhase.luteal));
    expect(CyclePhase.values, contains(CyclePhase.ovulation));
    expect(CyclePhase.values, contains(CyclePhase.menstrual));
  });
}
