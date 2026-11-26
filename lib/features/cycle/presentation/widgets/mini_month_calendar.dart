import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:peria_app/core/theme/theme.dart';
import 'package:peria_app/features/calendar/presentation/widgets/month_grid_layout.dart';
import 'package:peria_app/features/cycle/presentation/models/cycle_day_info.dart';
import 'package:peria_app/features/cycle/presentation/providers/cycle_provider.dart';
import 'package:peria_app/l10n/app_localizations.dart';

/// Grid maths of the compact month.
///
/// Kept pure and static so the offsets and the number of weeks can be tested
/// without pumping a widget: a wrong offset shifts every date by one column,
/// which is invisible to a compiler and obvious to a user.
class MiniMonthLayout {
  MiniMonthLayout._();

  static const int weekdays = 7;

  /// Index of a date with 0 = Sunday, matching
  /// [MaterialLocalizations.firstDayOfWeekIndex].
  static int weekdayIndex(DateTime date) => date.weekday % weekdays;

  /// Empty cells before the 1st, so the month starts on the right weekday.
  static int leadingBlanks({
    required DateTime firstDayOfMonth,
    required int firstDayOfWeekIndex,
  }) {
    final index = weekdayIndex(firstDayOfMonth);
    return (index - firstDayOfWeekIndex + weekdays) % weekdays;
  }

  static int daysInMonth(DateTime month) =>
      DateTime(month.year, month.month + 1, 0).day;

  /// The month as weeks of seven slots, `null` outside the month.
  static List<List<DateTime?>> weeks({
    required DateTime month,
    required int firstDayOfWeekIndex,
  }) {
    final first = DateTime(month.year, month.month, 1);
    final dayCount = daysInMonth(first);
    final lead = leadingBlanks(
      firstDayOfMonth: first,
      firstDayOfWeekIndex: firstDayOfWeekIndex,
    );
    final rows = MonthGridLayout.rowCount(
      startOffset: lead,
      dayCount: dayCount,
    );

    return [
      for (var row = 0; row < rows; row++)
        [
          for (var column = 0; column < weekdays; column++)
            _dayAt(
              first: first,
              dayNumber: row * weekdays + column - lead + 1,
              dayCount: dayCount,
            ),
        ],
    ];
  }

  static DateTime? _dayAt({
    required DateTime first,
    required int dayNumber,
    required int dayCount,
  }) {
    if (dayNumber < 1 || dayNumber > dayCount) return null;
    return DateTime(first.year, first.month, dayNumber);
  }
}

/// Compact month shown in the "Enregistrer tes règles" sheet.
///
/// It answers one question while recording a period: where am I in the month,
/// and which days are already saved versus predicted. Nothing is tappable: the
/// actions below the calendar stay the only way to change data, so the sheet
/// cannot record two different things at once.
class MiniMonthCalendar extends ConsumerStatefulWidget {
  const MiniMonthCalendar({super.key, this.referenceDate});

  /// Month opened first; defaults to today's month (tests pin it).
  final DateTime? referenceDate;

  /// How far the arrows may travel from today's month.
  static const int maxMonthOffset = 12;

  @override
  ConsumerState<MiniMonthCalendar> createState() => _MiniMonthCalendarState();
}

class _MiniMonthCalendarState extends ConsumerState<MiniMonthCalendar> {
  late DateTime _month;
  late DateTime _today;

  @override
  void initState() {
    super.initState();
    final reference = widget.referenceDate ?? DateTime.now();
    _today = DateTime(reference.year, reference.month, reference.day);
    _month = DateTime(_today.year, _today.month);
  }

  /// Whole months between today's month and [month], used to stop the arrows
  /// instead of letting them wander years away from any saved data.
  int _monthOffset(DateTime month) =>
      (month.year - _today.year) * 12 + (month.month - _today.month);

  bool get _canGoBack =>
      _monthOffset(_month) > -MiniMonthCalendar.maxMonthOffset;
  bool get _canGoForward =>
      _monthOffset(_month) < MiniMonthCalendar.maxMonthOffset;

