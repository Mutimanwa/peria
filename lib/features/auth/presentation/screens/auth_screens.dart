import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:perla_app/core/theme/theme.dart';
import 'package:perla_app/features/auth/domain/create_account_navigation_target.dart';
import 'package:perla_app/features/auth/domain/email_flow_navigation_target.dart';
import 'package:perla_app/features/auth/presentation/controllers/continue_with_email_controller.dart';
import 'package:perla_app/features/auth/presentation/controllers/create_account_controller.dart';
import 'package:perla_app/shared/widgets/common_widgets.dart';

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
    final state = ref.watch(continueWithEmailControllerProvider);

    void goTo(EmailFlowNavigationTarget target) {
      switch (target) {
        case EmailFlowNavigationTarget.createAccount:
          context.go('/create-account');
      }
    }

    return OnboardingScaffold(
      showBack: true,
      showSkip: false,
      child: Padding(
        padding: const EdgeInsets.only(top: 70),
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
            const Text('Enter your email',
                style: AppText.h1, textAlign: TextAlign.center),
            const SizedBox(height: 10),
            const Text(
              "We'll check if you already have an account",
              style: AppText.body,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 60),

            // ── Champ email ─────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Email Address', style: AppText.label),
                  const SizedBox(height: 8),
                  PillTextField(
                    hint: 'Your email address',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                ],
              ),
            ),

            const Spacer(),

            // ── Bouton Continue ─────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
              child: PrimaryButton(
                label: 'Continue',
                onPressed: state.canContinue
                    ? () => goTo(ref
                        .read(continueWithEmailControllerProvider.notifier)
                        .onContinueTapped())
                    : null,
              ),
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
///   • Lien "Forgot your password?"
///   • Label "Confirm Password" + champ
///   • Lien "Forgot your password?"
///   • Bouton "Continue" (désactivé)
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
    final state = ref.watch(createAccountControllerProvider);

    void goTo(CreateAccountNavigationTarget target) {
      switch (target) {
        case CreateAccountNavigationTarget.otp:
          context.go('/otp');
      }
    }

    return OnboardingScaffold(
      showBack: true,
      child: Padding(
        padding: const EdgeInsets.only(top: 70),
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

            const Text('Create your account',
                style: AppText.h1, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            const Text(
              'Set a password to create your Peria account.',
              style: AppText.body,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // ── Champs mot de passe ─────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Password
                  const Text('Password', style: AppText.label),
                  const SizedBox(height: 8),
                  PillTextField(
                    hint: 'Enter your password',
                    obscure: !state.showPassword,
                    controller: _pwdController,
                    suffix: IconButton(
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
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {/* TODO: mot de passe oublié */},
                      child: Text('Forgot your password?',
                          style: AppText.caption
                              .copyWith(color: AppColors.grey500)),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Confirm Password
                  const Text('Confirm Password', style: AppText.label),
                  const SizedBox(height: 8),
                  PillTextField(
                    hint: 'Enter your password',
                    obscure: !state.showConfirmPassword,
                    controller: _confirmController,
                    suffix: IconButton(
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
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text('Forgot your password?',
                          style: AppText.caption
                              .copyWith(color: AppColors.grey500)),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
              child: PrimaryButton(
                label: 'Continue',
                onPressed: state.canContinue
                    ? () => goTo(ref
                        .read(createAccountControllerProvider.notifier)
                        .onContinueTapped())
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
