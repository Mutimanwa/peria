import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peria_app/core/repositories/user_repository.dart';
import 'package:peria_app/features/cycle/data/models/period_log.dart';
import 'package:peria_app/features/cycle/data/repositories/period_repository.dart';
import 'package:peria_app/features/cycle/domain/cycle_engine.dart';
import 'package:peria_app/features/cycle/domain/cycle_phase.dart';
import 'package:peria_app/features/cycle/domain/cycle_regularity.dart';
import 'package:peria_app/features/cycle/domain/cycle_statistics.dart';
import 'package:peria_app/features/cycle/domain/cycle_status.dart';
import 'package:peria_app/features/cycle/presentation/models/cycle_day_info.dart';
import 'package:peria_app/features/profile/presentation/providers/user_profile_provider.dart';

final cycleUserRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

final periodRepositoryProvider = Provider<PeriodRepository>((ref) {
  return PeriodRepository(
    userRepository: ref.read(cycleUserRepositoryProvider),
  );
});

final periodLogsProvider =
    StateNotifierProvider<PeriodLogsNotifier, AsyncValue<List<PeriodLog>>>(
        (ref) {
  final notifier = PeriodLogsNotifier(ref.read(periodRepositoryProvider));
  notifier.load();
  return notifier;
});

class PeriodLogsNotifier extends StateNotifier<AsyncValue<List<PeriodLog>>> {
  PeriodLogsNotifier(this._repository) : super(const AsyncValue.loading());

  final PeriodRepository _repository;

  Future<void> load() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_repository.load);
  }

  Future<void> add(PeriodLog log) async {
    final current = [...(state.value ?? <PeriodLog>[])];
    current.removeWhere((x) => x.id == log.id);
    var mergedLog = log;
    final remaining = <PeriodLog>[];
    for (final existing in current) {
      if (existing.overlapsOrTouches(mergedLog)) {
        mergedLog = mergedLog.merge(existing);
      } else {
        remaining.add(existing);
      }
    }
    remaining.add(mergedLog);
    remaining.sort((a, b) => b.startDate.compareTo(a.startDate));
    state = AsyncValue.data(remaining);
    await _repository.save(remaining);
  }
}

// --- CYCLE STATUS FOR SPECIFIC DATE PROVIDER ---
// This is the canonical calculation entry point for a cycle date. Current-day
// status and all calendar consumers delegate to this provider.
final cycleStatusForDateProvider =
    Provider.family<CycleStatus?, DateTime>((ref, date) {
  final periodLogs = ref.watch(periodLogsProvider).value ?? const <PeriodLog>[];
  final profile = ref.watch(userProfileProvider).value;
  final targetDate = DateTime(date.year, date.month, date.day);

  final userCycleLengthDays = profile?.averageCycleLengthDays ?? 28;
  final userPeriodLengthDays = profile?.periodLengthDays ?? 5;
  const pmsDaysSetting = 5;

  if (periodLogs.isNotEmpty) {
    return CycleEngine.computeFromLogs(
      logs: periodLogs,
      userCycleLengthDays: userCycleLengthDays,
      userPeriodLengthDays: userPeriodLengthDays,
      pmsDaysSetting: pmsDaysSetting,
      now: targetDate,
    );
  }

  // Profile values are inputs/fallbacks only when no period logs exist.
  final lastPeriodStart = profile?.lastPeriodStart;
  if (lastPeriodStart != null) {
    return CycleEngine.computeFromSingleLog(
      startDate: lastPeriodStart,
      endDate: DateTime(
        lastPeriodStart.year,
        lastPeriodStart.month,
        lastPeriodStart.day + userPeriodLengthDays - 1,
      ),
      userCycleLengthDays: userCycleLengthDays,
      userPeriodLengthDays: userPeriodLengthDays,
      pmsDaysSetting: pmsDaysSetting,
      now: targetDate,
    );
  }

  return null;
});

// --- CYCLE STATUS PROVIDER (today) ---
final cycleStatusProvider = Provider<CycleStatus?>((ref) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  return ref.watch(cycleStatusForDateProvider(today));
});

/// Unified per-date view consumed by Calendar and Edit Calendar.
/// Actual logged days take precedence over predicted period days.
final cycleDayInfoProvider = Provider.family<CycleDayInfo, DateTime>(
  (ref, date) {
    final status = ref.watch(cycleStatusForDateProvider(date));
    final logs = ref.watch(periodLogsProvider).value ?? const <PeriodLog>[];

    return CycleDayInfo.forDate(
      date: date,
      status: status,
      periodLogs: logs,
      today: DateTime.now(),
    );
  },
);

