import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peria_app/features/profile/presentation/providers/security_provider.dart';
import 'package:peria_app/shared/widgets/lock_screen.dart';

/// Mounts [AuthGuard] around the whole app and ends the unlocked session as
/// soon as the app goes to the background, so the PIN / Face ID screen comes
/// back when the user returns.
///
/// Only users who explicitly turned the app lock on are affected: when
/// `appLockEnabled` is false, [AuthGuard] simply renders its child.
class AppLockGate extends ConsumerStatefulWidget {
  const AppLockGate({
    super.key,
    required this.child,
    this.minimumBackgroundTime = const Duration(seconds: 1),
  });

  final Widget child;

  /// Very short stays in the background (system permission sheets, the
  /// biometric prompt itself, screen rotation) must not end the session,
  /// otherwise the PIN screen would chain into an endless unlock loop.
  final Duration minimumBackgroundTime;

  @override
  ConsumerState<AppLockGate> createState() => _AppLockGateState();
}

class _AppLockGateState extends ConsumerState<AppLockGate>
    with WidgetsBindingObserver {
  DateTime? _backgroundedAt;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden) {
      _backgroundedAt ??= DateTime.now();
      return;
    }

    if (state != AppLifecycleState.resumed) {
      return;
    }

    final backgroundedAt = _backgroundedAt;
    _backgroundedAt = null;
    if (backgroundedAt == null) {
      return;
    }
    if (DateTime.now().difference(backgroundedAt) <
        widget.minimumBackgroundTime) {
      return;
    }

    _lockSession();
  }

  Future<void> _lockSession() async {
    final security = ref.read(securityProvider).valueOrNull;
    if (security == null || !security.appLockEnabled) {
      return;
    }
    await ref.read(securityProvider.notifier).endSession();
  }

  @override
  Widget build(BuildContext context) {
    return AuthGuard(child: widget.child);
  }
}
