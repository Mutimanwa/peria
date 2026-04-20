import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:perla_app/core/repositories/user_repository.dart';
import 'package:perla_app/core/storage/app_settings.dart';
import 'package:perla_app/core/storage/app_settings_provider.dart';
import 'package:perla_app/features/cycle/data/models/period_log.dart';
import 'package:perla_app/features/cycle/data/repositories/period_repository.dart';
import 'package:perla_app/features/cycle/domain/cycle_engine.dart';
import 'package:perla_app/features/cycle/domain/cycle_status.dart';
import 'package:perla_app/features/profile/presentation/providers/user_profile_provider.dart';

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
    current.add(log);
    current.sort((a, b) => b.startDate.compareTo(a.startDate));
    state = AsyncValue.data(current);
    await _repository.save(current);
  }
}

final cycleStatusProvider = Provider<CycleStatus?>((ref) {
  final settings = ref.watch(appSettingsProvider).value ?? const AppSettings();
  final profile = ref.watch(userProfileProvider).value;
  final lastStart = profile?.lastPeriodStart;
  return CycleEngine.compute(
    startDate: lastStart,
    cycleLengthDays: settings.cycleLengthDays,
    periodLengthDays: settings.periodLengthDays,
  );
});
