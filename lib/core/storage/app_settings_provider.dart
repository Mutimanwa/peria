import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_settings.dart';
import 'app_settings_repository.dart';

final appSettingsRepositoryProvider = Provider<AppSettingsRepository>((ref) {
  return AppSettingsRepository();
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
