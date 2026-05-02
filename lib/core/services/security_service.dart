import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:peria_app/core/storage/secure_storage_service.dart';

/// Production-grade security service for handling authentication, PIN management,
/// brute force protection, and session management.
class SecurityService {
  SecurityService._();

  static const String _pinHashKey = 'security.pin_hash.v2';
  static const String _pinSaltKey = 'security.pin_salt.v2';
  static const String _appLockEnabledKey = 'security.app_lock_enabled.v2';
  static const String _journalLockEnabledKey =
      'security.journal_lock_enabled.v2';
  static const String _biometricsEnabledKey = 'security.biometrics_enabled.v2';
  static const String _failedAttemptsKey = 'security.failed_attempts.v2';
  static const String _lastFailedTimestampKey =
      'security.last_failed_timestamp.v2';
  static const String _lockUntilKey = 'security.lock_until.v2';
  static const String _sessionExpiresAtKey = 'security.session_expires_at.v2';

  static const int _maxFailedAttempts = 5;
  static const Duration _sessionDuration = Duration(minutes: 5);
  static const int _minPinLength = 4;
  static const int _maxPinLength = 6;

  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  static final LocalAuthentication _localAuth = LocalAuthentication();

  /// Initialize the security service
  static Future<void> initialize() async {
    // Ensure encryption key exists for Hive
    await SecureStorageService.getEncryptionKey();
  }

  // ===========================================================================
  // PIN MANAGEMENT
  // ===========================================================================

  /// Create a new PIN with secure hashing
  static Future<void> createPin(String pin) async {
    if (!_isValidPinLength(pin)) {
      throw const SecurityException(
          'PIN must be between $_minPinLength and $_maxPinLength digits');
    }

    final salt = _generateSalt();
    final hash = _hashPin(pin, salt);

    await Future.wait([
      _secureStorage.write(key: _pinHashKey, value: hash),
      _secureStorage.write(key: _pinSaltKey, value: base64Encode(salt)),
    ]);

    // Reset brute force protection on successful PIN creation
    await _resetBruteForceProtection();
  }

  /// Verify a PIN against the stored hash
  static Future<bool> verifyPin(String pin) async {
    if (!_isValidPinLength(pin)) {
      return false;
    }

    final storedHash = await _secureStorage.read(key: _pinHashKey);
    final storedSalt = await _secureStorage.read(key: _pinSaltKey);

    if (storedHash == null || storedSalt == null) {
      return false;
    }

    final salt = base64Decode(storedSalt);
    final computedHash = _hashPin(pin, salt);

    return storedHash == computedHash;
  }

  /// Change the existing PIN
  static Future<void> changePin(String oldPin, String newPin) async {
    if (!await verifyPin(oldPin)) {
      throw const SecurityException('Current PIN is incorrect');
    }

    await createPin(newPin);
  }

  /// Delete the PIN and reset all security settings
  static Future<void> deletePin() async {
    await Future.wait([
      _secureStorage.delete(key: _pinHashKey),
      _secureStorage.delete(key: _pinSaltKey),
      _secureStorage.delete(key: _appLockEnabledKey),
      _secureStorage.delete(key: _journalLockEnabledKey),
      _secureStorage.delete(key: _biometricsEnabledKey),
      _secureStorage.delete(key: _sessionExpiresAtKey),
    ]);

    await _resetBruteForceProtection();
  }

  /// Check if a PIN is configured
  static Future<bool> hasPin() async {
    final hash = await _secureStorage.read(key: _pinHashKey);
    return hash != null && hash.isNotEmpty;
  }

  // ===========================================================================
  // AUTHENTICATION FLOW
  // ===========================================================================

  /// Unified authentication method with biometric fallback to PIN
  static Future<AuthResult> authenticate() async {
    // Check brute force protection first
    if (await _isLocked()) {
      return AuthResult.locked(await _getLockTimeRemaining());
    }

    // Try biometric authentication if enabled
    if (await isBiometricsEnabled()) {
      final biometricResult = await _authenticateBiometric();
      if (biometricResult.isSuccess) {
        await _onSuccessfulAuth();
        return biometricResult;
      }
      // If biometric fails, don't increment failed attempts yet
      // Fall through to PIN
    }

    // PIN authentication required
    return AuthResult.pinRequired();
  }

  /// Verify PIN as part of authentication flow
  static Future<AuthResult> authenticateWithPin(String pin) async {
    if (await _isLocked()) {
      return AuthResult.locked(await _getLockTimeRemaining());
    }

    final isValid = await verifyPin(pin);
    if (isValid) {
      await _onSuccessfulAuth();
      return AuthResult.success();
    } else {
      await _onFailedAuth();
      final attemptsLeft = _maxFailedAttempts - await _getFailedAttempts();
      return AuthResult.pinIncorrect(attemptsLeft);
    }
  }

