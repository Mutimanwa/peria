import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:perla_app/core/theme/theme.dart'; // Importe vos fichiers app_colors, app_spacing, etc.

// ── CONFIGURATION DES PHASES ──────────────────────────────────────────
enum CyclePhase { period, pms, ovulation }

class _PhaseConfig {
  final String label;
  final String dayLabel;
  final Color colorBottom; // Liquide foncé
  final Color colorMid;    // Liquide moyen
  final Color colorTop;    // Liquide clair
  final Color textColor;
  final int badgeDay;
  final double badgeAngle; // En radians
  final Color cardBg;

  const _PhaseConfig({
    required this.label,
    required this.dayLabel,
    required this.colorBottom,
    required this.colorMid,
    required this.colorTop,
    required this.textColor,
    required this.badgeDay,
    required this.badgeAngle,
    required this.cardBg,
  });
}

// ── ECRAN PRINCIPAL ──────────────────────────────────────────────────
class CycleHomeScreen extends StatefulWidget {
  const CycleHomeScreen({super.key});

  @override
  State<CycleHomeScreen> createState() => _CycleHomeScreenState();
}

class _CycleHomeScreenState extends State<CycleHomeScreen> with TickerProviderStateMixin {
  CyclePhase _currentPhase = CyclePhase.period;
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  _PhaseConfig get _config {
    switch (_currentPhase) {
      case CyclePhase.period:
        return const _PhaseConfig(
          label: 'Period',
          dayLabel: '3 day',
          colorBottom: AppColors.primary600,
          colorMid: AppColors.periodBase,
          colorTop: AppColors.periodLight,
          textColor: AppColors.primary900,
          badgeDay: 4,
          badgeAngle: -math.pi / 4,
          cardBg: AppColors.primary50,
        );
      case CyclePhase.pms:
        return const _PhaseConfig(
          label: 'PMS',
          dayLabel: '2 day',
          colorBottom: AppColors.warning200,
          colorMid: AppColors.pmsBase,
          colorTop: AppColors.pmsLight,
          textColor: AppColors.warning200,
          badgeDay: 25,
          badgeAngle: math.pi,
          cardBg: AppColors.warning50,
        );
      case CyclePhase.ovulation:
        return const _PhaseConfig(
          label: 'Ovulation',
          dayLabel: 'Day 14',
          colorBottom: AppColors.secondary600,
          colorMid: AppColors.ovulBase,
          colorTop: AppColors.ovulLight,
          textColor: AppColors.secondary900,
          badgeDay: 14,
          badgeAngle: math.pi / 2,
          cardBg: AppColors.secondary50,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cfg = _config;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.bgGradient),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: AppSpacing.s2),
              Text(
                'Next period in 5 days',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.neutral600),
              ),
              const SizedBox(height: AppSpacing.s4),
              
              // CERCLE CENTRAL
              AnimatedBuilder(
                animation: _waveController,
                builder: (context, child) {
                  return CustomPaint(
                    size: const Size(280, 280),
                    painter: _CycleCirclePainter(
                      config: cfg,
                      waveValue: _waveController.value,
                    ),
                    child: SizedBox(
                      width: 280,
                      height: 280,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(cfg.label, style: AppTypography.heading6.copyWith(color: cfg.textColor)),
                            Text(cfg.dayLabel, style: AppTypography.displaySmall.copyWith(color: cfg.textColor, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: AppSpacing.s4),
              const _WeekCalendar(),
              const SizedBox(height: AppSpacing.s4),

              // BOUTONS LOG
              Padding(
                padding: AppPadding.screen,
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          shape: const RoundedRectangleBorder(borderRadius: AppRadius.br24),
                          side: const BorderSide(color: AppColors.neutral200),
                        ),
                        child: const Text('Log Symptom'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s2),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.neutral950,
                          foregroundColor: AppColors.white,
                          shape: const RoundedRectangleBorder(borderRadius: AppRadius.br24),
                        ),
                        child: const Text('Log Period'),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.s4),
              const Expanded(child: _ArticlesList()),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _FloatingBottomNav(
        currentPhase: _currentPhase,
        onPhaseChanged: (p) => setState(() => _currentPhase = p),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: AppPadding.screen,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CircleAvatar(backgroundColor: AppColors.neutral200, radius: 20),
          Text('Peria', style: AppTypography.heading4.copyWith(color: AppColors.primary)),
          const Icon(Icons.notifications_none, color: AppColors.neutral900),
        ],
      ),
    );
  }
}

// ── PAINTER DU CERCLE (CORE DESIGN) ──────────────────────────────────
class _CycleCirclePainter extends CustomPainter {
  final _PhaseConfig config;
  final double waveValue;

