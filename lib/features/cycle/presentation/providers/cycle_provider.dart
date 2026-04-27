import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peria_app/core/repositories/user_repository.dart';
import 'package:peria_app/core/storage/app_settings.dart';
import 'package:peria_app/core/storage/app_settings_provider.dart';
import 'package:peria_app/features/cycle/data/models/period_log.dart';
import 'package:peria_app/features/cycle/data/repositories/period_repository.dart';
import 'package:peria_app/features/cycle/domain/cycle_engine.dart';
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

final cycleStatusProvider = Provider<CycleStatus?>((ref) {
  final settings = ref.watch(appSettingsProvider).value ?? const AppSettings();
  final periodLogs = ref.watch(periodLogsProvider).value ?? const <PeriodLog>[];
  final profile = ref.watch(userProfileProvider).value;
  final lastStart = profile?.lastPeriodStart;
  final cycleLengthDays =
      profile?.averageCycleLengthDays ?? settings.cycleLengthDays;
  final periodLengthDays =
      profile?.periodLengthDays ?? settings.periodLengthDays;

  if (periodLogs.isNotEmpty) {
    return CycleEngine.computeFromLogs(
      logs: periodLogs,
      cycleLengthDays: cycleLengthDays,
      periodLengthDays: periodLengthDays,
    );
  }

  return CycleEngine.compute(
    startDate: lastStart,
    cycleLengthDays: cycleLengthDays,
    periodLengthDays: periodLengthDays,
  );
});

final cycleStatusForDateProvider =
    Provider.family<CycleStatus?, DateTime>((ref, date) {
  final settings = ref.watch(appSettingsProvider).value ?? const AppSettings();
  final periodLogs = ref.watch(periodLogsProvider).value ?? const <PeriodLog>[];
  final profile = ref.watch(userProfileProvider).value;
  final lastStart = profile?.lastPeriodStart;
  final cycleLengthDays =
      profile?.averageCycleLengthDays ?? settings.cycleLengthDays;
  final periodLengthDays =
      profile?.periodLengthDays ?? settings.periodLengthDays;

  if (periodLogs.isNotEmpty) {
    return CycleEngine.computeFromLogs(
      logs: periodLogs,
      cycleLengthDays: cycleLengthDays,
      periodLengthDays: periodLengthDays,
      now: date,
    );
  }

  return CycleEngine.compute(
    startDate: lastStart,
    cycleLengthDays: cycleLengthDays,
    periodLengthDays: periodLengthDays,
    now: date,
  );
});

final cycleDayForDateProvider = Provider.family<int?, DateTime>((ref, date) {
  return ref.watch(cycleStatusForDateProvider(date))?.dayOfCycle;
});
