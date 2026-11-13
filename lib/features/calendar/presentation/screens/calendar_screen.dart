import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:peria_app/core/theme/theme.dart';
import 'package:peria_app/features/calendar/presentation/providers/symptom_provider.dart';
import 'package:peria_app/features/calendar/presentation/widgets/day_symptoms_card.dart';
import 'package:peria_app/features/calendar/presentation/day_semantics.dart';
import 'package:peria_app/features/calendar/presentation/widgets/month_grid_layout.dart';
import 'package:peria_app/features/calendar/presentation/calendar_phase_style.dart';
import 'package:peria_app/features/cycle/domain/cycle_phase.dart';
import 'package:peria_app/features/cycle/presentation/models/cycle_day_info.dart';
import 'package:peria_app/features/cycle/presentation/providers/cycle_provider.dart';
import 'package:peria_app/features/journal/presentation/providers/journal_provider.dart';
import 'package:peria_app/l10n/app_localizations.dart';
import 'package:peria_app/shared/widgets/common_widgets.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}
class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime _displayMonth = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime _selectedDate = DateTime.now();

  void _prevMonth() => setState(() {
        _displayMonth = DateTime(_displayMonth.year, _displayMonth.month - 1);
      });

  void _nextMonth() => setState(() {
        _displayMonth = DateTime(_displayMonth.year, _displayMonth.month + 1);
      });

  void _selectDay(DateTime day) {
    setState(() {
      _selectedDate = DateTime(day.year, day.month, day.day);
    });
  }

  DateTime _normalizeDay(DateTime d) => DateTime(d.year, d.month, d.day);

  bool _isToday(DateTime day) {
    final now = DateTime.now();
    return day.year == now.year && day.month == now.month && day.day == now.day;
  }

  bool _containsDay(Set<DateTime> days, DateTime target) {
    final normalized = _normalizeDay(target);
    return days.any((day) => _normalizeDay(day) == normalized);
  }

  String _formatDate(DateTime date, String locale) =>
      DateFormat.yMMMMd(locale).format(date);

  String _phaseLabel(CyclePhase phase, AppLocalizations l10n) {
    switch (phase) {
      case CyclePhase.menstrual:
        return l10n.cyclePhasePeriod;
      case CyclePhase.follicular:
        return l10n.cyclePhaseFollicular;
      case CyclePhase.ovulation:
        return l10n.cyclePhaseOvulation;
      case CyclePhase.luteal:
        return l10n.cyclePhaseLuteal;
    }
  }

  String _phaseDetail(CycleDayInfo cycleDay, AppLocalizations l10n) {
    if (cycleDay.isOverdue) return l10n.calendarExpectedNotLogged;
    if (cycleDay.isLoggedPeriod) return l10n.calendarLoggedPeriodDescription;
    if (cycleDay.isPredictedPeriod) {
      return l10n.calendarPredictedPeriodDescription;
    }
    if (cycleDay.isPmsDay) return l10n.calendarPmsDayDescription;
    if (cycleDay.isFertileWindow) return l10n.calendarFertilityWindowDescription;
    return l10n.calendarSelectedDay;
  }

  _CalendarDayState _dayState(
    DateTime day,
    CycleDayInfo cycleDay,
    AppLocalizations l10n,
  ) {
    final phase = cycleDay.phase;
    if (phase == null) {
      if (_isToday(day)) {
        return _CalendarDayState(
          label: l10n.todayLabel,
          description: l10n.calendarNoCyclePredictionAvailable,
          color: AppColors.grey900,
          softColor: AppColors.grey100,
          icon: Icons.today_rounded,
        );
      }
      return _CalendarDayState(
        label: l10n.calendarNoCycleData,
        description: l10n.calendarNoCyclePredictionAvailable,
        color: AppColors.grey700,
        softColor: AppColors.grey100,
        icon: Icons.calendar_today_outlined,
      );
    }

    final style = CalendarPhaseStyle.of(phase);
    return _CalendarDayState(
      label: _phaseLabel(phase, l10n),
      description: _phaseDetail(cycleDay, l10n),
      color: cycleDay.isOverdue ? AppColors.error : style.foreground,
      softColor: cycleDay.isOverdue ? const Color(0xFFFFE6E6) : style.background,
      icon: cycleDay.isOverdue ? Icons.warning_amber_rounded : style.icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final firstDay = DateTime(_displayMonth.year, _displayMonth.month, 1);
    final lastDay = DateTime(_displayMonth.year, _displayMonth.month + 1, 0);
    int startOffset = firstDay.weekday - 1;
    final selectedCycleDay = ref.watch(cycleDayInfoProvider(_selectedDate));
    final selectedState = _dayState(_selectedDate, selectedCycleDay, l10n);
    final symptomDays = ref.watch(symptomDaysProvider);
    final journalDays = ref.watch(journalDaysProvider);

    return PageScaffold(
      showBack: true,
      onBack: () => safeRouterBack(context, fallbackRoute: '/cycle'),
      showTitle: true,
      title: l10n.calendarTitle,
      // The scroll view must be the direct child of the scaffold: wrapping it
      // in a Column without Expanded leaves it unconstrained and it never scrolls.
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 100, bottom: 32),
        child: Column(
          children: [
            // ── Calendrier Card ────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
              child: Container(
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
                          icon: Icons.chevron_left_rounded,
                          semanticLabel: l10n.previousMonth,
                        ),
                        Expanded(
                          child: Text(
                            DateFormat.yMMMM(locale).format(_displayMonth),
                            style: AppText.h4,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        _NavArrow(
                          onTap: _nextMonth,
                          icon: Icons.chevron_right_rounded,
                          semanticLabel: l10n.nextMonth,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Weekday headings follow the app's selected locale.
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
                              color: AppColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 12),

                    // Grille des jours
                    _buildCalendarGrid(
                      firstDay,
                      lastDay,
                      startOffset,
                      symptomDays: symptomDays,
                      journalDays: journalDays,
                    ),
                    const SizedBox(height: 16),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: selectedState.softColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: selectedState.color.withOpacity(0.14),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color:
                                  selectedState.color.withOpacity(0.12),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              selectedState.icon,
                              color: selectedState.color,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _formatDate(_selectedDate, locale),
                                  style: AppText.label.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.grey900,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  selectedState.label,
                                  style: AppText.body.copyWith(
                                    color: selectedState.color,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  selectedState.description,
                                  style: AppText.caption.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 16,
                      runSpacing: 10,
                      children: [
                        for (final phase in CyclePhase.values)
                          _buildLegendItem(
                            _phaseLabel(phase, l10n),
                            CalendarPhaseStyle.of(phase).accent,
                          ),
                        _buildLegendItem(
                          l10n.calendarLegendSymptoms,
                          AppColors.success,
                        ),
                        _buildLegendItem(
                          l10n.calendarLegendJournal,
                          AppColors.grey700,
                        ),
                        _buildLegendItem(
                          l10n.calendarLegendToday,
                          AppColors.grey900,
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: () => context.push('/edit-calendar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.grey900,
                          foregroundColor: AppColors.white,
                          elevation: 0,
                          shape: const StadiumBorder(),
                        ),
                        icon: const Icon(Icons.edit_outlined, size: 18),
                        label: Text(
                          l10n.calendarEditPeriod,
                          style: AppText.label.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
              child: DaySymptomsCard(
                date: _selectedDate,
                onEdit: () => context.push('/symptoms'),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Légende
  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: AppText.caption),
      ],
    );
  }

  // Grille
  Widget _buildCalendarGrid(
    DateTime firstDay,
    DateTime lastDay,
    int startOffset, {
    required Set<DateTime> symptomDays,
    required Set<DateTime> journalDays,
  }) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final monthDays = ref.watch(
      monthCycleDayInfoProvider(
        DateTime(_displayMonth.year, _displayMonth.month),
      ),
    );
    final int totalDays = lastDay.day;
    const crossAxisSpacing = 4.0;
    const mainAxisSpacing = 6.0;
    const dayCellHeight = 52.0;
    final rows = MonthGridLayout.rowCount(
      startOffset: startOffset,
      dayCount: totalDays,
    );
    final totalCells = MonthGridLayout.cellCount(
      startOffset: startOffset,
      dayCount: totalDays,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final height = MonthGridLayout.heightFor(
          width: constraints.maxWidth,
          rows: rows,
          crossAxisSpacing: crossAxisSpacing,
          mainAxisSpacing: mainAxisSpacing,
          mainAxisExtent: dayCellHeight,
        );
        return SizedBox(
          height: height,
          child: GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisExtent: dayCellHeight,
      ),
      itemCount: totalCells,
      itemBuilder: (ctx, i) {
        final dayNum = i - startOffset + 1;
        if (dayNum < 1 || dayNum > totalDays) {
          final nextDayNum = dayNum < 1 ? 0 : dayNum - totalDays;
          return ExcludeSemantics(
            child: Center(
              child: Text(
                dayNum < 1 ? '' : nextDayNum.toString(),
                style: AppText.caption.copyWith(color: AppColors.grey200),
              ),
            ),
          );
        }
        final day = DateTime(_displayMonth.year, _displayMonth.month, dayNum);

        bool isSelected = day.year == _selectedDate.year &&
            day.month == _selectedDate.month &&
            day.day == _selectedDate.day;

        final cycleDay = monthDays[dayNum];
        if (cycleDay == null) return const SizedBox.shrink();
        final isToday = _isToday(day);
        final hasSymptoms = _containsDay(symptomDays, day);
        final hasJournal = _containsDay(journalDays, day);

        return Semantics(
          button: true,
          selected: isSelected,
          label: calendarDaySemanticsLabel(
            dateLabel: DateFormat.yMMMMd(locale).format(day),
            isToday: isToday,
            isLoggedPeriod: cycleDay.isLoggedPeriod,
            isPredictedPeriod: cycleDay.isPredictedPeriod,
            isFertileWindow: cycleDay.isFertileWindow,
            isPms: cycleDay.isPmsDay,
            hasSymptoms: hasSymptoms,
            hasJournal: hasJournal,
            todayLabel: l10n.calendarLegendToday,
            loggedPeriodLabel: l10n.calendarLegendLoggedPeriod,
            predictedPeriodLabel: l10n.calendarLegendPredictedPeriod,
            fertilityWindowLabel: l10n.calendarLegendFertilityWindow,
            pmsLabel: l10n.calendarLegendPmsDay,
            symptomsLabel: l10n.calendarLegendSymptoms,
            journalLabel: l10n.calendarLegendJournal,
          ),
          child: ExcludeSemantics(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _selectDay(day),
              child: _DayCell(
                day: day,
                isSelected: isSelected,
                phase: cycleDay.phase,
                isLoggedPeriod: cycleDay.isLoggedPeriod,
                isPredictedPeriod: cycleDay.isPredictedPeriod,
                isFertileWindow: cycleDay.isFertileWindow,
                isPms: cycleDay.isPmsDay,
                isToday: isToday,
                hasSymptoms: hasSymptoms,
                hasJournal: hasJournal,
              ),
            ),
          ),
        );
      },
            ),
          );
        },
      );
  }
}

class _DayCell extends StatelessWidget {
  final DateTime day;
  final bool isSelected;
  final CyclePhase? phase;
  final bool isLoggedPeriod;
  final bool isPredictedPeriod;
  final bool isFertileWindow;
  final bool isPms;
  final bool isToday;
  final bool hasSymptoms;
  final bool hasJournal;

  const _DayCell({
    required this.day,
    required this.isSelected,
    required this.phase,
    this.isLoggedPeriod = false,
    this.isPredictedPeriod = false,
    this.isFertileWindow = false,
    this.isPms = false,
    this.isToday = false,
    this.hasSymptoms = false,
    this.hasJournal = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = phase == null ? null : CalendarPhaseStyle.of(phase!);
    final bgColor = style?.background ?? Colors.transparent;
    final textColor = style?.foreground ?? AppColors.neutral900;
    final accent = style?.accent ?? AppColors.grey300;
    final borderColor = isSelected
        ? AppColors.grey900
        : isToday
            ? AppColors.grey900
            : accent.withOpacity(style == null ? 0 : 0.45);
    final marker = hasSymptoms
        ? AppColors.success
        : hasJournal
            ? AppColors.grey700
            : Colors.transparent;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor,
          width: isSelected || isToday ? 1.6 : 1,
        ),
      ),
      child: Stack(
        children: [
          if (style != null)
            Positioned(
              left: 8,
              right: 8,
              bottom: 5,
              child: Container(
                height: 3,
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
          Center(
            child: Text(
              '${day.day}',
              style: AppText.label.copyWith(
                color: textColor,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ),
          if (isLoggedPeriod || isPredictedPeriod || isFertileWindow || isPms)
            Positioned(
              right: 3,
              top: 3,
              child: Icon(
                isLoggedPeriod
                    ? Icons.water_drop
                    : isPredictedPeriod
                        ? Icons.water_drop_outlined
                        : isPms
                            ? Icons.bolt_rounded
                            : Icons.auto_awesome,
                size: 9,
                color: textColor.withOpacity(0.8),
              ),
            ),
          if (marker != Colors.transparent)
            Positioned(
              left: 5,
              top: 5,
              child: Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: marker,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CalendarDayState {
  final String label;
  final String description;
  final Color color;
  final Color softColor;
  final IconData icon;

  const _CalendarDayState({
    required this.label,
    required this.description,
    required this.color,
    required this.softColor,
    required this.icon,
  });
}

class _NavArrow extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final String semanticLabel;

  const _NavArrow({
    required this.onTap,
    required this.icon,
    required this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    // 44 px keeps the touch target inside the accessibility minimum while the
    // glyph stays the same size as the mockup.
    return Semantics(
      button: true,
      label: semanticLabel,
      child: ExcludeSemantics(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.grey200),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: AppColors.grey700),
          ),
        ),
      ),
    );
  }
}
