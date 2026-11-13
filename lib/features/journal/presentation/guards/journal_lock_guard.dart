import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:peria_app/features/journal/presentation/widgets/journal_skeleton.dart';
import 'package:peria_app/features/profile/presentation/providers/security_provider.dart';
import 'package:peria_app/l10n/app_localizations.dart';
import 'package:peria_app/core/theme/theme.dart';
import 'package:peria_app/shared/widgets/common_widgets.dart';
import 'package:peria_app/shared/widgets/pin_code_input.dart';

class JournalLockGuard extends ConsumerWidget {
  final Widget child;

  const JournalLockGuard({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final securityAsync = ref.watch(securityProvider);

    return securityAsync.when(
      data: (security) {
        final locked =
            security.journalLockEnabled && !security.isSessionValid;
        if (!locked) return child;
        return _LockOverlay(child: child);
      },
      loading: () => const Center(child: JournalSkeleton()),
      error: (_, __) => child,
    );
  }
}

class _LockOverlay extends ConsumerStatefulWidget {
  final Widget child;

  const _LockOverlay({required this.child});

  @override
  ConsumerState<_LockOverlay> createState() => _LockOverlayState();
}

class _LockOverlayState extends ConsumerState<_LockOverlay> {
  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _isBiometric = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    final canCheck = await _localAuth.canCheckBiometrics;
    if (mounted) {
      setState(() => _isBiometric = canCheck);
    }
  }

  Future<void> _authenticate() async {
    final result = await ref.read(securityProvider.notifier).authenticate();
    if (!mounted || result.isSuccess || result.requiresPin) return;
    setState(
      () => _error = AppLocalizations.of(context).securityBiometricFailed,
    );
  }

  Future<void> _verifyPin(String pin) async {
    if (pin.length != 4) return;

    final result =
        await ref.read(securityProvider.notifier).authenticateWithPin(pin);
    if (!mounted || result.isSuccess) return;
    setState(() => _error = AppLocalizations.of(context).securityIncorrectPin);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Stack(
      children: [
        widget.child,
        Scaffold(
          backgroundColor: Colors.black54,
          body: SafeArea(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    onPressed: () =>
                        safeRouterBack(context, fallbackRoute: '/cycle'),
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
                ),
                Center(
            child: Container(
              padding: const EdgeInsets.all(32),
              margin: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(24),
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
                    child: const Icon(Icons.lock_outline_rounded,
                        size: 32, color: AppColors.primary500),
                  ),
                  const SizedBox(height: 20),
                  Text(l10n.journalLockedTitle, style: AppText.h5),
                  const SizedBox(height: 8),
                  Text(
                    l10n.journalLockedDescription,
                    textAlign: TextAlign.center,
                    style: AppText.body.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 24),
                  if (_isBiometric)
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
                          Text(l10n.journalUseBiometrics,
                              style:
                                  AppText.label.copyWith(color: Colors.white)),
                        ],
                      ),
                    )
                  else
                    const SizedBox(height: 16),
                  if (!_isBiometric || true) ...[
                    PinCodeInput(
                      length: 4,
                      onCompleted: _verifyPin,
                      error: _error,
                      autoFocus: true,
                    ),
                    const SizedBox(height: 16),
                    const SizedBox(height: 16),
                  ],
                ],
              ),
            ),
          ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