  // ===========================================================================
  // BRUTE FORCE PROTECTION
  // ===========================================================================

  static Future<void> _onSuccessfulAuth() async {
    await _resetBruteForceProtection();
    await _startSession();
  }

  static Future<void> _onFailedAuth() async {
    final attempts = await _getFailedAttempts() + 1;
    await _secureStorage.write(
        key: _failedAttemptsKey, value: attempts.toString());

    final now = DateTime.now();
    await _secureStorage.write(
      key: _lastFailedTimestampKey,
      value: now.millisecondsSinceEpoch.toString(),
    );

    if (attempts >= _maxFailedAttempts) {
      await _lockSystem(now);
    }
  }

  static Future<void> _resetBruteForceProtection() async {
    await Future.wait([
      _secureStorage.delete(key: _failedAttemptsKey),
      _secureStorage.delete(key: _lastFailedTimestampKey),
      _secureStorage.delete(key: _lockUntilKey),
    ]);
  }

  static Future<bool> _isLocked() async {
    final lockUntilRaw = await _secureStorage.read(key: _lockUntilKey);
    if (lockUntilRaw == null) return false;

    final lockUntil =
        DateTime.fromMillisecondsSinceEpoch(int.parse(lockUntilRaw));
    return DateTime.now().isBefore(lockUntil);
  }

  static Future<Duration> _getLockTimeRemaining() async {
    final lockUntilRaw = await _secureStorage.read(key: _lockUntilKey);
    if (lockUntilRaw == null) return Duration.zero;

    final lockUntil =
        DateTime.fromMillisecondsSinceEpoch(int.parse(lockUntilRaw));
    final now = DateTime.now();
    return lockUntil.isAfter(now) ? lockUntil.difference(now) : Duration.zero;
  }

  static Future<void> _lockSystem(DateTime failedAt) async {
    final attempts = await _getFailedAttempts();
    final lockDuration = _calculateLockDuration(attempts);
    final lockUntil = failedAt.add(lockDuration);

    await _secureStorage.write(
      key: _lockUntilKey,
      value: lockUntil.millisecondsSinceEpoch.toString(),
    );
  }

  static Duration _calculateLockDuration(int attempts) {
    // Exponential backoff: 30s, 1min, 5min, 15min, 30min
    final durations = [
      const Duration(seconds: 30),
      const Duration(minutes: 1),
      const Duration(minutes: 5),
      const Duration(minutes: 15),
      const Duration(minutes: 30),
    ];

    final index = min(attempts - _maxFailedAttempts, durations.length - 1);
    return durations[index];
  }

  static Future<int> _getFailedAttempts() async {
    final raw = await _secureStorage.read(key: _failedAttemptsKey);
    return raw != null ? int.parse(raw) : 0;
  }

  // ===========================================================================
  // SESSION MANAGEMENT
  // ===========================================================================

  static Future<void> _startSession() async {
    final expiresAt = DateTime.now().add(_sessionDuration);
    await _secureStorage.write(
      key: _sessionExpiresAtKey,
      value: expiresAt.millisecondsSinceEpoch.toString(),
    );
  }

  /// Check if the current session is still valid
  static Future<bool> isSessionValid() async {
    final expiresAtRaw = await _secureStorage.read(key: _sessionExpiresAtKey);
    if (expiresAtRaw == null) return false;

    final expiresAt =
        DateTime.fromMillisecondsSinceEpoch(int.parse(expiresAtRaw));
    return DateTime.now().isBefore(expiresAt);
  }

  /// End the current session
  static Future<void> endSession() async {
    await _secureStorage.delete(key: _sessionExpiresAtKey);
  }

  // ===========================================================================
  // FEATURE DEPENDENCY RULES
  // ===========================================================================

  /// Enable/disable app lock (root feature)
  static Future<void> setAppLockEnabled(bool enabled) async {
    if (enabled && !await hasPin()) {
      throw const SecurityException('Cannot enable app lock without a PIN');
    }

    await _secureStorage.write(
        key: _appLockEnabledKey, value: enabled.toString());

    // Enforce dependencies
    if (!enabled) {
      await Future.wait([
        setJournalLockEnabled(false),
        setBiometricsEnabled(false),
        endSession(),
      ]);
    }
  }

  /// Check if app lock is enabled
  static Future<bool> isAppLockEnabled() async {
    final raw = await _secureStorage.read(key: _appLockEnabledKey);
    return raw == 'true';
  }

  /// Enable/disable journal lock (requires app lock)
  static Future<void> setJournalLockEnabled(bool enabled) async {
    if (enabled && !await isAppLockEnabled()) {
      throw const SecurityException(
          'Journal lock requires app lock to be enabled');
    }

    await _secureStorage.write(
        key: _journalLockEnabledKey, value: enabled.toString());
  }

