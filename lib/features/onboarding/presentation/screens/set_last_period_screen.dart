import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:peria_app/core/router/router.dart';
import 'package:peria_app/core/services/onboarding_service.dart';
import 'package:peria_app/core/theme/theme.dart';
import 'package:peria_app/features/calendar/presentation/widgets/month_grid_layout.dart';
import 'package:peria_app/features/profile/presentation/providers/user_profile_provider.dart';
import 'package:peria_app/l10n/app_localizations.dart';
import 'package:peria_app/shared/widgets/common_widgets.dart';

/// ═══════════════════════════════════════════════════════════════════
///  ÉCRAN 9 — Set Last Period Date
///  Structure :
///   • Bouton retour + Skip
///   • Titre "When was your last period?"
///   • Sous-titre
///   • Calendrier dans card blanche arrondie :
///     - Chevrons nav mois
///     - En-têtes jours (mo tu we th fr sa su)
///     - Jours cliquables
///     - Jours sélectionnés → fond rose (1er = cercle plein, dernier = cercle plein, intermédiaires = fond léger)
///     - Bouton "Today" (outline, bas calendrier)
///   • Boutons "Not Sure" (outline) + "Continue" (noir)
/// ═══════════════════════════════════════════════════════════════════
class SetLastPeriodScreen extends ConsumerStatefulWidget {
  const SetLastPeriodScreen({super.key});

  @override
  ConsumerState<SetLastPeriodScreen> createState() =>
      _SetLastPeriodScreenState();
}

class _SetLastPeriodScreenState extends ConsumerState<SetLastPeriodScreen> {
  DateTime _displayMonth = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime? _startDate;
  DateTime? _endDate;

  void _prevMonth() => setState(() {
        _displayMonth = DateTime(_displayMonth.year, _displayMonth.month - 1);
      });

  void _nextMonth() => setState(() {
        _displayMonth = DateTime(_displayMonth.year, _displayMonth.month + 1);
      });

  void _selectDay(DateTime day) {
    setState(() {
      if (_startDate == null || (_startDate != null && _endDate != null)) {
        // Premier tap → début de plage
        _startDate = day;
        _endDate = null;
      } else if (day.isBefore(_startDate!)) {
        // Tap avant le début → nouveau début
        _startDate = day;
      } else {
        // Deuxième tap → fin de plage
        _endDate = day;
      }
    });
  }

  bool _isSelected(DateTime day) {
    if (_startDate == null) return false;
    if (_endDate == null) return _isSameDay(day, _startDate!);
    return !day.isBefore(_startDate!) && !day.isAfter(_endDate!);
  }

