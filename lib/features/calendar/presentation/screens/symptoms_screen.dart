import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:perla_app/core/theme/app_typography.dart';
import 'package:perla_app/core/theme/theme.dart';
import 'package:perla_app/shared/widgets/common_widgets.dart';

class SymptomsScreen extends StatefulWidget {
  const SymptomsScreen({super.key});

  @override
  State<SymptomsScreen> createState() => _SymptomsScreenState();
}

class _SymptomsScreenState extends State<SymptomsScreen> {
  // Liste des dates pour le scroller horizontal
  final List<DateTime> _dates = List.generate(7, (index) => DateTime(2025, 9, 18).add(Duration(days: index)));
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = _dates[3]; // Le 21, comme sur la maquette
  }

  void _showWaterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      builder: (context) => const _WaterBottomSheet(),
    );
  }

  void _showWeightSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      builder: (context) => const _WeightBottomSheet(),
    );
  }

  void _showNoteSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      builder: (context) => const _NoteBottomSheet(),
    );
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('September', style: AppText.h3),
                        Row(
                          children: [
                            Icon(Icons.chevron_left, color: AppColors.grey600),
                            const SizedBox(width: 16),
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
                        final dayName = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'][date.weekday - 1];

                        return GestureDetector(
                          onTap: () => setState(() => _selectedDate = date),
                          child: Container(
                            width: 50,
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primary100 : Colors.transparent,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('${date.day}', style: AppTypography.bodyLarge.copyWith(
                                  color: isSelected ? AppColors.primary : AppColors.black,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                )),
                                Text(dayName, style: AppText.caption.copyWith(
                                  color: isSelected ? AppColors.primary : AppColors.grey500,
                                )),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Search Bar ──────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.grey100,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text('Search sympton...', style: AppText.body.copyWith(color: AppColors.grey400)),
                          ),
                          Icon(Icons.search, color: AppColors.grey400),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Symptom Categories ──────────
                  _buildCategoryCard('Pregnancy test', [
                    _Pill(label: 'Faint line', icon: Icons.favorite_border, isSelected: true),
                    _Pill(label: 'Positive', icon: Icons.add_circle_outline),
                    _Pill(label: 'No tests', icon: Icons.cancel_outlined),
                    _Pill(label: 'Negative', icon: Icons.remove_circle_outline, isSelected: true),
                  ]),
                  
                  _buildCategoryCard('Sexual activity', [
                    _Pill(label: 'Protected Sex', icon: Icons.female, isSelected: true),
                    _Pill(label: 'Orgasm', icon: Icons.favorite_border, isSelected: true),
                    _Pill(label: 'High activity', icon: Icons.search),
                    _Pill(label: 'Unprotected sex', icon: Icons.male),
                  ]),

                  _buildCategoryCard('Mental', [
                    _Pill(label: 'Breathing Exercises', icon: Icons.directions_run, isSelected: true),
                    _Pill(label: 'Stress', icon: Icons.self_improvement, isSelected: true),
                    _Pill(label: 'Yoga', icon: Icons.cloud_outlined),
                    _Pill(label: 'Meditation', icon: Icons.self_improvement),
                  ]),

                  _buildCategoryCard('Discharge', [
                    _Pill(label: 'Unusual', icon: Icons.water_drop_outlined),
                    _Pill(label: 'Sticky', icon: Icons.water_drop, isSelected: true),
                    _Pill(label: 'Bleeding', icon: Icons.water_drop, isSelected: true),
                    _Pill(label: 'Heavy Bleeding', icon: Icons.water_drop_outlined),
                    _Pill(label: 'Low Bleeding', icon: Icons.water_drop_outlined),
                  ]),

                  _buildCategoryCard('Physical activity', [
                    _Pill(label: 'No Exercise', icon: Icons.remove, isSelected: true),
                    _Pill(label: 'Team sports', icon: Icons.sports_basketball, isSelected: true),
                    _Pill(label: 'Cycling', icon: Icons.directions_bike, isSelected: true),
                    _Pill(label: 'Gym', icon: Icons.fitness_center),
                    _Pill(label: 'Dancing', icon: Icons.accessibility_new),
                    _Pill(label: 'Aerobics', icon: Icons.directions_walk),
                    _Pill(label: 'Swimming', icon: Icons.pool, isSelected: true),
                  ]),

                  _buildCategoryCard('Mood', [
                    _Pill(label: 'Anxious', icon: Icons.sentiment_dissatisfied, isSelected: true),
                    _Pill(label: 'Sad', icon: Icons.sentiment_dissatisfied),
                    _Pill(label: 'Happy', icon: Icons.sentiment_very_satisfied, isSelected: true),
                    _Pill(label: 'Calm', icon: Icons.sentiment_satisfied, isSelected: true),
                    _Pill(label: 'Angry', icon: Icons.sentiment_very_dissatisfied),
                    _Pill(label: 'Energetic', icon: Icons.sentiment_satisfied_alt),
                    _Pill(label: 'Confused', icon: Icons.sentiment_neutral, isSelected: true),
                    _Pill(label: 'Depressed', icon: Icons.sentiment_very_dissatisfied, isSelected: true),
                  ]),

                  // ── Tracking Cards ──────────
                  _buildTrackingCard('Weight', Icons.monitor_weight_outlined, '75.02 kg', _showWeightSheet),
                  _buildTrackingCard('Note', Icons.calendar_today_outlined, 'I had a very good day.', _showNoteSheet),
                  _buildTrackingCard('Water', Icons.local_drink_outlined, '750 ml / 2000 ml', _showWaterSheet),

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

  Widget _buildTrackingCard(String title, IconData icon, String value, VoidCallback onEdit) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.grey200),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(icon, color: AppColors.primary),
                    const SizedBox(width: 12),
                    Text(title, style: AppText.h4),
                  ],
                ),
                GestureDetector(
                  onTap: onEdit,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.grey200),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.edit_outlined, size: 16),
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),
            Text(value, style: AppText.body),
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
        border: Border.all(color: isSelected ? AppColors.primary100 : AppColors.grey200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: isSelected ? AppColors.primary : AppColors.grey600),
          const SizedBox(width: 8),
          Text(label, style: AppTypography.bodySmall.copyWith(
            color: isSelected ? AppColors.primary : AppColors.grey800,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          )),
        ],
      ),
    );
  }
}

