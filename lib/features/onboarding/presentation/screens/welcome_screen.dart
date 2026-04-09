import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:perla_app/core/theme/theme.dart';
// import 'package:perla_app/features/onboarding/domain/onboarding_navigation_target.dart';
// import 'package:perla_app/features/onboarding/presentation/controllers/welcome_controller.dart';
import 'package:perla_app/l10n/app_localizations.dart';
import 'package:perla_app/shared/widgets/common_widgets.dart';

/// ═══════════════════════════════════════════════════════════════════
///  ÉCRAN 1 — Welcome / Splash
///  Maquette : Welcome_2x.png
///
///  Structure :
///   • Header gradient rose → violet (coin haut-droit)
///   • Logo Peria (SVG dessiné) en haut à gauche
///   • Grande illustration 3D centrale (personnage + avatars)  ← IMAGE À REMPLIR
///   • Titre "Welcome To peria"
///   • Sous-titre descriptif
///   • Bouton "Turn on notification" (noir, pill)
///   • Lien "Another Time"
/// ═══════════════════════════════════════════════════════════════════
class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // Gradient de fond : blanc → rose → violet (comme maquette)
        decoration: const BoxDecoration(gradient: AppColors.bgGradient),
        child: SafeArea(
          child: Column(
            children: [
              // ── Logo Peria ────────────────────────
              const SizedBox(height: 36),
              Center(child: Image.asset("assets/images/logo/logo.png")),
              const SizedBox(height: 36),

              // ── Zone illustration 3D ─────────────────────────────
              Expanded(
                child: Image.asset(
                  "assets/images/onboarding/frame.png",
                  height: 300,
                ),
              ),

              // ── Textes + Boutons ─────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Text(l10n.welcomeTitle,
                        style: AppText.h1, textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    Text(l10n.welcomeSubtitle,
                        style: AppText.body, textAlign: TextAlign.center),
                    const SizedBox(height: 32),
                    // PrimaryButton(
                    //   label: 'Turn on notification',
                    //   onPressed: () => goTo(controller.onTurnOnNotificationsTapped()),
                    // ),
                    // const SizedBox(height: 16),
                    // GestureDetector(
                    //   onTap: () => goTo(controller.onAnotherTimeTapped()),
                    //   child: Text(
                    //     'Another Time',
                    //     style: AppText.label.copyWith(color: AppColors.grey700),
                    //   ),
                    // ),

                    PrimaryButton(
                      label: l10n.continueCta,
                      onPressed: () => context.go('/ask-name'),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
