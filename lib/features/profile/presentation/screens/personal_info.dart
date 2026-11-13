import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:peria_app/core/theme/theme.dart';
import 'package:peria_app/features/profile/presentation/providers/user_profile_provider.dart';
import 'package:peria_app/features/onboarding/domain/minimum_age.dart';
import 'package:peria_app/l10n/app_localizations.dart';
import 'package:peria_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:peria_app/features/profile/data/models/user_profile.dart';
import 'package:peria_app/shared/widgets/common_widgets.dart';
import 'package:peria_app/shared/widgets/profile_avatar.dart';

class PersonalInformationScreen extends ConsumerStatefulWidget {
  const PersonalInformationScreen({super.key});

  @override
  ConsumerState<PersonalInformationScreen> createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState
    extends ConsumerState<PersonalInformationScreen> {
  bool _isEditMode = false;
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _enterEditMode(UserProfile profile) {
    _nameController.text = profile.displayName ?? '';
    setState(() => _isEditMode = true);
  }

  Future<void> _saveProfile() async {
    final name = _nameController.text.trim();
    await ref.read(userProfileProvider.notifier).patch(
          (profile) => profile.copyWith(displayName: name),
        );
    if (!mounted) return;
    setState(() => _isEditMode = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final profileAsync = ref.watch(userProfileProvider);
    final isAnonymous =
        ref.watch(authProvider.select((state) => state.user?.isAnonymous)) ??
            false;

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
                        ProfileAvatar(
                          avatarBase64: profile.avatarBase64,
                          radius: 55,
                          withBorder: true,
                        ),
                        GestureDetector(
                          onTap: () => _pickAvatar(profile),
                          child: Container(
                            padding: const EdgeInsets.all(7),
                            margin: const EdgeInsets.only(bottom: 4, right: 4),
                            decoration: BoxDecoration(
                              color: AppColors.grey900,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.white,
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.photo_camera_outlined,
                              size: 18,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (!_isEditMode)
                      OutlinedButton.icon(
                        icon: const Icon(Icons.edit_outlined, size: 18),
                        label: Text(l10n.editProfile),
                        onPressed: () => _enterEditMode(profile),
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
                  label: l10n.fullNameLabel,
                  value: profile.displayName?.isNotEmpty == true
                      ? profile.displayName!
                      : "—",
                ),
                const SizedBox(height: 16),
                if (!isAnonymous) ...[
                  _ReadOnlyField(
                    label: l10n.emailAddressLabel,
                    value: profile.email?.isNotEmpty == true
                        ? profile.email!
                        : "—",
                  ),
                  const SizedBox(height: 16),
                ],
                _ReadOnlyField(
                  label: l10n.dateOfBirth,
                  value: profile.dateOfBirth != null
                      ? DateFormat.yMd(locale).format(profile.dateOfBirth!)
                      : '—',
                  trailing: const Icon(Icons.calendar_today_outlined,
                      color: AppColors.grey400, size: 20),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () => context.push('/set-goals'),
                  borderRadius: BorderRadius.circular(24),
                  child: _ReadOnlyField(
                    label: l10n.myGoal,
                    value: _goalSummary(l10n, profile),
                    trailing: const Icon(Icons.chevron_right_rounded,
                        color: AppColors.grey400, size: 24),
                  ),
                ),
              ] else ...[
                // EDIT MODE
                _EditableField(
                  label: l10n.fullNameLabel,
                  controller: _nameController,
                ),
                const SizedBox(height: 16),
                if (!isAnonymous) ...[
                  _EmailEditField(
                    value: profile.email ?? '',
                    onChanged: (val) =>
                        ref.read(userProfileProvider.notifier).patch(
                              (p) => p.copyWith(email: val),
                            ),
                  ),
                  const SizedBox(height: 16),
                ],
                InkWell(
                  onTap: () async {
                    final date = await _showDatePickerCalendar(
                      context,
                      initialDate: profile.dateOfBirth,
                      title: l10n.dateOfBirth,
                    );
                    if (date != null) {
                      ref
                          .read(userProfileProvider.notifier)
                          .patch((p) => p.copyWith(dateOfBirth: date));
                    }
                  },
                  borderRadius: BorderRadius.circular(24),
                  child: _ReadOnlyField(
                    label: l10n.dateOfBirth,
                    value: profile.dateOfBirth != null
                        ? DateFormat.yMd(locale).format(profile.dateOfBirth!)
                        : '—',
                    trailing: const Icon(Icons.calendar_today_outlined,
                        color: AppColors.grey400, size: 20),
                  ),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () => context.push('/set-goals'),
                  borderRadius: BorderRadius.circular(24),
                  child: _ReadOnlyField(
                    label: l10n.myGoal,
                    value: _goalSummary(l10n, profile),
                    trailing: const Icon(Icons.chevron_right_rounded,
                        color: AppColors.grey400, size: 24),
                  ),
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: PrimaryButton(
                   label: l10n.saveChanges,
                   onPressed: _saveProfile,
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

  String _goalSummary(AppLocalizations l10n, UserProfile profile) {
    final goals = profile.goals;
    if (goals == null || goals.isEmpty) return l10n.noGoalsSelected;
    final visible = goals.take(2).join(' · ');
    return goals.length > 2 ? '$visible…' : visible;
  }

  Future<void> _pickAvatar(UserProfile profile) async {
    final l10n = AppLocalizations.of(context);
    final action = await showModalBottomSheet<_AvatarAction>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _AvatarSourceSheet(
        hasAvatar: profile.avatarBase64?.isNotEmpty == true,
      ),
    );
    if (action == null || !mounted) return;
    if (action == _AvatarAction.remove) {
      await _removeAvatar();
      return;
    }

    try {
      final picked = await ImagePicker().pickImage(
        source: action == _AvatarAction.camera
            ? ImageSource.camera
            : ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 70,
      );
      if (picked == null) return;
      final bytes = await picked.readAsBytes();
      if (!mounted) return;
      await ref.read(userProfileProvider.notifier).patch(
            (current) => current.copyWith(avatarBase64: base64Encode(bytes)),
          );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.photoUpdateFailed)),
      );
    }
  }

  Future<void> _removeAvatar() async {
    await ref.read(userProfileProvider.notifier).patch(
          (current) => current.copyWith(clearAvatar: true),
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
  bool _ageRejected = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _currentMonth = widget.initialDate ?? DateTime.now();
  }

  bool get _canGoForward {
    final now = DateTime.now();
    return _currentMonth.isBefore(DateTime(now.year, now.month));
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
    });
  }

  void _nextMonth() {
    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month);
    // A birth date can never be in the future.
    if (!_currentMonth.isBefore(currentMonth)) return;
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
    });
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
      _ageRejected = false;
    });
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Widget _buildCalendar() {
    final locale = Localizations.localeOf(context).toString();
    final firstDay = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final lastDay = DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
    final firstDayIndex = MaterialLocalizations.of(context).firstDayOfWeekIndex;
    final startOffset = (firstDay.weekday - 1 - firstDayIndex + 7) % 7;
    final int totalDays = lastDay.day;
    final int totalCells = ((startOffset + totalDays) / 7).ceil() * 7;

    return Column(
      children: [
        // En-tête des jours
        Row(
          children: List.generate(7, (index) {
            final weekdayNumber = (firstDayIndex + index + 6) % 7 + 1;
            final weekday = DateTime(2024, 1, weekdayNumber);
            final label = DateFormat.E(locale).format(weekday).replaceAll('.', '');
            return Expanded(
              child: Text(
                label,
                style: AppText.caption.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
            );
          }),
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
            final now = DateTime.now();
            final isFuture = date.isAfter(DateTime(now.year, now.month, now.day));

            return GestureDetector(
              onTap: isFuture ? null : () => _selectDate(date),
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
                    color: isSelected
                        ? AppColors.white
                        : (isFuture ? AppColors.textSecondary : AppColors.grey900),
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
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      child: Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
        mainAxisSize: MainAxisSize.min,
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
                    final date = _selectedDate;
                    if (date == null) return;
                    if (!isAtLeastMinimumAge(date, DateTime.now())) {
                      setState(() => _ageRejected = true);
                      return;
                    }
                    widget.onDateSelected(date);
                  },
                  child: Text(
                    l10n.ok,
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
                  DateFormat.yMMMM(locale).format(_currentMonth),
                  style: AppText.h4,
                ),
                IconButton(
                  onPressed: _canGoForward ? _nextMonth : null,
                  icon: Icon(
                    Icons.chevron_right,
                    color: _canGoForward
                        ? AppColors.grey600
                        : AppColors.grey300,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 16, color: AppColors.grey200),
          if (_ageRejected)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: Text(
                l10n.minimumAgeMessage(minimumAccountAgeYears),
                style: AppText.caption.copyWith(color: AppColors.textError),
                textAlign: TextAlign.center,
              ),
            ),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              child: _buildCalendar(),
            ),
          ),
        ],
      ),
      ),
      ),
    );
  }
}