// ── BOTTOM SHEETS ──

class _WaterBottomSheet extends StatelessWidget {
  const _WaterBottomSheet();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.grey200, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: AppColors.primary50, shape: BoxShape.circle),
                    child: Icon(Icons.local_drink_outlined, color: AppColors.primary, size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Text('Water', style: AppText.h3),
                ],
              ),
              GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: AppColors.grey100, shape: BoxShape.circle),
                  child: const Icon(Icons.close, size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.grey50,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const Text('750 ml / 2000 ml', style: AppText.h4),
                const SizedBox(height: 24),
                // Pseudo grid for glasses
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (index) => _WaterGlass(isFilled: index < 3, isPlus: index == 3)),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (index) => const _WaterGlass(isFilled: false, isPlus: false)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          PrimaryButton(label: 'Save', onPressed: () => context.pop()),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _WaterGlass extends StatelessWidget {
  final bool isFilled;
  final bool isPlus;

  const _WaterGlass({required this.isFilled, required this.isPlus});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Text('250 ml', style: AppTypography.captionSmall.copyWith(color: isFilled ? AppColors.info : AppColors.grey400)),
          const SizedBox(height: 4),
          Icon(
            isPlus ? Icons.add_box_outlined : (isFilled ? Icons.local_drink : Icons.local_drink_outlined),
            color: isFilled ? AppColors.info : AppColors.grey300,
            size: 32,
          ),
        ],
      ),
    );
  }
}

class _WeightBottomSheet extends StatelessWidget {
  const _WeightBottomSheet();

  @override
  Widget build(BuildContext context) {
    // Dans une vraie app on aurait un controleur texte + numpad custom
    return Padding(
      padding: EdgeInsets.only(left: 24, right: 24, top: 24, bottom: MediaQuery.of(context).viewInsets.bottom + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.grey200, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: AppColors.primary50, shape: BoxShape.circle),
                    child: Icon(Icons.monitor_weight_outlined, color: AppColors.primary, size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Text('Weight', style: AppText.h3),
                ],
              ),
              GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: AppColors.grey100, shape: BoxShape.circle),
                  child: const Icon(Icons.close, size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: AppColors.grey50, borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: [
                const Text('75.02', style: AppText.h3),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.primary50, borderRadius: BorderRadius.circular(8)),
                  child: Text('kg', style: AppText.caption.copyWith(color: AppColors.primary)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('please type a value from 25 kg to 300 kg', style: AppText.body.copyWith(color: AppColors.grey700)),
          const SizedBox(height: 24),
          PrimaryButton(label: 'Save', onPressed: () => context.pop()),
        ],
      ),
    );
  }
}

class _NoteBottomSheet extends StatelessWidget {
  const _NoteBottomSheet();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 24, right: 24, top: 24, bottom: MediaQuery.of(context).viewInsets.bottom + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.grey200, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: AppColors.primary50, shape: BoxShape.circle),
                    child: Icon(Icons.calendar_today_outlined, color: AppColors.primary, size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Text('Note', style: AppText.h3),
                ],
              ),
              GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: AppColors.grey100, shape: BoxShape.circle),
                  child: const Icon(Icons.close, size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(color: AppColors.grey50, borderRadius: BorderRadius.circular(16)),
            child: const TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'I had a very good day.',
              ),
              maxLines: 5,
            ),
          ),
          const SizedBox(height: 32),
          PrimaryButton(label: 'Save', onPressed: () => context.pop()),
        ],
      ),
    );
  }
}
