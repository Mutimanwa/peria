import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:peria_app/core/theme/theme.dart';
import 'package:peria_app/features/auth/domain/auth_validators.dart';
import 'package:peria_app/features/auth/presentation/auth_error_text.dart';
import 'package:peria_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:peria_app/features/auth/presentation/screens/verify_email_screen.dart';
import 'package:peria_app/features/auth/domain/auth_error_code.dart';
import 'package:peria_app/features/auth/presentation/controllers/continue_with_email_controller.dart';
import 'package:peria_app/features/auth/presentation/controllers/create_account_controller.dart';
import 'package:peria_app/l10n/app_localizations.dart';
import 'package:peria_app/shared/widgets/common_widgets.dart';

/// ═══════════════════════════════════════════════════════════════════
///  ÉCRAN 3 — Continue With Email
///  Maquette : Continue_With_Email_2x.png
///
///  Structure :
///   • Bouton retour (haut gauche)
///   • Illustration 3D enveloppe rose/violet  ← ÉLÉMENT 3D À REMPLIR
///   • Titre "Enter your email"
///   • Sous-titre
///   • Label "Email Address" + champ pill
///   • Bouton "Continue" (désactivé si vide)
/// ═══════════════════════════════════════════════════════════════════
class ContinueWithEmailScreen extends ConsumerStatefulWidget {
  const ContinueWithEmailScreen({super.key});

  @override
  ConsumerState<ContinueWithEmailScreen> createState() =>
      _ContinueWithEmailScreenState();
}

class _ContinueWithEmailScreenState
    extends ConsumerState<ContinueWithEmailScreen> {
  final _emailController = TextEditingController();
  bool _checking = false;

  /// Un compte existant doit saisir son mot de passe : on l'envoie vers la
  /// connexion au lieu de l'inscription.
  ///
  /// `fetchSignInMethodsForEmail` renvoie une liste vide quand la protection
  /// contre l'énumération des comptes est active : dans ce cas, et en cas
  /// d'échec réseau, on laisse l'inscription se charger de le dire.
  Future<void> _continue() async {
    final email =
        ref.read(continueWithEmailControllerProvider).email.trim();
    if (_checking) return;

    setState(() => _checking = true);
    var accountExists = false;
    try {
      final methods =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      accountExists = methods.isNotEmpty;
    } catch (_) {
      accountExists = false;
    }
    if (!mounted) return;
    setState(() => _checking = false);

    context.push(accountExists ? '/sign-in' : '/create-account', extra: email);
  }

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      ref
          .read(continueWithEmailControllerProvider.notifier)
          .onEmailChanged(_emailController.text);
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
final l10n = AppLocalizations.of(context); 
  final state = ref.watch(continueWithEmailControllerProvider);

    return OnboardingScaffold(
      showBack: true,
      showSkip: false,
      resizeToAvoidBottomInset: true,
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.fromLTRB(24, 70, 24, 32),
        child: Column(
          children: [
            // ── Illustration enveloppe 3D ───────────────────────
            // ⚠️  ÉLÉMENT 3D À REMPLIR
            // Remplacer par : Image.asset('assets/images/envelope_3d.png', height: 140)
            // L'image montre une enveloppe rose/violet en 3D isométrique
            Container(
              width: 140,
              height: 140,
              alignment: Alignment.center,
              child: Image.asset("assets/images/icons/envelope.png")
            ),
            const SizedBox(height: 32),

            // ── Titre ───────────────────────────────────────────
            Text(l10n.enterYourEmailTitle,
                style: AppText.h1, textAlign: TextAlign.center),
            const SizedBox(height: 10),
            Text(l10n.enterYourEmailSubtitle,
                style: AppText.body, textAlign: TextAlign.center),
            const SizedBox(height: 48),

            // ── Champ email ─────────────────────────────────────
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.emailAddressLabel, style: AppText.label),
                const SizedBox(height: 8),
                PillTextField(
                  hint: l10n.yourEmailAddressHint,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
              ],
            ),

            const SizedBox(height: 32),

            // ── Bouton Continue ─────────────────────────────────
            PrimaryButton(
              label: l10n.continueCta,
              onPressed: state.canContinue && !_checking ? _continue : null,
            ),
          ],
        ),
      ),
    );
  }
}

/// ═══════════════════════════════════════════════════════════════════
///  ÉCRAN 4 — Create Account (Set Password)
///  Maquette : Create_Account_2x.png
///
///  Structure :
///   • Bouton retour
///   • Illustration enveloppe 3D (même que écran 3)  ← MÊME IMAGE
///   • Titre "Create your account"
///   • Sous-titre
///   • Label "Password" + champ obscur (avec cursor rouge visible)
///   • Label "Confirm Password" + champ
///   • Bouton "Continue" (désactivé tant que les deux champs ne sont pas
///     valides et identiques)
///
///  Pas de lien « mot de passe oublié » ici : à la création du compte il n'y a
///  rien à récupérer, et ce lien n'existe que sur la connexion.
/// ═══════════════════════════════════════════════════════════════════
class CreateAccountScreen extends ConsumerStatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  ConsumerState<CreateAccountScreen> createState() =>
      _CreateAccountScreenState();
}

