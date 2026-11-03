import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:peria_app/core/theme/theme.dart';
import 'package:peria_app/features/calendar/data/models/symptom_log.dart';
import 'package:peria_app/features/calendar/presentation/constants/symptom_constants.dart';
import 'package:peria_app/features/calendar/presentation/symptom_localization.dart';
import 'package:peria_app/features/calendar/presentation/providers/symptom_provider.dart';
import 'package:peria_app/l10n/app_localizations.dart';
import 'package:peria_app/shared/widgets/common_widgets.dart';

class SymptomsScreen extends ConsumerStatefulWidget {
  const SymptomsScreen({super.key});

  @override
  ConsumerState<SymptomsScreen> createState() => _SymptomsScreenState();
}

class _SymptomsScreenState extends ConsumerState<SymptomsScreen> {
  late DateTime _selectedDate;
  late DateTime _weekStart;
  Map<String, Set<String>> _selectedByCategory = {};
  String? _loadedDocumentId;
  late final TextEditingController _notesController;
  late final TextEditingController _searchController;
  String _query = '';
  int? _intensity;
  double? _weightKg;
  int? _waterMl;

  static const Map<String, List<SymptomOption>> _categories = symptomCategories;

  bool get _hasExistingLog =>
      _loadedDocumentId != null &&
      (_selectedByCategory.isNotEmpty ||
          _notesController.text.trim().isNotEmpty ||
          _intensity != null ||
          _weightKg != null ||
          _waterMl != null);

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController();
    _searchController = TextEditingController();
    final today = DateTime.now();
    _selectedDate = DateTime(today.year, today.month, today.day);
    _weekStart = _selectedDate.subtract(Duration(days: today.weekday - 1));
  }

  @override
  void dispose() {
    _notesController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<DateTime> get _weekDays =>
      List.generate(7, (index) => _weekStart.add(Duration(days: index)));

  bool get _isCurrentWeek =>
      !_weekStart.isBefore(_todayWeekStart) &&
      !_weekStart.isAfter(_todayWeekStart);

  DateTime get _todayWeekStart {
    final today = DateTime.now();
    final day = DateTime(today.year, today.month, today.day);
    return day.subtract(Duration(days: today.weekday - 1));
  }

  void _applyLog(SymptomLog? log) {
    final next = <String, Set<String>>{};
    if (log != null) {
      for (final entry in log.selections.entries) {
        next[entry.key] = entry.value.toSet();
      }
    }
    _selectedByCategory = next;
    _notesController.text = log?.freeNotes ?? '';
    _intensity = log?.intensity;
    _weightKg = log?.weightKg;
    _waterMl = log?.waterMl;
    _loadedDocumentId = log?.id ??
        ref.read(symptomRepositoryProvider).documentIdForDate(_selectedDate);
  }

  bool _isSelected(String category, String label) {
    return _selectedByCategory[category]?.contains(label) ?? false;
  }

  void _toggleSelection(String category, String label) {
    setState(() {
      final current = {...(_selectedByCategory[category] ?? <String>{})};
      if (current.contains(label)) {
        current.remove(label);
      } else {
        current.add(label);
      }
      _selectedByCategory[category] = current;
    });
  }

  Future<void> _save() async {
    final repository = ref.read(symptomRepositoryProvider);
    final normalizedDate =
        DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
    final selections = <String, List<String>>{};
    for (final entry in _selectedByCategory.entries) {
      if (entry.value.isNotEmpty) {
        selections[entry.key] = entry.value.toList()..sort();
      }
    }

    final log = SymptomLog(
      id: repository.documentIdForDate(normalizedDate),
      date: normalizedDate,
      selections: selections,
      updatedAt: DateTime.now(),
      freeNotes: _notesController.text.trim(),
      intensity: _intensity,
      weightKg: _weightKg,
      waterMl: _waterMl,
    );

    await repository.saveForDate(log);
    ref.invalidate(symptomLogProvider(normalizedDate));
    ref.invalidate(symptomLogsProvider);
    if (mounted) {
      safeRouterBack(context, fallbackRoute: '/cycle');
    }
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = DateTime(date.year, date.month, date.day);
      _selectedByCategory = {};
      _notesController.clear();
      _intensity = null;
      _weightKg = null;
      _waterMl = null;
      _loadedDocumentId = null;
    });
  }

  void _shiftWeek(int weeks) {
    final next = _weekStart.add(Duration(days: 7 * weeks));
    if (next.isAfter(_todayWeekStart)) return;
    setState(() {
      _weekStart = next;
      if (_selectedDate.isBefore(next) ||
          _selectedDate.isAfter(next.add(const Duration(days: 6)))) {
        _selectDate(DateTime.now());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final asyncLog = ref.watch(symptomLogProvider(_selectedDate));
    ref.listen<AsyncValue<SymptomLog?>>(symptomLogProvider(_selectedDate),
        (previous, next) {
      if (!mounted) return;
      next.when(
        data: (log) {
          if (!mounted || _loadedDocumentId != null) return;
          if (_notesController.text.trim().isNotEmpty ||
              _selectedByCategory.isNotEmpty ||
              _intensity != null ||
              _weightKg != null ||
              _waterMl != null) {
            return;
          }
          setState(() => _applyLog(log));
        },
        error: (_, __) {},
        loading: () {},
      );
    });
    if (asyncLog.hasValue &&
        _loadedDocumentId == null &&
        _notesController.text.trim().isEmpty &&
        _selectedByCategory.isEmpty &&
        _intensity == null &&
        _weightKg == null &&
        _waterMl == null) {
      final loaded = asyncLog.value;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || _loadedDocumentId != null) return;
        if (_notesController.text.trim().isNotEmpty ||
            _selectedByCategory.isNotEmpty ||
            _intensity != null ||
            _weightKg != null ||
            _waterMl != null) {
          return;
        }
        setState(() => _applyLog(loaded));
      });
    }

    return PageScaffold(
      showBack: true,
      onBack: () => safeRouterBack(context, fallbackRoute: '/cycle'),
      showTitle: true,
      title: l10n.logSymptoms,
      child: Stack(
        children: [
          const Positioned.fill(child: ColoredBox(color: AppColors.white)),
          if (asyncLog.isLoading)
            const Positioned(
              top: 64,
              left: 20,
              right: 20,
              child: LinearProgressIndicator(
                minHeight: 3,
                color: AppColors.primary,
                backgroundColor: AppColors.primary50,
              ),
            ),
          if (asyncLog.hasError)
            Positioned(
              top: 70,
              left: 20,
              right: 20,
              child: Text(
                l10n.symptomLogUnavailable,
                style: AppText.caption.copyWith(color: AppColors.error),
              ),
            ),
          Positioned.fill(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                top: asyncLog.hasError ? 104 : 74,
                bottom: 110,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMonthRow(context),
                  const SizedBox(height: 12),
                  _buildWeekStrip(context),
                  const SizedBox(height: 16),
                  _buildSearchField(l10n),
                  const SizedBox(height: 16),
                  if (asyncLog.isLoading)
                    const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else
                    ..._buildCategoryCards(context, l10n),
                  const SizedBox(height: 4),
                  _buildWeightCard(context, l10n),
                  _buildNoteCard(context, l10n),
                  _buildWaterCard(context, l10n),
                  _buildIntensityCard(context, l10n),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 24,
            left: 20,
            right: 20,
            child: PrimaryButton(
              label: _hasExistingLog ? l10n.update : l10n.save,
              onPressed: _save,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthRow(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Text(
            DateFormat.yMMMM(locale).format(_selectedDate),
            style: AppText.h4.copyWith(
              color: AppColors.grey900,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          _WeekArrow(
            icon: Icons.chevron_left_rounded,
            onTap: () => _shiftWeek(-1),
          ),
          const SizedBox(width: 8),
          _WeekArrow(
            icon: Icons.chevron_right_rounded,
            onTap: _isCurrentWeek ? null : () => _shiftWeek(1),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekStrip(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final today = DateTime.now();
    final lastDay = DateTime(today.year, today.month, today.day);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          for (final date in _weekDays)
            Expanded(
              child: Builder(
                builder: (context) {
                  final isSelected = date.year == _selectedDate.year &&
                      date.month == _selectedDate.month &&
                      date.day == _selectedDate.day;
                  final isFuture = date.isAfter(lastDay);
                  return GestureDetector(
                    onTap: isFuture ? null : () => _selectDate(date),
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      height: 72,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary50
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: isSelected
                            ? Border.all(color: AppColors.primary100)
                            : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${date.day}',
                            style: AppText.h6.copyWith(
                              color: isFuture
                                  ? AppColors.grey300
                                  : (isSelected
                                      ? AppColors.primary500
                                      : AppColors.grey900),
                              fontWeight:
                                  isSelected ? FontWeight.w700 : FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            DateFormat.E(locale).format(date).substring(0, 2),
                            style: AppText.caption.copyWith(
                              color: isSelected
                                  ? AppColors.primary500
                                  : AppColors.grey500,
                              fontWeight:
                                  isSelected ? FontWeight.w600 : FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchField(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.grey100,
          borderRadius: BorderRadius.circular(99),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                style: AppText.body.copyWith(color: AppColors.grey900),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  hintText: l10n.symptomSearchHint,
                  hintStyle: AppText.body.copyWith(color: AppColors.grey500),
                ),
                onChanged: (value) => setState(() => _query = value.trim()),
              ),
            ),
            const Icon(Icons.search_rounded, size: 20, color: AppColors.grey500),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCategoryCards(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    final query = _query.toLowerCase();
    final cards = <Widget>[];

    for (final entry in _categories.entries) {
      final options = entry.value.where((option) {
        if (query.isEmpty) return true;
        return symptomLabel(l10n, option.label).toLowerCase().contains(query);
      }).toList();

      if (options.isEmpty) continue;

      cards.add(
        _CategoryCard(
          title: symptomLabel(l10n, entry.key),
          children: [
            for (final option in options)
              _SymptomChip(
                label: symptomLabel(l10n, option.label),
                icon: option.icon,
                isSelected: _isSelected(entry.key, option.label),
                onTap: () => _toggleSelection(entry.key, option.label),
              ),
          ],
        ),
      );
    }

    if (cards.isEmpty) {
      cards.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
          child: Text(
            l10n.symptomNoMatch,
            style: AppText.body.copyWith(color: AppColors.grey600),
          ),
        ),
      );
    }
    return cards;
  }

  Widget _buildWeightCard(BuildContext context, AppLocalizations l10n) {
    return _ValueCard(
      icon: Icons.monitor_weight_outlined,
      title: l10n.symptomWeight,
      editTooltip: l10n.symptomEdit,
      value: _weightKg == null
          ? '—'
          : '${_weightKg!.toStringAsFixed(2)} kg',
      onEdit: () async {
        final weight = await showModalBottomSheet<double>(
          context: context,
          useRootNavigator: true,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          barrierColor: Colors.black.withOpacity(0.46),
          builder: (context) => _ValueSheet(
            title: l10n.symptomWeight,
            icon: Icons.monitor_weight_outlined,
            unit: 'kg',
            hint: l10n.symptomWeightHint,
            initialValue:
                _weightKg == null ? '' : _weightKg!.toStringAsFixed(2),
            allowDecimal: true,
            isValid: (value) => value >= 25 && value <= 300,
          ),
        );
        if (weight != null && mounted) setState(() => _weightKg = weight);
      },
    );
  }

  Widget _buildWaterCard(BuildContext context, AppLocalizations l10n) {
    final total = _waterMl ?? 0;
    return _ValueCard(
      icon: Icons.local_drink_outlined,
      title: l10n.symptomWater,
      editTooltip: l10n.symptomEdit,
      value: '$total ml / $kWaterGoalMl ml',
      onEdit: () async {
        final water = await showModalBottomSheet<double>(
          context: context,
          useRootNavigator: true,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          barrierColor: Colors.black.withOpacity(0.46),
          builder: (context) => _ValueSheet(
            title: l10n.symptomWater,
            icon: Icons.local_drink_outlined,
            unit: 'ml',
            hint: l10n.symptomWaterHint,
            initialValue: _waterMl?.toString() ?? '',
            allowDecimal: false,
            isValid: (value) => value >= 0 && value <= 5000,
          ),
        );
        if (water != null && mounted) {
          setState(() => _waterMl = water.round());
        }
      },
    );
  }

  Widget _buildNoteCard(BuildContext context, AppLocalizations l10n) {
    final note = _notesController.text.trim();
    return _ValueCard(
      icon: Icons.event_note_outlined,
      title: l10n.notes,
      editTooltip: l10n.symptomEdit,
      value: note.isEmpty ? '—' : note,
      onEdit: () async {
        final text = await showModalBottomSheet<String>(
          context: context,
          useRootNavigator: true,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          barrierColor: Colors.black.withOpacity(0.46),
          builder: (context) => _NoteSheet(
            title: l10n.notes,
            initialValue: _notesController.text,
            hint: l10n.writeHowYouFeelToday,
          ),
        );
        if (text != null && mounted) {
          setState(() => _notesController.text = text);
        }
      },
    );
  }

  Widget _buildIntensityCard(BuildContext context, AppLocalizations l10n) {
    return _CategoryCard(
      title: l10n.intensity,
      children: [
        for (var value = 1; value <= 5; value++)
          _SymptomChip(
            label: '$value',
            icon: Icons.bolt_rounded,
            isSelected: _intensity == value,
            onTap: () => setState(
              () => _intensity = _intensity == value ? null : value,
            ),
          ),
      ],
    );
  }

}

class _WeekArrow extends StatelessWidget {
  const _WeekArrow({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.grey200),
          ),
          child: Icon(
            icon,
            size: 20,
            color: enabled ? AppColors.grey900 : AppColors.grey300,
          ),
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Color(0x0F000000),
              blurRadius: 16,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppText.h6.copyWith(
                color: AppColors.grey900,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(spacing: 8, runSpacing: 8, children: children),
          ],
        ),
      ),
    );
  }
}

class _SymptomChip extends StatelessWidget {
  const _SymptomChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary50 : AppColors.grey100,
          borderRadius: BorderRadius.circular(99),
          border: Border.all(
            color: isSelected ? AppColors.primary200 : Colors.transparent,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? AppColors.primary500 : AppColors.grey600,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppText.label.copyWith(
                color: isSelected ? AppColors.primary600 : AppColors.grey800,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ValueCard extends StatelessWidget {
  const _ValueCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.onEdit,
    required this.editTooltip,
  });

  final IconData icon;
  final String title;
  final String value;
  final VoidCallback onEdit;
  final String editTooltip;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Color(0x0F000000),
              blurRadius: 16,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _CardIconTile(icon: icon),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: AppText.h6.copyWith(
                      color: AppColors.grey900,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Tooltip(
                  message: editTooltip,
                  child: Material(
                    color: AppColors.grey100,
                    shape: const CircleBorder(),
                    child: InkWell(
                      onTap: onEdit,
                      customBorder: const CircleBorder(),
                      child: const SizedBox(
                        width: 34,
                        height: 34,
                        child: Icon(
                          Icons.edit_outlined,
                          size: 16,
                          color: AppColors.grey600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: AppText.body.copyWith(color: AppColors.grey800),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardIconTile extends StatelessWidget {
  const _CardIconTile({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: AppColors.primary50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, size: 17, color: AppColors.primary500),
    );
  }
}

class _NoteSheet extends StatefulWidget {
  const _NoteSheet({
    required this.title,
    required this.initialValue,
    required this.hint,
  });

  final String title;
  final String initialValue;
  final String hint;

  @override
  State<_NoteSheet> createState() => _NoteSheetState();
}

class _NoteSheetState extends State<_NoteSheet> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.initialValue);
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _SheetShell(
      paddingBottom: MediaQuery.viewInsetsOf(context).bottom + 12,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const _CardIconTile(icon: Icons.event_note_outlined),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.title,
                  style: AppText.h5.copyWith(
                    color: AppColors.grey900,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Material(
                color: AppColors.grey100,
                shape: const CircleBorder(),
                child: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  customBorder: const CircleBorder(),
                  child: const SizedBox(
                    width: 34,
                    height: 34,
                    child: Icon(Icons.close_rounded,
                        size: 18, color: AppColors.grey700),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            decoration: BoxDecoration(
              color: AppColors.grey100,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: TextField(
              controller: _controller,
              minLines: 5,
              maxLines: 8,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              style: AppText.body.copyWith(color: AppColors.grey900),
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                hintText: widget.hint,
                hintStyle: AppText.body.copyWith(color: AppColors.grey500),
              ),
            ),
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            label: AppLocalizations.of(context).save,
            onPressed: () => Navigator.of(context).pop(_controller.text.trim()),
          ),
        ],
      ),
    );
  }
}

class _ValueSheet extends StatefulWidget {
  const _ValueSheet({
    required this.title,
    required this.icon,
    required this.unit,
    required this.hint,
    required this.initialValue,
    required this.allowDecimal,
    required this.isValid,
  });

  final String title;
  final IconData icon;
  final String unit;
  final String hint;
  final String initialValue;
  final bool allowDecimal;
  final bool Function(double value) isValid;

  @override
  State<_ValueSheet> createState() => _ValueSheetState();
}

class _ValueSheetState extends State<_ValueSheet> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.initialValue);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double? get _value {
    final parsed = double.tryParse(_controller.text.replaceAll(',', '.'));
    if (parsed == null || !widget.isValid(parsed)) return null;
    return parsed;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final value = _value;

    return _SheetShell(
      paddingBottom: MediaQuery.viewInsetsOf(context).bottom + 12,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _CardIconTile(icon: widget.icon),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.title,
                  style: AppText.h5.copyWith(
                    color: AppColors.grey900,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Material(
                color: AppColors.grey100,
                shape: const CircleBorder(),
                child: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  customBorder: const CircleBorder(),
                  child: const SizedBox(
                    width: 34,
                    height: 34,
                    child: Icon(Icons.close_rounded,
                        size: 18, color: AppColors.grey700),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: AppColors.grey100,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    autofocus: true,
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: widget.allowDecimal,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        widget.allowDecimal
                            ? RegExp(r'[0-9.,]')
                            : RegExp(r'[0-9]'),
                      ),
                    ],
                    onChanged: (_) => setState(() {}),
                    style: AppText.h4.copyWith(color: AppColors.grey900),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      hintText: '0',
                      hintStyle: AppText.h4.copyWith(
                        color: AppColors.grey400,
                      ),
                    ),
                  ),
                ),
                Text(
                  widget.unit,
                  style: AppText.label.copyWith(color: AppColors.grey600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            widget.hint,
            style: AppText.caption.copyWith(color: AppColors.grey600),
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            label: l10n.save,
            onPressed:
                value == null ? null : () => Navigator.of(context).pop(value),
          ),
        ],
      ),
    );
  }
}

class _SheetShell extends StatelessWidget {
  const _SheetShell({required this.child, required this.paddingBottom});

  final Widget child;
  final double paddingBottom;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 28, bottom: paddingBottom),
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
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
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
                const SizedBox(height: 14),
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
