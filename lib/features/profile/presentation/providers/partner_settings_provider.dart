import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:perla_app/core/repositories/user_repository.dart';
import 'package:perla_app/features/profile/data/models/partner_settings.dart';
import 'package:perla_app/features/profile/data/repositories/partner_settings_repository.dart';

final partnerUserRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

final partnerSettingsRepositoryProvider =
    Provider<PartnerSettingsRepository>((ref) {
  return PartnerSettingsRepository(
    userRepository: ref.read(partnerUserRepositoryProvider),
  );
});

final partnerSettingsProvider =
    StateNotifierProvider<PartnerSettingsNotifier, AsyncValue<PartnerSettings>>(
        (ref) {
  final notifier =
      PartnerSettingsNotifier(ref.read(partnerSettingsRepositoryProvider));
  notifier.load();
  return notifier;
});

class PartnerSettingsNotifier
    extends StateNotifier<AsyncValue<PartnerSettings>> {
  PartnerSettingsNotifier(this._repository) : super(const AsyncValue.loading());

  final PartnerSettingsRepository _repository;

  Future<void> load() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_repository.load);
  }

  Future<void> update(PartnerSettings next) async {
    state = AsyncValue.data(next);
    await _repository.save(next);
  }

  Future<void> patch(PartnerSettings Function(PartnerSettings current) builder) async {
    final current = state.value ?? const PartnerSettings();
    await update(builder(current));
  }

  Future<void> invitePartner(String email) async {
    await _repository.invitePartner(email);
    await load();
  }

  Future<void> cancelInvitation() async {
    await _repository.cancelInvitation();
    await load();
  }

  Future<void> connectPartner(String email) async {
    await _repository.connectPartner(email);
    await load();
  }

  Future<void> disconnectPartner() async {
    await _repository.disconnectPartner();
    await load();
  }
}
