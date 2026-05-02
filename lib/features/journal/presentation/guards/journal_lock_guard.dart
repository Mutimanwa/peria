import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:peria_app/features/journal/presentation/widgets/journal_skeleton.dart';
import 'package:peria_app/features/profile/presentation/providers/security_provider.dart';
import 'package:peria_app/core/services/security_service.dart';
import 'package:peria_app/core/theme/theme.dart';
import 'package:peria_app/shared/widgets/pin_code_input.dart';

class JournalLockGuard extends ConsumerWidget {
  final Widget child;
  final String entryId; // For detail/edit routes

  const JournalLockGuard({
    super.key,
    required this.child,
    this.entryId = '',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final securityAsync = ref.watch(securityProvider);

    return securityAsync.when(
      data: (security) {
        if (security.journalLockEnabled) {
          return _LockOverlay(
            onVerified: () => _onUnlock(context),
            child: child,
          );
        }
        return child;
      },
      loading: () => const Center(child: JournalSkeleton()),
      error: (_, __) => child, // Fallback
    );
  }

  void _onUnlock(BuildContext context) {
    // Unlock success - navigate to journal screen
    context.go('/journal${entryId.isNotEmpty ? '/detail/$entryId' : ''}');
  }
}

class _LockOverlay extends ConsumerStatefulWidget {
  final VoidCallback onVerified;
  final Widget child;

  const _LockOverlay({required this.onVerified, required this.child});

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
    try {
      final didAuth = await _localAuth.authenticate(
        localizedReason: 'Unlock your private journal',
        options: const AuthenticationOptions(biometricOnly: false),
      );
      if (didAuth && mounted) {
        widget.onVerified();
      }
    } catch (e) {
      if (mounted) setState(() => _error = 'Biometric failed');
    }
  }

  Future<void> _verifyPin(String pin) async {
    if (pin.length != 4) return;

    final isValid = await SecurityService.verifyPin(pin);
    if (isValid && mounted) {
      widget.onVerified();
    } else {
      setState(() => _error = 'Invalid PIN');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Scaffold(
          backgroundColor: Colors.black54,
          body: Center(
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
                  const Text('Journal is locked', style: AppText.h5),
                  const SizedBox(height: 8),
                  Text(
                    'Enter PIN or use biometrics to access your private notes.',
                    textAlign: TextAlign.center,
                    style: AppText.body.copyWith(color: AppColors.grey600),
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
                          Text('Use biometrics',
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
                  if (_error != null) ...[
                    const SizedBox(height: 12),
                    Text(_error!,
                        style: const TextStyle(color: AppColors.error)),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
