import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:peria_app/core/repositories/user_repository.dart';
import 'app_settings.dart';

class AppSettingsRepository {
  AppSettingsRepository({
    UserRepository? userRepository,
  }) : _userRepository = userRepository ?? UserRepository();

  final UserRepository _userRepository;

  void _log(String message) {
    if (kDebugMode) {
      debugPrint('[AppSettingsRepository] $message');
    }
  }

  DocumentReference<Map<String, dynamic>> get _settingsDoc {
    return _userRepository.userCollection('settings').doc('app');
  }

  Future<AppSettings> load() async {
    await _userRepository.ensureUserDocument();
    _log('loading settings from users/${_userRepository.currentUid}/settings/app');
    final snap = await _settingsDoc.get();
    final data = snap.data();
    _log('settings load completed exists=${data != null}');
    if (data == null) return const AppSettings();
    return AppSettings.fromJson(data);
  }

  Future<void> save(AppSettings settings) async {
    await _userRepository.ensureUserDocument();
    _log('saving app settings');
    await _settingsDoc.set(settings.toJson(), SetOptions(merge: true));
    _log('app settings saved');
  }
}
