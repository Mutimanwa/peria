import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:perla_app/core/theme/theme.dart';
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
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
                    const Text(
                      'Welcome To peria',
                      style: AppText.h1,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Peria helps you understand your body\nwith calm, personalized guidance.',
                      style: AppText.body,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    PrimaryButton(
                      label: 'Turn on notification',
                      onPressed: () {/* TODO: demander permission notif */},
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () {
                        context.go('/register');
                      },
                      child: Text(
                        'Another Time',
                        style: AppText.label.copyWith(color: AppColors.grey700),
                      ),
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

// ───────────────────────────────────────────────
//  Widget interne : Logo Peria dessiné
// ───────────────────────────────────────────────
class _PeriaLogoSvg extends StatelessWidget {
  final double size;
  const _PeriaLogoSvg({required this.size});

  @override
  Widget build(BuildContext context) {
    // Logo deux cercles entrelacés (style maquette)
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _PeriaPainter()),
    );
  }
}

class _PeriaPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final r = size.width * 0.32;

    // Cercle gauche (rose)
    paint.color = AppColors.primary;
    canvas.drawCircle(Offset(center.dx - r * 0.4, center.dy), r, paint);

    // Cercle droit (violet)
    paint.color = AppColors.secondary;
    canvas.drawCircle(Offset(center.dx + r * 0.4, center.dy), r, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}

// ───────────────────────────────────────────────
//  Widget interne : Avatar flottant
// ───────────────────────────────────────────────
class _FloatingAvatar extends StatelessWidget {
  final Color color;
  final String label;

  const _FloatingAvatar({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4)),
        ],
      ),
      // ⚠️  Remplacer par Image.asset() dès que les images sont disponibles
      child: Center(
        child: Text('👤', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