  /// Check if journal lock is enabled
  static Future<bool> isJournalLockEnabled() async {
    final raw = await _secureStorage.read(key: _journalLockEnabledKey);
    return raw == 'true';
  }

  /// Enable/disable biometrics (requires app lock)
  static Future<void> setBiometricsEnabled(bool enabled) async {
    if (enabled && !await isAppLockEnabled()) {
      throw const SecurityException(
          'Biometrics requires app lock to be enabled');
    }

    await _secureStorage.write(
        key: _biometricsEnabledKey, value: enabled.toString());
  }

  /// Check if biometrics is enabled
  static Future<bool> isBiometricsEnabled() async {
    final raw = await _secureStorage.read(key: _biometricsEnabledKey);
    return raw == 'true';
  }

  // ===========================================================================
  // BIOMETRIC AUTHENTICATION
  // ===========================================================================

  static Future<AuthResult> _authenticateBiometric() async {
    try {
      final canAuthenticate = await _localAuth.canCheckBiometrics ||
          await _localAuth.isDeviceSupported();
      if (!canAuthenticate) {
        return AuthResult.biometricUnavailable();
      }

      final authenticated = await _localAuth.authenticate(
        localizedReason: 'Authenticate to access your secure data',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: false,
          useErrorDialogs: true,
        ),
      );

      return authenticated
          ? AuthResult.success()
          : AuthResult.biometricFailed();
    } catch (e) {
      return AuthResult.biometricError(e.toString());
    }
  }

  // ===========================================================================
  // DATA SECURITY
  // ===========================================================================

  /// Clear all local sensitive data
  static Future<void> clearAllLocalData() async {
    // Clear all security-related data
    final securityKeys = [
      _pinHashKey,
      _pinSaltKey,
      _appLockEnabledKey,
      _journalLockEnabledKey,
      _biometricsEnabledKey,
      _failedAttemptsKey,
      _lastFailedTimestampKey,
      _lockUntilKey,
      _sessionExpiresAtKey,
    ];

    await Future.wait(
        securityKeys.map((key) => _secureStorage.delete(key: key)));

    // TODO: Clear Hive boxes (journal, logs, profile)
    // This should be implemented when integrating with the data layer

    // TODO: Clear app settings
    // This should be implemented when integrating with settings
  }

  // ===========================================================================
  // UTILITY METHODS
  // ===========================================================================

  static bool _isValidPinLength(String pin) {
    return pin.length >= _minPinLength &&
        pin.length <= _maxPinLength &&
        RegExp(r'^\d+$').hasMatch(pin);
  }

  static List<int> _generateSalt() {
    final random = Random.secure();
    return List<int>.generate(32, (_) => random.nextInt(256));
  }

  static String _hashPin(String pin, List<int> salt) {
    final key = utf8.encode(pin);
    final hmac = Hmac(sha256, salt);
    final digest = hmac.convert(key);
    return base64Encode(digest.bytes);
  }
}

/// Result of an authentication attempt
class AuthResult {
  final AuthStatus status;
  final String? message;
  final int? attemptsLeft;
  final Duration? lockTimeRemaining;

  const AuthResult._({
    required this.status,
    this.message,
    this.attemptsLeft,
    this.lockTimeRemaining,
  });

  factory AuthResult.success() =>
      const AuthResult._(status: AuthStatus.success);
  factory AuthResult.pinRequired() =>
      const AuthResult._(status: AuthStatus.pinRequired);
  factory AuthResult.pinIncorrect(int attemptsLeft) => AuthResult._(
        status: AuthStatus.pinIncorrect,
        attemptsLeft: attemptsLeft,
      );
  factory AuthResult.locked(Duration timeRemaining) => AuthResult._(
        status: AuthStatus.locked,
        lockTimeRemaining: timeRemaining,
      );
  factory AuthResult.biometricFailed() =>
      const AuthResult._(status: AuthStatus.biometricFailed);
  factory AuthResult.biometricUnavailable() =>
      const AuthResult._(status: AuthStatus.biometricUnavailable);
  factory AuthResult.biometricError(String error) => AuthResult._(
        status: AuthStatus.biometricError,
        message: error,
      );

  bool get isSuccess => status == AuthStatus.success;
  bool get requiresPin => status == AuthStatus.pinRequired;
  bool get isLocked => status == AuthStatus.locked;
}

/// Authentication status
enum AuthStatus {
  success,
  pinRequired,
  pinIncorrect,
  locked,
  biometricFailed,
  biometricUnavailable,
  biometricError,
}

/// Security-related exception
class SecurityException implements Exception {
  final String message;
  const SecurityException(this.message);

  @override
  String toString() => 'SecurityException: $message';
}
