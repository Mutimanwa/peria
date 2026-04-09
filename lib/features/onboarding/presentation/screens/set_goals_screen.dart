import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:perla_app/core/theme/theme.dart';
import 'package:perla_app/features/profile/presentation/providers/user_profile_provider.dart';
import 'package:perla_app/l10n/app_localizations.dart';
import 'package:perla_app/shared/widgets/common_widgets.dart';

/// ═══════════════════════════════════════════════════════════════════
///  ÉCRAN 8 — Set Goals
///  Maquettes : Set_Goals_2x.png (rien sélectionné) +
///              Set_Goals_-_Select_Items_2x.png (un item sélectionné)
///
///  Structure :
///   • Bouton retour + Skip
///   • Titre "What's your goal?"
///   • Sous-titre
///   • Grille 2 × 3 de GoalCards
///     - Icône dans cercle gris
///     - Label sous l'icône
///     - Sélectionné → fond rose, icône plus claire
///   • Bouton "Continue" (noir quand ≥1 sélection, gris sinon)
///
///  Goals :
///   1. Track my period (cycle icon)
///   2. Understand my body better (body icon)
///   3. Track my period [ovulation] (drop icon)
///   4. Get health insights (heart+magnifier icon)
///   5. Share data with my doctor (stethoscope icon)
///   6. AI-Powered Guidance (chat+sparkle icon)
/// ═══════════════════════════════════════════════════════════════════
class SetGoalsScreen extends ConsumerStatefulWidget {
  const SetGoalsScreen({super.key});

  @override
  ConsumerState<SetGoalsScreen> createState() => _SetGoalsScreenState();
}

class _SetGoalsScreenState extends ConsumerState<SetGoalsScreen> {
  // Ensemble des indices sélectionnés
  final Set<int> _selected = {};

  static final List<_GoalItem> _goals = [
    const _GoalItem(icon: Icons.loop_rounded, label: 'Track my period'),
    const _GoalItem(
        icon: Icons.accessibility_new, label: 'Understand my body better'),
    const _GoalItem(icon: Icons.water_drop_outlined, label: 'Track my period'),
    const _GoalItem(
        icon: Icons.favorite_border_rounded, label: 'Get health insights'),
    const _GoalItem(
        icon: Icons.medical_services, label: 'Share data with my doctor'),
    const _GoalItem(
        icon: Icons.auto_awesome_outlined, label: 'AI-Powered Guidance'),
  ];

  void _toggleGoal(int index) {
    setState(() {
      if (_selected.contains(index)) {
        _selected.remove(index);
      } else {
        _selected.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
final l10n = AppLocalizations.of(context)!;
    final bool canContinue = _selected.isNotEmpty;

    return OnboardingScaffold(
      showBack: true,
      showSkip: true,
      onSkip: () {/* TODO */},
      child: Column(
        children: [
          const SizedBox(height: 72),

          // ── Titre ──────────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Text(l10n.setGoalsTitle,
                    style: AppText.h1, textAlign: TextAlign.center),
                SizedBox(height: 10),
                Text(
                  l10n.setGoalsSubtitle,
                  style: AppText.body,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // ── Grille 2 colonnes ───────────────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.0,
                ),
                itemCount: _goals.length,
                itemBuilder: (context, i) {
                  final isSelected = _selected.contains(i);
                  return _GoalCard(
                    item: _goals[i],
                    isSelected: isSelected,
                    onTap: () => _toggleGoal(i),
                  );
                },
              ),
            ),
          ),

          // ── Bouton Continue ─────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
            child: PrimaryButton(
              label: l10n.continueCta,
              onPressed: canContinue
                  ? () {
                      final goals =
                          _selected.map((i) => _goals[i].label).toList();
                      ref
                          .read(userProfileProvider.notifier)
                          .patch((p) => p.copyWith(goals: goals));
                      context.go("/last-period");
                    }
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Item de la grille ─────────────────────────────────
class _GoalItem {
  final IconData icon;
  final String label;
  const _GoalItem({required this.icon, required this.label});
}

// ── Card de goal (sélectable) ─────────────────────────
class _GoalCard extends StatelessWidget {
  final _GoalItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _GoalCard(
      {required this.item, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary100 : AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary200 : AppColors.grey200,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icône dans cercle
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.white.withOpacity(0.7)
                    : AppColors.grey100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                item.icon,
                size: 26,
                color: isSelected ? AppColors.primary : AppColors.grey700,
              ),
            ),
            const SizedBox(height: 12),
            // Label
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                item.label,
                style: AppText.label.copyWith(
                  color: isSelected ? AppColors.primary : AppColors.grey900,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
