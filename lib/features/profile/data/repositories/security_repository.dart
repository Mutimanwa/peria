import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecurityRepository {
  static const _appLockKey = 'security.app_lock_enabled.v1';
  static const _pinKey = 'security.pin.v1';

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<bool> loadAppLockEnabled() async {
    final raw = await _secureStorage.read(key: _appLockKey);
    return raw == 'true';
  }

  Future<void> setAppLockEnabled(bool enabled) async {
    await _secureStorage.write(key: _appLockKey, value: enabled.toString());
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
