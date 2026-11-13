import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:peria_app/core/constants/app_assets.dart';
import 'package:peria_app/core/theme/app_colors.dart';
import 'package:peria_app/core/theme/app_spacing.dart';
import 'package:peria_app/core/theme/app_text.dart';
import 'package:peria_app/features/cycle/data/models/period_log.dart';
import 'package:peria_app/features/cycle/domain/cycle_phase.dart';
import 'package:peria_app/features/cycle/domain/period_log_quick_actions.dart';
import 'package:peria_app/features/cycle/presentation/providers/cycle_provider.dart';
import 'package:peria_app/features/profile/presentation/providers/user_profile_provider.dart';
import 'package:peria_app/shared/widgets/profile_avatar.dart';

import 'package:peria_app/l10n/app_localizations.dart';

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
  // Navigation state is now managed by ShellNavigation
  // NavItem _activeTab = NavItem.cycle; // Removed - managed by shell

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
  _PhaseConfig _config(
    CyclePhase phase,
    int dayOfCycle,
    AppLocalizations l10n,
  ) {
    final dayLabel = '${l10n.day} $dayOfCycle';

    switch (phase) {
      case CyclePhase.menstrual:
        return _PhaseConfig(
          label: l10n.cyclePhasePeriod,
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
          badgeDay: dayOfCycle,
          // Angle du badge sur l'anneau (0 = 3h, -π/2 = 12h)
          // Period → badge à ~2h30 (droite légèrement haut)
          badgeAngleDeg: -40.0,
          // Couleur des dots de l'anneau
          dotColor: AppColors.secondary300,
          // Couleur de fond du gap (anneau blanc entre outer et inner)
          ringBg: AppColors.primary100.withOpacity(0.5),
        );
      case CyclePhase.luteal:
        return _PhaseConfig(
          label: l10n.cyclePhaseLuteal,
          dayLabel: dayLabel,
          colorBottom: AppColors.pmsBase,
          colorMid: AppColors.pmsBase.withOpacity(0.8),
          colorTop: AppColors.pmsLight,
          textColor: AppColors.neutral900,
          badgeDay: dayOfCycle,
          badgeAngleDeg: -160.0, // gauche ~10h
          dotColor: AppColors.secondary200,
          ringBg: AppColors.warning50.withOpacity(0.5),
        );
      case CyclePhase.ovulation:
        return _PhaseConfig(
          label: l10n.cyclePhaseOvulation,
          dayLabel: dayLabel,
          colorBottom: AppColors.ovulBase,
          colorMid: AppColors.ovulBase.withOpacity(0.8),
          colorTop: AppColors.ovulLight,
          textColor: AppColors.secondary800,
          badgeDay: dayOfCycle,
          badgeAngleDeg: 90.0, // bas ~6h
          dotColor: AppColors.secondary300,
          ringBg: AppColors.secondary50,
        );
      case CyclePhase.follicular:
        return _PhaseConfig(
          label: l10n.cyclePhaseFollicular,
          dayLabel: dayLabel,
          colorBottom: AppColors.secondary500,
          colorMid: AppColors.secondary400.withOpacity(0.85),
          colorTop: AppColors.secondary100,
          textColor: AppColors.secondary800,
          badgeDay: dayOfCycle,
          badgeAngleDeg: -20.0,
          dotColor: AppColors.secondary200,
          ringBg: AppColors.secondary50,
        );
    }
  }

  Future<void> _showQuickPeriodSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.46),
      elevation: 0,
      clipBehavior: Clip.none,
      builder: (_) => _QuickPeriodLogSheet(
        onOpenStructuredEdit: () {
          if (mounted) context.push('/edit-calendar');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final status = ref.watch(cycleStatusProvider);
    ref.listen(cycleStatusProvider, (previous, next) {
      if (previous?.phase != next?.phase) {
        _phaseCtrl.forward(from: 0);
      }
    });

    final dayOfCycle = status?.dayOfCycle ?? 1;
    final daysUntilNext = status?.daysUntilNextPeriod;
    final phase = status?.phase ?? CyclePhase.follicular;
    final cycleLength = status?.cycleLengthDays ?? 28;
    final cycleLengthDays = cycleLength > 0 ? cycleLength : 28;
    final cycleProgress =
        (dayOfCycle / cycleLengthDays).clamp(0.0, 1.0).toDouble();
    final cfg = _config(phase, dayOfCycle, l10n);
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
                    AppColors.primary50, // rose pâle haut
                    AppColors.secondary50, // violet pâle milieu
                    AppColors.neutral50, // blanc
                    AppColors.white, // blanc bas
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
                _AppBar(
                  onAvatarTap: () => context.push('/profile'),
                  avatarBase64: ref.watch(userProfileProvider).value?.avatarBase64,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.page,
                      8,
                      AppSpacing.page,
                      24,
                    ),
                    child: Column(
                      children: [
                        Text(
                          daysUntilNext == null
                              ? l10n.nextPeriodUnknown
                              : daysUntilNext <= 0
                                  ? l10n.periodIsDue
                                  : l10n.nextPeriodInDays(daysUntilNext),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.neutral700,
                          ),
                        ),
                        const SizedBox(height: 18),
                        AnimatedBuilder(
                          animation: Listenable.merge(
                            [_wave1Ctrl, _wave2Ctrl, _phaseAnim],
                          ),
                          builder: (_, __) {
                            return SizedBox(
                              width: size.width * 0.62,
                              height: size.width * 0.62,
                              child: _CycleWheel(
                                config: cfg,
                                wave1: _wave1Ctrl.value,
                                wave2: _wave2Ctrl.value,
                                phaseAnim: _phaseAnim.value,
                                progress: cycleProgress,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 28),
                        Row(
                          children: [
                            Expanded(
                              child: _LogBtn(
                                label: l10n.logSymptoms,
                                filled: false,
                                onTap: () => context.push('/symptoms'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _LogBtn(
                                label: l10n.logPeriodButton,
                                filled: true,
                                onTap: _showQuickPeriodSheet,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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

enum _QuickPeriodLogAction { startToday, addToday, endToday }

class _QuickPeriodLogSheet extends ConsumerStatefulWidget {
  const _QuickPeriodLogSheet({required this.onOpenStructuredEdit});

  final VoidCallback onOpenStructuredEdit;

  @override
  ConsumerState<_QuickPeriodLogSheet> createState() =>
      _QuickPeriodLogSheetState();
}

class _QuickPeriodLogSheetState extends ConsumerState<_QuickPeriodLogSheet> {
  bool _isSaving = false;
  String? _feedback;

  Future<void> _submit(
    _QuickPeriodLogAction action,
    List<PeriodLog> logs,
  ) async {
    if (_isSaving) return;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final periodLog = action == _QuickPeriodLogAction.endToday
        ? PeriodLogQuickActions.endToday(logs: logs, today: today)
        : PeriodLogQuickActions.recordToday(logs: logs, today: today);

    if (periodLog == null) {
      final message = action == _QuickPeriodLogAction.endToday &&
              !logs.any((log) =>
                  !log.isEstimated &&
                  log.endDate.year == today.year &&
                  log.endDate.month == today.month &&
                  log.endDate.day == today.day)
          ? AppLocalizations.of(context).periodLogNoRecentToEnd
          : AppLocalizations.of(context).periodLogAlreadyLoggedToday;
      setState(() => _feedback = message);
      return;
    }

    final periodLogsNotifier = ref.read(periodLogsProvider.notifier);
    setState(() {
      _isSaving = true;
      _feedback = null;
    });

    try {
      await periodLogsNotifier.add(periodLog);
      if (!mounted) return;

      // Period logs are the cycle engine's source of truth. Keep the profile's
      // legacy fallback anchor aligned when it is already available.
      final savedLogs =
          ref.read(periodLogsProvider).value ?? const <PeriodLog>[];
      final periodContainingToday = savedLogs
          .where((log) => log.contains(today) && !log.isEstimated)
          .toList()
        ..sort((a, b) => b.startDate.compareTo(a.startDate));
      final profile = ref.read(userProfileProvider).value;
      if (periodContainingToday.isNotEmpty && profile != null) {
        final loggedStart = periodContainingToday.first.startDate;
        final currentStart = profile.lastPeriodStart;
        if (currentStart == null || loggedStart.isAfter(currentStart)) {
          try {
            await ref.read(userProfileProvider.notifier).patch(
                  (current) => current.copyWith(lastPeriodStart: loggedStart),
                );
          } catch (_) {
            // The saved period log remains canonical if this legacy fallback
            // profile field cannot be refreshed.
          }
        }
      }

      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      // `add` updates the provider optimistically. Reload its canonical value
      // after a failed write so a retry cannot mistake an unsaved entry for a
      // successfully recorded period.
      try {
        await periodLogsNotifier.load();
      } catch (_) {
        // Keep the original save error visible if refreshing also fails.
      }
      if (mounted) {
        final reloadedLogs =
            ref.read(periodLogsProvider).value ?? const <PeriodLog>[];
        final wasSaved = reloadedLogs.any(
          (log) => log.contains(today) && !log.isEstimated,
        );
        if (wasSaved) {
          Navigator.of(context).pop();
        } else {
          setState(() =>
              _feedback = AppLocalizations.of(context).periodLogSaveError);
        }
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final logsState = ref.watch(periodLogsProvider);
    final canSave = logsState.hasValue &&
        !logsState.isLoading &&
        !logsState.hasError &&
        !_isSaving;
    final logs = logsState.value ?? const <PeriodLog>[];
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(top: 28, bottom: bottomInset),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.22),
              blurRadius: 28,
              spreadRadius: 2,
              offset: const Offset(0, -10),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.grey300,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(l10n.logPeriodSheetTitle, style: AppText.h4),
                const SizedBox(height: 6),
                Text(
                  l10n.logPeriodSheetSubtitle,
                  style: AppText.body.copyWith(color: AppColors.textSecondary),
                ),
                if (logsState.isLoading || _isSaving) ...[
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        _isSaving
                            ? l10n.periodLogSaving
                            : l10n.periodLogLoading,
                        style: AppText.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
                if (logsState.hasError) ...[
                  const SizedBox(height: 14),
                  Text(
                    l10n.periodLogLoadError,
                    style: AppText.caption.copyWith(color: AppColors.textError),
                  ),
                ],
                if (_feedback != null) ...[
                  const SizedBox(height: 14),
                  Text(
                    _feedback!,
                    style: AppText.caption.copyWith(color: AppColors.textError),
                  ),
                ],
                const SizedBox(height: 18),
                _QuickActionTile(
                  icon: Icons.play_arrow_rounded,
                  title: l10n.periodStartedToday,
                  subtitle: l10n.periodStartedTodaySubtitle,
                  color: AppColors.primary400,
                  enabled: canSave,
                  onTap: () =>
                      _submit(_QuickPeriodLogAction.startToday, logs),
                ),
                const SizedBox(height: 12),
                _QuickActionTile(
                  icon: Icons.water_drop_outlined,
                  title: l10n.addTodayPeriodDay,
                  subtitle: l10n.addTodayPeriodDaySubtitle,
                  color: AppColors.primary500,
                  enabled: canSave,
                  onTap: () => _submit(_QuickPeriodLogAction.addToday, logs),
                ),
                const SizedBox(height: 12),
                _QuickActionTile(
                  icon: Icons.stop_rounded,
                  title: l10n.periodEndedToday,
                  subtitle: l10n.periodEndedTodaySubtitle,
                  color: AppColors.warning700,
                  enabled: canSave,
                  onTap: () => _submit(_QuickPeriodLogAction.endToday, logs),
                ),
                const SizedBox(height: 16),
                _LogBtn(
                  label: l10n.openStructuredPeriodEdit,
                  filled: false,
                  onTap: () {
                    Navigator.of(context).pop();
                    widget.onOpenStructuredEdit();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════
//  APPBAR
// ════════════════════════════════════════════════════════════════════
class _AppBar extends StatelessWidget {
  final VoidCallback onAvatarTap;
  final String? avatarBase64;
  const _AppBar({required this.onAvatarTap, this.avatarBase64});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.page,
        18,
        AppSpacing.page,
        0,
      ),
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
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: profileAvatarImage(avatarBase64),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
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

          Row(
            children: [
              _HeaderAction(
                onTap: () => context.push('/notifications'),
                child: Image.asset(
                  AppAssets.notificationBell,
                  width: 22,
                  height: 22,
                ),
              ),
              const SizedBox(width: 8),
              _HeaderAction(
                onTap: () => context.push('/calendar'),
                child: Image.asset(
                  AppAssets.calendar,
                  width: 22,
                  height: 22,
                ),
              ),
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
class _HeaderAction extends StatelessWidget {
  const _HeaderAction({required this.onTap, required this.child});

  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Center(child: child),
        ),
      ),
    );
  }
}

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
  final double progress;

  const _CycleWheel({
    required this.config,
    required this.wave1,
    required this.wave2,
    required this.phaseAnim,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CycleWheelPainter(
        config: config,
        wave1: wave1,
        wave2: wave2,
        phaseAnim: phaseAnim,
        progress: progress,
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
  final double progress;

  _CycleWheelPainter({
    required this.config,
    required this.wave1,
    required this.wave2,
    required this.phaseAnim,
    required this.progress,
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
    const dotCount = 40;
    const dotR = 3.2;
    final filledDots = (dotCount * progress).round().clamp(0, dotCount);
    for (int i = 0; i < dotCount; i++) {
      final dotPaint = Paint()
        ..color = i < filledDots
            ? config.colorBottom
            : config.dotColor.withOpacity(0.45);
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
      textDirection: ui.TextDirection.ltr,
    );
    tp.layout();
    tp.paint(canvas, pos - Offset(tp.width / 2, tp.height / 2));
  }

  @override
  bool shouldRepaint(_CycleWheelPainter old) =>
      old.wave1 != wave1 ||
      old.wave2 != wave2 ||
      old.progress != progress ||
      old.config.label != config.label;
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

class _QuickActionTile extends StatelessWidget {
  const _QuickActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
    this.enabled = true,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final actionColor = enabled ? color : AppColors.grey400;
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.grey50,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.grey200),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: actionColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: actionColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppText.label.copyWith(
                      fontWeight: FontWeight.w700,
                      color: enabled ? AppColors.grey900 : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppText.caption.copyWith(
                      color: enabled ? AppColors.textSecondary : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: enabled ? AppColors.grey500 : AppColors.grey300,
            ),
          ],
        ),
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
    required this.dotColor,
    required this.ringBg,
  });
}
