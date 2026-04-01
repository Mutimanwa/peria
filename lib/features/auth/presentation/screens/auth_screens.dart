import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:perla_app/core/theme/theme.dart';
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
class ContinueWithEmailScreen extends StatefulWidget {
  const ContinueWithEmailScreen({super.key});

  @override
  State<ContinueWithEmailScreen> createState() =>
      _ContinueWithEmailScreenState();
}

class _ContinueWithEmailScreenState extends State<ContinueWithEmailScreen> {
  final _emailController = TextEditingController();
  bool _hasEmail = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      setState(() => _hasEmail = _emailController.text.trim().isNotEmpty);
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              child: Image.asset("images/icons/envelope.png")
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
                onPressed: _hasEmail
                    ? () {
                      context.go("/create-account");
                    }
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
class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _pwdController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _showPwd = false;
  bool _showConfirm = false;
  bool _canContinue = false;

  @override
  void initState() {
    super.initState();
    void _check() => setState(() {
          _canContinue = _pwdController.text.isNotEmpty &&
              _confirmController.text.isNotEmpty;
        });
    _pwdController.addListener(_check);
    _confirmController.addListener(_check);
  }

  @override
  void dispose() {
    _pwdController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              child: Image.asset("images/icons/envelope.png")
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
                    obscure: !_showPwd,
                    controller: _pwdController,
                    suffix: IconButton(
                      icon: Icon(
                        _showPwd
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.grey500,
                      ),
                      onPressed: () => setState(() => _showPwd = !_showPwd),
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
                    obscure: !_showConfirm,
                    controller: _confirmController,
                    suffix: IconButton(
                      icon: Icon(
                        _showConfirm
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.grey500,
                      ),
                      onPressed: () =>
                          setState(() => _showConfirm = !_showConfirm),
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
                onPressed:
                    _canContinue ? () {
                      context.go("/otp");
                    } : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
