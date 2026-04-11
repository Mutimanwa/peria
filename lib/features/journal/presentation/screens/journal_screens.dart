import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:perla_app/core/theme/theme.dart';
import 'package:perla_app/features/journal/data/models/journal_entry.dart';
import 'package:perla_app/features/journal/presentation/providers/journal_provider.dart';
import 'package:perla_app/shared/widgets/common_widgets.dart';
import 'package:perla_app/l10n/app_localizations.dart';

class JournalScreen extends ConsumerStatefulWidget {
  const JournalScreen({super.key});

  @override
  ConsumerState<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends ConsumerState<JournalScreen> {
  late DateTime _selectedDate;
  bool _searchOpen = false;
  String _query = '';
  bool _isLocked = true;
  bool _showLockOverlay = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    // Simuler l'état verrouillé au démarrage (à intégrer avec biométrie réelle)
    _showLockOverlay = _isLocked;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<DateTime> _getWeekDays() {
    final now = _selectedDate;
    final monday = now.subtract(Duration(days: now.weekday - 1));
    return List.generate(7, (i) => monday.add(Duration(days: i)));
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  /// Logique de filtrage disjointe : date OU recherche globale
  List<JournalEntry> _filterEntries(List<JournalEntry> entries) {
    if (_query.isNotEmpty) {
      // Mode recherche global : ignorer le filtre date
      return entries.where((entry) {
        return entry.title.toLowerCase().contains(_query) ||
            entry.content.toLowerCase().contains(_query) ||
            entry.mood.toLowerCase().contains(_query);
      }).toList();
    } else {
      // Mode normal : filtrer par jour sélectionné
      return entries.where((entry) {
        return _isSameDay(entry.createdAt, _selectedDate);
      }).toList();
    }
  }

  /// Vérifier si un jour a des entrées (pour l'indicateur)
  bool _dayHasEntries(DateTime day, List<JournalEntry> entries) {
    return entries.any((entry) => _isSameDay(entry.createdAt, day));
  }

  /// Déverrouiller le journal (biométrie à implémenter)
  void _unlockJournal() async {
    // TODO: Intégrer avec local_auth pour biométrie réelle
    setState(() => _showLockOverlay = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(journalProvider);
    final weekDays = _getWeekDays();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          Container(decoration: const BoxDecoration(gradient: AppColors.bgGradient)),
          SafeArea(
            child: Column(
              children: [
                // ════ HEADER CENTRÉ (sans profil) ════
                _buildCenteredHeader(context, l10n),

                // ════ WEEK CALENDAR avec indicateurs ════
                state.when(
                  data: (entries) => _buildWeekCalendarWithIndicators(weekDays, entries),
                  loading: () => const SizedBox(height: 70),
                  error: (_, __) => const SizedBox(height: 70),
                ),

                // ════ ENTRIES LIST avec animations ════
                Expanded(
                  child: state.when(
                    data: (entries) {
                      final filtered = _filterEntries(entries);

                      if (filtered.isEmpty) {
                        return _EmptyJournal(
                          hasQuery: _query.isNotEmpty,
                          selectedDate: _selectedDate,
                        );
                      }

                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: ListView.builder(
                          key: ValueKey(filtered.length),
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _JournalCard(entry: filtered[index]),
                            );
                          },
                        ),
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (_, __) => Center(
                      child: Text('Unable to load journal'),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ════ ÉCRAN DE VERROUILLAGE BIOMÉTRIQUE ════
          if (_showLockOverlay) _buildLockOverlay(context, l10n),
        ],
      ),
      floatingActionButton: _buildFAB(context, l10n),
    );
  }

  /// Header centré avec actions contextuelles (recherche + verrou)
  Widget _buildCenteredHeader(BuildContext context, AppLocalizations l10n) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(
        children: [
          // Titre centré
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                l10n.journalTitle,
                style: AppText.h4,
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Actions contextuelles en bas
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Search icon
              GestureDetector(
                onTap: () => setState(() => _searchOpen = !_searchOpen),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _searchOpen ? AppColors.primary100 : AppColors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _searchOpen ? AppColors.primary : AppColors.grey200,
                    ),
                  ),
                  child: Icon(
                    Icons.search,
                    size: 18,
                    color: _searchOpen ? AppColors.primary : AppColors.grey700,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Lock icon (toggle biométrie)
              GestureDetector(
                onTap: () => setState(() => _isLocked = !_isLocked),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _isLocked ? AppColors.primary100 : AppColors.grey100,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _isLocked ? AppColors.primary : AppColors.grey300,
                    ),
                  ),
                  child: Icon(
                    _isLocked ? Icons.lock : Icons.lock_open,
                    size: 18,
                    color: _isLocked ? AppColors.primary : AppColors.grey600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Week calendar avec indicateurs de contenu (petit point si entrée existe)
  Widget _buildWeekCalendarWithIndicators(List<DateTime> weekDays, List<JournalEntry> entries) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          // Inline search field (apparaît quand search est ouvert)
          if (_searchOpen)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                controller: _searchController,
                onChanged: (value) => setState(() => _query = value.trim().toLowerCase()),
                decoration: InputDecoration(
                  hintText: 'Search entries...',
                  hintStyle: AppText.body.copyWith(color: AppColors.grey400),
                  prefixIcon: const Icon(Icons.search, color: AppColors.grey400, size: 20),
                  suffixIcon: _query.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            _searchController.clear();
                            setState(() => _query = '');
                          },
                          child: const Icon(Icons.close, color: AppColors.grey400, size: 20),
                        )
                      : null,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.grey200),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.grey200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
            ),

          // Week calendar avec indicateurs
          SizedBox(
            height: 70,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 7,
              itemBuilder: (context, index) {
                final day = weekDays[index];
                final isSelected = _isSameDay(day, _selectedDate);
                final isToday = _isSameDay(day, DateTime.now());
                final hasEntry = _dayHasEntries(day, entries);

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDate = day;
                      _query = ''; // Clear search when changing day
                      _searchOpen = false;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : AppColors.grey200,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('EEE').format(day).substring(0, 1),
                          style: AppText.caption.copyWith(
                            color: isSelected ? AppColors.white : AppColors.grey600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${day.day}',
                          style: AppText.label.copyWith(
                            color: isSelected ? AppColors.white : AppColors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        // Indicateur de contenu
                        if (hasEntry || isToday)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Container(
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.white : AppColors.primary,
                                shape: BoxShape.circle,
                              ),
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

  /// Écran de verrouillage biométrique (overlay)
  Widget _buildLockOverlay(BuildContext context, AppLocalizations l10n) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () {}, // Empêcher les clicks en dessous
        child: Container(
          color: Colors.black87,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock_outline, size: 80, color: AppColors.white),
                const SizedBox(height: 24),
                Text(
                  'Journal verrouillé',
                  style: AppText.h4.copyWith(color: AppColors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  'Authentifiez-vous pour accéder',
                  style: AppText.body.copyWith(color: AppColors.grey300),
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: _unlockJournal,
                  icon: const Icon(Icons.fingerprint),
                  label: const Text('Déverrouiller'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFAB(BuildContext context, AppLocalizations l10n) {
    return FloatingActionButton(
      onPressed: () => context.go('/journal/new'),
      backgroundColor: AppColors.primary,
      child: const Icon(Icons.add, size: 28),
    );
  }
}

class JournalEditorScreen extends ConsumerStatefulWidget {
  const JournalEditorScreen({super.key, this.entryId});

  final String? entryId;

  @override
  ConsumerState<JournalEditorScreen> createState() =>
      _JournalEditorScreenState();
}

class _JournalEditorScreenState extends ConsumerState<JournalEditorScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String _mood = 'calm';
  JournalEntry? _existing;

  static const _moods = [
    ('calm', 'Calm'),
    ('happy', 'Happy'),
    ('sad', 'Sad'),
    ('anxious', 'Anxious'),
    ('tired', 'Tired'),
  ];

  @override
  void initState() {
    super.initState();
    final entries = ref.read(journalProvider).value ?? const <JournalEntry>[];
    if (widget.entryId != null) {
      _existing = entries.cast<JournalEntry?>().firstWhere(
            (item) => item?.id == widget.entryId,
            orElse: () => null,
          );
      if (_existing != null) {
        _titleController.text = _existing!.title;
        _contentController.text = _existing!.content;
        _mood = _existing!.mood;
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PageScaffold(
      showBack: true,
      onBack: () => context.pop(),
      showTitle: true,
      title: widget.entryId == null ? l10n.newEntry : l10n.saveEntry,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 88, 22, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _formattedDate(_existing?.createdAt ?? DateTime.now()),
              style: AppText.caption.copyWith(color: AppColors.grey500),
            ),
            const SizedBox(height: 16),
            const Text('How are you feeling?', style: AppText.label),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _moods.map((mood) {
                final selected = _mood == mood.$1;
                return GestureDetector(
                  onTap: () => setState(() => _mood = mood.$1),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primary50 : AppColors.grey100,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                          color: selected
                              ? AppColors.primary300
                              : AppColors.grey200),
                    ),
                    child: Text(
                      mood.$2,
                      style: AppText.label.copyWith(
                        color:
                            selected ? AppColors.primary400 : AppColors.grey700,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 18),
            const Text('Title', style: AppText.label),
            const SizedBox(height: 8),
            PillTextField(
              hint: 'Today I want to remember...',
              controller: _titleController,
            ),
            const SizedBox(height: 18),
            const Text('Your note', style: AppText.label),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.grey100,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _contentController,
                  maxLines: null,
                  expands: true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: l10n.writeFreelyHint,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                if (_existing != null)
                  Expanded(
                    child: OutlineButton(
                      label: l10n.delete,
                      onPressed: () async {
                        await ref
                            .read(journalProvider.notifier)
                            .delete(_existing!.id);
                        if (mounted) context.go('/journal');
                      },
                    ),
                  ),
                if (_existing != null) const SizedBox(width: 12),
                Expanded(
                  child: PrimaryButton(
                    label: l10n.saveEntry,
                    onPressed: _contentController.text.trim().isEmpty &&
                            _titleController.text.trim().isEmpty
                        ? null
                        : _save,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    final now = DateTime.now();
    final entry = (_existing ??
            JournalEntry(
              id: now.microsecondsSinceEpoch.toString(),
              createdAt: now,
              updatedAt: now,
              title: '',
              content: '',
              mood: 'calm',
            ))
        .copyWith(
      updatedAt: now,
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      mood: _mood,
    );
    await ref.read(journalProvider.notifier).upsert(entry);
    if (mounted) context.go('/journal');
  }

  String _formattedDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}

class _JournalCard extends StatelessWidget {
  const _JournalCard({required this.entry});

  final JournalEntry entry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return GestureDetector(
      onTap: () => context.go('/journal/edit/${entry.id}'),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.grey200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _MoodBadge(mood: entry.mood),
                const Spacer(),
                Text(
                  '${entry.updatedAt.day}/${entry.updatedAt.month}/${entry.updatedAt.year}',
                  style: AppText.caption.copyWith(color: AppColors.grey500),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              entry.title.isEmpty ? l10n.untitledNote : entry.title,
              style: AppText.h6,
            ),
            const SizedBox(height: 8),
            Text(
              entry.content.isEmpty ? l10n.noDetailsYet : entry.content,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: AppText.body.copyWith(color: AppColors.grey700),
            ),
          ],
        ),
      ),
    );
  }
}

class _MoodBadge extends StatelessWidget {
  const _MoodBadge({required this.mood});

  final String mood;

  @override
  Widget build(BuildContext context) {
    final map = <String, String>{
      'calm': 'Calm',
      'happy': 'Happy',
      'sad': 'Sad',
      'anxious': 'Anxious',
      'tired': 'Tired',
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        map[mood] ?? mood,
        style: AppText.caption.copyWith(
          color: AppColors.primary400,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _EmptyJournal extends StatelessWidget {
  const _EmptyJournal({
    required this.hasQuery,
    required this.selectedDate,
  });

  final bool hasQuery;
  final DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isToday = DateTime.now().day == selectedDate.day &&
        DateTime.now().month == selectedDate.month &&
        DateTime.now().year == selectedDate.year;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.menu_book_outlined,
              size: 64, color: AppColors.grey400),
          const SizedBox(height: 14),
          Text(
            hasQuery
                ? l10n.noMatchingNotes
                : (isToday ? l10n.journalEmpty : 'No entry for this day'),
            style: AppText.h5,
          ),
          const SizedBox(height: 8),
          Text(
            hasQuery
                ? l10n.tryAnotherKeyword
                : (isToday
                    ? l10n.startFirstNote
                    : 'Start writing to capture your thoughts'),
            textAlign: TextAlign.center,
            style: AppText.body.copyWith(color: AppColors.grey600),
          ),
        ],
      ),
    );
  }
}
