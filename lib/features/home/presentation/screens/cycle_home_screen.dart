import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:perla_app/core/theme/app_colors.dart';
import 'package:perla_app/core/storage/app_settings.dart';
import 'package:perla_app/core/storage/app_settings_provider.dart';
import 'package:perla_app/features/cycle/domain/cycle_status.dart';
import 'package:perla_app/features/cycle/presentation/providers/cycle_provider.dart';
import 'package:perla_app/features/profile/presentation/providers/user_profile_provider.dart';
import 'package:perla_app/shared/widgets/custom_bottom_nav.dart';

// ════════════════════════════════════════════════════════════════════
//  ENUM — 4 phases du cycle (computed from startDate)
// ════════════════════════════════════════════════════════════════════
enum CyclePhase { menstrual, follicular, ovulation, luteal }

// ════════════════════════════════════════════════════════════════════
//  ÉCRAN PRINCIPAL — Cycle Home
// ════════════════════════════════════════════════════════════════════
class CycleHomeScreen extends ConsumerStatefulWidget {
  const CycleHomeScreen({super.key});

  @override
  ConsumerState<CycleHomeScreen> createState() => _CycleHomeScreenState();
}

class _CycleHomeScreenState extends ConsumerState<CycleHomeScreen>
    with TickerProviderStateMixin {
  // ── Phase courante (pilotée par cycleStatusProvider) ─────────────
  CyclePhase _phase = CyclePhase.follicular;
  int _dayOfCycle = 1;
  int? _daysUntilNextPeriod;
  NavItem _activeTab = NavItem.cycle;

  // ── Controllers d'animation de vague ────────────────────────────
  late AnimationController _wave1Ctrl;
  late AnimationController _wave2Ctrl;

  // ── Transition de phase (AnimatedSwitcher) ───────────────────────
  late AnimationController _phaseCtrl;
  late Animation<double> _phaseAnim;

  @override
  void initState() {
    super.initState();
    // Vague 1 : plus lente
    _wave1Ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat();
    // Vague 2 : légèrement plus rapide, déphasée
    _wave2Ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2100),
    )..repeat();
    // Phase transition
    _phaseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _phaseAnim = CurvedAnimation(parent: _phaseCtrl, curve: Curves.easeInOut);
    _phaseCtrl.forward();
  }

  @override
  void dispose() {
    _wave1Ctrl.dispose();
    _wave2Ctrl.dispose();
    _phaseCtrl.dispose();
    super.dispose();
  }

  // ── Config couleurs + données par phase ─────────────────────────
  _PhaseConfig get _config {
    final dayLabel = 'Day $_dayOfCycle';

    switch (_phase) {
      case CyclePhase.menstrual:
        return _PhaseConfig(
          label: 'Period',
          dayLabel: dayLabel,
          // Couche du bas (la plus foncée, occupe ~65% bas)
          colorBottom: AppColors.primary300,
          // Couche intermédiaire (vague 1)
          colorMid: AppColors.primary200,
          // Couche haute (vague 2, la plus claire)
          colorTop: AppColors.primary100,
          // Couleur texte dans la roue
          textColor: AppColors.primary800,
          // Badge numéro cycle
          badgeDay: _dayOfCycle,
          // Angle du badge sur l'anneau (0 = 3h, -π/2 = 12h)
          // Period → badge à ~2h30 (droite légèrement haut)
          badgeAngleDeg: -40.0,
          // Surbrillance du jour dans le calendrier
          calHighlight: AppColors.primary200,
          calTextColor: AppColors.primary400,
          // Couleur des dots de l'anneau
          dotColor: AppColors.secondary300,
          // Couleur de fond du gap (anneau blanc entre outer et inner)
          ringBg: Color(0xFFF5D6E0),
        );
      case CyclePhase.luteal:
        return _PhaseConfig(
          label: 'Luteal',
          dayLabel: dayLabel,
          colorBottom: AppColors.pmsBase,
          colorMid: AppColors.pmsBase.withOpacity(0.8),
          colorTop: AppColors.pmsLight,
          textColor: const Color(0xFF7A5200),
          badgeDay: _dayOfCycle,
          badgeAngleDeg: -160.0, // gauche ~10h
          calHighlight: const Color(0xFFFFF5C0),
          calTextColor: const Color(0xFFD4920F),
          dotColor: const Color(0xFFD4B8EE),
          ringBg: const Color(0xFFF5EED4),
        );
      case CyclePhase.ovulation:
        return _PhaseConfig(
          label: 'Ovulation',
          dayLabel: dayLabel,
          colorBottom: AppColors.ovulBase,
          colorMid: AppColors.ovulBase.withOpacity(0.8),
          colorTop: AppColors.ovulLight,
          textColor: const Color(0xFF4A2080),
          badgeDay: _dayOfCycle,
          badgeAngleDeg: 90.0, // bas ~6h
          calHighlight: const Color(0xFFE8D8FA),
          calTextColor: const Color(0xFF8B5CF6),
          dotColor: const Color(0xFFD4B8EE),
          ringBg: const Color(0xFFF0E4FA),
        );
      case CyclePhase.follicular:
        return _PhaseConfig(
          label: 'Follicular',
          dayLabel: dayLabel,
          colorBottom: AppColors.secondary500,
          colorMid: AppColors.secondary400.withOpacity(0.85),
          colorTop: AppColors.secondary100,
          textColor: const Color(0xFF4A2080),
          badgeDay: _dayOfCycle,
          badgeAngleDeg: -20.0,
          calHighlight: const Color(0xFFF3EBFC),
          calTextColor: const Color(0xFF8B5CF6),
          dotColor: const Color(0xFFD4B8EE),
          ringBg: const Color(0xFFF0E4FA),
        );
    }
  }

  CyclePhase _phaseFromStatus(CycleStatus? status) {
    if (status == null) return CyclePhase.follicular;
    final phaseName = status.phase.toString().split('.').last;
    return switch (phaseName) {
      'menstrual' => CyclePhase.menstrual,
      'ovulation' => CyclePhase.ovulation,
      'luteal' => CyclePhase.luteal,
      _ => CyclePhase.follicular,
    };
  }

  void _applyPhase(CyclePhase next) {
    if (next == _phase) return;
    setState(() => _phase = next);
    _phaseCtrl.forward(from: 0);
  }

  // void _switchPhase(CyclePhase p) {
  //   setState(() => _phase = p);
  //   _phaseCtrl.forward(from: 0);
  // }

  @override
  Widget build(BuildContext context) {
    final status = ref.watch(cycleStatusProvider);
    final dayOfCycle = status?.dayOfCycle ?? 1;
    final daysUntilNext = status?.daysUntilNextPeriod;
    final nextPhase = _phaseFromStatus(status);

    if (_dayOfCycle != dayOfCycle || _daysUntilNextPeriod != daysUntilNext) {
      // Avoid setState during build.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() {
          _dayOfCycle = dayOfCycle;
          _daysUntilNextPeriod = daysUntilNext;
        });
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _applyPhase(nextPhase);
    });

    final cfg = _config;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.white,
      // ── Fond gradient rose→violet→blanc ───────────────────────────
      body: Stack(
        children: [
          // Gradient background
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 0.35, 0.65, 1.0],
                  colors: [
                    Color(0xFFFBE4EC), // rose pâle haut
                    Color(0xFFF3E5F5), // violet pâle milieu
                    Color(0xFFFAF5FF), // presque blanc
                    Color(0xFFFFFFFF), // blanc bas
                  ],
                ),
              ),
            ),
          ),

          // ── Contenu principal ───────────────────────────────────
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                // AppBar
                _AppBar(onAvatarTap: () => context.go('/profile')),
                const SizedBox(height: 10),

                // Texte subtitle
                Text(
                  _daysUntilNextPeriod == null
                      ? 'Next period: unknown'
                      : _daysUntilNextPeriod! <= 0
                          ? 'Period is due'
                          : 'Next period in $_daysUntilNextPeriod days',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF5A5A5A),
                  ),
                ),
                const SizedBox(height: 14),

                // ── Roue animée ──────────────────────────────────
                AnimatedBuilder(
                  animation:
                      Listenable.merge([_wave1Ctrl, _wave2Ctrl, _phaseAnim]),
                  builder: (_, __) {
                    return SizedBox(
                      width: size.width * 0.55, // Decreased as requested
                      height: size.width * 0.55,
                      child: _CycleWheel(
                        config: cfg,
                        wave1: _wave1Ctrl.value,
                        wave2: _wave2Ctrl.value,
                        phaseAnim: _phaseAnim.value,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 22),

                // ── Calendrier semaine ───────────────────────────
                _WeekCalendar(config: cfg, now: status?.now ?? DateTime.now()),
                const SizedBox(height: 28),

                // ── Boutons Log ──────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Row(
                    children: [
                      Expanded(
                        child: _LogBtn(
                          label: 'Log Symptom',
                          filled: false,
                          onTap: () => context.go('/symptoms'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _LogBtn(
                          label: 'Log Period',
                          filled: true,
                          onTap: () => context.go('/edit-calendar'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // ── Cartes articles ──────────────────────────────
                Expanded(
                  child: Stack(
                    children: [
                      const Positioned.fill(
                        child: Padding(
                          padding: EdgeInsets.only(
                              bottom: 10), // Increased to clear floating nav
                          child: _ArticlesRow(),
                        ),
                      ),
                      // Floating Bottom Nav
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: CustomBottomNav(
                          currentIndex: _activeTab,
                          onTap: (tab) {
                            setState(() => _activeTab = tab);
                            if (tab == NavItem.cycle) {
                              context.go('/');
                            } else if (tab == NavItem.ai) {
                              context.go('/ai');
                            } else if (tab == NavItem.journal) {
                              context.go('/journal');
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════
//  APPBAR
// ════════════════════════════════════════════════════════════════════
class _AppBar extends StatelessWidget {
  final VoidCallback onAvatarTap;
  const _AppBar({required this.onAvatarTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
      child: Row(
        children: [
          // ── Avatar utilisateur (gauche) ─────────────────────
          GestureDetector(
            onTap: onAvatarTap,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.grey200,
                border: Border.all(color: AppColors.white, width: 1),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 6,
                      offset: const Offset(0, 2)),
                ],
              ),
              child: Image.asset('assets/images/icons/Profile.png',
                  fit: BoxFit.cover),
            ),
          ),

          // ── Logo Peria (centre) ──────────────────────────────
          const Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _PeriaLogo(size: 24),
                SizedBox(width: 7),
                Text(
                  'Peria',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),

          // ── Icônes droite ────────────────────────────────────
          Row(
            children: [
              // Cloche + badge rouge
              SizedBox(
                width: 28,
                height: 28,
                child: Stack(
                  children: [
                    InkWell(
                        onTap: () {
                          context.go("/notification");
                        },
                        child: Image.asset(
                            "assets/images/icons/notification-1.png")),
                    Positioned(
                      top: 1,
                      right: 1,
                      child: Container(
                        width: 9,
                        height: 9,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border:
                              Border.all(color: AppColors.white, width: 1.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              // Button pour calendrier
              InkWell(
                  onTap: () {
                    context.go("/calendar");
                  },
                  child: Image.asset("assets/images/icons/calendar.png"))
            ],
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════
//  LOGO PERIA — 2 cercles entrelacés
// ════════════════════════════════════════════════════════════════════
class _PeriaLogo extends StatelessWidget {
  final double size;
  const _PeriaLogo({required this.size});

  @override
  Widget build(BuildContext context) => SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _PeriaLogoPainter()));
}

class _PeriaLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round;
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width * 0.34;
    // Cercle gauche (rose)
    paint.color = AppColors.primary;
    canvas.drawCircle(Offset(cx - r * 0.38, cy), r, paint);
    // Cercle droit (violet)
    paint.color = AppColors.secondary;
    canvas.drawCircle(Offset(cx + r * 0.38, cy), r, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}

// ════════════════════════════════════════════════════════════════════
//  ROUE CYCLIQUE — Dessinée en Flutter avec CustomPaint + animations
// ════════════════════════════════════════════════════════════════════
class _CycleWheel extends StatelessWidget {
  final _PhaseConfig config;
  final double wave1; // 0.0 → 1.0 (animation vague 1)
  final double wave2; // 0.0 → 1.0 (animation vague 2)
  final double phaseAnim;

  const _CycleWheel({
    required this.config,
    required this.wave1,
    required this.wave2,
    required this.phaseAnim,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CycleWheelPainter(
        config: config,
        wave1: wave1,
        wave2: wave2,
        phaseAnim: phaseAnim,
      ),
      // ── Texte centré dans la roue ──────────────────────────
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Label phase (ex: "Period", "PMS", "Ovulation")
            Text(
              config.label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: config.textColor,
              ),
            ),
            const SizedBox(height: 4),
            // Valeur (ex: "3 day", "Day 14")
            Text(
              config.dayLabel,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 30,
                fontWeight: FontWeight.w800,
                color: config.textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════
//  PAINTER — logique de dessin de la roue
// ════════════════════════════════════════════════════════════════════
class _CycleWheelPainter extends CustomPainter {
  final _PhaseConfig config;
  final double wave1;
  final double wave2;
  final double phaseAnim;

  _CycleWheelPainter({
    required this.config,
    required this.wave1,
    required this.wave2,
    required this.phaseAnim,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    final outerR = size.width / 2 - 2.0;
    const ringW = 18.0;
    const gapW = 25.0;
    final innerR = outerR - ringW - gapW;

    final center = Offset(cx, cy);

    // 1. Anneau de fond (bande)
    final ringPaint = Paint()
      ..color = config.ringBg
      ..style = PaintingStyle.stroke
      ..strokeWidth = ringW;
    canvas.drawCircle(center, outerR - ringW / 2, ringPaint);

    // 2. Points
    final dotPaint = Paint()..color = config.dotColor;
    const dotCount = 40;
    const dotR = 3.2;
    for (int i = 0; i < dotCount; i++) {
      final angle = (i / dotCount) * 2 * math.pi - math.pi / 2;
      final dotCx = cx + (outerR - ringW / 2) * math.cos(angle);
      final dotCy = cy + (outerR - ringW / 2) * math.sin(angle);
      canvas.drawCircle(Offset(dotCx, dotCy), dotR, dotPaint);
    }

    // 3. Gap blanc
    final gapPaint = Paint()
      ..color = Colors.transparent
      ..style = PaintingStyle.stroke
      ..strokeWidth = gapW;
    canvas.drawCircle(center, outerR - ringW - gapW / 2, gapPaint);

    // 4. Cercle intérieur blanc (fond)
    final bgPaint = Paint()..color = Colors.transparent;
    canvas.drawCircle(center, innerR, bgPaint);

    // 5. Vagues (style liquid) – clip dans le cercle intérieur
    canvas.save();
    canvas.clipPath(
        Path()..addOval(Rect.fromCircle(center: center, radius: innerR)));

// Surface (haut)
    _drawWaveLiquid(
      canvas: canvas,
      center: center,
      radius: innerR,
      anim: wave1,
      color: config.colorTop,
      fillPercent: 0.4,
      amplitude: innerR * 0.07,
    );
// Milieu
    _drawWaveLiquid(
      canvas: canvas,
      center: center,
      radius: innerR,
      anim: wave1 + 0.3,
      color: config.colorMid,
      fillPercent: 0.3,
      amplitude: innerR * 0.06,
    );
    _drawWaveLiquid(
      canvas: canvas,
      center: center,
      radius: innerR,
      anim: wave1 + 0.4,
      color: config.colorMid,
      fillPercent: 0.35,
      amplitude: innerR * 0.065,
    );
    _drawWaveLiquid(
      canvas: canvas,
      center: center,
      radius: innerR,
      anim: wave2,
      color: config.colorBottom,
      fillPercent: 0.2,
      amplitude: innerR * 0.05,
    );

    canvas.restore();

    // 6. Badge
    final badgeAngleRad = config.badgeAngleDeg * math.pi / 180;
    final badgeCx = cx + outerR * math.cos(badgeAngleRad);
    final badgeCy = cy + outerR * math.sin(badgeAngleRad);
    _drawBadge(canvas, Offset(badgeCx, badgeCy), config.badgeDay, config);
  }

  void _drawWaveLiquid({
    required Canvas canvas,
    required Offset center,
    required double radius,
    required double anim, // 0..1 pour l’ondulation
    required Color color,
    required double fillPercent, // 0.0 (vide) à 1.0 (plein)
    required double amplitude,
  }) {
    final paint = Paint()..color = color;
    final path = Path();

    final topY = center.dy - radius; // haut du cercle
    final bottomY = center.dy + radius; // bas du cercle
    final waterLevel = bottomY - (radius * 2 * fillPercent); // niveau de l’eau

    path.moveTo(center.dx - radius, bottomY);

    // On dessine de gauche à droite en ajoutant une sinusoïde
    for (double x = center.dx - radius; x <= center.dx + radius; x += 2) {
      final dx = x - (center.dx - radius);
      final angle = (dx / (radius * 2)) * 2 * math.pi;
      final y =
          waterLevel + amplitude * math.sin(angle * 2 + (anim * 2 * math.pi));
      path.lineTo(x, y.clamp(topY, bottomY));
    }

    path.lineTo(center.dx + radius, bottomY);
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawBadge(Canvas canvas, Offset pos, int day, _PhaseConfig cfg) {
    // (identique au code existant)
    const badgeR = 15.0;
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.10)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
    canvas.drawCircle(pos + const Offset(0, 2), badgeR + 1, shadowPaint);
    canvas.drawCircle(pos, badgeR, Paint()..color = AppColors.white);
    canvas.drawCircle(
      pos,
      badgeR,
      Paint()
        ..color = cfg.colorMid.withOpacity(0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8,
    );
    final tp = TextPainter(
      text: TextSpan(
        text: '$day',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: day > 9 ? 13.0 : 15.0,
          fontWeight: FontWeight.w700,
          color: cfg.colorBottom,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    tp.paint(canvas, pos - Offset(tp.width / 2, tp.height / 2));
  }

  @override
  bool shouldRepaint(_CycleWheelPainter old) =>
      old.wave1 != wave1 ||
      old.wave2 != wave2 ||
      old.config.label != config.label;
}

// ════════════════════════════════════════════════════════════════════
//  CALENDRIER SEMAINE — 7 jours, aujourd'hui surligné
// ════════════════════════════════════════════════════════════════════
class _WeekCalendar extends StatelessWidget {
  final _PhaseConfig config;
  final DateTime now;

  const _WeekCalendar({
    required this.config,
    required this.now,
  });

  DateTime _startOfDay(DateTime d) => DateTime(d.year, d.month, d.day);

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    // Week starts Monday (weekday: Mon=1..Sun=7)
    final today = _startOfDay(now);
    final weekStart = today.subtract(Duration(days: today.weekday - 1));
    final weekDays = List.generate(7, (i) => weekStart.add(Duration(days: i)));
    const dayNames = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(7, (i) {
          final date = weekDays[i];
          final isToday = _isSameDay(date, today);
          return SizedBox(
            width: 42,
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 42,
                  height: 58,
                  decoration: BoxDecoration(
                    color: isToday ? config.calHighlight : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${date.day}',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 17,
                          fontWeight:
                              isToday ? FontWeight.w700 : FontWeight.w500,
                          color:
                              isToday ? config.calTextColor : AppColors.grey700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        dayNames[date.weekday - 1],
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color:
                              isToday ? config.calTextColor : AppColors.grey500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════
//  BOUTONS LOG SYMPTOM / LOG PERIOD
// ════════════════════════════════════════════════════════════════════
class _LogBtn extends StatelessWidget {
  final String label;
  final bool filled;
  final VoidCallback onTap;

  const _LogBtn(
      {required this.label, required this.filled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: filled ? AppColors.grey900 : AppColors.white,
          borderRadius: BorderRadius.circular(50),
          border:
              filled ? null : Border.all(color: AppColors.grey900, width: 1.5),
          boxShadow: filled
              ? [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 8,
                      offset: const Offset(0, 3))
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: filled ? AppColors.white : AppColors.black,
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════
//  SECTION ARTICLES — 3 cards horizontales avec images 3D
// ════════════════════════════════════════════════════════════════════
class _ArticlesRow extends StatelessWidget {
  const _ArticlesRow();

  @override
  Widget build(BuildContext context) {
    // Config des 3 articles
    // Couleurs selon maquette : article 1 et 3 rose, article 2 violet
    const articles = [
      _ArticleCfg(
        title: 'Healthy di',
        bg: Color(0xFFFFD6DE),
        textColor: Color(0xFFE03060),
        image: 'assets/images/skin.png',
        width: 140,
        height: 140,
        marginTop: 25,
      ),
      _ArticleCfg(
        title: 'Skin care',
        bg: Color(0xFFE8D8FA),
        textColor: Color(0xFF8B5CF6),
        image: 'assets/images/skin.png',
        width: 185,
        height: 155,
        marginTop: 0,
      ),
      _ArticleCfg(
        title: 'Yoga Tipps',
        bg: Color(0xFFFFD6DE),
        textColor: Color(0xFFE03060),
        image: 'assets/images/yoga.png',
        width: 140,
        height: 140,
        marginTop: 25,
      ),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: articles.asMap().entries.map((entry) {
          final isLast = entry.key == articles.length - 1;
          return Padding(
            padding: EdgeInsets.only(right: isLast ? 0 : 12),
            child: _ArticleCard(cfg: entry.value),
          );
        }).toList(),
      ),
    );
  }
}

class _ArticleCfg {
  final String title;
  final Color bg;
  final Color textColor;
  final String image;
  final double width;
  final double height;
  final double marginTop;

  const _ArticleCfg({
    required this.title,
    required this.bg,
    required this.textColor,
    required this.image,
    required this.width,
    required this.height,
    required this.marginTop,
  });
}

class _ArticleCard extends StatelessWidget {
  final _ArticleCfg cfg;
  const _ArticleCard({required this.cfg});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: cfg.marginTop),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: cfg.width,
            height: cfg.height,
            decoration: BoxDecoration(
              color: cfg.bg,
              borderRadius: BorderRadius.circular(28), // Premium rounding
            ),
            clipBehavior: Clip.antiAlias,
            alignment: Alignment.center,
            child: Image.asset(
              cfg.image,
              fit: BoxFit.contain,
              width: cfg.width * 0.85,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 6),
            child: Text(
              cfg.title,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: cfg.textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════
//  DATA CLASS — Configuration d'une phase
// ════════════════════════════════════════════════════════════════════
class _PhaseConfig {
  final String label;
  final String dayLabel;
  // Couleurs des 3 couches de la roue (bas = foncé, haut = clair)
  final Color colorBottom;
  final Color colorMid;
  final Color colorTop;
  // Couleur du texte à l'intérieur de la roue
  final Color textColor;
  // Badge numéro de jour sur l'anneau
  final int badgeDay;
  // Angle en DEGRÉS (0° = 3h, -90° = 12h, 90° = 6h, 180°/-180° = 9h)
  final double badgeAngleDeg;
  // Calendrier semaine
  final Color calHighlight;
  final Color calTextColor;
  // Dots de l'anneau
  final Color dotColor;
  // Fond de l'anneau (zone entre dots et cercle intérieur)
  final Color ringBg;

  const _PhaseConfig({
    required this.label,
    required this.dayLabel,
    required this.colorBottom,
    required this.colorMid,
    required this.colorTop,
    required this.textColor,
    required this.badgeDay,
    required this.badgeAngleDeg,
    required this.calHighlight,
    required this.calTextColor,
    required this.dotColor,
    required this.ringBg,
  });
}