  bool _isRangeEdge(DateTime day) {
    if (_startDate == null) return false;
    return _isSameDay(day, _startDate!) ||
        (_endDate != null && _isSameDay(day, _endDate!));
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool get _canContinue => _startDate != null;

  Future<void> _finishOnboarding({DateTime? periodStart}) async {
    try {
      await ref
          .read(userProfileProvider.notifier)
          .patch((profile) => profile.copyWith(lastPeriodStart: periodStart))
          .timeout(const Duration(seconds: 3));
    } catch (_) {
      // Entering the app must not depend on a profile write.
    }
    await OnboardingService.setOnboardingCompleted();
    updateOnboardingState(true);
    if (!mounted) return;
    context.go('/cycle');
  }

  @override
  Widget build(BuildContext context) {
final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    // Générer les jours du mois
    final firstDay = DateTime(_displayMonth.year, _displayMonth.month, 1);
    final lastDay = DateTime(_displayMonth.year, _displayMonth.month + 1, 0);
    // Décalage : lundi = 0
    int startOffset = firstDay.weekday - 1; // weekday: 1=Mon

    return OnboardingScaffold(
      showBack: true,
      showSkip: true,
      onSkip: () => _finishOnboarding(),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 72, 24, 12),
              child: Column(
                children: [
                  Text(l10n.whenWasYourLastPeriodTitle,
                      style: AppText.h1, textAlign: TextAlign.center),
                  const SizedBox(height: 10),
                  Text(
                    l10n.whenWasYourLastPeriodSubtitle,
                    style: AppText.body,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.grey200),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Navigation mois
                    Row(
                      children: [
                        _NavArrow(
                            onTap: _prevMonth,
                            icon: Icons.chevron_left_rounded),
                        Expanded(
                          child: Text(
                            DateFormat.yMMMM(locale).format(_displayMonth),
                            style: AppText.h3,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        _NavArrow(
                            onTap: _nextMonth,
                            icon: Icons.chevron_right_rounded),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // En-têtes jours
                    Row(
                      children: List.generate(7, (index) {
                        final weekday = DateTime(2024, 1, 1 + index);
                        final label = DateFormat.E(locale)
                            .format(weekday)
                            .replaceAll('.', '');
                        return Expanded(
                          child: Text(
                            label,
                            style: AppText.caption.copyWith(
                              color: AppColors.grey400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 8),
                    _buildCalendarGrid(firstDay, lastDay, startOffset),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () => _selectDay(DateTime.now()),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.grey200),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(l10n.today, style: AppText.label),
                        ),
                      ),
                    ),
                  ],
                ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: Row(
              children: [
                Expanded(
                  child: OutlineButton(
                    label: l10n.notSure,
                    onPressed: () => _finishOnboarding(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: PrimaryButton(
                    label: l10n.continueCta,
                    onPressed: _canContinue
                        ? () => _finishOnboarding(periodStart: _startDate)
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Construction de la grille calendrier
  Widget _buildCalendarGrid(
      DateTime firstDay, DateTime lastDay, int startOffset) {
    final int totalDays = lastDay.day;
    const crossAxisSpacing = 4.0;
    const mainAxisSpacing = 4.0;
    final int totalCells = MonthGridLayout.cellCount(
      startOffset: startOffset,
      dayCount: totalDays,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final height = MonthGridLayout.heightFor(
          width: constraints.maxWidth,
          rows: MonthGridLayout.rowCount(
            startOffset: startOffset,
            dayCount: totalDays,
          ),
          crossAxisSpacing: crossAxisSpacing,
          mainAxisSpacing: mainAxisSpacing,
        );
        return SizedBox(
          height: height,
          child: _dayGrid(
            totalCells: totalCells,
            totalDays: totalDays,
            startOffset: startOffset,
            crossAxisSpacing: crossAxisSpacing,
            mainAxisSpacing: mainAxisSpacing,
          ),
        );
      },
    );
  }

  Widget _dayGrid({
    required int totalCells,
    required int totalDays,
    required int startOffset,
    required double crossAxisSpacing,
    required double mainAxisSpacing,
  }) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
        childAspectRatio: 1,
      ),
      itemCount: totalCells,
      itemBuilder: (ctx, i) {
        final dayNum = i - startOffset + 1;
        if (dayNum < 1 || dayNum > totalDays) {
          // Cellule vide ou débordement sur mois suivant
          final nextDayNum = dayNum < 1 ? 0 : dayNum - totalDays;
          return Center(
            child: Text(
              dayNum < 1 ? '' : nextDayNum.toString(),
              style: AppText.caption.copyWith(color: AppColors.grey200),
            ),
          );
        }
        final day = DateTime(_displayMonth.year, _displayMonth.month, dayNum);
        final selected = _isSelected(day);
        final edge = _isRangeEdge(day);

        return GestureDetector(
          onTap: () => _selectDay(day),
          child: _DayCell(day: day, selected: selected, isEdge: edge),
        );
      },
    );
  }
}

// ── Cellule jour du calendrier ────────────────────────
class _DayCell extends StatelessWidget {
  final DateTime day;
  final bool selected;
  final bool isEdge;

  const _DayCell(
      {required this.day, required this.selected, required this.isEdge});

  @override
  Widget build(BuildContext context) {
    Color? bg;
    Color textColor = AppColors.black;

    if (isEdge) {
      bg = AppColors.primary;
      textColor = AppColors.white;
    } else if (selected) {
      bg = AppColors.primary100;
      textColor = AppColors.primary;
    }

    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        '${day.day}',
        style: AppText.label.copyWith(
          color: textColor,
          fontWeight: isEdge ? FontWeight.w700 : FontWeight.w500,
          fontSize: 14,
        ),
      ),
    );
  }
}

// ── Flèche navigation mois ─────────────────────────────
class _NavArrow extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;

  const _NavArrow({required this.onTap, required this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.grey200),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 20, color: AppColors.grey700),
      ),
    );
  }
}
