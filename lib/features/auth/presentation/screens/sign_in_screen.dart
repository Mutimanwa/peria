import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:peria_app/core/theme/theme.dart';
import 'package:peria_app/features/auth/domain/auth_validators.dart';
import 'package:peria_app/features/auth/presentation/auth_error_text.dart';
import 'package:peria_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:peria_app/features/auth/presentation/screens/verify_email_screen.dart';
import 'package:peria_app/features/auth/presentation/widgets/forgot_password_sheet.dart';
import 'package:peria_app/l10n/app_localizations.dart';
import 'package:peria_app/shared/widgets/common_widgets.dart';

/// Sign-in for a returning user.
///
/// Without it an account could be created but never opened again.
class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscure = true;
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (!AuthValidators.isEmailValid(email)) {
      setState(() => _error = l10n.authErrorInvalidEmail);
      return;
    }
    if (password.isEmpty) {
      setState(() => _error = l10n.authErrorWrongPassword);
      return;
    }

    setState(() {
      _submitting = true;
      _error = null;
    });

    try {
      await ref
          .read(authRepositoryProvider)
          .signInWithEmail(email: email, password: password);
      if (!mounted) return;
      final verified = FirebaseAuth.instance.currentUser?.emailVerified ?? false;
      if (verified) {
        context.go('/home');
      } else {
        context.go(
          '/verify-email',
          extra: VerifyEmailArgs(email: email, isNewAccount: false),
        );
      }
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _submitting = false;
        _error = authErrorText(l10n, authErrorCodeFrom(error));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return OnboardingScaffold(
      showBack: true,
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(24, 70, 24, 40 + bottomInset),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.signInTitle, style: AppText.h1),
            const SizedBox(height: 10),
            Text(
              l10n.signInSubtitle,
              style: AppText.body.copyWith(color: AppColors.grey600),
            ),
            const SizedBox(height: 40),

            Text(l10n.emailAddressLabel, style: AppText.label),
            const SizedBox(height: 8),
            PillTextField(
              hint: l10n.yourEmailAddressHint,
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),

            Text(l10n.passwordLabel, style: AppText.label),
            const SizedBox(height: 8),
            PillTextField(
              hint: l10n.enterYourPasswordHint,
              obscure: _obscure,
              controller: _passwordController,
              suffix: IconButton(
                icon: Icon(
                  _obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.grey500,
                ),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => showForgotPasswordSheet(
                  context,
                  initialEmail: _emailController.text.trim(),
                ),
                child: Text(
                  l10n.forgotYourPassword,
                  style: AppText.caption.copyWith(color: AppColors.grey500),
                ),
              ),
            ),

            if (_error != null) ...[
              const SizedBox(height: 4),
              Text(
                _error!,
                style: AppText.caption.copyWith(color: AppColors.error),
              ),
            ],

            const SizedBox(height: 24),
            PrimaryButton(
              label: l10n.signInCta,
              onPressed: _submitting ? null : _submit,
            ),
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () => context.go('/register'),
                child: Text(
                  l10n.dontHaveAccount,
                  style: AppText.caption.copyWith(color: AppColors.grey500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
