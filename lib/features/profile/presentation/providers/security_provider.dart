import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peria_app/core/services/security_service.dart';

/// Security configuration state
class SecurityState {
  final bool appLockEnabled;
  final bool pinConfigured;
  final bool journalLockEnabled;
  final bool biometricsEnabled;
  final bool isSessionValid;
  final AuthResult? lastAuthResult;

  const SecurityState({
    this.appLockEnabled = false,
    this.pinConfigured = false,
    this.journalLockEnabled = false,
    this.biometricsEnabled = false,
    this.isSessionValid = false,
    this.lastAuthResult,
  });

  SecurityState copyWith({
    bool? appLockEnabled,
    bool? pinConfigured,
    bool? journalLockEnabled,
    bool? biometricsEnabled,
    bool? isSessionValid,
    AuthResult? lastAuthResult,
  }) {
    return SecurityState(
      appLockEnabled: appLockEnabled ?? this.appLockEnabled,
      pinConfigured: pinConfigured ?? this.pinConfigured,
      journalLockEnabled: journalLockEnabled ?? this.journalLockEnabled,
      biometricsEnabled: biometricsEnabled ?? this.biometricsEnabled,
      isSessionValid: isSessionValid ?? this.isSessionValid,
      lastAuthResult: lastAuthResult ?? this.lastAuthResult,
    );
  }
}

/// Riverpod StateNotifier for security management
class SecurityNotifier extends StateNotifier<AsyncValue<SecurityState>> {
  SecurityNotifier() : super(const AsyncValue.loading()) {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      await SecurityService.initialize();
      await _loadState();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> _loadState() async {
    final appLockEnabled = await SecurityService.isAppLockEnabled();
    final pinConfigured = await SecurityService.hasPin();
    final journalLockEnabled = await SecurityService.isJournalLockEnabled();
    final biometricsEnabled = await SecurityService.isBiometricsEnabled();
    final isSessionValid = await SecurityService.isSessionValid();

    state = AsyncValue.data(SecurityState(
      appLockEnabled: appLockEnabled,
      pinConfigured: pinConfigured,
      journalLockEnabled: journalLockEnabled,
      biometricsEnabled: biometricsEnabled,
      isSessionValid: isSessionValid,
    ));
  }

  // ===========================================================================
  // PIN MANAGEMENT
  // ===========================================================================

  Future<void> createPin(String pin) async {
    state = const AsyncValue.loading();
    try {
      await SecurityService.createPin(pin);
      await _loadState();
    } catch (error) {
      await _loadState();
      rethrow;
    }
  }

  Future<void> changePin(String oldPin, String newPin) async {
    state = const AsyncValue.loading();
    try {
      await SecurityService.changePin(oldPin, newPin);
      await _loadState();
    } catch (error) {
      await _loadState();
      rethrow;
    }
  }

  Future<void> deletePin() async {
    state = const AsyncValue.loading();
    try {
      await SecurityService.deletePin();
      await _loadState();
    } catch (error) {
      await _loadState();
      rethrow;
    }
  }

  // ===========================================================================
  // AUTHENTICATION
  // ===========================================================================

  Future<AuthResult> authenticate() async {
    try {
      final result = await SecurityService.authenticate();
      await _updateAuthResult(result);
      return result;
    } catch (error) {
      final errorResult = AuthResult.biometricError(error.toString());
      await _updateAuthResult(errorResult);
      return errorResult;
    }
  }

  Future<AuthResult> authenticateWithPin(String pin) async {
    try {
      final result = await SecurityService.authenticateWithPin(pin);
      await _updateAuthResult(result);
      return result;
    } catch (error) {
      final errorResult = AuthResult.biometricError(error.toString());
      await _updateAuthResult(errorResult);
      return errorResult;
    }
  }

  Future<void> _updateAuthResult(AuthResult result) async {
    final currentState = state.valueOrNull ?? const SecurityState();
    final isSessionValid = await SecurityService.isSessionValid();

    state = AsyncValue.data(currentState.copyWith(
      isSessionValid: isSessionValid,
      lastAuthResult: result,
    ));
  }

  // ===========================================================================
  // FEATURE TOGGLES
  // ===========================================================================

  Future<void> setAppLockEnabled(bool enabled) async {
    state = const AsyncValue.loading();
    try {
      await SecurityService.setAppLockEnabled(enabled);
      await _loadState();
    } catch (error) {
      await _loadState();
      rethrow;
    }
  }

  Future<void> setJournalLockEnabled(bool enabled) async {
    state = const AsyncValue.loading();
    try {
      await SecurityService.setJournalLockEnabled(enabled);
      await _loadState();
    } catch (error) {
      await _loadState();
      rethrow;
    }
  }

  Future<void> setBiometricsEnabled(bool enabled) async {
    state = const AsyncValue.loading();
    try {
      await SecurityService.setBiometricsEnabled(enabled);
      await _loadState();
    } catch (error) {
      await _loadState();
      rethrow;
    }
  }

  // ===========================================================================
  // SESSION MANAGEMENT
  // ===========================================================================

  Future<void> endSession() async {
    await SecurityService.endSession();
    final currentState = state.valueOrNull ?? const SecurityState();
    state = AsyncValue.data(currentState.copyWith(isSessionValid: false));
  }

  Future<void> refreshSessionStatus() async {
    final isSessionValid = await SecurityService.isSessionValid();
    final currentState = state.valueOrNull ?? const SecurityState();
    state = AsyncValue.data(currentState.copyWith(isSessionValid: isSessionValid));
  }

  // ===========================================================================
  // DATA MANAGEMENT
  // ===========================================================================

  Future<void> clearAllLocalData() async {
    state = const AsyncValue.loading();
    try {
      await SecurityService.clearAllLocalData();
      await _loadState();
    } catch (error) {
      await _loadState();
      rethrow;
    }
  }
}

/// Riverpod provider for security state
final securityProvider = StateNotifierProvider<SecurityNotifier, AsyncValue<SecurityState>>(
  (ref) => SecurityNotifier(),
);
