import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:peria_app/core/constants/app_assets.dart';
import 'package:peria_app/core/router/router.dart';
import 'package:peria_app/core/theme/theme.dart';
import 'package:peria_app/features/onboarding/domain/minimum_age.dart';
import 'package:peria_app/features/profile/presentation/providers/user_profile_provider.dart';
import 'package:peria_app/l10n/app_localizations.dart';
import 'package:peria_app/shared/widgets/common_widgets.dart';

/// ═══════════════════════════════════════════════════════════════════
///
///  Structure :
///   • Bouton retour + Skip (haut)
///   • Illustration 3D personnage violet tenant un téléphone  ← IMAGE À REMPLIR
///   • Titre "What should we call you?"
///   • Sous-titre
///   • Champ pill "Enter your name"
///   • Bouton "Continue" (désactivé si vide)
/// ═══════════════════════════════════════════════════════════════════
class AskNameScreen extends ConsumerStatefulWidget {
  const AskNameScreen({super.key});

  @override
  ConsumerState<AskNameScreen> createState() => _AskNameScreenState();
}

class _AskNameScreenState extends ConsumerState<AskNameScreen> {
  final _nameController = TextEditingController();
  bool _hasName = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() =>
        setState(() => _hasName = _nameController.text.trim().isNotEmpty));
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    try {
      await ref
          .read(userProfileProvider.notifier)
          .patch((profile) => profile.copyWith(displayName: name))
          .timeout(const Duration(seconds: 3));
    } catch (_) {
      // A failed profile write must not trap the user on this screen.
    }
    if (!mounted) return;
    context.go('/date-of-birth');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;
    return OnboardingScaffold(
      showBack: true,
      showSkip: true,
      // Skip still has to pass the age step. It must not open the app, and it
      // must not be treated as a finished onboarding.
      onSkip: () => context.go('/date-of-birth'),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.fromLTRB(24, 72, 24, 24 + keyboard),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: (constraints.maxHeight - 96 - keyboard)
                    .clamp(0, double.infinity),
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: keyboard > 0 ? 88 : 160,
                    height: keyboard > 0 ? 88 : 160,
                    child: Image.asset(AppAssets.login, fit: BoxFit.contain),
                  ),
                  const SizedBox(height: 24),
                  Text(l10n.askNameTitle,
                      style: AppText.h1, textAlign: TextAlign.center),
                  const SizedBox(height: 10),
                  Text(l10n.askNameSubtitle,
                      style: AppText.body, textAlign: TextAlign.center),
                  const SizedBox(height: 32),
                  PillTextField(
                    hint: l10n.enterYourNameHint,
                    controller: _nameController,
                    keyboardType: TextInputType.name,
                    scrollPadding: EdgeInsets.only(bottom: keyboard + 96),
                  ),
                  const SizedBox(height: 28),
                  PrimaryButton(
                    label: l10n.continueCta,
                    onPressed: _hasName ? _continue : null,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// ═══════════════════════════════════════════════════════════════════
///  ÉCRAN 7 — Date of Birth
///  Maquette : Date_of_Birth_2x.png
///
///  Structure :
///   • Bouton retour + Skip
///   • Illustration 3D personnage violet lisant un livre  ← IMAGE À REMPLIR
///   • Titre "When's your birthday"
///   • Sous-titre
///   • Champ pill avec date + icône calendrier
///   • Scroll picker : Mois | Jour | Année
///   • Bouton "Continue"
/// ═══════════════════════════════════════════════════════════════════
class DateOfBirthScreen extends ConsumerStatefulWidget {
  const DateOfBirthScreen({super.key});

  @override
  ConsumerState<DateOfBirthScreen> createState() => _DateOfBirthScreenState();
}

class _DateOfBirthScreenState extends ConsumerState<DateOfBirthScreen> {
  int _selectedMonth = 0; // index
  int _selectedDay = 0;
  // Default to 18 years ago so a typical adult is not blocked, while ages
  // under 10 stay selectable and rejected.
  int _selectedYear = 18;

  final List<int> _days = List.generate(31, (i) => i + 1);
  final List<int> _years = List.generate(80, (i) => DateTime.now().year - i);

  DateTime get _selectedDate => calendarDate(
        _years[_selectedYear],
        _selectedMonth + 1,
        _days[_selectedDay],
      );

  bool get _isOldEnough => isAtLeastMinimumAge(_selectedDate, DateTime.now());

  Future<void> _continue() async {
    if (!_isOldEnough) return;
    final selectedDob = _selectedDate;
    try {
      await ref
          .read(userProfileProvider.notifier)
          .patch((profile) => profile.copyWith(dateOfBirth: selectedDob))
          .timeout(const Duration(seconds: 3));
    } catch (_) {
      // Age was already checked locally. Don't block the flow on a write error.
    }
    if (!mounted) return;
    context.go(hasCompletedOnboarding ? '/cycle' : '/last-period');
  }


  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final months = List.generate(
      12,
      (index) => DateFormat.MMMM(locale).format(DateTime(2024, index + 1, 1)),
    );
    final displayDate = DateFormat.yMd(locale).format(_selectedDate);
    final oldEnough = _isOldEnough;
    return OnboardingScaffold(
      showBack: true,
      showSkip: false,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 72, 24, 12),
              child: Column(
                children: [
                  SizedBox(
                    width: 140,
                    height: 140,
                    child: Image.asset(AppAssets.birthday, fit: BoxFit.contain),
                  ),
                  const SizedBox(height: 20),
                  Text(l10n.dateOfBirthTitle,
                      style: AppText.h1, textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  Text(l10n.dateOfBirthSubtitle,
                      style: AppText.body, textAlign: TextAlign.center),
                  const SizedBox(height: 24),
                  Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.grey100,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(displayDate, style: AppText.label),
                        ),
                        const Icon(Icons.calendar_today_outlined,
                            size: 20, color: AppColors.grey500),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Divider(color: AppColors.grey200, height: 1),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 180,
                    child: Row(
                      children: [
                        Expanded(
                            child: _ScrollColumn(
                          items: months,
                          selected: _selectedMonth,
                          onChanged: (i) => setState(() => _selectedMonth = i),
                        )),
                        Expanded(
                            child: _ScrollColumn(
                          items: _days.map((d) => d.toString()).toList(),
                          selected: _selectedDay,
                          onChanged: (i) => setState(() => _selectedDay = i),
                        )),
                        Expanded(
                            child: _ScrollColumn(
                          items: _years.map((y) => y.toString()).toList(),
                          selected: _selectedYear,
                          onChanged: (i) => setState(() => _selectedYear = i),
                        )),
                      ],
                    ),
                  ),
                  if (!oldEnough) ...[
                    const SizedBox(height: 12),
                    Text(
                      l10n.minimumAgeMessage(minimumAccountAgeYears),
                      style: AppText.body.copyWith(color: AppColors.error),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: PrimaryButton(
              label: l10n.continueCta,
              onPressed: oldEnough ? _continue : null,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Colonne de scroll pour le date picker ───────────
class _ScrollColumn extends StatefulWidget {
  final List<String> items;
  final int selected;
  final ValueChanged<int> onChanged;

  const _ScrollColumn(
      {required this.items, required this.selected, required this.onChanged});

  @override
  State<_ScrollColumn> createState() => _ScrollColumnState();
}

class _ScrollColumnState extends State<_ScrollColumn> {
  late FixedExtentScrollController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = FixedExtentScrollController(initialItem: widget.selected);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Ligne sélection (style maquette : underline sur l'item central)
        const Positioned(
          top: 70,
          left: 8,
          right: 8,
          child: Divider(color: AppColors.grey200, thickness: 1),
        ),
        const Positioned(
          top: 110,
          left: 8,
          right: 8,
          child: Divider(color: AppColors.grey200, thickness: 1),
        ),
        ListWheelScrollView.useDelegate(
          controller: _ctrl,
          itemExtent: 42,
          diameterRatio: 2.5,
          physics: const FixedExtentScrollPhysics(),
          onSelectedItemChanged: widget.onChanged,
          childDelegate: ListWheelChildBuilderDelegate(
            childCount: widget.items.length,
            builder: (context, i) {
              final isSelected = i == widget.selected;
              return Center(
                child: Text(
                  widget.items[i],
                  style: isSelected
                      ? AppText.label.copyWith(fontSize: 17)
                      : AppText.body
                          .copyWith(color: AppColors.grey400, fontSize: 15),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
