import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:peria_app/core/theme/theme.dart';
import 'package:peria_app/l10n/app_localizations.dart';
import 'package:peria_app/shared/widgets/common_widgets.dart';

/// Result of the journal date-range sheet.
/// A dismissed sheet returns null. [apply] with a null range clears the filter.
class JournalRangeChoice {
  const JournalRangeChoice.apply(this.range) : apply = true;

  final DateTimeRange? range;
  final bool apply;
}

Future<DateTime?> showJournalDaySheet({
  required BuildContext context,
  required DateTime initialDate,
  Set<DateTime> markedDays = const {},
}) {
  return showModalBottomSheet<DateTime>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    isDismissible: true,
    enableDrag: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.46),
    elevation: 0,
    clipBehavior: Clip.none,
    builder: (context) => _JournalCalendarSheet(
      initialDate: initialDate,
      markedDays: markedDays,
    ),
  );
}

Future<JournalRangeChoice?> showJournalRangeSheet({
  required BuildContext context,
  DateTimeRange? initialRange,
  Set<DateTime> markedDays = const {},
}) {
  return showModalBottomSheet<JournalRangeChoice>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    isDismissible: true,
    enableDrag: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.46),
    elevation: 0,
    clipBehavior: Clip.none,
    builder: (context) => _JournalCalendarSheet(
      initialDate: initialRange?.start ?? DateTime.now(),
      initialRange: initialRange,
      markedDays: markedDays,
      rangeMode: true,
    ),
  );
}

class _JournalCalendarSheet extends StatefulWidget {
  const _JournalCalendarSheet({
    required this.initialDate,
    required this.markedDays,
    this.initialRange,
    this.rangeMode = false,
  });

  final DateTime initialDate;
  final DateTimeRange? initialRange;
  final Set<DateTime> markedDays;
  final bool rangeMode;

  @override
  State<_JournalCalendarSheet> createState() => _JournalCalendarSheetState();
}

class _JournalCalendarSheetState extends State<_JournalCalendarSheet> {
  late DateTime _month;
  late DateTime _selected;
  DateTime? _start;
  DateTime? _end;

  @override
  void initState() {
    super.initState();
    _selected = _dateOnly(widget.initialDate);
    _month = DateTime(_selected.year, _selected.month);
    final range = widget.initialRange;
    if (range != null) {
      _start = _dateOnly(range.start);
      _end = _dateOnly(range.end);
      _month = DateTime(_start!.year, _start!.month);
    }
  }