  void _shiftMonth(int delta) {
    final next = DateTime(_month.year, _month.month + delta);
    if (_monthOffset(next).abs() > MiniMonthCalendar.maxMonthOffset) return;
    setState(() => _month = DateTime(next.year, next.month));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final firstDayOfWeek = MaterialLocalizations.of(context).firstDayOfWeekIndex;
    final weeks = MiniMonthLayout.weeks(
      month: _month,
      firstDayOfWeekIndex: firstDayOfWeek,
    );
    final daysByNumber = ref.watch(
      monthCycleDayInfoProvider(DateTime(_month.year, _month.month)),
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _header(l10n, locale),
          const SizedBox(height: 6),
          _weekdayRow(locale, firstDayOfWeek),
          const SizedBox(height: 4),
          for (final week in weeks) _weekRow(week, daysByNumber, locale, l10n),
          const SizedBox(height: 8),
          _legend(l10n),
        ],
      ),
    );
  }

  Widget _header(AppLocalizations l10n, String locale) {
    final label = DateFormat.yMMMM(locale).format(_month);
    return Row(
      children: [
        _MonthArrow(
          icon: Icons.chevron_left_rounded,
          tooltip: l10n.previousMonth,
          onTap: _canGoBack ? () => _shiftMonth(-1) : null,
        ),
        Expanded(
          child: Text(
            // "Septembre 2026" rather than a lowercase locale string.
            label.isEmpty ? '' : label[0].toUpperCase() + label.substring(1),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.label.copyWith(
              color: AppColors.grey900,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        _MonthArrow(
          icon: Icons.chevron_right_rounded,
          tooltip: l10n.nextMonth,
          onTap: _canGoForward ? () => _shiftMonth(1) : null,
        ),
      ],
    );
  }

  /// Two-letter weekday initials, starting on the locale's first day.
  Widget _weekdayRow(String locale, int firstDayOfWeek) {
    // 2024-01-07 is a Sunday: offsetting from it walks one full week.
    final sunday = DateTime(2024, 1, 7);
    final letters = [
      for (var column = 0; column < MiniMonthLayout.weekdays; column++)
        _weekdayLetter(locale, sunday, firstDayOfWeek, column),
    ];

    return Row(
      children: [
        for (final letter in letters)
          Expanded(
            child: ExcludeSemantics(
              child: Center(
                child: Text(
                  letter,
                  style: AppText.caption.copyWith(
                    color: AppColors.grey500,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  /// Two letters of the weekday, as on the mockup ("mo", "tu", "we").
  String _weekdayLetter(String locale, DateTime sunday, int firstDayOfWeek, int column) {
    final date = sunday.add(Duration(days: (firstDayOfWeek + column) % 7));
    final short = DateFormat.E(locale).format(date).replaceAll('.', '');
    final lower = short.toLowerCase();
    return lower.length >= 2 ? lower.substring(0, 2) : lower;
  }

  Widget _weekRow(
    List<DateTime?> week,
    Map<int, CycleDayInfo> daysByNumber,
    String locale,
    AppLocalizations l10n,
  ) {
    return Row(
      children: [
        for (final day in week)
          Expanded(
            child: day == null
                ? const SizedBox(height: 32)
                : _MiniDayCell(
                    day: day,
                    info: daysByNumber[day.day],
                    isToday: _isSameDay(day, _today),
                    locale: locale,
                    todayLabel: l10n.today,
                    loggedLabel: l10n.calendarLegendLoggedPeriod,
                    predictedLabel: l10n.calendarLegendPredictedPeriod,
                  ),
          ),
      ],
    );
  }

  Widget _legend(AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _LegendDot(
          filled: true,
          label: l10n.calendarLegendLoggedPeriod,
        ),
        const SizedBox(width: 14),
        _LegendDot(
          filled: false,
          label: l10n.calendarLegendPredictedPeriod,
        ),
      ],
    );
  }

  static bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

class _MonthArrow extends StatelessWidget {
  const _MonthArrow({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: onTap != null,
      label: tooltip,
      child: InkResponse(
        onTap: onTap,
        radius: 20,
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: onTap == null ? AppColors.grey200 : AppColors.grey300,
            ),
          ),
          child: Icon(
            icon,
            size: 18,
            color: onTap == null ? AppColors.grey300 : AppColors.grey800,
          ),
        ),
      ),
    );
  }
}

class _MiniDayCell extends StatelessWidget {
  const _MiniDayCell({
    required this.day,
    required this.info,
    required this.isToday,
    required this.locale,
    required this.todayLabel,
    required this.loggedLabel,
    required this.predictedLabel,
  });

  final DateTime day;
  final CycleDayInfo? info;
  final bool isToday;
  final String locale;
  final String todayLabel;
  final String loggedLabel;
  final String predictedLabel;

  @override
  Widget build(BuildContext context) {
    final isLogged = info?.isLoggedPeriod ?? false;
    final isPredicted = !isLogged && (info?.isPredictedPeriod ?? false);

    final Color background;
    final Color foreground;
    final Color border;
    if (isToday) {
      background = AppColors.grey900;
      foreground = AppColors.white;
      border = AppColors.grey900;
    } else if (isLogged) {
      // Saved period: solid, the truth.
      background = AppColors.primary100;
      foreground = AppColors.primary800;
      border = AppColors.primary300;
    } else if (isPredicted) {
      // Predicted period: outline only, so it never looks saved.
      background = Colors.transparent;
      foreground = AppColors.primary700;
      border = AppColors.primary300;
    } else {
      background = Colors.transparent;
      foreground = AppColors.grey800;
      border = Colors.transparent;
    }

    final parts = <String>[DateFormat.yMMMMd(locale).format(day)];
    if (isToday) parts.add(todayLabel);
    if (isLogged) parts.add(loggedLabel);
    if (isPredicted) parts.add(predictedLabel);

    return Semantics(
      label: parts.join(', '),
      excludeSemantics: true,
      child: SizedBox(
        height: 32,
        child: Center(
          child: Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: border, width: 1),
            ),
            child: Text(
              '${day.day}',
              style: AppText.caption.copyWith(
                fontSize: 12,
                fontWeight:
                    isToday || isLogged || isPredicted ? FontWeight.w700 : FontWeight.w500,
                color: foreground,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.filled, required this.label});

  final bool filled;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: filled ? AppColors.primary100 : Colors.transparent,
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: AppColors.primary300),
          ),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: AppText.caption.copyWith(color: AppColors.grey600, fontSize: 10),
        ),
      ],
    );
  }
}
