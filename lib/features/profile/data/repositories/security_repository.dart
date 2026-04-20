import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:perla_app/core/repositories/user_repository.dart';

class SecurityRepository {
  static const _appLockKey = 'security.app_lock_enabled.v1';
  static const _pinKey = 'security.pin.v1';
  static const _journalLockKey = 'security.journal_lock_enabled.v1';

  SecurityRepository({
    FlutterSecureStorage? secureStorage,
    UserRepository? userRepository,
  })  : _secureStorage = secureStorage ?? const FlutterSecureStorage(),
        _userRepository = userRepository ?? UserRepository();

  final FlutterSecureStorage _secureStorage;
  final UserRepository _userRepository;

  DocumentReference<Map<String, dynamic>> get _securityDoc {
    return _userRepository.userCollection('settings').doc('security');
  }

  Future<Map<String, dynamic>> _loadRemote() async {
    await _userRepository.ensureUserDocument();
    final snap = await _securityDoc.get();
    return snap.data() ?? const <String, dynamic>{};
  }

  Future<void> _saveRemote(Map<String, dynamic> data) async {
    await _userRepository.ensureUserDocument();
    await _securityDoc.set(data, SetOptions(merge: true));
  }

  Future<bool> loadAppLockEnabled() async {
    final remote = await _loadRemote();
    if (remote.containsKey('appLockEnabled')) {
      return remote['appLockEnabled'] == true;
    }
    final raw = await _secureStorage.read(key: _appLockKey);
    return raw == 'true';
  }

  Future<void> setAppLockEnabled(bool enabled) async {
    await _secureStorage.write(key: _appLockKey, value: enabled.toString());
    await _saveRemote({'appLockEnabled': enabled});
  }

  Future<bool> loadJournalLockEnabled() async {
    final remote = await _loadRemote();
    if (remote.containsKey('journalLockEnabled')) {
      return remote['journalLockEnabled'] == true;
    }
    final raw = await _secureStorage.read(key: _journalLockKey);
    return raw == 'true';
  }

  Future<void> setJournalLockEnabled(bool enabled) async {
    await _secureStorage.write(key: _journalLockKey, value: enabled.toString());
    await _saveRemote({'journalLockEnabled': enabled});
  }

  Future<bool> hasPin() async {
    final raw = await _secureStorage.read(key: _pinKey);
    return raw != null && raw.isNotEmpty;
  }

  Future<void> savePin(String pin) async {
    await _secureStorage.write(key: _pinKey, value: pin);
  }

  Future<bool> verifyPin(String pin) async {
    final raw = await _secureStorage.read(key: _pinKey);
    return raw != null && raw == pin;
  }

  Future<void> deletePin() async {
    await _secureStorage.delete(key: _pinKey);
  }
}
