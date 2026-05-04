import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peria_app/core/services/security_service.dart';
import 'package:peria_app/features/profile/presentation/providers/security_provider.dart';
import 'package:peria_app/l10n/app_localizations.dart';
import 'package:peria_app/core/theme/app_colors.dart';
import 'package:peria_app/shared/widgets/pin_code_input.dart';

/// Lock screen widget that handles authentication
class LockScreen extends ConsumerStatefulWidget {
  const LockScreen({super.key});

  @override
  ConsumerState<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<LockScreen> {
  AuthResult? _authResult;
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    _startAuthentication();
  }

  Future<void> _startAuthentication() async {
    setState(() => _isAuthenticating = true);

    final securityNotifier = ref.read(securityProvider.notifier);
    final result = await securityNotifier.authenticate();

    setState(() {
      _authResult = result;
      _isAuthenticating = false;
    });

    if (result.isSuccess) {
      _onAuthenticated();
    }
  }

  Future<void> _authenticateWithPin(String pin) async {
    setState(() => _isAuthenticating = true);

    final securityNotifier = ref.read(securityProvider.notifier);
    final result = await securityNotifier.authenticateWithPin(pin);

    setState(() {
      _authResult = result;
      _isAuthenticating = false;
    });

    if (result.isSuccess) {
      _onAuthenticated();
    }
  }

  void _onAuthenticated() {
    // Navigate back or to the protected content
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              // Security icon
              Image.asset(
                'assets/images/icons/security.png',
                width: 96,
                height: 96,
              ),
              const SizedBox(height: 24),

              // Title
              Text(
                l10n.accountSecurity,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Status message
              if (_authResult != null) ...[
                _buildStatusMessage(l10n),
                const SizedBox(height: 32),
              ],

              // PIN input if needed
              if (_authResult?.requiresPin == true ||
                  _authResult?.status == AuthStatus.pinIncorrect) ...[
                const SizedBox(height: 32),
                PinCodeInput(
                  length: 4,
                  autoFocus: true,
                  obscureText: true,
                  showVisibilityToggle: true,
                  error: _authResult?.status == AuthStatus.pinIncorrect
                      ? l10n
                          .pinsDoNotMatch // Or specific "Incorrect PIN" key if available
                      : null,
                  onCompleted: _authenticateWithPin,
                ),
              ],

              // Loading indicator
              if (_isAuthenticating) ...[
                const SizedBox(height: 32),
                const CircularProgressIndicator(),
              ],

              const Spacer(),

              // Emergency exit (for development/testing)
              if (_authResult?.isLocked == false) ...[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Skip (Development Only)'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusMessage(AppLocalizations l10n) {
    final result = _authResult!;
    if (result.status == AuthStatus.pinIncorrect) {
      return const SizedBox.shrink();
    }

    String message;
    Color color;

    switch (result.status) {
      case AuthStatus.success:
        message = 'Authentification réussie';
        color = Colors.green;
        break;
      case AuthStatus.pinRequired:
        message = 'PIN requis';
        color = AppColors.grey500;
        break;
      case AuthStatus.locked:
        final minutes = result.lockTimeRemaining!.inMinutes;
        final seconds = result.lockTimeRemaining!.inSeconds % 60;
        message = 'Verrouillé pendant ${minutes}m ${seconds}s';
        color = AppColors.error;
        break;
      default:
        message = result.message ?? 'Erreur d\'authentification';
        color = AppColors.error;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        message,
        style:
            TextStyle(color: color, fontWeight: FontWeight.w500, fontSize: 13),
        textAlign: TextAlign.center,
      ),
    );
  }
}

/// Route guard that shows lock screen if authentication is required
class AuthGuard extends ConsumerWidget {
  final Widget child;

  const AuthGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final securityState = ref.watch(securityProvider);

    return securityState.when(
      data: (security) {
        // If app lock is disabled or session is valid, show content
        if (!security.appLockEnabled || security.isSessionValid) {
          return child;
        }

        // Show lock screen
        return const LockScreen();
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Security Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(securityProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