// --- WIDGETS DE DESIGN (DESIGN SYSTEM PERIA) ---

class _EditableField extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const _EditableField({
    required this.label,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppText.label.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          style: AppText.body,
          textCapitalization: TextCapitalization.words,
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

enum _AvatarAction { camera, gallery, remove }

class _AvatarSourceSheet extends StatelessWidget {
  const _AvatarSourceSheet({required this.hasAvatar});

  final bool hasAvatar;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: AppColors.grey300,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            _AvatarOption(
              icon: Icons.photo_camera_outlined,
              label: l10n.takePhoto,
              onTap: () => Navigator.pop(context, _AvatarAction.camera),
            ),
            _AvatarOption(
              icon: Icons.photo_library_outlined,
              label: l10n.chooseFromGallery,
              onTap: () => Navigator.pop(context, _AvatarAction.gallery),
            ),
            if (hasAvatar)
              _AvatarOption(
                icon: Icons.delete_outline_rounded,
                label: l10n.removePhoto,
                danger: true,
                onTap: () => Navigator.pop(context, _AvatarAction.remove),
              ),
          ],
        ),
      ),
    );
  }
}

class _AvatarOption extends StatelessWidget {
  const _AvatarOption({
    required this.icon,
    required this.label,
    required this.onTap,
    this.danger = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final color = danger ? AppColors.error : AppColors.grey900;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 14),
            Text(
              label,
              style: AppText.body.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmailEditField extends StatefulWidget {
  const _EmailEditField({required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String> onChanged;

  @override
  State<_EmailEditField> createState() => _EmailEditFieldState();
}

class _EmailEditFieldState extends State<_EmailEditField> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.value);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.emailAddressLabel,
          style: AppText.label.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _controller,
          keyboardType: TextInputType.emailAddress,
          style: AppText.body,
          onChanged: widget.onChanged,
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
