import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:peria_app/core/theme/theme.dart';
import 'package:peria_app/features/profile/presentation/providers/user_profile_provider.dart';
import 'package:peria_app/l10n/app_localizations.dart';
import 'package:peria_app/shared/widgets/common_widgets.dart';
import 'package:peria_app/shared/widgets/profile_widgets.dart';

class PersonalInformationScreen extends ConsumerWidget {
  const PersonalInformationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final profileAsync = ref.watch(userProfileProvider);

    return SimplePage(
      title: l10n.personalInformation,
      child: profileAsync.when(
        skipLoadingOnReload: true,
        loading: () => const _PersonalInfoSkeleton(),
        error: (err, _) => Center(child: Text(l10n.unableToLoadProfile)),
        data: (profile) => SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- SECTION: IDENTITÉ ---
              _ProfileSectionCard(children: [
                _EditableField(
                  label: l10n.fullNameLabel,
                  value: profile.displayName ?? '',
                  onChanged: (val) => ref.read(userProfileProvider.notifier).patch(
                    (p) => p.copyWith(displayName: val),
                  ),
                ),
              ]),

              const SizedBox(height: 24),
              SectionLabel(l10n.cycleProfile),
              const SizedBox(height: 12),

              // --- SECTION: DONNÉES CYCLE ---
              _ProfileSectionCard(children: [
                _SelectableRow(
                  label: l10n.dateOfBirth,
                  value: profile.dateOfBirth != null 
                      ? DateFormat('dd/MM/yyyy').format(profile.dateOfBirth!) 
                      : '--/--/----',
                  onTap: () async {
                    final date = await _showDatePickerCalendar(
                      context, 
                      initialDate: profile.dateOfBirth,
                      title: l10n.dateOfBirth,
                    );
                    if (date != null) {
                      ref.read(userProfileProvider.notifier).patch((p) => p.copyWith(dateOfBirth: date));
                    }
                  },
                ),
                const Divider(height: 32, thickness: 0.5, color: AppColors.grey300),
                _SelectableRow(
                  label: l10n.averageCycleLength,
                  value: l10n.daysCount(profile.averageCycleLengthDays),
                  onTap: () async {
                    final val = await _pickCycleLengthPicker(
                      context,
                      title: l10n.averageCycleLength,
                      currentValue: profile.averageCycleLengthDays,
                      min: 21,
                      max: 35,
                    );
                    if (val != null) {
                      ref.read(userProfileProvider.notifier).patch((p) => p.copyWith(averageCycleLengthDays: val));
                    }
                  },
                ),
                const Divider(height: 32, thickness: 0.5, color: AppColors.grey300),
                _SelectableRow(
                  label: l10n.periodLength,
                  value: l10n.daysCount(profile.periodLengthDays),
                  onTap: () async {
                    final val = await _pickPeriodLengthPicker(
                      context,
                      title: l10n.periodLength,
                      currentValue: profile.periodLengthDays,
                      min: 2,
                      max: 12,
                    );
                    if (val != null) {
                      ref.read(userProfileProvider.notifier).patch((p) => p.copyWith(periodLengthDays: val));
                    }
                  },
                ),
                const Divider(height: 32, thickness: 0.5, color: AppColors.grey300),
                _SelectableRow(
                  label: l10n.lastPeriodStartDate,
                  value: profile.lastPeriodStart != null 
                      ? DateFormat('dd/MM/yyyy').format(profile.lastPeriodStart!) 
                      : '--/--/----',
                  onTap: () async {
                    final date = await _showDatePickerCalendar(
                      context, 
                      initialDate: profile.lastPeriodStart,
                      title: l10n.lastPeriodStartDate,
                    );
                    if (date != null) {
                      ref.read(userProfileProvider.notifier).patch((p) => p.copyWith(lastPeriodStart: date));
                    }
                  },
                ),
                const Divider(height: 32, thickness: 0.5, color: AppColors.grey300),
                _ToggleRow(
                  label: l10n.regularCycleQuestion,
                  value: profile.isCycleRegular,
                  onChanged: (val) {
                    ref.read(userProfileProvider.notifier).patch((p) => p.copyWith(isCycleRegular: val));
                  },
                ),
              ]),

              const SizedBox(height: 32),
              Center(
                child: Text(
                  l10n.changesSavedAutomatically,
                  style: AppText.caption.copyWith(color: AppColors.grey400),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // --- NOUVEAU PICKER CALENDRIER (style EditCalendarScreen) ---
  Future<DateTime?> _showDatePickerCalendar(
    BuildContext context, {
    required DateTime? initialDate,
    required String title,
  }) async {
    DateTime? selectedDate = initialDate;
    
    return showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => _DatePickerBottomSheet(
        initialDate: selectedDate,
        title: title,
        onDateSelected: (date) {
          selectedDate = date;
          Navigator.pop(context, date);
        },
      ),
    );
  }

  // --- PICKERS POUR LES NOMBRES (anciens composants) ---
  
  Future<int?> _pickCycleLengthPicker(
    BuildContext context, {
    required String title,
    required int currentValue,
    required int min,
    required int max,
  }) {
    return showModalBottomSheet<int>(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.grey300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(title, style: AppText.h4),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (int value = min; value <= max; value++)
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(value),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: value == currentValue
                              ? AppColors.primary50
                              : AppColors.grey100,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: value == currentValue
                                ? AppColors.primary300
                                : AppColors.grey200,
                          ),
                        ),
                        child: Text(
                          '$value',
                          style: AppText.label.copyWith(
                            color: value == currentValue
                                ? AppColors.primary400
                                : AppColors.grey800,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<int?> _pickPeriodLengthPicker(
    BuildContext context, {
    required String title,
    required int currentValue,
    required int min,
    required int max,
  }) {
    return showModalBottomSheet<int>(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.grey300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(title, style: AppText.h4),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (int value = min; value <= max; value++)
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(value),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: value == currentValue
                              ? AppColors.primary50
                              : AppColors.grey100,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: value == currentValue
                                ? AppColors.primary300
                                : AppColors.grey200,
                          ),
                        ),
                        child: Text(
                          '$value',
                          style: AppText.label.copyWith(
                            color: value == currentValue
                                ? AppColors.primary400
                                : AppColors.grey800,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

// --- BOTTOM SHEET CALENDRIER (style EditCalendarScreen) ---

class _DatePickerBottomSheet extends StatefulWidget {
  final DateTime? initialDate;
  final String title;
  final Function(DateTime) onDateSelected;

  const _DatePickerBottomSheet({
    required this.initialDate,
    required this.title,
    required this.onDateSelected,
  });

  @override
  State<_DatePickerBottomSheet> createState() => _DatePickerBottomSheetState();
}

class _DatePickerBottomSheetState extends State<_DatePickerBottomSheet> {
  late DateTime _currentMonth;
  DateTime? _selectedDate;

  static const List<String> _monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];
  static const List<String> _weekDays = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _currentMonth = widget.initialDate ?? DateTime.now();
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
    });
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Widget _buildCalendar() {
    final firstDay = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final lastDay = DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
    int startOffset = firstDay.weekday - 1;
    final int totalDays = lastDay.day;
    final int totalCells = ((startOffset + totalDays) / 7).ceil() * 7;

    return Column(
      children: [
        // En-tête des jours
        Row(
          children: _weekDays.map((d) => Expanded(
            child: Text(
              d,
              style: AppText.caption.copyWith(color: AppColors.grey400),
              textAlign: TextAlign.center,
            ),
          )).toList(),
        ),
        const SizedBox(height: 12),
        // Grille des jours
        GridView.builder(
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
              return const SizedBox.shrink();
            }
            final date = DateTime(_currentMonth.year, _currentMonth.month, dayNum);
            final isSelected = _selectedDate != null && _isSameDay(date, _selectedDate!);
            
            return GestureDetector(
              onTap: () => _selectDate(date),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  '$dayNum',
                  style: AppText.label.copyWith(
                    color: isSelected ? AppColors.white : AppColors.grey900,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Indicateur de swipe
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.grey300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: AppText.h3,
                ),
                TextButton(
                  onPressed: () {
                    if (_selectedDate != null) {
                      widget.onDateSelected(_selectedDate!);
                    }
                  },
                  child: Text(
                    'OK',
                    style: AppText.body.copyWith(
                      color: AppColors.primary500,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Navigation mois
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: _previousMonth,
                  icon: const Icon(Icons.chevron_left, color: AppColors.grey600),
                ),
                Text(
                  '${_monthNames[_currentMonth.month - 1]} ${_currentMonth.year}',
                  style: AppText.h4,
                ),
                IconButton(
                  onPressed: _nextMonth,
                  icon: const Icon(Icons.chevron_right, color: AppColors.grey600),
                ),
              ],
            ),
          ),
          const Divider(height: 16, color: AppColors.grey200),
          // Calendrier
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildCalendar(),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// --- WIDGETS DE DESIGN (DESIGN SYSTEM PERIA) ---

class _ProfileSectionCard extends StatelessWidget {
  final List<Widget> children;
  const _ProfileSectionCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _EditableField extends StatelessWidget {
  final String label;
  final String value;
  final ValueChanged<String> onChanged;

  const _EditableField({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppText.label.copyWith(color: AppColors.grey500)),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: value,
          style: AppText.body,
          onFieldSubmitted: onChanged,
          onSaved: (val) => onChanged(val ?? ''),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.grey50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }
}

class _SelectableRow extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const _SelectableRow({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppText.body.copyWith(color: AppColors.grey600)),
            Row(
              children: [
                Text(value, style: AppText.body.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(width: 4),
                const Icon(Icons.chevron_right, color: AppColors.grey400, size: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppText.body.copyWith(color: AppColors.grey600)),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary500,
          ),
        ],
      ),
    );
  }
}

class _PersonalInfoSkeleton extends StatelessWidget {
  const _PersonalInfoSkeleton();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.grey100,
      highlightColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: List.generate(2, (index) => Container(
            margin: const EdgeInsets.only(bottom: 24),
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
          )),
        ),
      ),
    );
  }
}