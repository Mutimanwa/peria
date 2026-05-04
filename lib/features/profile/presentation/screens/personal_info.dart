import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:peria_app/core/theme/theme.dart';
import 'package:peria_app/features/profile/presentation/providers/user_profile_provider.dart';
import 'package:peria_app/l10n/app_localizations.dart';
import 'package:peria_app/shared/widgets/common_widgets.dart';
import 'package:peria_app/core/constants/app_assets.dart';

class PersonalInformationScreen extends ConsumerStatefulWidget {
  const PersonalInformationScreen({super.key});

  @override
  ConsumerState<PersonalInformationScreen> createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState
    extends ConsumerState<PersonalInformationScreen> {
  bool _isEditMode = false;

  void _toggleEditMode() {
    setState(() => _isEditMode = !_isEditMode);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final profileAsync = ref.watch(userProfileProvider);

    return SimplePage(
      title: l10n.personalInformation,
      fallbackRoute: '/profile',
      child: profileAsync.when(
        skipLoadingOnReload: true,
        loading: () => const _PersonalInfoSkeleton(),
        error: (err, _) => Center(child: Text(l10n.unableToLoadProfile)),
        data: (profile) => SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- AVATAR ---
              Center(
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: AppColors.grey300, width: 1.5),
                            image: const DecorationImage(
                              image: AssetImage(AppAssets.avatar),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        if (_isEditMode)
                          Container(
                            padding: const EdgeInsets.all(6),
                            margin: const EdgeInsets.only(bottom: 4, right: 4),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.grey300),
                            ),
                            child: const Icon(Icons.edit_outlined,
                                size: 20, color: AppColors.grey800),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (!_isEditMode)
                      OutlinedButton.icon(
                        icon: const Icon(Icons.edit_outlined, size: 18),
                        label: const Text("Edit Profile"),
                        onPressed: _toggleEditMode,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.grey900,
                          side: const BorderSide(color: AppColors.grey900),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // --- FIELDS ---
              if (!_isEditMode) ...[
                // VIEW MODE
                _ReadOnlyField(
                  label: "Full Name",
                  value: profile.displayName?.isNotEmpty == true
                      ? profile.displayName!
                      : "—",
                ),
                const SizedBox(height: 16),
                _ReadOnlyField(
                  label: "Email Address",
                  value:
                      profile.email?.isNotEmpty == true ? profile.email! : "—",
                ),
                const SizedBox(height: 16),
                _ReadOnlyField(
                  label: "Date of Birth",
                  value: profile.dateOfBirth != null
                      ? DateFormat('dd.MM.yyyy').format(profile.dateOfBirth!)
                      : '—',
                  trailing: const Icon(Icons.calendar_today_outlined,
                      color: AppColors.grey400, size: 20),
                ),
                const SizedBox(height: 16),
                _ReadOnlyField(
                  label: "My Goal",
                  value: (profile.goals?.isNotEmpty == true)
                      ? "${profile.goals!.length} Selected"
                      : "0 Selected",
                  trailing: const Icon(Icons.keyboard_arrow_down,
                      color: AppColors.grey400, size: 24),
                ),
              ] else ...[
                // EDIT MODE
                _EditableField(
                  label: "Full Name",
                  value: profile.displayName ?? '',
                  onChanged: (val) =>
                      ref.read(userProfileProvider.notifier).patch(
                            (p) => p.copyWith(displayName: val),
                          ),
                ),
                const SizedBox(height: 16),
                _EditableField(
                  label: "Email Address",
                  value: profile.email ?? '',
                  onChanged: (val) =>
                      ref.read(userProfileProvider.notifier).patch(
                            (p) => p.copyWith(email: val),
                          ),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () async {
                    final date = await _showDatePickerCalendar(
                      context,
                      initialDate: profile.dateOfBirth,
                      title: "Date of Birth",
                    );
                    if (date != null) {
                      ref
                          .read(userProfileProvider.notifier)
                          .patch((p) => p.copyWith(dateOfBirth: date));
                    }
                  },
                  borderRadius: BorderRadius.circular(24),
                  child: _ReadOnlyField(
                    label: "Date of Birth",
                    value: profile.dateOfBirth != null
                        ? DateFormat('dd.MM.yyyy').format(profile.dateOfBirth!)
                        : '—',
                    trailing: const Icon(Icons.calendar_today_outlined,
                        color: AppColors.grey400, size: 20),
                  ),
                ),
                const SizedBox(height: 16),
                _ReadOnlyField(
                  label: "My Goal",
                  value: (profile.goals?.isNotEmpty == true)
                      ? "${profile.goals!.length} Selected"
                      : "0 Selected",
                  trailing: const Icon(Icons.keyboard_arrow_down,
                      color: AppColors.grey400, size: 24),
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: PrimaryButton(
                   label: 'Save Changes',
                   onPressed: _toggleEditMode,
                   ),
                ),
              ],
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
    'Mo',
    'Tu',
    'We',
    'Th',
    'Fr',
    'Sa',
    'Su'
  ];

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
          children: _weekDays
              .map((d) => Expanded(
                    child: Text(
                      d,
                      style: AppText.caption.copyWith(color: AppColors.grey400),
                      textAlign: TextAlign.center,
                    ),
                  ))
              .toList(),
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
            final date =
                DateTime(_currentMonth.year, _currentMonth.month, dayNum);
            final isSelected =
                _selectedDate != null && _isSameDay(date, _selectedDate!);

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
                  icon:
                      const Icon(Icons.chevron_left, color: AppColors.grey600),
                ),
                Text(
                  '${_monthNames[_currentMonth.month - 1]} ${_currentMonth.year}',
                  style: AppText.h4,
                ),
                IconButton(
                  onPressed: _nextMonth,
                  icon:
                      const Icon(Icons.chevron_right, color: AppColors.grey600),
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
            fillColor: AppColors.grey100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
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

class _ReadOnlyField extends StatelessWidget {
  final String label;
  final String value;
  final Widget? trailing;

  const _ReadOnlyField({
    required this.label,
    required this.value,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppText.label.copyWith(color: AppColors.grey800)),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          decoration: BoxDecoration(
            color: AppColors.grey100,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(value, style: AppText.body),
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ],
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
          children: List.generate(
              2,
              (index) => Container(
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
