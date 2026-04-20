import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:perla_app/core/repositories/user_repository.dart';
import 'package:perla_app/features/profile/data/repositories/security_repository.dart';

class SecurityConfig {
  final bool appLockEnabled;
  final bool pinConfigured;
  final bool journalLockEnabled;

  const SecurityConfig({
    this.appLockEnabled = false,
    this.pinConfigured = false,
    this.journalLockEnabled = false,
  });

  SecurityConfig copyWith({
    bool? appLockEnabled,
    bool? pinConfigured,
    bool? journalLockEnabled,
  }) {
    return SecurityConfig(
      appLockEnabled: appLockEnabled ?? this.appLockEnabled,
      pinConfigured: pinConfigured ?? this.pinConfigured,
      journalLockEnabled: journalLockEnabled ?? this.journalLockEnabled,
    );
  }
}

final securityUserRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

final securityRepositoryProvider = Provider<SecurityRepository>((ref) {
  return SecurityRepository(
    userRepository: ref.read(securityUserRepositoryProvider),
  );
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
      final journalLockEnabled = await _repository.loadJournalLockEnabled();
      return SecurityConfig(
        appLockEnabled: appLockEnabled,
        pinConfigured: pinConfigured,
        journalLockEnabled: journalLockEnabled,
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
    if (pin.length != 4) throw ArgumentError('PIN must be exactly 4 digits');
    await _repository.savePin(pin);
    final current = state.valueOrNull ?? const SecurityConfig();
    state = AsyncValue.data(current.copyWith(pinConfigured: true));
  }

  Future<void> setJournalLockEnabled(bool enabled) async {
    final current = state.valueOrNull ?? const SecurityConfig();
    state = AsyncValue.data(current.copyWith(journalLockEnabled: enabled));
    await _repository.setJournalLockEnabled(enabled);
  }

  Future<void> clearPin() async {
    await _repository.deletePin();
    final current = state.valueOrNull ?? const SecurityConfig();
    state = AsyncValue.data(current.copyWith(
      pinConfigured: false, 
      appLockEnabled: false,
      journalLockEnabled: false,
    ));
    await _repository.setAppLockEnabled(false);
    await _repository.setJournalLockEnabled(false);
  }
}
