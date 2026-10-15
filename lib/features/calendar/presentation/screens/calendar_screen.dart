import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:peria_app/core/theme/theme.dart';
import 'package:peria_app/features/calendar/presentation/providers/symptom_provider.dart';
import 'package:peria_app/features/calendar/presentation/widgets/month_grid_layout.dart';
import 'package:peria_app/features/cycle/data/models/period_log.dart';
import 'package:peria_app/features/cycle/presentation/models/cycle_day_info.dart';
import 'package:peria_app/features/cycle/presentation/providers/cycle_provider.dart';
import 'package:peria_app/features/journal/presentation/providers/journal_provider.dart';
import 'package:peria_app/features/profile/presentation/providers/user_profile_provider.dart';
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
      _selectedDate = day;
    });
  }

  Future<void> _showQuickPeriodSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final l10n = AppLocalizations.of(context);
        final today = DateTime.now();
        final todayStart = DateTime(today.year, today.month, today.day);

        Future<void> savePeriodLog({
          required DateTime start,
          required DateTime end,
        }) async {
          final navigator = Navigator.of(context);
          final log = PeriodLog(
            id: DateTime.now().microsecondsSinceEpoch.toString(),
            startDate: start,
            endDate: end,
            isEstimated: false,
          );
          await ref.read(periodLogsProvider.notifier).add(log);

          final currentProfile = ref.read(userProfileProvider).value;
          final currentLast = currentProfile?.lastPeriodStart;
          if (currentLast == null || start.isAfter(currentLast)) {
            await ref.read(userProfileProvider.notifier).patch(
                  (p) => p.copyWith(lastPeriodStart: start),
                );
          }

          if (mounted) navigator.pop();
        }

        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(28),
            ),
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
                Text(l10n.periodLogSheetTitle, style: AppText.h4),
                const SizedBox(height: 6),
                Text(
                  l10n.periodLogSheetSubtitle,
                  style: AppText.body.copyWith(color: AppColors.grey600),
                ),
                const SizedBox(height: 18),
                _QuickActionTile(
                  icon: Icons.play_arrow_rounded,
                  title: l10n.periodStartedToday,
                  subtitle: l10n.periodStartedTodaySubtitle,
                  color: AppColors.primary400,
                  onTap: () =>
                      savePeriodLog(start: todayStart, end: todayStart),
                ),
                const SizedBox(height: 12),
                _QuickActionTile(
                  icon: Icons.water_drop_outlined,
                  title: l10n.addTodayPeriodDay,
                  subtitle: l10n.addTodayPeriodDaySubtitle,
                  color: AppColors.primary500,
                  onTap: () {
                    final logs = ref.read(periodLogsProvider).value ?? const [];
                    if (logs.isEmpty) {
                      savePeriodLog(start: todayStart, end: todayStart);
                      return;
                    }
                    final latest = logs.first;
                    final updated = PeriodLog(
                      id: latest.id,
                      startDate: latest.startDate,
                      endDate: todayStart.isAfter(latest.endDate)
                          ? todayStart
                          : latest.endDate,
                      isEstimated: latest.isEstimated,
                    );
                    ref.read(periodLogsProvider.notifier).add(updated);
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(height: 12),
                _QuickActionTile(
                  icon: Icons.stop_rounded,
                  title: l10n.periodEndedToday,
                  subtitle: l10n.periodEndedTodaySubtitle,
                  color: AppColors.warning700,
                  onTap: () {
                    final logs = ref.read(periodLogsProvider).value ?? const [];
                    if (logs.isEmpty) {
                      Navigator.of(context).pop();
                      return;
                    }
                    final latest = logs.first;
                    final updated = PeriodLog(
                      id: latest.id,
                      startDate: latest.startDate,
                      endDate: todayStart,
                      isEstimated: latest.isEstimated,
                    );
                    ref.read(periodLogsProvider.notifier).add(updated);
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(height: 16),
                OutlineButton(
                  label: l10n.openStructuredPeriodEdit,
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.push('/edit-calendar');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
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

  _CalendarDayState _dayState(
    DateTime day,
    CycleDayInfo cycleDay,
    AppLocalizations l10n,
  ) {
    if (cycleDay.status == null && !cycleDay.isLoggedPeriod) {
      return _CalendarDayState(
        label: l10n.calendarNoCycleData,
        description: l10n.calendarNoCyclePredictionAvailable,
        color: AppColors.grey700,
        softColor: AppColors.grey100,
        icon: Icons.calendar_today_outlined,
      );
    }
    if (cycleDay.isOverdue) {
      return _CalendarDayState(
        label: l10n.calendarOverdue,
        description: l10n.calendarExpectedNotLogged,
        color: AppColors.error,
        softColor: Color(0xFFFFE6E6),
        icon: Icons.warning_amber_rounded,
      );
    }
    if (cycleDay.isLoggedPeriod) {
      return _CalendarDayState(
        label: l10n.calendarLoggedPeriodDay,
        description: l10n.calendarLoggedPeriodDescription,
        color: AppColors.primary400,
        softColor: AppColors.primary50,
        icon: Icons.water_drop,
      );
    }
    if (cycleDay.isPredictedPeriod) {
      return _CalendarDayState(
        label: l10n.calendarPredictedPeriodDay,
        description: l10n.calendarPredictedPeriodDescription,
        color: AppColors.primary400,
        softColor: AppColors.primary50,
        icon: Icons.water_drop_outlined,
      );
    }
    if (cycleDay.isFertileWindow) {
      return _CalendarDayState(
        label: l10n.calendarFertilityWindow,
        description: l10n.calendarFertilityWindowDescription,
        color: AppColors.secondary500,
        softColor: AppColors.secondary50,
        icon: Icons.auto_awesome,
      );
    }
    if (cycleDay.isPmsDay) {
      return _CalendarDayState(
        label: l10n.calendarPmsDay,
        description: l10n.calendarPmsDayDescription,
        color: AppColors.warning700,
        softColor: AppColors.warning50,
        icon: Icons.bolt_rounded,
      );
    }
    if (_isToday(day)) {
      return _CalendarDayState(
        label: l10n.todayLabel,
        description: l10n.calendarSelectedDay,
        color: AppColors.grey900,
        softColor: AppColors.grey100,
        icon: Icons.today_rounded,
      );
    }
    return _CalendarDayState(
      label: l10n.calendarRegularDay,
      description: l10n.calendarNoTrackedCycleEvent,
      color: AppColors.grey700,
      softColor: AppColors.grey100,
      icon: Icons.calendar_today_outlined,
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
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 100, bottom: 16),
              child: Column(
                children: [
                  // ── Calendrier Card ────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
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
                                  icon: Icons.chevron_left_rounded),
                              Expanded(
                                child: Text(
                                  DateFormat.yMMMM(locale).format(_displayMonth),
                                  style: AppText.h4,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              _NavArrow(
                                  onTap: _nextMonth,
                                  icon: Icons.chevron_right_rounded),
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
                                    color: AppColors.grey400,
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
                                          color: AppColors.grey600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColors.grey50,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.grey200),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.calendarMonthlyOverview,
                                  style: AppText.label.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.grey900,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  l10n.calendarMonthlyOverviewHelp,
                                  style: AppText.caption.copyWith(
                                    color: AppColors.grey600,
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
                              _buildLegendItem(l10n.calendarLegendPmsDay, AppColors.warning50),
                              _buildLegendItem(l10n.calendarLegendLoggedPeriod, AppColors.primary100),
                              _buildLegendItem(l10n.calendarLegendPredictedPeriod, AppColors.primary50),
                              _buildLegendItem(l10n.calendarLegendFertilityWindow, AppColors.secondary100),
                              _buildLegendItem(l10n.calendarLegendSymptoms, AppColors.success),
                              _buildLegendItem(l10n.calendarLegendJournal, AppColors.grey700),
                              _buildLegendItem(l10n.calendarLegendToday, AppColors.grey900),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.grey200),
                      ),
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.calendarQuickCapture, style: AppText.h4),
                          const SizedBox(height: 8),
                          Text(
                            l10n.calendarQuickCaptureHelp,
                            style:
                                AppText.body.copyWith(color: AppColors.grey600),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.calendarDateRangeHelp,
                            style: AppText.caption
                                .copyWith(color: AppColors.grey600),
                          ),
                          const SizedBox(height: 12),
                          OutlineButton(
                            label: l10n.calendarEditTitle,
                            onPressed: () => context.push('/edit-calendar'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
            child: Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    label: l10n.logPeriodButton,
                    onPressed: _showQuickPeriodSheet,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlineButton(
                    label: l10n.logSymptoms,
                    onPressed: () => context.push('/symptoms'),
                  ),
                ),
              ],
            ),
          ),
        ],
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
    final int totalDays = lastDay.day;
    const crossAxisSpacing = 4.0;
    const mainAxisSpacing = 8.0;
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
        childAspectRatio: 1,
      ),
      itemCount: totalCells,
      itemBuilder: (ctx, i) {
        final dayNum = i - startOffset + 1;
        if (dayNum < 1 || dayNum > totalDays) {
          final nextDayNum = dayNum < 1 ? 0 : dayNum - totalDays;
          return Center(
            child: Text(
              dayNum < 1 ? '' : nextDayNum.toString(),
              style: AppText.caption.copyWith(color: AppColors.grey200),
            ),
          );
        }
        final day = DateTime(_displayMonth.year, _displayMonth.month, dayNum);

        bool isSelected = day.year == _selectedDate.year &&
            day.month == _selectedDate.month &&
            day.day == _selectedDate.day;

        final cycleDay = ref.watch(cycleDayInfoProvider(day));

        return GestureDetector(
          onTap: () => _selectDay(day),
          child: _DayCell(
            day: day,
            isSelected: isSelected,
            isLoggedPeriod: cycleDay.isLoggedPeriod,
            isPredictedPeriod: cycleDay.isPredictedPeriod,
            isFertileWindow: cycleDay.isFertileWindow,
            isPms: cycleDay.isPmsDay,
            isToday: _isToday(day),
            hasSymptoms: _containsDay(symptomDays, day),
            hasJournal: _containsDay(journalDays, day),
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
    Color? bgColor;
    Color textColor = AppColors.neutral900;
    Color borderColor = Colors.transparent;
    IconData? badgeIcon;
    Color secondaryDotColor = Colors.transparent;

    if (isLoggedPeriod) {
      bgColor = AppColors.primary100;
      textColor = AppColors.primary400;
      borderColor = AppColors.primary200;
      badgeIcon = Icons.water_drop;
    } else if (isPredictedPeriod) {
      bgColor = AppColors.primary50;
      textColor = AppColors.primary400;
      borderColor = AppColors.primary100;
      badgeIcon = Icons.water_drop_outlined;
    } else if (isFertileWindow) {
      bgColor = AppColors.secondary100;
      textColor = AppColors.secondary500;
      borderColor = AppColors.secondary200;
      badgeIcon = Icons.auto_awesome;
    } else if (isPms) {
      bgColor = AppColors.warning50;
      textColor = AppColors.warning700;
      borderColor = AppColors.warning200;
      badgeIcon = Icons.bolt_rounded;
    }

    if (isSelected) {
      bgColor = AppColors.grey900;
      textColor = AppColors.white;
      borderColor = AppColors.grey900;
    } else if (isToday) {
      borderColor = AppColors.grey300;
    }

    if (hasSymptoms) {
      secondaryDotColor = AppColors.success;
    } else if (hasJournal) {
      secondaryDotColor = AppColors.grey700;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Stack(
        children: [
          Center(
            child: Text(
              '${day.day}',
              style: AppText.label.copyWith(
                color: textColor,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
          if (!isSelected && badgeIcon != null)
            Positioned(
              right: 4,
              bottom: 4,
              child: Icon(
                badgeIcon,
                size: 10,
                color: textColor.withOpacity(0.75),
              ),
            ),
          if (!isSelected && secondaryDotColor != Colors.transparent)
            Positioned(
              left: 5,
              bottom: 5,
              child: Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: secondaryDotColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          if (!isSelected && isToday)
            Positioned(
              top: 5,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 5,
                  height: 5,
                  decoration: const BoxDecoration(
                    color: AppColors.grey900,
                    shape: BoxShape.circle,
                  ),
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

class _QuickActionTile extends StatelessWidget {
  const _QuickActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 20),
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
                      color: AppColors.grey900,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppText.caption.copyWith(color: AppColors.grey600),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.grey500,
            ),
          ],
        ),
      ),
    );
  }
}
