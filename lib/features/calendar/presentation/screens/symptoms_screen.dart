import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:perla_app/core/theme/theme.dart';
import 'package:perla_app/shared/widgets/common_widgets.dart';

class SymptomsScreen extends StatefulWidget {
  const SymptomsScreen({super.key});

  @override
  State<SymptomsScreen> createState() => _SymptomsScreenState();
}

class _SymptomsScreenState extends State<SymptomsScreen> {
  // Liste des dates pour le scroller horizontal
  final List<DateTime> _dates = List.generate(
      7, (index) => DateTime(2025, 9, 18).add(Duration(days: index)));
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = _dates[3]; // Le 21, comme sur la maquette
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      showBack: true,
      onBack: () => context.pop(),
      showTitle: true,
      title: 'Add Symptoms',
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 80, bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Date Scroller ──────────
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('September', style: AppText.h3),
                        Row(
                          children: [
                            Icon(Icons.chevron_left, color: AppColors.grey600),
                            SizedBox(width: 16),
                            Icon(Icons.chevron_right, color: AppColors.black),
                          ],
                        )
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
                        final dayName = [
                          'Mo',
                          'Tu',
                          'We',
                          'Th',
                          'Fr',
                          'Sa',
                          'Su'
                        ][date.weekday - 1];

                        return GestureDetector(
                          onTap: () => setState(() => _selectedDate = date),
                          child: Container(
                            width: 50,
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
                                Text('${date.day}',
                                    style: AppTypography.bodyLarge.copyWith(
                                      color: isSelected
                                          ? AppColors.primary
                                          : AppColors.black,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                    )),
                                Text(dayName,
                                    style: AppText.caption.copyWith(
                                      color: isSelected
                                          ? AppColors.primary
                                          : AppColors.grey500,
                                    )),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildCategoryCard('Sexual activity', [
                    const _Pill(
                        label: 'Protected Sex',
                        icon: Icons.female,
                        isSelected: true),
                    const _Pill(
                        label: 'Orgasm',
                        icon: Icons.favorite_border,
                        isSelected: true),
                    const _Pill(label: 'High activity', icon: Icons.search),
                    const _Pill(label: 'Unprotected sex', icon: Icons.male),
                  ]),

                  _buildCategoryCard('Mental', [
                    const _Pill(
                        label: 'Breathing Exercises',
                        icon: Icons.directions_run,
                        isSelected: true),
                    const _Pill(
                        label: 'Stress',
                        icon: Icons.self_improvement,
                        isSelected: true),
                    const _Pill(label: 'Yoga', icon: Icons.cloud_outlined),
                    const _Pill(label: 'Meditation', icon: Icons.self_improvement),
                  ]),

                  _buildCategoryCard('Discharge', [
                    const _Pill(label: 'Unusual', icon: Icons.water_drop_outlined),
                    const _Pill(
                        label: 'Sticky',
                        icon: Icons.water_drop,
                        isSelected: true),
                    const _Pill(
                        label: 'Bleeding',
                        icon: Icons.water_drop,
                        isSelected: true),
                    const _Pill(
                        label: 'Heavy Bleeding',
                        icon: Icons.water_drop_outlined),
                    const _Pill(
                        label: 'Low Bleeding', icon: Icons.water_drop_outlined),
                  ]),

                  _buildCategoryCard('Physical activity', [
                    const _Pill(
                        label: 'No Exercise',
                        icon: Icons.remove,
                        isSelected: true),
                    const _Pill(
                        label: 'Team sports',
                        icon: Icons.sports_basketball,
                        isSelected: true),
                    const _Pill(
                        label: 'Cycling',
                        icon: Icons.directions_bike,
                        isSelected: true),
                    const _Pill(label: 'Gym', icon: Icons.fitness_center),
                    const _Pill(label: 'Dancing', icon: Icons.accessibility_new),
                    const _Pill(label: 'Aerobics', icon: Icons.directions_walk),
                    const _Pill(
                        label: 'Swimming', icon: Icons.pool, isSelected: true),
                  ]),

                  _buildCategoryCard('Mood', [
                    const _Pill(
                        label: 'Anxious',
                        icon: Icons.sentiment_dissatisfied,
                        isSelected: true),
                    const _Pill(label: 'Sad', icon: Icons.sentiment_dissatisfied),
                    const _Pill(
                        label: 'Happy',
                        icon: Icons.sentiment_very_satisfied,
                        isSelected: true),
                    const _Pill(
                        label: 'Calm',
                        icon: Icons.sentiment_satisfied,
                        isSelected: true),
                    const _Pill(
                        label: 'Angry',
                        icon: Icons.sentiment_very_dissatisfied),
                    const _Pill(
                        label: 'Energetic',
                        icon: Icons.sentiment_satisfied_alt),
                    const _Pill(
                        label: 'Confused',
                        icon: Icons.sentiment_neutral,
                        isSelected: true),
                    const _Pill(
                        label: 'Depressed',
                        icon: Icons.sentiment_very_dissatisfied,
                        isSelected: true),
                  ]),
                ],
              ),
            ),
          ),

          // ── Bottom Save Button ──────────
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: PrimaryButton(
              label: 'save',
              onPressed: () => context.pop(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String title, List<Widget> children) {
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
              children: children,
            ),
          ],
        ),
      ),
    );
  }

}

class _Pill extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;

  const _Pill({required this.label, required this.icon, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
