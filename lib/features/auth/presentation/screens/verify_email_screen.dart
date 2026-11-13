import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:peria_app/core/theme/theme.dart';
import 'package:peria_app/features/auth/domain/email_mask.dart';
import 'package:peria_app/features/auth/presentation/auth_error_text.dart';
import 'package:peria_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:peria_app/l10n/app_localizations.dart';
import 'package:peria_app/shared/widgets/common_widgets.dart';

/// Arguments carried by the `/verify-email` route.
class VerifyEmailArgs {
  final String? email;

  /// True when the account was just created: the remaining onboarding
  /// (name, date of birth) still has to run.
  final bool isNewAccount;

  const VerifyEmailArgs({this.email, this.isNewAccount = false});
}

/// Real e-mail verification.
///
/// The previous screen asked for a 4-digit code that nothing ever checked
/// (any input "succeeded"). Firebase verifies an address with a signed link
/// sent to the inbox, so this screen waits for that link to be clicked and
/// reports whether the account is really verified.
class VerifyEmailScreen extends ConsumerStatefulWidget {
  final VerifyEmailArgs args;

  const VerifyEmailScreen({super.key, this.args = const VerifyEmailArgs()});

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  static const int _resendCooldown = 45;

  int _seconds = _resendCooldown;
  Timer? _timer;
  bool _sending = false;
  bool _checking = false;
  String? _error;
  String? _notice;

  @override
  void initState() {
    super.initState();
    _startTimer(notify: false);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer({bool notify = true}) {
    _timer?.cancel();
    _seconds = _resendCooldown;
    if (notify) setState(() {});
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_seconds <= 1) {
        timer.cancel();
        setState(() => _seconds = 0);
      } else {
        setState(() => _seconds--);
      }
    });
  }

  Future<void> _resend() async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _sending = true;
      _error = null;
      _notice = null;
    });
    try {
      await ref.read(authRepositoryProvider).sendEmailVerification();
      if (!mounted) return;
      setState(() {
        _sending = false;
        _notice = l10n.verifyEmailResent;
      });
      _startTimer();
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _sending = false;
        _error = authErrorText(l10n, authErrorCodeFrom(error));
      });
    }
  }

  Future<void> _checkVerified() async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _checking = true;
      _error = null;
    });
    try {
      final verified = await ref.read(authRepositoryProvider).reloadEmailVerified();
      if (!mounted) return;
      if (!verified) {
        setState(() {
          _checking = false;
          _error = l10n.verifyEmailNotVerified;
        });
        return;
      }
      setState(() => _checking = false);
      await _showSuccessDialog();
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _checking = false;
        _error = authErrorText(l10n, authErrorCodeFrom(error));
      });
    }
  }

  Future<void> _showSuccessDialog() async {
    final l10n = AppLocalizations.of(context);
    final destination = widget.args.isNewAccount ? '/ask-name' : '/home';
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          l10n.verifyEmailSuccessTitle,
          style: AppText.h5.copyWith(fontWeight: FontWeight.w700),
        ),
        content: Text(
          l10n.verifyEmailSuccessMessage,
          style: AppText.body.copyWith(color: AppColors.textSecondary, height: 1.45),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.go(destination);
            },
            child: Text(
              l10n.continueCta,
              style: AppText.label.copyWith(
                color: AppColors.grey900,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final email =
        widget.args.email ?? FirebaseAuth.instance.currentUser?.email;
    final masked = maskEmail(email ?? '');
    final subtitle = masked.isEmpty
        ? l10n.verifyEmailNotVerified
        : l10n.verifyEmailSubtitle(masked);

    return OnboardingScaffold(
      showBack: true,
      child: Padding(
        padding: const EdgeInsets.only(top: 70),
        child: Column(
          children: [
            SizedBox(
              width: 150,
              height: 150,
              child: Image.asset('assets/images/icons/security.png'),
            ),
            const SizedBox(height: 32),
            Text(
              l10n.verifyEmailTitle,
              style: AppText.h1,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                subtitle,
                style: AppText.body.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),

            if (_error != null) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  _error!,
                  style: AppText.caption.copyWith(color: AppColors.textError),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 12),
            ],
            if (_notice != null) ...[
              Text(
                _notice!,
                style: AppText.caption.copyWith(color: AppColors.textSuccess),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
            ],

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${l10n.didntGetCode} ', style: AppText.body),
                GestureDetector(
                  onTap: _seconds == 0 && !_sending ? _resend : null,
                  child: Text(
                    _seconds > 0
                        ? l10n.resendIn(_seconds)
                        : l10n.resendNow,
                    style: AppText.body.copyWith(
                      color: _seconds == 0
                          ? AppColors.primary
                          : AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const Spacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
              child: PrimaryButton(
                label: l10n.verifyEmailCta,
                onPressed: _checking ? null : _checkVerified,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