// --- CYCLE DAY PROVIDER ---
final cycleDayForDateProvider = Provider.family<int?, DateTime>((ref, date) {
  return ref.watch(cycleStatusForDateProvider(date))?.dayOfCycle;
});

// --- CONFIDENCE SCORE PROVIDER ---
final cycleConfidenceProvider = Provider<double?>((ref) {
  return ref.watch(cycleStatusProvider)?.confidenceScore;
});

// --- CYCLE REGULARITY PROVIDER ---
final cycleRegularityProvider = Provider<CycleRegularity?>((ref) {
  return ref.watch(cycleStatusProvider)?.cycleRegularity;
});

// --- OVULATION PREDICTION PROVIDER (with range) ---
final ovulationPredictionProvider = Provider<Map<String, dynamic>?>((ref) {
  final status = ref.watch(cycleStatusProvider);
  if (status == null) return null;

  return {
    'rangeStart': status.ovulationRangeStart,
    'rangeEnd': status.ovulationRangeEnd,
    'midPoint': status.ovulationDate,
    'confidence': status.confidenceScore,
    'isEstimated': status.isEstimated,
  };
});

// --- FERTILE WINDOW PROVIDER ---
final fertileWindowProvider = Provider<List<DateTime>?>((ref) {
  return ref.watch(cycleStatusProvider)?.fertileWindow;
});

// --- PMS DAYS PROVIDER ---
final pmsDaysProvider = Provider<List<DateTime>?>((ref) {
  return ref.watch(cycleStatusProvider)?.pmsDays;
});

// --- PERIOD DAYS PROVIDER (for current cycle) ---
final currentPeriodDaysProvider = Provider<List<DateTime>?>((ref) {
  return ref.watch(cycleStatusProvider)?.periodDays;
});

// --- IS IN PERIOD PROVIDER ---
final isInPeriodProvider = Provider<bool>((ref) {
  return ref.watch(cycleStatusProvider)?.isInPeriod ?? false;
});

// --- IS OVERDUE PROVIDER ---
final isOverdueProvider = Provider<bool>((ref) {
  return ref.watch(cycleStatusProvider)?.isOverdue ?? false;
});

// --- NEXT PERIOD PREDICTION PROVIDER ---
final nextPeriodPredictionProvider = Provider<DateTime?>((ref) {
  return ref.watch(cycleStatusProvider)?.nextPeriodStart;
});

// --- DAYS UNTIL NEXT PERIOD PROVIDER ---
final daysUntilNextPeriodProvider = Provider<int?>((ref) {
  return ref.watch(cycleStatusProvider)?.daysUntilNextPeriod;
});

// --- CYCLE PHASE FOR DATE PROVIDER ---
final cyclePhaseForDateProvider = Provider.family<CyclePhase?, DateTime>(
  (ref, date) {
    return ref.watch(cycleStatusForDateProvider(date))?.phase;
  },
);

// --- IS DATE IN FERTILE WINDOW PROVIDER ---
final isDateInFertileWindowProvider = Provider.family<bool, DateTime>(
  (ref, date) {
    final fertileWindow =
        ref.watch(cycleStatusForDateProvider(date))?.fertileWindow ?? [];
    final normalizedDate = DateTime(date.year, date.month, date.day);
    return fertileWindow.any((d) =>
        d.year == normalizedDate.year &&
        d.month == normalizedDate.month &&
        d.day == normalizedDate.day);
  },
);

// --- CYCLE STATISTICS PROVIDER ---
final cycleStatisticsProvider = Provider<CycleStatistics?>((ref) {
  final logs = ref.watch(periodLogsProvider).value ?? const <PeriodLog>[];
  return CycleEngine.computeStatistics(logs: logs);
});

// --- CYCLE PREDICTION FOR FUTURE DATE PROVIDER ---
final cyclePredictionForDateProvider =
    Provider.family<CyclePrediction?, DateTime>(
  (ref, date) {
    final status = ref.watch(cycleStatusForDateProvider(date));
    if (status == null) return null;

    return CyclePrediction(
      predictedPhase: status.phase,
      confidenceScore: status.confidenceScore,
      isEstimated: status.isEstimated,
      predictedPeriodStart: status.dayOfCycle > status.cycleLengthDays - 7
          ? status.nextPeriodStart
          : null,
    );
  },
);

class CyclePrediction {
  final CyclePhase predictedPhase;
  final double confidenceScore;
  final bool isEstimated;
  final DateTime? predictedPeriodStart;

  CyclePrediction({
    required this.predictedPhase,
    required this.confidenceScore,
    required this.isEstimated,
    this.predictedPeriodStart,
  });
}
