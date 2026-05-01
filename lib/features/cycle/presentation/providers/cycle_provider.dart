import 'dart:math' as math;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peria_app/core/repositories/user_repository.dart';
import 'package:peria_app/core/storage/app_settings.dart';
import 'package:peria_app/core/storage/app_settings_provider.dart';
import 'package:peria_app/features/cycle/data/models/period_log.dart';
import 'package:peria_app/features/cycle/data/repositories/period_repository.dart';
import 'package:peria_app/features/cycle/domain/cycle_engine.dart';
import 'package:peria_app/features/cycle/domain/cycle_phase.dart';
import 'package:peria_app/features/cycle/domain/cycle_regularity.dart';
import 'package:peria_app/features/cycle/domain/cycle_status.dart';
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

// --- CYCLE STATUS PROVIDER (current date) ---
final cycleStatusProvider = Provider<CycleStatus?>((ref) {
  final settings = ref.watch(appSettingsProvider).value ?? const AppSettings();
  final periodLogs = ref.watch(periodLogsProvider).value ?? const <PeriodLog>[];
  final profile = ref.watch(userProfileProvider).value;
  
  final userCycleLengthDays = profile?.averageCycleLengthDays ?? settings.cycleLengthDays;
  final userPeriodLengthDays = profile?.periodLengthDays ?? settings.periodLengthDays;
  final pmsDaysSetting = settings.pmsLengthDays;

  if (periodLogs.isNotEmpty) {
    return CycleEngine.computeFromLogs(
      logs: periodLogs,
      userCycleLengthDays: userCycleLengthDays,
      userPeriodLengthDays: userPeriodLengthDays,
      pmsDaysSetting: pmsDaysSetting,
    );
  }

  // No logs fallback - use only user-defined values
  if (profile?.lastPeriodStart != null) {
    return CycleEngine.computeFromSingleLog(
      startDate: profile!.lastPeriodStart!,
      endDate: profile.lastPeriodStart!.add(Duration(days: userPeriodLengthDays - 1)),
      userCycleLengthDays: userCycleLengthDays,
      userPeriodLengthDays: userPeriodLengthDays,
      pmsDaysSetting: pmsDaysSetting,
    );
  }

  return null;
});

// --- CYCLE STATUS FOR SPECIFIC DATE PROVIDER ---
final cycleStatusForDateProvider =
    Provider.family<CycleStatus?, DateTime>((ref, date) {
  final settings = ref.watch(appSettingsProvider).value ?? const AppSettings();
  final periodLogs = ref.watch(periodLogsProvider).value ?? const <PeriodLog>[];
  final profile = ref.watch(userProfileProvider).value;
  
  final userCycleLengthDays = profile?.averageCycleLengthDays ?? settings.cycleLengthDays;
  final userPeriodLengthDays = profile?.periodLengthDays ?? settings.periodLengthDays;
  final pmsDaysSetting = settings.pmsLengthDays;

  if (periodLogs.isNotEmpty) {
    return CycleEngine.computeFromLogs(
      logs: periodLogs,
      userCycleLengthDays: userCycleLengthDays,
      userPeriodLengthDays: userPeriodLengthDays,
      pmsDaysSetting: pmsDaysSetting,
      now: date,
    );
  }

  // No logs fallback
  if (profile?.lastPeriodStart != null) {
    return CycleEngine.computeFromSingleLog(
      startDate: profile!.lastPeriodStart!,
      endDate: profile.lastPeriodStart!.add(Duration(days: userPeriodLengthDays - 1)),
      userCycleLengthDays: userCycleLengthDays,
      userPeriodLengthDays: userPeriodLengthDays,
      pmsDaysSetting: pmsDaysSetting,
      now: date,
    );
  }

  return null;
});

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
    final fertileWindow = ref.watch(cycleStatusForDateProvider(date))?.fertileWindow ?? [];
    final normalizedDate = DateTime(date.year, date.month, date.day);
    return fertileWindow.any((d) => 
        d.year == normalizedDate.year && 
        d.month == normalizedDate.month && 
        d.day == normalizedDate.day);
  },
);

// --- CYCLE STATISTICS PROVIDER ---
final cycleStatisticsProvider = Provider<CycleStatistics?>((ref) {
  final logs = ref.watch(periodLogsProvider).value ?? [];
  if (logs.length < 2) return null;
  
  final cycleLengths = <int>[];
  for (int i = 0; i < logs.length - 1; i++) {
    final length = logs[i].startDate.difference(logs[i + 1].startDate).inDays;
    cycleLengths.add(length);
  }
  
  if (cycleLengths.isEmpty) return null;
  
  final average = cycleLengths.reduce((a, b) => a + b) / cycleLengths.length;
  final variance = cycleLengths.map((l) => math.pow(l - average, 2)).reduce((a, b) => a + b) / cycleLengths.length;
  final stdDeviation = math.sqrt(variance);
  
  return CycleStatistics(
    averageCycleLength: average.round(),
    minCycleLength: cycleLengths.reduce((a, b) => a < b ? a : b),
    maxCycleLength: cycleLengths.reduce((a, b) => a > b ? a : b),
    stdDeviation: stdDeviation,
    totalCyclesLogged: logs.length,
    isRegular: stdDeviation <= 5,
  );
});

// --- CYCLE PREDICTION FOR FUTURE DATE PROVIDER ---
final cyclePredictionForDateProvider = Provider.family<CyclePrediction?, DateTime>(
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


// Additional data classes
class CycleStatistics {
  final int averageCycleLength;
  final int minCycleLength;
  final int maxCycleLength;
  final double stdDeviation;
  final int totalCyclesLogged;
  final bool isRegular;
  
  CycleStatistics({
    required this.averageCycleLength,
    required this.minCycleLength,
    required this.maxCycleLength,
    required this.stdDeviation,
    required this.totalCyclesLogged,
    required this.isRegular,
  });
}

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