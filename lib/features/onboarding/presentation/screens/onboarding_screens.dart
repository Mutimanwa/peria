import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:perla_app/core/theme/theme.dart';
import 'package:perla_app/shared/widgets/common_widgets.dart';

/// ═══════════════════════════════════════════════════════════════════
///  ÉCRAN 6 — Ask Name
///  Maquette : Ask_Name_2x.png
///
///  Structure :
///   • Bouton retour + Skip (haut)
///   • Illustration 3D personnage violet tenant un téléphone  ← IMAGE À REMPLIR
///   • Titre "What should we call you?"
///   • Sous-titre
///   • Champ pill "Enter your name"
///   • Bouton "Continue" (désactivé si vide)
/// ═══════════════════════════════════════════════════════════════════
class AskNameScreen extends StatefulWidget {
  const AskNameScreen({super.key});

  @override
  State<AskNameScreen> createState() => _AskNameScreenState();
}

class _AskNameScreenState extends State<AskNameScreen> {
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

  @override
  Widget build(BuildContext context) {
    return OnboardingScaffold(
      showBack: true,
      showSkip: true,
onSkip: () => context.go('/home'),

      child: Padding(
        padding: const EdgeInsets.only(top: 70),
        child: Column(
          children: [
            // ── Illustration 3D ────────────────────────────────
            // ⚠️  IMAGE 3D À REMPLIR
            // Remplacer par : Image.asset('assets/images/ask_name_character.png', height: 200)
            // Personnage féminin aux cheveux violets/lavande tenant un téléphone, souriant
            Container(
              width: 200,
              height: 200,
              alignment: Alignment.center,
              child: Image.asset("images/icons/login1.png")
            ),
            const SizedBox(height: 32),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const Text('What should we call you?',
                      style: AppText.h1, textAlign: TextAlign.center),
                  const SizedBox(height: 10),
                  const Text(
                    "Let's make this experience truly yours.",
                    style: AppText.body,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  PillTextField(
                    hint: 'Enter your name',
                    controller: _nameController,
                    keyboardType: TextInputType.name,
                  ),
                ],
              ),
            ),

            const Spacer(),

            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
              child: PrimaryButton(
                label: 'Continue',
                onPressed: _hasName
                    ? () {
                      context.go("/date-of-birth");
                    }
                    : null,
              ),
            ),
          ],
        ),
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
class DateOfBirthScreen extends StatefulWidget {
  const DateOfBirthScreen({super.key});

  @override
  State<DateOfBirthScreen> createState() => _DateOfBirthScreenState();
}

class _DateOfBirthScreenState extends State<DateOfBirthScreen> {
  int _selectedMonth = 0; // index
  int _selectedDay = 0;
  int _selectedYear = 0;

  static const List<String> _months = [
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
    'December'
  ];
  final List<int> _days = List.generate(31, (i) => i + 1);
  final List<int> _years = List.generate(80, (i) => DateTime.now().year - i);

  String get _displayDate {
    final m = _selectedMonth + 1;
    final d = _days[_selectedDay];
    final y = _years[_selectedYear];
    return '${d.toString().padLeft(2, '0')}.${m.toString().padLeft(2, '0')}.$y';
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingScaffold(
      showBack: true,
      showSkip: true,
onSkip: () => context.go('/home'),

      child: Padding(
        padding: const EdgeInsets.only(top: 70),
        child: Column(
          children: [
            // ── Illustration 3D personnage avec livre ───────────

            Container(
              width: 200,
              height: 200,
              
              alignment: Alignment.center,
              child: Image.asset("images/icons/birthday.png")
            ),
            const SizedBox(height: 28),

            const Text("When's your birthday",
                style: AppText.h1, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            const Text(
              'This helps us personalize your cycle predictions.',
              style: AppText.body,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // ── Champ date display ──────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.grey100,
                  borderRadius: BorderRadius.circular(50),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(_displayDate, style: AppText.label),
                    ),
                    const Icon(Icons.calendar_today_outlined,
                        size: 20, color: AppColors.grey500),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Séparateur
            const Divider(color: AppColors.grey200, height: 1),
            const SizedBox(height: 8),

            // ── Scroll Picker : Mois | Jour | Année ─────────────
            SizedBox(
              height: 180,
              child: Row(
                children: [
                  // Mois
                  Expanded(
                      child: _ScrollColumn(
                    items: _months,
                    selected: _selectedMonth,
                    onChanged: (i) => setState(() => _selectedMonth = i),
                  )),
                  // Jour
                  Expanded(
                      child: _ScrollColumn(
                    items: _days.map((d) => d.toString()).toList(),
                    selected: _selectedDay,
                    onChanged: (i) => setState(() => _selectedDay = i),
                  )),
                  // Année
                  Expanded(
                      child: _ScrollColumn(
                    items: _years.map((y) => y.toString()).toList(),
                    selected: _selectedYear,
                    onChanged: (i) => setState(() => _selectedYear = i),
                  )),
                ],
              ),
            ),

            const Spacer(),

            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
              child: PrimaryButton(
                label: 'Continue',
                onPressed: () {
                  context.go("/set-goals");
                },
              ),
            ),
          ],
        ),
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
