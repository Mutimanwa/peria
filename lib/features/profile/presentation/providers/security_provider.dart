import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peria_app/core/services/security_service.dart';

/// Security configuration state
class SecurityState {
  final bool appLockEnabled;
  final bool pinConfigured;
  final bool journalLockEnabled;
  final bool biometricsEnabled;
  final bool isSessionValid;
  final bool multitaskProtectionEnabled;

  /// Le journal a été déverrouillé pour cette session.
  ///
  /// Il ne réutilise pas [isSessionValid] : la session globale de cinq minutes
  /// laissait le journal ouvert sans jamais demander le code, si bien que
  /// activer « Verrouillage du journal » ne changeait rien de visible.
  final bool isJournalUnlocked;

  final AuthResult? lastAuthResult;

  const SecurityState({
    this.appLockEnabled = false,
    this.pinConfigured = false,
    this.journalLockEnabled = false,
    this.biometricsEnabled = false,
    this.isSessionValid = false,
    this.multitaskProtectionEnabled = true,
    this.isJournalUnlocked = false,
    this.lastAuthResult,
  });

  SecurityState copyWith({
    bool? appLockEnabled,
    bool? pinConfigured,
    bool? journalLockEnabled,
    bool? biometricsEnabled,
    bool? isSessionValid,
    bool? multitaskProtectionEnabled,
    bool? isJournalUnlocked,
    AuthResult? lastAuthResult,
  }) {
    return SecurityState(
      appLockEnabled: appLockEnabled ?? this.appLockEnabled,
      pinConfigured: pinConfigured ?? this.pinConfigured,
      journalLockEnabled: journalLockEnabled ?? this.journalLockEnabled,
      biometricsEnabled: biometricsEnabled ?? this.biometricsEnabled,
      isSessionValid: isSessionValid ?? this.isSessionValid,
      multitaskProtectionEnabled:
          multitaskProtectionEnabled ?? this.multitaskProtectionEnabled,
      isJournalUnlocked: isJournalUnlocked ?? this.isJournalUnlocked,
      lastAuthResult: lastAuthResult ?? this.lastAuthResult,
    );
  }
}

/// Riverpod StateNotifier for security management
class SecurityNotifier extends StateNotifier<AsyncValue<SecurityState>> {
  SecurityNotifier({SecurityState? seed})
      : super(seed == null
            ? const AsyncValue.loading()
            : AsyncValue.data(seed)) {
    // A seeded state already comes from a completed load (tests, restore).
    if (seed == null) {
      _initialize();
    }
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
    final multitaskProtectionEnabled =
        await SecurityService.isMultitaskProtectionEnabled();

    state = AsyncValue.data(SecurityState(
      appLockEnabled: appLockEnabled,
      pinConfigured: pinConfigured,
      journalLockEnabled: journalLockEnabled,
      biometricsEnabled: biometricsEnabled,
      isSessionValid: isSessionValid,
      multitaskProtectionEnabled: multitaskProtectionEnabled,
      // Toute relecture des réglages referme le journal : un changement de
      // code ou de verrou doit se voir immédiatement.
      isJournalUnlocked: false,
    ));
  }

  // ===========================================================================
  // PIN MANAGEMENT
  // ===========================================================================

  Future<void> createPin(String pin) async {
    try {
      await SecurityService.createPin(pin);
      await _loadState();
    } catch (error) {
      await _loadState();
      rethrow;
    }
  }

  Future<void> changePin(String oldPin, String newPin) async {
    try {
      await SecurityService.changePin(oldPin, newPin);
      await _loadState();
    } catch (error) {
      await _loadState();
      rethrow;
    }
  }

  Future<void> deletePin() async {
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
    try {
      await SecurityService.setAppLockEnabled(enabled);
      if (enabled) {
        // Activer le verrouillage doit se voir tout de suite : on ferme la
        // session au lieu d'offrir cinq minutes de sursis pendant lesquelles
        // l'ecran de verrouillage ne s'affichait jamais.
        await SecurityService.endSession();
      }
      await _loadState();
    } catch (error) {
      await _loadState();
      rethrow;
    }
  }

  Future<void> setJournalLockEnabled(bool enabled) async {
    try {
      await SecurityService.setJournalLockEnabled(enabled);
      if (enabled) {
        // Le journal se referme immediatement : le code sera demande a la
        // premiere ouverture, ce qui rend le reglage visible.
        await SecurityService.endSession();
      }
      await _loadState();
    } catch (error) {
      await _loadState();
      rethrow;
    }
  }

  Future<void> setBiometricsEnabled(bool enabled) async {
    try {
      await SecurityService.setBiometricsEnabled(enabled);
      await _loadState();
    } catch (error) {
      await _loadState();
      rethrow;
    }
  }

  Future<void> setMultitaskProtectionEnabled(bool enabled) async {
    try {
      await SecurityService.setMultitaskProtectionEnabled(enabled);
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
    state = AsyncValue.data(currentState.copyWith(
      isSessionValid: false,
      isJournalUnlocked: false,
    ));
  }

  Future<void> refreshSessionStatus() async {
    final isSessionValid = await SecurityService.isSessionValid();
    final currentState = state.valueOrNull ?? const SecurityState();
    state =
        AsyncValue.data(currentState.copyWith(isSessionValid: isSessionValid));
  }

  // ===========================================================================
  // JOURNAL SESSION
  // ===========================================================================

  /// Ouvre le journal après un code correct ou une authentification
  /// biométrique réussie.
  Future<void> unlockJournal() async {
    final currentState = state.valueOrNull ?? const SecurityState();
    state = AsyncValue.data(currentState.copyWith(isJournalUnlocked: true));
  }

  /// Referme le journal (retour au premier plan, changement de réglage).
  Future<void> lockJournal() async {
    final currentState = state.valueOrNull ?? const SecurityState();
    state = AsyncValue.data(currentState.copyWith(isJournalUnlocked: false));
  }

  // ===========================================================================
  // DATA MANAGEMENT
  // ===========================================================================

  Future<void> clearAllLocalData() async {
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
final securityProvider =
    StateNotifierProvider<SecurityNotifier, AsyncValue<SecurityState>>(
  (ref) => SecurityNotifier(),
);
