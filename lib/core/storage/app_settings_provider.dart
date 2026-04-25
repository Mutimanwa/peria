import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peria_app/core/repositories/user_repository.dart';
import 'app_settings.dart';
import 'app_settings_repository.dart';

final settingsUserRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

final appSettingsRepositoryProvider = Provider<AppSettingsRepository>((ref) {
  return AppSettingsRepository(
    userRepository: ref.read(settingsUserRepositoryProvider),
  );
});

final appSettingsProvider =
    StateNotifierProvider<AppSettingsNotifier, AsyncValue<AppSettings>>((ref) {
  final notifier = AppSettingsNotifier(ref.read(appSettingsRepositoryProvider));
  notifier.load();
  return notifier;
});

class AppSettingsNotifier extends StateNotifier<AsyncValue<AppSettings>> {
  AppSettingsNotifier(this._repository) : super(const AsyncValue.loading());

  final AppSettingsRepository _repository;

  Future<void> load() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_repository.load);
  }

  Future<void> update(AppSettings next) async {
    state = AsyncValue.data(next);
    await _repository.save(next);
  }

  Future<void> patch(AppSettings Function(AppSettings current) builder) async {
    final current = state.value ?? const AppSettings();
    final next = builder(current);
    await update(next);
  }
}
