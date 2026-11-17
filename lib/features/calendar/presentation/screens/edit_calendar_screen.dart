import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:peria_app/core/theme/theme.dart';
import 'package:peria_app/features/calendar/presentation/widgets/month_grid_layout.dart';
import 'package:peria_app/features/cycle/data/models/period_log.dart';
import 'package:peria_app/features/cycle/domain/period_rules.dart';
import 'package:peria_app/features/cycle/presentation/providers/cycle_provider.dart';
import 'package:peria_app/features/profile/presentation/providers/user_profile_provider.dart';
import 'package:peria_app/l10n/app_localizations.dart';
import 'package:peria_app/shared/widgets/common_widgets.dart';

/// Full period editor reached from the "Edit Period" button of the calendar.
/// Months are stacked in one card, days select a range and the save button
/// stays pinned at the bottom of that card (see `moc/calender period-disable`).
///
/// The list starts on the current month and only goes back in time: this screen
/// corrects a recorded period, it is not a way to browse the coming year.
/// Selection follows [PeriodRules], exactly like the quick actions on the home
/// screen, so both entry points produce the same period.
class EditCalendarScreen extends ConsumerStatefulWidget {
  const EditCalendarScreen({super.key});

  @override
  ConsumerState<EditCalendarScreen> createState() => _EditCalendarScreenState();
}

class _EditCalendarScreenState extends ConsumerState<EditCalendarScreen> {
  static const int _monthCount = PeriodRules.maxLookBackMonths;

  DateTime? _startDate;
  DateTime? _endDate;

  /// The list opens on the current month, then goes back in time; the current
  /// month is the only month a user needs at a glance.
  DateTime get _firstMonth {
    final now = DateTime.now();
    return DateTime(now.year, now.month);
  }

  static DateTime get _today => PeriodRules.dayOnly(DateTime.now());

  bool _isFuture(DateTime day) => PeriodRules.isAfterToday(day, _today);

  /// A day is selectable when it is not in the future and, once the start is
  /// known, when the resulting period stays within
  /// [PeriodRules.maxPeriodLengthDays].
  bool _isSelectable(DateTime day) {
    if (_isFuture(day)) return false;
    final start = _startDate;
    if (start == null || _endDate != null) return true;
    if (day.isBefore(start)) return true;
    return !PeriodRules.dayOnly(day)
        .isAfter(PeriodRules.latestSelectableEnd(start, _today));
  }

  void _selectDay(DateTime day) {
    // Never trust the picker: no future day, no period longer than the rule.
    if (!_isSelectable(day)) return;
    final normalised = PeriodRules.dayOnly(day);
    setState(() {
      if (_startDate == null || (_startDate != null && _endDate != null)) {
        _startDate = normalised;
        _endDate = null;
      } else if (normalised.isBefore(_startDate!)) {
        _startDate = normalised;
        _endDate = null;
      } else {
        _endDate = normalised;
      }
    });
  }

  bool _isSelected(DateTime day) {
    if (_startDate == null) return false;
    if (_endDate == null) return _isSameDay(day, _startDate!);
    return !day.isBefore(_startDate!) && !day.isAfter(_endDate!);
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool get _canSave => _startDate != null;

  Future<void> _save() async {
    final start = _startDate;
    if (start == null) return;
    final now = DateTime.now();
    // Clamp again on save: the grid can be left half-selected and the profile
    // may be edited from another screen while this one is open.
    final range = PeriodRules.clampRange(
      start: start,
      end: _endDate ?? start,
      today: now,
    );
    final log = PeriodLog(
      id: now.microsecondsSinceEpoch.toString(),
      startDate: range.start,
      endDate: range.end,
      isEstimated: false,
    );
    await ref.read(periodLogsProvider.notifier).add(log);

    // Keep the profile in sync: lastPeriodStart follows the latest known start.
    final currentProfile = ref.read(userProfileProvider).value;
    final currentLast = currentProfile?.lastPeriodStart;
    if (currentLast == null || range.start.isAfter(currentLast)) {
      await ref.read(userProfileProvider.notifier).patch(
            (p) => p.copyWith(lastPeriodStart: range.start),
          );
    }

    if (mounted) {
      safeRouterBack(context, fallbackRoute: '/calendar');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PageScaffold(
      showBack: true,
      onBack: () => safeRouterBack(context, fallbackRoute: '/calendar'),
      showTitle: true,
      title: l10n.calendarEditScreenTitle,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.page,
          72,
          AppSpacing.page,
          16,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.grey200),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Text(
                  l10n.calendarPeriodMaxHelp,
                  style: AppText.caption.copyWith(color: AppColors.textSecondary),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
                  itemCount: _monthCount,
                  itemBuilder: (context, index) {
                    final first = _firstMonth;
                    final month = DateTime(first.year, first.month - index);
                    return _buildMonthSection(
                      month,
                      isLast: index == _monthCount - 1,
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: PrimaryButton(
                  label: l10n.save,
                  onPressed: _canSave ? _save : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMonthSection(DateTime monthDate, {required bool isLast}) {
    final locale = Localizations.localeOf(context).toString();
    final firstDay = DateTime(monthDate.year, monthDate.month, 1);
    final lastDay = DateTime(monthDate.year, monthDate.month + 1, 0);
    final startOffset = firstDay.weekday - 1;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          Text(
            DateFormat.yMMMM(locale).format(monthDate),
            style: AppText.h4.copyWith(
              color: AppColors.grey900,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: List.generate(7, (index) {
              final weekday = DateTime(2024, 1, 1 + index);
              final label =
                  DateFormat.E(locale).format(weekday).replaceAll('.', '');
              return Expanded(
                child: Text(
                  label.toLowerCase(),
                  style: AppText.caption.copyWith(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          _buildCalendarGrid(firstDay, lastDay, startOffset, monthDate),
          if (!isLast)
            const Padding(
              padding: EdgeInsets.only(top: 18),
              child: Divider(color: AppColors.grey100, thickness: 1, height: 1),
            ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid(
    DateTime firstDay,
    DateTime lastDay,
    int startOffset,
    DateTime monthDate,
  ) {
    final totalDays = lastDay.day;
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
                return const SizedBox.shrink();
              }
              final day = DateTime(monthDate.year, monthDate.month, dayNum);
              final disabled = !_isSelectable(day) && !_isSelected(day);
              return GestureDetector(
                onTap: disabled ? null : () => _selectDay(day),
                behavior: HitTestBehavior.opaque,
                child: _DayCell(
                  day: day,
                  selected: _isSelected(day),
                  disabled: disabled,
                  isToday: _isSameDay(day, _today),
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
  const _DayCell({
    required this.day,
    required this.selected,
    this.disabled = false,
    this.isToday = false,
  });

  final DateTime day;
  final bool selected;
  final bool disabled;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      decoration: BoxDecoration(
        color: selected ? AppColors.primary100 : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${day.day}',
            style: AppText.label.copyWith(
              color: selected
                  ? AppColors.primary600
                  : (disabled ? AppColors.textSecondary : AppColors.grey900),
              fontWeight: selected || isToday ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
          if (isToday)
            Container(
              margin: const EdgeInsets.only(top: 2),
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: selected ? AppColors.primary600 : AppColors.grey900,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}
