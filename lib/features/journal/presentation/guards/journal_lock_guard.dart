import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:peria_app/core/theme/theme.dart';
import 'package:peria_app/features/journal/presentation/widgets/journal_skeleton.dart';
import 'package:peria_app/features/profile/presentation/providers/security_provider.dart';
import 'package:peria_app/l10n/app_localizations.dart';
import 'package:peria_app/shared/widgets/common_widgets.dart';
import 'package:peria_app/shared/widgets/pin_code_input.dart';

/// Protège les routes du journal quand « Verrouillage du journal » est actif.
///
/// Le contenu n'est **pas** construit tant que le code n'est pas saisi : un
/// simple voile sombre au-dessus de la liste laissait lire les notes.
class JournalLockGuard extends ConsumerWidget {
  final Widget child;

  const JournalLockGuard({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final securityAsync = ref.watch(securityProvider);
    final l10n = AppLocalizations.of(context);

    return securityAsync.when(
      data: (security) {
        // Le journal a sa propre session : sans cela, la session globale de
        // cinq minutes laissait passer la première ouverture après activation
        // du verrouillage, et le réglage semblait sans effet.
        final locked =
            security.journalLockEnabled && !security.isJournalUnlocked;
        if (!locked) return child;
        return const _JournalLockScreen();
      },
      loading: () => const ColoredBox(
        color: AppColors.white,
        child: Center(child: JournalSkeleton()),
      ),
      // État de sécurité illisible : on n'affiche pas les notes « au cas où ».
      error: (_, __) => Scaffold(
        backgroundColor: AppColors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock_outline_rounded,
                    size: 48, color: AppColors.grey400),
                const SizedBox(height: 16),
                Text(
                  l10n.unableToLoadSecuritySettings,
                  textAlign: TextAlign.center,
                  style: AppText.body.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => ref.invalidate(securityProvider),
                  child: Text(l10n.securityRetry),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _JournalLockScreen extends ConsumerStatefulWidget {
  const _JournalLockScreen();

  @override
  ConsumerState<_JournalLockScreen> createState() => _JournalLockScreenState();
}

class _JournalLockScreenState extends ConsumerState<_JournalLockScreen> {
  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _isBiometric = false;
  String? _error;

  /// Incremente a chaque code refuse : la saisie est reconstruite, sinon les
  /// cases restent remplies et le code suivant n'est plus pris en compte.
  int _attempts = 0;

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    // Un appareil sans capteur (ou un test) laisse simplement le code PIN.
    var canCheck = false;
    try {
      canCheck = await _localAuth.canCheckBiometrics ||
          await _localAuth.isDeviceSupported();
    } catch (_) {
      canCheck = false;
    }
    if (mounted) setState(() => _isBiometric = canCheck);
  }

  Future<void> _authenticate() async {
    final notifier = ref.read(securityProvider.notifier);
    final result = await notifier.authenticate();
    if (!mounted) return;
    if (result.isSuccess) {
      await notifier.unlockJournal();
      return;
    }
    if (result.requiresPin) return;
    setState(
      () => _error = AppLocalizations.of(context).securityBiometricFailed,
    );
  }

  Future<void> _verifyPin(String pin) async {
    final notifier = ref.read(securityProvider.notifier);
    final result = await notifier.authenticateWithPin(pin);
    if (!mounted) return;
    if (result.isSuccess) {
      await notifier.unlockJournal();
      return;
    }

    final l10n = AppLocalizations.of(context);
    final remaining = result.lockTimeRemaining;
    setState(() {
      _error = result.isLocked && remaining != null
          ? l10n.securityLockedFor(remaining.inMinutes, remaining.inSeconds % 60)
          : l10n.securityIncorrectPin;
      _attempts++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 4,
              left: 4,
              child: IconButton(
                onPressed: () =>
                    safeRouterBack(context, fallbackRoute: '/cycle'),
                icon: const Icon(Icons.arrow_back_rounded),
                tooltip: l10n.back,
              ),
            ),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.grey100),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.grey900.withOpacity(0.06),
                        blurRadius: 24,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: AppColors.primary50,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.lock_outline_rounded,
                          size: 32,
                          color: AppColors.primary500,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        l10n.journalLockedTitle,
                        textAlign: TextAlign.center,
                        style: AppText.h5,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.journalLockedDescription,
                        textAlign: TextAlign.center,
                        style:
                            AppText.body.copyWith(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 24),
                      if (_isBiometric) ...[
                        ElevatedButton(
                          onPressed: _authenticate,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary500,
                            foregroundColor: Colors.white,
                            shape: const StadiumBorder(),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.fingerprint, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                l10n.journalUseBiometrics,
                                style: AppText.label
                                    .copyWith(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                      PinCodeInput(
                        key: ValueKey(_attempts),
                        length: 4,
                        obscureText: true,
                        showVisibilityToggle: true,
                        onCompleted: _verifyPin,
                        error: _error,
                        autoFocus: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
