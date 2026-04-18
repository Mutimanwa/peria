import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:perla_app/features/profile/data/repositories/security_repository.dart';

class SecurityConfig {
  final bool appLockEnabled;
  final bool pinConfigured;

  const SecurityConfig({
    this.appLockEnabled = false,
    this.pinConfigured = false,
  });

  SecurityConfig copyWith({
    bool? appLockEnabled,
    bool? pinConfigured,
  }) {
    return SecurityConfig(
      appLockEnabled: appLockEnabled ?? this.appLockEnabled,
      pinConfigured: pinConfigured ?? this.pinConfigured,
    );
  }
}

final securityRepositoryProvider = Provider<SecurityRepository>((ref) {
  return SecurityRepository();
});

final securityProvider = StateNotifierProvider<SecurityNotifier, AsyncValue<SecurityConfig>>(
  (ref) {
    final repo = ref.read(securityRepositoryProvider);
    final notifier = SecurityNotifier(repo);
    notifier.load();
    return notifier;
  },
);

class SecurityNotifier extends StateNotifier<AsyncValue<SecurityConfig>> {
  SecurityNotifier(this._repository) : super(const AsyncValue.loading());

  final SecurityRepository _repository;

  Future<void> load() async {
    state = const AsyncValue.loading();
    final config = await AsyncValue.guard(() async {
      final appLockEnabled = await _repository.loadAppLockEnabled();
      final pinConfigured = await _repository.hasPin();
      return SecurityConfig(
        appLockEnabled: appLockEnabled,
        pinConfigured: pinConfigured,
      );
    });
    state = config;
  }

  Future<void> setAppLockEnabled(bool enabled) async {
    final current = state.valueOrNull ?? const SecurityConfig();
    state = AsyncValue.data(current.copyWith(appLockEnabled: enabled));
    await _repository.setAppLockEnabled(enabled);
  }

  Future<void> savePin(String pin) async {
    await _repository.savePin(pin);
    final current = state.valueOrNull ?? const SecurityConfig();
    state = AsyncValue.data(current.copyWith(pinConfigured: true));
  }

  Future<void> clearPin() async {
    await _repository.deletePin();
    final current = state.valueOrNull ?? const SecurityConfig();
    state = AsyncValue.data(current.copyWith(pinConfigured: false, appLockEnabled: false));
    await _repository.setAppLockEnabled(false);
  }
}
