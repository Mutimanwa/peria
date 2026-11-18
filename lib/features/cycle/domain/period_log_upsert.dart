import 'package:peria_app/features/cycle/data/models/period_log.dart';
import 'package:peria_app/features/cycle/domain/period_rules.dart';

/// Applique une écriture de période à une liste de journaux existants.
///
/// Deux intentions différentes, deux comportements :
/// - la plage chevauche un enregistrement : c'est une correction, elle le
///   remplace (sinon les deux versions s'empileraient) ;
/// - la plage est seulement accolée (un jour d'écart) : c'est la suite de la
///   même période, on la prolonge — mais uniquement si la durée reste
///   plausible.
///
/// La logique est pure, donc testable sans Hive ni provider.
class PeriodLogUpsert {
  const PeriodLogUpsert._();

  static List<PeriodLog> apply({
    required List<PeriodLog> logs,
    required PeriodLog log,
    required DateTime today,
  }) {
    final range = PeriodRules.clampRange(
      start: log.startDate,
      end: log.endDate,
      today: today,
    );

    var incoming = PeriodLog(
      id: log.id,
      startDate: range.start,
      endDate: range.end,
      isEstimated: log.isEstimated,
    );

    final remaining = logs.where((existing) => existing.id != incoming.id);
    final kept = <PeriodLog>[];

    for (final existing in remaining) {
      if (_overlaps(existing, incoming)) {
        // Correction : la nouvelle plage fait foi pour ces jours.
        continue;
      }

      if (_adjacent(existing, incoming)) {
        final merged = existing.merge(incoming);
        final mergedLength = PeriodRules.spanDays(
          merged.startDate,
          merged.endDate,
        );
        if (mergedLength <= PeriodRules.maxPeriodLengthDays) {
          incoming = PeriodLog(
            id: merged.id,
            startDate: merged.startDate,
            endDate: merged.endDate,
            isEstimated: merged.isEstimated,
          );
          continue;
        }
        // Prolonger dépasserait la durée maximale : on garde l'existant tel
        // quel plutôt que d'inventer une période d'un mois.
      }

      kept.add(existing);
    }

    kept.add(incoming);
    kept.sort((a, b) => b.startDate.compareTo(a.startDate));
    return kept;
  }

  static bool _overlaps(PeriodLog a, PeriodLog b) {
    final aStart = PeriodRules.dayOnly(a.startDate);
    final aEnd = PeriodRules.dayOnly(a.endDate);
    final bStart = PeriodRules.dayOnly(b.startDate);
    final bEnd = PeriodRules.dayOnly(b.endDate);
    return !aStart.isAfter(bEnd) && !aEnd.isBefore(bStart);
  }

  /// Un seul jour d'écart entre les deux plages.
  static bool _adjacent(PeriodLog a, PeriodLog b) {
    final aStart = PeriodRules.dayOnly(a.startDate);
    final aEnd = PeriodRules.dayOnly(a.endDate);
    final bStart = PeriodRules.dayOnly(b.startDate);
    final bEnd = PeriodRules.dayOnly(b.endDate);
    if (PeriodRules.addDays(aEnd, 1).isAtSameMomentAs(bStart)) return true;
    if (PeriodRules.addDays(bEnd, 1).isAtSameMomentAs(aStart)) return true;
    return false;
  }
}
