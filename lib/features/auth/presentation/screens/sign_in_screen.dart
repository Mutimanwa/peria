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
  const SignInScreen({super.key, this.initialEmail});

  /// Renseigné quand l'adresse vient de l'ecran precedent : la personne n'a
  /// pas a la retaper apres avoir choisi « j'ai deja un compte ».
  final String? initialEmail;

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
  void initState() {
    super.initState();
    final email = widget.initialEmail?.trim();
    if (email != null && email.isNotEmpty) {
      _emailController.text = email;
    }
  }

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
        // `/home` n'a jamais existe dans le routeur : GoRouter affichait sa
        // page d'erreur apres une connexion reussie. `/cycle` est l'accueil
        // authentifie.
        context.go('/cycle');
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

    return OnboardingScaffold(
      showBack: true,
      // Le corps se reduit avec le clavier, sinon le champ garde sa position
      // sous le clavier et la zone defilable ne defile pas.
      resizeToAvoidBottomInset: true,
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.fromLTRB(24, 70, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.signInTitle, style: AppText.h1),
            const SizedBox(height: 10),
            Text(
              l10n.signInSubtitle,
              style: AppText.body.copyWith(color: AppColors.textSecondary),
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
              autocorrect: false,
              enableSuggestions: false,
              controller: _passwordController,
              suffix: IconButton(
                tooltip: _obscure ? l10n.showPassword : l10n.hidePassword,
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
                  style: AppText.caption.copyWith(color: AppColors.textSecondary),
                ),
              ),
            ),

            if (_error != null) ...[
              const SizedBox(height: 4),
              Text(
                _error!,
                style: AppText.caption.copyWith(color: AppColors.textError),
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
                onPressed: () => context.push('/register'),
                child: Text(
                  l10n.dontHaveAccount,
                  style: AppText.caption.copyWith(color: AppColors.textSecondary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
