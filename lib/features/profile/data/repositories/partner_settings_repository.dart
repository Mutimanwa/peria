import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:perla_app/core/repositories/user_repository.dart';
import 'package:perla_app/features/profile/data/models/partner_settings.dart';

class PartnerSettingsRepository {
  PartnerSettingsRepository({
    UserRepository? userRepository,
  }) : _userRepository = userRepository ?? UserRepository();

  final UserRepository _userRepository;

  DocumentReference<Map<String, dynamic>> get _partnerDoc {
    return _userRepository.userCollection('partner').doc('settings');
  }

  Future<PartnerSettings> load() async {
    await _userRepository.ensureUserDocument();
    final snap = await _partnerDoc.get();
    final data = snap.data();
    if (data == null) return const PartnerSettings();
    return PartnerSettings.fromJson(data);
  }

  Future<void> save(PartnerSettings settings) async {
    await _userRepository.ensureUserDocument();
    await _partnerDoc.set(settings.toJson(), SetOptions(merge: true));
  }

  Future<void> invitePartner(String email) async {
    final current = await load();
    await save(
      current.copyWith(
        status: 'pending',
        partnerEmail: email.trim(),
      ),
    );
  }

  Future<void> cancelInvitation() async {
    await save(const PartnerSettings());
  }

  Future<void> connectPartner(String email) async {
    final current = await load();
    await save(
      current.copyWith(
        status: 'connected',
        partnerEmail: email.trim(),
      ),
    );
  }

  Future<void> disconnectPartner() async {
    await save(const PartnerSettings());
  }
}