  DateTime _dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);

  bool _same(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool _isMarked(DateTime day) => widget.markedDays.any((date) => _same(date, day));

  void _shiftMonth(int delta) {
    final next = DateTime(_month.year, _month.month + delta);
    final earliest = DateTime(2020, 1);
    final latest = DateTime(DateTime.now().year, DateTime.now().month + 13);
    if (next.isBefore(earliest) || !next.isBefore(latest)) return;
    setState(() => _month = DateTime(next.year, next.month));
  }

  void _selectDay(DateTime day) {
    if (!widget.rangeMode) {
      Navigator.of(context).pop(_dateOnly(day));
      return;
    }
    setState(() {
      final date = _dateOnly(day);
      if (_start == null || _end != null) {
        _start = date;
        _end = null;
      } else if (date.isBefore(_start!)) {
        _end = _start;
        _start = date;
      } else {
        _end = date;
      }
      _selected = date;
      _month = DateTime(date.year, date.month);
    });
  }

  void _applyPreset(DateTime start, DateTime end) {
    setState(() {
      _start = _dateOnly(start);
      _end = _dateOnly(end);
      _selected = _start!;
      _month = DateTime(_start!.year, _start!.month);
    });
  }

  bool _inRange(DateTime day) {
    if (_start == null) return false;
    final end = _end ?? _start!;
    final date = _dateOnly(day);
    return !date.isBefore(_start!) && !date.isAfter(end);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final firstDayIndex = MaterialLocalizations.of(context).firstDayOfWeekIndex;
    final maxHeight = MediaQuery.sizeOf(context).height * 0.88;

    return Padding(
      padding: const EdgeInsets.only(top: 28),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
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
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.grey300,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.rangeMode ? l10n.selectDateRange : l10n.selectDate,
                    textAlign: TextAlign.center,
                    style: AppText.h4,
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      _SheetIconButton(
                        icon: Icons.chevron_left_rounded,
                        onTap: () => _shiftMonth(-1),
                      ),
                      Expanded(
                        child: Text(
                          DateFormat.yMMMM(locale).format(_month),
                          textAlign: TextAlign.center,
                          style: AppText.h5.copyWith(color: AppColors.grey900),
                        ),
                      ),
                      _SheetIconButton(
                        icon: Icons.chevron_right_rounded,
                        onTap: () => _shiftMonth(1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _WeekdayRow(locale: locale, firstDayIndex: firstDayIndex),
                  const SizedBox(height: 6),
                  _MonthGrid(
                    month: _month,
                    firstDayIndex: firstDayIndex,
                    selected: _selected,
                    rangeMode: widget.rangeMode,
                    isMarked: _isMarked,
                    inRange: _inRange,
                    isEdge: (day) =>
                        (_start != null && _same(day, _start!)) ||
                        (_end != null && _same(day, _end!)),
                    onTap: _selectDay,
                  ),
                  if (widget.rangeMode) ...[
                    const SizedBox(height: 14),
                    _PresetRow(
                      locale: locale,
                      todayLabel: l10n.today,
                      onToday: () {
                        final today = _dateOnly(DateTime.now());
                        _applyPreset(today, today);
                      },
                      onWeek: () {
                        final today = _dateOnly(DateTime.now());
                        final start = journalWeekStart(today, firstDayIndex);
                        _applyPreset(start, start.add(const Duration(days: 6)));
                      },
                      onMonth: () {
                        final today = DateTime.now();
                        _applyPreset(
                          DateTime(today.year, today.month, 1),
                          DateTime(today.year, today.month + 1, 0),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    PrimaryButton(
                      label: l10n.save,
                      onPressed: _start == null
                          ? null
                          : () => Navigator.of(context).pop(
                                JournalRangeChoice.apply(
                                  DateTimeRange(
                                    start: _start!,
                                    end: _end ?? _start!,
                                  ),
                                ),
                              ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(
                        const JournalRangeChoice.apply(null),
                      ),
                      child: Text(
                        l10n.clearAll,
                        style: AppText.body.copyWith(color: AppColors.grey600),
                      ),
                    ),
                  ] else ...[
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () =>
                          Navigator.of(context).pop(_dateOnly(DateTime.now())),
                      child: Text(
                        l10n.today,
                        style: AppText.label.copyWith(
                          color: AppColors.primary500,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

DateTime journalWeekStart(DateTime date, int firstDayIndex) {
  final materialIndex = date.weekday % 7;
  final offset = (materialIndex - firstDayIndex + 7) % 7;
  final start = DateTime(date.year, date.month, date.day)
      .subtract(Duration(days: offset));
  return start;
}

class _WeekdayRow extends StatelessWidget {
  const _WeekdayRow({required this.locale, required this.firstDayIndex});

  final String locale;
  final int firstDayIndex;

  @override
  Widget build(BuildContext context) {
    final sunday = DateTime(2024, 1, 7);
    return Row(
      children: List.generate(7, (index) {
        final day = sunday.add(Duration(days: (firstDayIndex + index) % 7));
        final label = DateFormat.E(locale).format(day).replaceAll('.', '');
        return Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppText.caption.copyWith(color: AppColors.grey400),
          ),
        );
      }),
    );
  }
}

class _MonthGrid extends StatelessWidget {
  const _MonthGrid({
    required this.month,
    required this.firstDayIndex,
    required this.selected,
    required this.rangeMode,
    required this.isMarked,
    required this.inRange,
    required this.isEdge,
    required this.onTap,
  });

  final DateTime month;
  final int firstDayIndex;
  final DateTime selected;
  final bool rangeMode;
  final bool Function(DateTime day) isMarked;
  final bool Function(DateTime day) inRange;
  final bool Function(DateTime day) isEdge;
  final ValueChanged<DateTime> onTap;

  @override
  Widget build(BuildContext context) {
    final first = DateTime(month.year, month.month, 1);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final offset = (first.weekday % 7 - firstDayIndex + 7) % 7;
    final total = offset + daysInMonth;
    final cells = total + (7 - total % 7) % 7;

    return Column(
      children: [
        for (var row = 0; row < cells / 7; row++)
          Row(
            children: [
              for (var column = 0; column < 7; column++)
                Expanded(
                  child: _cell(row * 7 + column, offset, daysInMonth),
                ),
            ],
          ),
      ],
    );
  }

  Widget _cell(int index, int offset, int daysInMonth) {
    final dayNumber = index - offset + 1;
    if (dayNumber < 1 || dayNumber > daysInMonth) {
      return const SizedBox(height: 42);
    }
    final day = DateTime(month.year, month.month, dayNumber);
    final selectedDay =
        day.year == selected.year && day.month == selected.month && day.day == selected.day;
    final edge = rangeMode && isEdge(day);
    final inside = rangeMode && inRange(day);
    final active = rangeMode ? edge : selectedDay;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
      child: GestureDetector(
        onTap: () => onTap(day),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active
                ? AppColors.grey900
                : inside
                    ? AppColors.primary50
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$dayNumber',
                style: AppText.label.copyWith(
                  color: active ? AppColors.white : AppColors.grey900,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                width: 4,
                height: 4,
                margin: const EdgeInsets.only(top: 2),
                decoration: BoxDecoration(
                  color: isMarked(day)
                      ? (active ? AppColors.white : AppColors.primary500)
                      : Colors.transparent,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PresetRow extends StatelessWidget {
  const _PresetRow({
    required this.locale,
    required this.todayLabel,
    required this.onToday,
    required this.onWeek,
    required this.onMonth,
  });

  final String locale;
  final String todayLabel;
  final VoidCallback onToday;
  final VoidCallback onWeek;
  final VoidCallback onMonth;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final firstDayIndex = MaterialLocalizations.of(context).firstDayOfWeekIndex;
    final weekStart = journalWeekStart(now, firstDayIndex);
    final weekEnd = weekStart.add(const Duration(days: 6));
    final weekLabel =
        '${DateFormat('d MMM', locale).format(weekStart)} – ${DateFormat('d MMM', locale).format(weekEnd)}';
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _PresetChip(label: todayLabel, onTap: onToday),
          const SizedBox(width: 8),
          _PresetChip(label: weekLabel, onTap: onWeek),
          const SizedBox(width: 8),
          _PresetChip(
            label: DateFormat.MMMM(locale).format(now),
            onTap: onMonth,
          ),
        ],
      ),
    );
  }
}

class _PresetChip extends StatelessWidget {
  const _PresetChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 36,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: AppColors.grey100,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          label,
          style: AppText.caption.copyWith(
            color: AppColors.grey800,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _SheetIconButton extends StatelessWidget {
  const _SheetIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 44,
        height: 44,
        child: Icon(icon, color: AppColors.grey700, size: 24),
      ),
    );
  }
}
