import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:perla_app/core/theme/theme.dart';
import 'package:perla_app/features/calendar/data/models/symptom_log.dart';
import 'package:perla_app/features/calendar/presentation/providers/symptom_provider.dart';
import 'package:perla_app/shared/widgets/common_widgets.dart';

class SymptomsScreen extends ConsumerStatefulWidget {
  const SymptomsScreen({super.key});

  @override
  ConsumerState<SymptomsScreen> createState() => _SymptomsScreenState();
}

class _SymptomsScreenState extends ConsumerState<SymptomsScreen> {
  late List<DateTime> _dates;
  late DateTime _selectedDate;
  Map<String, Set<String>> _selectedByCategory = {};
  String? _loadedDocumentId;

  static const Map<String, List<_SymptomOption>> _categories = {
    'Sexual activity': [
      _SymptomOption('Protected Sex', Icons.female),
      _SymptomOption('Orgasm', Icons.favorite_border),
      _SymptomOption('High activity', Icons.local_fire_department_outlined),
      _SymptomOption('Unprotected sex', Icons.male),
    ],
    'Mental': [
      _SymptomOption('Breathing Exercises', Icons.air),
      _SymptomOption('Stress', Icons.self_improvement),
      _SymptomOption('Yoga', Icons.accessibility_new),
      _SymptomOption('Meditation', Icons.spa_outlined),
    ],
    'Discharge': [
      _SymptomOption('Unusual', Icons.water_drop_outlined),
      _SymptomOption('Sticky', Icons.water_drop),
      _SymptomOption('Bleeding', Icons.opacity),
      _SymptomOption('Heavy Bleeding', Icons.bloodtype_outlined),
      _SymptomOption('Low Bleeding', Icons.invert_colors_off_outlined),
    ],
    'Physical activity': [
      _SymptomOption('No Exercise', Icons.remove),
      _SymptomOption('Team sports', Icons.sports_basketball),
      _SymptomOption('Cycling', Icons.directions_bike),
      _SymptomOption('Gym', Icons.fitness_center),
      _SymptomOption('Dancing', Icons.music_note_outlined),
      _SymptomOption('Aerobics', Icons.directions_walk),
      _SymptomOption('Swimming', Icons.pool),
    ],
    'Mood': [
      _SymptomOption('Anxious', Icons.sentiment_dissatisfied),
      _SymptomOption('Sad', Icons.sentiment_dissatisfied_outlined),
      _SymptomOption('Happy', Icons.sentiment_very_satisfied),
      _SymptomOption('Calm', Icons.sentiment_satisfied),
      _SymptomOption('Angry', Icons.sentiment_very_dissatisfied),
      _SymptomOption('Energetic', Icons.bolt_outlined),
      _SymptomOption('Confused', Icons.sentiment_neutral),
      _SymptomOption('Depressed', Icons.cloud_outlined),
    ],
  };

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    final weekStart = DateTime(today.year, today.month, today.day)
        .subtract(Duration(days: today.weekday - 1));
    _dates = List.generate(7, (index) => weekStart.add(Duration(days: index)));
    _selectedDate = DateTime(today.year, today.month, today.day);
  }

  void _applyLog(SymptomLog? log) {
    final next = <String, Set<String>>{};
    if (log != null) {
      for (final entry in log.selections.entries) {
        next[entry.key] = entry.value.toSet();
      }
    }
    _selectedByCategory = next;
    _loadedDocumentId = log?.id ?? ref.read(symptomRepositoryProvider).documentIdForDate(_selectedDate);
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
    );

    await repository.saveForDate(log);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final asyncLog = ref.watch(symptomLogProvider(_selectedDate));
    final expectedId =
        ref.read(symptomRepositoryProvider).documentIdForDate(_selectedDate);
    if (_loadedDocumentId != expectedId && asyncLog.hasValue) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() => _applyLog(asyncLog.value));
      });
    }

    return PageScaffold(
      showBack: true,
      onBack: () => context.pop(),
      showTitle: true,
      title: 'Log Symptoms',
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 80, bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('MMMM').format(_selectedDate),
                          style: AppText.h3,
                        ),
                        Text(
                          DateFormat('y').format(_selectedDate),
                          style: AppText.caption.copyWith(
                            color: AppColors.grey600,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 70,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _dates.length,
                      itemBuilder: (context, index) {
                        final date = _dates[index];
                        final isSelected = date == _selectedDate;
                        final dayName = DateFormat('E').format(date);

                        return GestureDetector(
                          onTap: () => setState(() => _selectedDate = date),
                          child: Container(
                            width: 56,
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary100
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${date.day}',
                                  style: AppTypography.bodyLarge.copyWith(
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.black,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  dayName,
                                  style: AppText.caption.copyWith(
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.grey500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.grey50,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.grey200),
                      ),
                      child: Text(
                        'Quick daily symptom capture. Tap everything that matches how you feel today.',
                        style: AppText.body.copyWith(color: AppColors.grey600),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (asyncLog.isLoading)
                    const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else
                    ..._categories.entries.map(
                      (entry) => _buildCategoryCard(entry.key, entry.value),
                    ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: PrimaryButton(
              label: 'Save',
              onPressed: _save,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String title, List<_SymptomOption> options) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.grey200),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppText.h4),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: options
                  .map(
                    (option) => _Pill(
                      label: option.label,
                      icon: option.icon,
                      isSelected: _isSelected(title, option.label),
                      onTap: () => _toggleSelection(title, option.label),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary50 : AppColors.grey50,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary100 : AppColors.grey200,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? AppColors.primary : AppColors.grey600,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                color: isSelected ? AppColors.primary : AppColors.grey800,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SymptomOption {
  const _SymptomOption(this.label, this.icon);

  final String label;
  final IconData icon;
}