class _CreateAccountScreenState extends ConsumerState<CreateAccountScreen> {
  final _pwdController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _submitting = false;
  String? _error;
  AuthErrorCode? _errorCode;

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    final email =
        ref.read(continueWithEmailControllerProvider).email.trim();
    final state = ref.read(createAccountControllerProvider);

    if (!AuthValidators.isEmailValid(email)) {
      setState(() => _error = l10n.authErrorInvalidEmail);
      return;
    }

    final wasAnonymous =
        FirebaseAuth.instance.currentUser?.isAnonymous ?? false;

    setState(() {
      _submitting = true;
      _error = null;
      _errorCode = null;
    });

    try {
      await ref.read(authRepositoryProvider).createAccount(
            email: email,
            password: state.password,
          );
      if (!mounted) return;
      // A fresh sign-up still has to pick a name and a birth date; a linked
      // anonymous account already went through onboarding.
      context.go(
        '/verify-email',
        extra: VerifyEmailArgs(email: email, isNewAccount: !wasAnonymous),
      );
    } catch (error) {
      if (!mounted) return;
      final code = authErrorCodeFrom(error);
      setState(() {
        _submitting = false;
        _errorCode = code;
        _error = authErrorText(l10n, code);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _pwdController.addListener(() {
      ref
          .read(createAccountControllerProvider.notifier)
          .onPasswordChanged(_pwdController.text);
    });
    _confirmController.addListener(() {
      ref
          .read(createAccountControllerProvider.notifier)
          .onConfirmPasswordChanged(_confirmController.text);
    });
  }

  @override
  void dispose() {
    _pwdController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
final l10n = AppLocalizations.of(context);   final state = ref.watch(createAccountControllerProvider);

    final isAnonymous =
        FirebaseAuth.instance.currentUser?.isAnonymous ?? false;

    return OnboardingScaffold(
      showBack: true,
      resizeToAvoidBottomInset: true,
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.fromLTRB(24, 70, 24, 32),
        child: Column(
          children: [
            // ── Illustration enveloppe 3D ───────────────────────
            Container(
              width: 140,
              height: 140,
              alignment: Alignment.center,
              child: Image.asset("assets/images/icons/envelope.png")
            ),
            const SizedBox(height: 32),

            Text(l10n.createAccountTitle,
                style: AppText.h1, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(l10n.createAccountSubtitle,
                style: AppText.body, textAlign: TextAlign.center),
            const SizedBox(height: 32),

            // ── Champs mot de passe ─────────────────────────────
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  // Password
                  Text(l10n.passwordLabel, style: AppText.label),
                  const SizedBox(height: 8),
                  PillTextField(
                    hint: l10n.enterYourPasswordHint,
                    obscure: !state.showPassword,
                    autocorrect: false,
                    enableSuggestions: false,
                    controller: _pwdController,
                    suffix: IconButton(
                      tooltip: state.showPassword
                          ? l10n.hidePassword
                          : l10n.showPassword,
                      icon: Icon(
                        state.showPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.grey500,
                      ),
                      onPressed: ref
                          .read(createAccountControllerProvider.notifier)
                          .toggleShowPassword,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      l10n.passwordMinLengthHint,
                      style: AppText.caption
                          .copyWith(color: AppColors.textSecondary),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Confirm Password
                  Text(l10n.confirmPasswordLabel, style: AppText.label),
                  const SizedBox(height: 8),
                  PillTextField(
                    hint: l10n.enterYourPasswordHint,
                    obscure: !state.showConfirmPassword,
                    autocorrect: false,
                    enableSuggestions: false,
                    controller: _confirmController,
                    suffix: IconButton(
                      tooltip: state.showConfirmPassword
                          ? l10n.hidePassword
                          : l10n.showPassword,
                      icon: Icon(
                        state.showConfirmPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.grey500,
                      ),
                      onPressed: ref
                          .read(createAccountControllerProvider.notifier)
                          .toggleShowConfirmPassword,
                    ),
                  ),
                if (state.confirmPassword.isNotEmpty &&
                    state.password != state.confirmPassword) ...[
                  const SizedBox(height: 6),
                  Text(
                    l10n.passwordMismatch,
                    style: AppText.caption.copyWith(color: AppColors.textError),
                  ),
                ],
              ],
            ),

            if (isAnonymous) ...[
              const SizedBox(height: 16),
              Text(
                l10n.createAccountKeepsData,
                style: AppText.caption.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
            ],

            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(
                _error!,
                style: AppText.caption.copyWith(color: AppColors.textError),
                textAlign: TextAlign.center,
              ),
              if (_errorCode == AuthErrorCode.emailAlreadyInUse)
                TextButton(
                  onPressed: () => context.push(
                    '/sign-in',
                    extra: ref
                        .read(continueWithEmailControllerProvider)
                        .email
                        .trim(),
                  ),
                  child: Text(
                    l10n.signInCta,
                    style: AppText.label.copyWith(
                      color: AppColors.primary600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],

            const SizedBox(height: 32),

            PrimaryButton(
              label: l10n.continueCta,
              onPressed: state.canContinue && !_submitting ? _submit : null,
            ),
          ],
        ),
      ),
    );
  }
}
