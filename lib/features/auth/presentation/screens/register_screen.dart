import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:perla_app/core/theme/theme.dart';
import 'package:perla_app/shared/widgets/common_widgets.dart';

/// ═══════════════════════════════════════════════════════════════════
///  ÉCRAN 2 — Register / Login
///  Maquette : Register_2x.png
///
///  Structure :
///   • Header gradient (coin haut-droit rose → violet)
///   • Logo Peria (haut gauche)
///   • Illustration 3D personnage assis sur canapé  ← IMAGE À REMPLIR
///   • Titre "Let's get you started"
///   • Sous-titre
///   • Bouton "Continue with email" (noir)
///   • Divider "Or"
///   • Bouton "Continue with Google" (outline)
///   • Bouton "Continue with Apple" (outline)
/// ═══════════════════════════════════════════════════════════════════
class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.bgGradient),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Logo ──────────────────────────────────────────
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    _PeriaLogoMini(),
                    const SizedBox(width: 8),
                    Text('Peria',
                        style: AppText.h3.copyWith(color: AppColors.primary)),
                  ],
                ),
              ),

              // ── Illustration 3D ────────────────────────────────
              // ⚠️  IMAGE 3D À REMPLIR
              // Remplacer par : Image.asset('assets/images/register_character.png')
              // L'image montre un personnage féminin assis en tailleur sur un canapé
              Expanded(
                child: Center(
                child: Image.asset(
                  "assets/images/onboarding/frame-2.png",
                  height: 300,
                ),
              )
              ),
              
              // Expanded(
              //   child: Center(
              //     child: Container(
              //       width: 280,
              //       height: 280,
              //       decoration: BoxDecoration(
              //         color: AppColors.primary100.withOpacity(0.4),
              //         borderRadius: BorderRadius.circular(20),
              //       ),
              //       alignment: Alignment.center,
              //       child: Column(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           const Icon(Icons.self_improvement,
              //               size: 80, color: AppColors.primary),
              //           const SizedBox(height: 8),
              //           Text('🖼️ register_character.png',
              //               style: AppText.caption
              //                   .copyWith(color: AppColors.primary)),
              //           Text('Personnage assis sur canapé',
              //               style: AppText.caption),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),

              // ── Texte ──────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const Text("Let's get you started",
                        style: AppText.h1, textAlign: TextAlign.center),
                    const SizedBox(height: 8),
                    const Text(
                      'Login or create an account to get started.',
                      style: AppText.body,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // Bouton Email
                    PrimaryButton(
                      label: 'Continue with email',
                      onPressed: () {
                        context.go("/email");
                      },
                    ),
                    const SizedBox(height: 20),

                    // Divider "Or"
                    Row(
                      children: [
                        const Expanded(
                            child: Divider(
                                color: AppColors.grey200, thickness: 1)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text('Or',
                              style: AppText.caption
                                  .copyWith(color: AppColors.grey400)),
                        ),
                        const Expanded(
                            child: Divider(
                                color: AppColors.grey200, thickness: 1)),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Bouton Google
                    SocialButton(
                      label: 'Continue with Google',
                      icon: _GoogleLogo(),
                      onPressed: () {/* TODO: auth Google */},
                    ),
                    const SizedBox(height: 12),

                    // Bouton Apple
                    SocialButton(
                      label: 'Continue with Apple',
                      icon: const Icon(Icons.apple,
                          size: 22, color: AppColors.black),
                      onPressed: () {/* TODO: auth Apple */},
                    ),
                    const SizedBox(height: 40),
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

// ── Logo Peria mini (version inline) ────────────────
class _PeriaLogoMini extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 28,
      height: 28,
      child: CustomPaint(painter: _PeriaPainterMini()),
    );
  }
}

class _PeriaPainterMini extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width * 0.32;
    paint.color = AppColors.primary;
    canvas.drawCircle(Offset(c.dx - r * 0.4, c.dy), r, paint);
    paint.color = AppColors.secondary;
    canvas.drawCircle(Offset(c.dx + r * 0.4, c.dy), r, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}

// ── Logo Google dessiné en Flutter ──────────────────
class _GoogleLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 22,
      height: 22,
      child: CustomPaint(painter: _GooglePainter()),
    );
  }
}

class _GooglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Simplification : lettre G colorée
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'G',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Color(0xFF4285F4),
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, const Offset(2, 0));
  }

  @override
  bool shouldRepaint(_) => false;
}
