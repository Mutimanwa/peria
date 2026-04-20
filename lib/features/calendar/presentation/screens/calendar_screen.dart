import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:perla_app/core/storage/app_settings.dart';
import 'package:perla_app/core/storage/app_settings_provider.dart';
import 'package:perla_app/core/theme/theme.dart';
import 'package:perla_app/features/cycle/data/models/period_log.dart';
import 'package:perla_app/features/cycle/presentation/providers/cycle_provider.dart';
import 'package:perla_app/features/profile/presentation/providers/user_profile_provider.dart';
import 'package:perla_app/shared/widgets/common_widgets.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime _displayMonth = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime _selectedDate = DateTime.now();
  // Navigation state is now managed by ShellNavigation
  // NavItem _activeTab = NavItem.cycle; // Removed - managed by shell

  static const List<String> _monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  static const List<String> _weekDays = [
    'mo',
    'tu',
    'we',
    'th',
    'fr',
    'sa',
    'su'
  ];

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
        final today = DateTime.now();
        final todayStart = DateTime(today.year, today.month, today.day);

        Future<void> savePeriodLog({
          required DateTime start,
          required DateTime end,
        }) async {
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

          if (mounted) Navigator.of(context).pop();
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
                const Text('Log period', style: AppText.h4),
                const SizedBox(height: 6),
                Text(
                  'Quick daily capture. Use Edit Calendar when you need a precise correction.',
                  style: AppText.body.copyWith(color: AppColors.grey600),
                ),
                const SizedBox(height: 18),
                _QuickActionTile(
                  icon: Icons.play_arrow_rounded,
                  title: 'Period started today',
                  subtitle: 'Save today as the first day of your period.',
                  color: AppColors.primary400,
                  onTap: () => savePeriodLog(start: todayStart, end: todayStart),
                ),
                const SizedBox(height: 12),
                _QuickActionTile(
                  icon: Icons.water_drop_outlined,
                  title: 'Add today as a period day',
                  subtitle: 'Extend your latest period log with one more day.',
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
                  title: 'Period ended today',
                  subtitle: 'Close your latest log with today as the end date.',
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
                  label: 'Open structured edit',
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

  DateTime _startOfDay(DateTime d) => DateTime(d.year, d.month, d.day);
  DateTime _endOfDay(DateTime d) =>
      DateTime(d.year, d.month, d.day, 23, 59, 59, 999);

  bool _inRange(DateTime day, DateTime? start, DateTime? end) {
    if (start == null || end == null) return false;
    final xStart = _startOfDay(day);
    final xEnd = _endOfDay(day);
    return (xStart.isAtSameMomentAs(start) || xStart.isAfter(start)) &&
        (xEnd.isAtSameMomentAs(end) || xEnd.isBefore(end));
  }

  bool _isPeriodDay(DateTime day) {
    final logsState = ref.watch(periodLogsProvider);
    final logs = logsState.value ?? const [];
    for (final log in logs) {
      if (_inRange(day, log.startDate, log.endDate)) return true;
    }

    // Fallback: if no logs, use onboarding lastPeriodStart as an initial period range.
    final profile = ref.watch(userProfileProvider).value;
    final last = profile?.lastPeriodStart;
    if (last == null) return false;
    final settings =
        ref.watch(appSettingsProvider).value ?? const AppSettings();
    final end = last.add(Duration(
      days: (settings.periodLengthDays - 1).clamp(0, 60),
      hours: 23,
      minutes: 59,
      seconds: 59,
      milliseconds: 999,
    ));
    return _inRange(day, last, end);
  }

  bool _isOvulationDay(DateTime day) {
    final status = ref.watch(cycleStatusProvider);
    if (status == null) return false;
    return _inRange(day, status.fertileWindowStart, status.fertileWindowEnd);
  }

  bool _isPmsDay(DateTime day) {
    final status = ref.watch(cycleStatusProvider);
    if (status == null) return false;
    final nextStart = status.nextPeriodStart;
    final pmsStart = nextStart.subtract(const Duration(days: 5));
    final pmsEnd = nextStart.subtract(const Duration(days: 1));
    return _inRange(day, pmsStart, pmsEnd);
  }

  bool _isToday(DateTime day) {
    final now = DateTime.now();
    return day.year == now.year && day.month == now.month && day.day == now.day;
  }

  String _formatDate(DateTime date) {
    return '${_monthNames[date.month - 1]} ${date.day}, ${date.year}';
  }

  _CalendarDayState _dayState(DateTime day) {
    if (_isPeriodDay(day)) {
      return const _CalendarDayState(
        label: 'Period day',
        description: 'Your period is tracked on this date.',
        color: AppColors.primary400,
        softColor: AppColors.primary50,
        icon: Icons.water_drop_outlined,
      );
    }
    if (_isOvulationDay(day)) {
      return const _CalendarDayState(
        label: 'Fertility window',
        description: 'This date is inside your predicted fertile window.',
        color: AppColors.secondary500,
        softColor: AppColors.secondary50,
        icon: Icons.auto_awesome,
      );
    }
    if (_isPmsDay(day)) {
      return const _CalendarDayState(
        label: 'PMS day',
        description: 'This date falls in your predicted PMS phase.',
        color: AppColors.warning700,
        softColor: AppColors.warning50,
        icon: Icons.bolt_rounded,
      );
    }
    if (_isToday(day)) {
      return const _CalendarDayState(
        label: 'Today',
        description: 'You selected today in your cycle calendar.',
        color: AppColors.grey900,
        softColor: AppColors.grey100,
        icon: Icons.today_rounded,
      );
    }
    return const _CalendarDayState(
      label: 'Regular day',
      description: 'No tracked cycle event is attached to this date.',
      color: AppColors.grey700,
      softColor: AppColors.grey100,
      icon: Icons.calendar_today_outlined,
    );
  }

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(_displayMonth.year, _displayMonth.month, 1);
    final lastDay = DateTime(_displayMonth.year, _displayMonth.month + 1, 0);
    int startOffset = firstDay.weekday - 1;
    final selectedState = _dayState(_selectedDate);

    return PageScaffold(
      showBack: true,
      onBack: () => safeRouterBack(context, fallbackRoute: '/cycle'),
      showTitle: true,
      title: 'Cycle Calendar',
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 100, bottom: 120), // Espace sous l'AppBar et pour la nav
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
                                  '${_monthNames[_displayMonth.month - 1]} ${_displayMonth.year}',
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

                          // En-têtes jours
                          Row(
                            children: _weekDays
                                .map((d) => Expanded(
                                      child: Text(d,
                                          style: AppText.caption.copyWith(
                                              color: AppColors.grey400),
                                          textAlign: TextAlign.center),
                                    ))
                                .toList(),
                          ),
                          const SizedBox(height: 12),

                          // Grille des jours
                          _buildCalendarGrid(firstDay, lastDay, startOffset),
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
                                        _formatDate(_selectedDate),
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
                                  'Monthly overview',
                                  style: AppText.label.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.grey900,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'This screen is for reading the cycle across time. Use quick log for daily capture and Edit Calendar for corrections.',
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
                              _buildLegendItem('pms day', AppColors.warning50),
                              _buildLegendItem('period day', AppColors.primary50),
                              _buildLegendItem('ovulation day', AppColors.secondary100),
                              _buildLegendItem('today', AppColors.grey900),
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
                          const Text('Quick capture', style: AppText.h4),
                          const SizedBox(height: 8),
                          Text(
                            'Fast daily actions for period and symptoms, without opening the structured editor.',
                            style: AppText.body.copyWith(color: AppColors.grey600),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: PrimaryButton(
                                  label: 'Log Period',
                                  onPressed: _showQuickPeriodSheet,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: OutlineButton(
                                  label: 'Log Symptoms',
                                  onPressed: () => context.go('/symptoms'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Need to define or fix a date range? Use Edit Calendar.',
                            style: AppText.caption.copyWith(color: AppColors.grey600),
                          ),
                          const SizedBox(height: 12),
                          OutlineButton(
                            label: 'Edit Calendar',
                            onPressed: () => context.push('/edit-calendar'),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Résumé des symptômes Card ────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.secondary50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Symptoms snapshot', style: AppText.h4),
                          const SizedBox(height: 8),
                          Text(
                            'Track daily observations like pain, mood, fatigue or discharge.',
                            style:
                                AppText.body.copyWith(color: AppColors.grey600),
                          ),
                          const SizedBox(height: 16),
                          OutlineButton(
                            label: '+ Log Symptoms',
                            onPressed: () {
                              context.go("/symptoms");
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
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
      DateTime firstDay, DateTime lastDay, int startOffset) {
    final int totalDays = lastDay.day;
    final int totalCells = ((startOffset + totalDays) / 7).ceil() * 7;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 8,
        crossAxisSpacing: 4,
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

        return GestureDetector(
          onTap: () => _selectDay(day),
          child: _DayCell(
            day: day,
            isSelected: isSelected,
            isPeriod: _isPeriodDay(day),
            isOvulation: _isOvulationDay(day),
            isPms: _isPmsDay(day),
            isToday: _isToday(day),
          ),
        );
      },
    );
  }
}

class _DayCell extends StatelessWidget {
  final DateTime day;
  final bool isSelected;
  final bool isPeriod;
  final bool isOvulation;
  final bool isPms;
  final bool isToday;

  const _DayCell({
    required this.day,
    required this.isSelected,
    this.isPeriod = false,
    this.isOvulation = false,
    this.isPms = false,
    this.isToday = false,
  });

  @override
  Widget build(BuildContext context) {
    Color? bgColor;
    Color textColor = AppColors.neutral900;
    Color borderColor = Colors.transparent;
    IconData? badgeIcon;

    if (isPeriod) {
      bgColor = AppColors.primary50;
      textColor = AppColors.primary400;
      borderColor = AppColors.primary100;
      badgeIcon = Icons.water_drop;
    } else if (isOvulation) {
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
