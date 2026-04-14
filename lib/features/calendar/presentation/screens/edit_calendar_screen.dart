import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:perla_app/core/theme/app_colors.dart';
import 'package:perla_app/core/theme/app_text.dart';
import 'package:perla_app/core/theme/app_typography.dart';
import 'package:perla_app/features/cycle/data/models/period_log.dart';
import 'package:perla_app/features/cycle/presentation/providers/cycle_provider.dart';
import 'package:perla_app/features/profile/presentation/providers/user_profile_provider.dart';
import 'package:perla_app/shared/widgets/common_widgets.dart';

class EditCalendarScreen extends ConsumerStatefulWidget {
  const EditCalendarScreen({super.key});

  @override
  ConsumerState<EditCalendarScreen> createState() => _EditCalendarScreenState();
}

class _EditCalendarScreenState extends ConsumerState<EditCalendarScreen> {
  DateTime? _startDate;
  DateTime? _endDate;

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

  bool get _canSave => _startDate != null;

  String _formatDate(DateTime date) {
    return '${_monthNames[date.month - 1]} ${date.day}';
  }

  String get _selectionTitle {
    final start = _startDate;
    if (start == null) return 'Structured period edit';
    final end = _endDate;
    if (end == null) return 'Start date selected';
    return 'Period range ready';
  }

  String get _selectionSubtitle {
    final start = _startDate;
    if (start == null) {
      return 'Use this screen to define or correct an exact period range.';
    }
    final end = _endDate;
    if (end == null) {
      return '${_formatDate(start)} selected. Now choose the last day for this structured edit.';
    }
    final duration = end.difference(start).inDays + 1;
    return '${_formatDate(start)} - ${_formatDate(end)} • $duration days';
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      showBack: true,
      onBack: () => context.pop(),
      showTitle: true,
      title: 'Edit Calendar',
      child: Padding(
        padding: const EdgeInsets.only(top: 80, bottom: 20),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.grey200),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _canSave ? AppColors.primary50 : AppColors.grey50,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color:
                          _canSave ? AppColors.primary100 : AppColors.grey200,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: _canSave
                              ? AppColors.primary.withOpacity(0.12)
                              : AppColors.grey200,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _endDate == null
                              ? Icons.date_range_rounded
                              : Icons.check_rounded,
                          color:
                              _canSave ? AppColors.primary : AppColors.grey600,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _selectionTitle,
                              style: AppText.label.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.grey900,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _selectionSubtitle,
                              style: AppText.body.copyWith(
                                color: AppColors.grey600,
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
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.grey50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.grey200),
                  ),
                  child: Text(
                    'This screen is for precise corrections. For quick daily updates, use Log Period from the calendar overview.',
                    style: AppText.caption.copyWith(color: AppColors.grey600),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  itemCount: 12, // Par exemple, les 12 mois à venir/passés
                  itemBuilder: (context, index) {
                    final targetMonth = DateTime.now().month - 3 + index;
                    final monthDate =
                        DateTime(DateTime.now().year, targetMonth, 1);
                    return _buildMonthSection(monthDate);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: PrimaryButton(
                  label: _endDate == null ? 'Save start date' : 'Save period range',
                  onPressed: _canSave
                      ? () {
                          final start = _startDate!;
                          final end = _endDate ?? _startDate!;
                          final now = DateTime.now();
                          final log = PeriodLog(
                            id: now.microsecondsSinceEpoch.toString(),
                            startDate:
                                DateTime(start.year, start.month, start.day),
                            endDate: DateTime(end.year, end.month, end.day),
                            isEstimated: false,
                          );
                          ref.read(periodLogsProvider.notifier).add(log);

                          // Keep profile in sync: lastPeriodStart should reflect the most recent known start.
                          final currentProfile =
                              ref.read(userProfileProvider).value;
                          final currentLast = currentProfile?.lastPeriodStart;
                          if (currentLast == null ||
                              start.isAfter(currentLast)) {
                            ref.read(userProfileProvider.notifier).patch(
                                  (p) => p.copyWith(lastPeriodStart: start),
                                );
                          }

                          context.pop();
                        }
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMonthSection(DateTime monthDate) {
    final firstDay = DateTime(monthDate.year, monthDate.month, 1);
    final lastDay = DateTime(monthDate.year, monthDate.month + 1, 0);
    int startOffset = firstDay.weekday - 1;

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('${_monthNames[monthDate.month - 1]} ${monthDate.year}',
              style: AppText.h4),
          const SizedBox(height: 16),
          Row(
            children: _weekDays
                .map((d) => Expanded(
                      child: Text(d,
                          style: AppTypography.captionSmall
                              .copyWith(color: AppColors.grey400),
                          textAlign: TextAlign.center),
                    ))
                .toList(),
          ),
          const SizedBox(height: 8),
          _buildCalendarGrid(firstDay, lastDay, startOffset, monthDate),
          const SizedBox(height: 16),
          const Divider(color: AppColors.grey100, thickness: 1),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid(DateTime firstDay, DateTime lastDay,
      int startOffset, DateTime monthDate) {
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
              style:
                  AppTypography.captionSmall.copyWith(color: AppColors.grey200),
            ),
          );
        }
        final day = DateTime(monthDate.year, monthDate.month, dayNum);

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
    Color borderColor = Colors.transparent;

    if (isEdge) {
      bg = AppColors.primary;
      textColor = AppColors.white;
      borderColor = AppColors.primary;
    } else if (selected) {
      bg = AppColors.primary100;
      textColor = AppColors.primary;
      borderColor = AppColors.primary100;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
        boxShadow: isEdge
            ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.18),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      alignment: Alignment.center,
      child: Text(
        '${day.day}',
        style: AppText.label.copyWith(
          color: textColor,
          fontWeight: isEdge || selected ? FontWeight.w700 : FontWeight.w400,
        ),
      ),
    );
  }
}