  _CycleCirclePainter({required this.config, required this.waveValue});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width / 2;
    final ringWidth = 12.0;
    final gapWidth = 10.0;
    final innerRadius = outerRadius - ringWidth - gapWidth;

    // 1. ANNEAU POINTILLÉ (Cycle complet)
    final dotPaint = Paint()..color = AppColors.neutral200;
    for (int i = 0; i < 40; i++) {
      double angle = (i * 2 * math.pi / 40);
      Offset dotPos = center + Offset(math.cos(angle) * (outerRadius - 6), math.sin(angle) * (outerRadius - 6));
      canvas.drawCircle(dotPos, 2, dotPaint);
    }

    // 2. BADGE NUMÉRIQUE
    final badgePos = center + Offset(math.cos(config.badgeAngle) * (outerRadius - 6), math.sin(config.badgeAngle) * (outerRadius - 6));
    canvas.drawCircle(badgePos, 18, Paint()..color = AppColors.white);
    canvas.drawCircle(badgePos, 18, Paint()..color = config.colorMid..style = PaintingStyle.stroke..strokeWidth = 2);
    
    // (Texte du badge omis ici pour brièveté, utiliser TextPainter)

    // 3. LIQUIDE (3 COUCHES DE VAGUES)
    final clipPath = Path()..addOval(Rect.fromCircle(center: center, radius: innerRadius));
    canvas.save();
    canvas.clipPath(clipPath);

    _drawWave(canvas, center, innerRadius, waveValue, config.colorBottom, 0.4, 15);
    _drawWave(canvas, center, innerRadius, waveValue + 0.5, config.colorMid, 0.3, 12);
    _drawWave(canvas, center, innerRadius, waveValue + 0.2, config.colorTop, 0.2, 10);

    canvas.restore();
  }

  void _drawWave(Canvas canvas, Offset center, double radius, double anim, Color color, double heightFactor, double amp) {
    final paint = Paint()..color = color;
    final path = Path();
    final yBase = center.dy + radius - (radius * 2 * heightFactor);

    path.moveTo(center.dx - radius, center.dy + radius);
    for (double i = 0; i <= radius * 2; i++) {
      double x = center.dx - radius + i;
      double y = yBase + math.sin((i / radius * math.pi) + (anim * 2 * math.pi)) * amp;
      path.lineTo(x, y);
    }
    path.lineTo(center.dx + radius, center.dy + radius);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// ── CALENDRIER HEBDOMADAIRE ──────────────────────────────────────────
class _WeekCalendar extends StatelessWidget {
  const _WeekCalendar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.hP24,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(7, (index) {
          bool isSelected = index == 3;
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary100 : Colors.transparent,
                  borderRadius: AppRadius.br12,
                ),
                child: Column(
                  children: [
                    Text('${18 + index}', style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                    Text(['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'][index], style: AppTypography.captionSmall),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

// ── LISTE DES ARTICLES ───────────────────────────────────────────────
class _ArticlesList extends StatelessWidget {
  const _ArticlesList();

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(left: 24, bottom: 20),
      children: [
        _buildArticleCard('Healthy diet', AppColors.primary50),
        _buildArticleCard('Skin care', AppColors.secondary50),
        _buildArticleCard('Yoga tips', AppColors.warning50),
      ],
    );
  }

  Widget _buildArticleCard(String title, Color bg) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 16),
      padding: AppPadding.p16,
      decoration: BoxDecoration(color: bg, borderRadius: AppRadius.br24),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Text(title, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
      ),
    );
  }
}

// ── MENU DE NAVIGATION FLOTTANT ──────────────────────────────────────
class _FloatingBottomNav extends StatelessWidget {
  final CyclePhase currentPhase;
  final Function(CyclePhase) onPhaseChanged;

  const _FloatingBottomNav({required this.currentPhase, required this.onPhaseChanged});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        height: 64,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: AppRadius.brRounded,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(Icons.sync, 'Cycle', true),
            GestureDetector(onTap: () => onPhaseChanged(CyclePhase.ovulation), child: const Icon(Icons.auto_awesome, color: AppColors.neutral400)),
            const Icon(Icons.menu_book, color: AppColors.neutral400),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? AppColors.neutral950 : Colors.transparent,
        borderRadius: AppRadius.brRounded,
      ),
      child: Row(
        children: [
          Icon(icon, color: isActive ? AppColors.white : AppColors.neutral400, size: 20),
          if (isActive) ...[
            const SizedBox(width: 8),
            Text(label, style: AppTypography.buttonSmall.copyWith(color: AppColors.white)),
          ]
        ],
      ),
    );
  }
}