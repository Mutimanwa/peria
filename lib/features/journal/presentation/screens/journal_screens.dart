
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:perla_app/core/theme/theme.dart';
import 'package:perla_app/features/journal/data/models/journal_entry.dart';
import 'package:perla_app/features/journal/presentation/providers/journal_provider.dart';
import 'package:perla_app/l10n/app_localizations.dart';
import 'package:perla_app/shared/widgets/common_widgets.dart';

class JournalScreen extends ConsumerStatefulWidget {
  const JournalScreen({super.key});

  @override
  ConsumerState<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends ConsumerState<JournalScreen> {
  late DateTime _selectedDate;
  final _searchController = TextEditingController();
  final _quickLogController = TextEditingController();
  bool _searchOpen = false;
  String _query = '';
  String _quickMood = 'calm';

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
    _selectedDate = DateTime.now();
    _quickLogController.addListener(_refresh);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _quickLogController
      ..removeListener(_refresh)
      ..dispose();
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  List<DateTime> _getWeekDays() {
    final monday = _selectedDate.subtract(Duration(days: _selectedDate.weekday - 1));
    return List.generate(7, (i) => monday.add(Duration(days: i)));
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  List<JournalEntry> _filterEntries(List<JournalEntry> entries) {
    if (_query.isNotEmpty) {
      // Global search across all entries
      return entries.where((entry) {
        return entry.title.toLowerCase().contains(_query) ||
            entry.content.toLowerCase().contains(_query) ||
            entry.mood.toLowerCase().contains(_query);
      }).toList();
    } else {
      // Date filter only when no query
      return entries.where((entry) => _isSameDay(entry.createdAt, _selectedDate)).toList();
    }
  }

  bool _dayHasEntries(DateTime day, List<JournalEntry> entries) {
    return entries.any((entry) => _isSameDay(entry.createdAt, day));
  }

  Future<void> _saveQuickEntry() async {
    final note = _quickLogController.text.trim();
    if (note.isEmpty) return;
    final now = DateTime.now();
    await ref.read(journalProvider.notifier).upsert(
          JournalEntry(
            id: now.microsecondsSinceEpoch.toString(),
            createdAt: now,
            updatedAt: now,
            title: '',
            content: note,
            mood: _quickMood,
          ),
        );
    if (!mounted) return;
    setState(() {
      _selectedDate = now;
      _quickMood = 'calm';
      _quickLogController.clear();
    });
  }

  Future<void> _openQuickLogSheet(AppLocalizations l10n) async {
    final controller = TextEditingController(text: _quickLogController.text);
    var mood = _quickMood;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final canSave = controller.text.trim().isNotEmpty;
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 100,
              ),
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 42,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.grey300,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(l10n.newEntry, style: AppText.h4),
                    const SizedBox(height: 6),
                    Text(
                      l10n.writeFreelyHint,
                      style: AppText.body.copyWith(color: AppColors.grey600),
                    ),
                    const SizedBox(height: 18),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _moods.map((item) {
                        final selected = mood == item.$1;
                        final tone = _JournalMoodTone.fromMood(item.$1);
                        return GestureDetector(
                          onTap: () => setModalState(() => mood = item.$1),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: selected ? tone.softBackground : AppColors.grey100,
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                color: selected ? tone.accent : AppColors.grey200,
                              ),
                            ),
                            child: Text(
                              item.$2,
                              style: AppText.caption.copyWith(
                                color: selected ? tone.accent : AppColors.grey700,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.grey100,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: TextField(
                        controller: controller,
                        minLines: 5,
                        maxLines: 8,
                        onChanged: (_) => setModalState(() {}),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: l10n.writeFreelyHint,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlineButton(
                            label: 'Open editor',
                            onPressed: () {
                              Navigator.of(context).pop();
                              this.context.go('/journal/new');
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: PrimaryButton(
                            label: l10n.saveEntry,
                            onPressed: canSave
                                ? () async {
                                    final now = DateTime.now();
                                    await ref.read(journalProvider.notifier).upsert(
                                          JournalEntry(
                                            id: now.microsecondsSinceEpoch.toString(),
                                            createdAt: now,
                                            updatedAt: now,
                                            title: '',
                                            content: controller.text.trim(),
                                            mood: mood,
                                          ),
                                        );
                                    if (!mounted) return;
                                    setState(() {
                                      _selectedDate = now;
                                      _quickMood = 'calm';
                                      _quickLogController.clear();
                                    });
                                    Navigator.of(context).pop();
                                  }
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    controller.dispose();
  }

  String _summaryLabel(DateTime date, int count) {
    final day = DateFormat('EEEE, d MMMM').format(date);
    final suffix = count <= 1 ? 'note' : 'notes';
    return '$day • $count $suffix';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(journalProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.bgGradient),
        child: SafeArea(
          child: state.when(
            data: (entries) {
              final filtered = _filterEntries(entries);
              final weekDays = _getWeekDays();
              return Column(
                children: [
                  _buildHeader(l10n),
                  _buildWeekCalendar(weekDays, entries),
                  _buildSummaryBar(filtered.length),
                  Expanded(
                    child: ListView(
                      key: ValueKey('journal-${_selectedDate.toIso8601String()}-$_query-${filtered.length}'),
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
                      children: [
                        if (_query.isEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _QuickLogComposer(
                              value: _quickLogController.text,
                              selectedMood: _quickMood,
                              moods: _moods,
                              onMoodSelected: (mood) => setState(() => _quickMood = mood),
                              onOpenSheet: () => _openQuickLogSheet(l10n),
                              controller: _quickLogController,
                              onSave: _saveQuickEntry,
                            ),
                          ),
                        if (filtered.isEmpty)
                          _EmptyJournal(hasQuery: _query.isNotEmpty, selectedDate: _selectedDate)
                        else
                          ...filtered.map(
                            (entry) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _JournalCard(entry: entry),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 80)
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const Center(child: Text('Unable to load journal')),
          ),
        ),
      ),
      
    );
  }

  Widget _buildHeader(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _query.isNotEmpty ? l10n.searchJournalHint : l10n.journalTitle,
                      style: AppText.h3.copyWith(fontSize: 22),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _query.isNotEmpty ? l10n.tryAnotherKeyword : l10n.journalSubtitle,
                      style: AppText.caption.copyWith(color: AppColors.grey600),
                    ),
                  ],
                ),
              ),
              _HeaderIconButton(
                icon: _searchOpen ? Icons.close_rounded : Icons.search_rounded,
                onTap: () {
                  setState(() {
                    _searchOpen = !_searchOpen;
                    if (!_searchOpen) {
                      _searchController.clear();
                      _query = '';
                    }
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_searchOpen)
            Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.grey200),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) => setState(() => _query = value.trim().toLowerCase()),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: l10n.searchJournalHint,
                  hintStyle: AppText.body.copyWith(color: AppColors.grey400),
                  icon: const Icon(Icons.search_rounded, color: AppColors.grey500, size: 20),
                ),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.grey200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.shield_outlined, size: 18, color: AppColors.grey600),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Private by default on this device.',
                      style: AppText.caption.copyWith(
                        color: AppColors.grey700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWeekCalendar(List<DateTime> weekDays, List<JournalEntry> entries) {
    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final day = weekDays[index];
          return _WeekDayChip(
            date: day,
            isSelected: _isSameDay(day, _selectedDate),
            isToday: _isSameDay(day, DateTime.now()),
            hasEntry: _dayHasEntries(day, entries),
            onTap: () => setState(() => _selectedDate = day),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemCount: weekDays.length,
      ),
    );
  }

  Widget _buildSummaryBar(int count) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.72),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              _summaryLabel(_selectedDate, count),
              style: AppText.body.copyWith(
                color: AppColors.grey800,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            _isSameDay(_selectedDate, DateTime.now()) ? 'Today' : DateFormat('EEE').format(_selectedDate),
            style: AppText.caption.copyWith(
              color: AppColors.primary500,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class JournalDetailScreen extends ConsumerWidget {
  const JournalDetailScreen({super.key, required this.entryId});

  final String entryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final entries = ref.watch(journalProvider).value ?? const <JournalEntry>[];
    JournalEntry? entry;

    for (final item in entries) {
      if (item.id == entryId) {
        entry = item;
        break;
      }
    }

    if (entry == null) {
      return PageScaffold(
        showBack: true,
        onBack: () => context.pop(),
        showTitle: true,
        title: l10n.journalTitle,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 88, 22, 24),
          child: Center(
            child: _EmptyJournal(
              hasQuery: false,
              selectedDate: DateTime.now(),
            ),
          ),
        ),
      );
    }

    final resolvedEntry = entry;
    final tone = _JournalMoodTone.fromMood(resolvedEntry.mood);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(gradient: AppColors.bgGradient),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.white.withOpacity(0.75),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.grey200),
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: AppColors.grey900,
                            size: 18,
                          ),
                        ),
                      ),
                      Text(
                        l10n.journalTitle,
                        style: AppText.caption.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.grey700,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.go('/journal/edit/${resolvedEntry.id}'),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.white.withOpacity(0.75),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.grey200),
                          ),
                          child: const Icon(
                            Icons.edit_outlined,
                            color: AppColors.grey700,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          tone.accent.withOpacity(0.14),
                          tone.softBackground.withOpacity(0.65),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: tone.accent.withOpacity(0.22),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: tone.accent.withOpacity(0.08),
                          offset: const Offset(0, 4),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: tone.accent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            tone.label,
                            style: AppText.caption.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          resolvedEntry.title.isEmpty ? l10n.untitledNote : resolvedEntry.title,
                          style: AppText.h4.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.grey900,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _JournalMetaChip(
                              icon: Icons.calendar_today_outlined,
                              label: DateFormat('d MMM yyyy').format(resolvedEntry.createdAt),
                            ),
                            _JournalMetaChip(
                              icon: Icons.schedule,
                              label: DateFormat('HH:mm').format(resolvedEntry.updatedAt),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _JournalDetailCard(
                    icon: Icons.menu_book_outlined,
                    title: 'Note',
                    content: resolvedEntry.content.isEmpty ? l10n.noDetailsYet : resolvedEntry.content,
                    accentColor: tone.accent,
                  ),
                  const SizedBox(height: 14),
                  _JournalDetailCard(
                    icon: Icons.info_outline,
                    title: 'Details',
                    content:
                        'Created ${DateFormat('EEEE, d MMMM yyyy').format(resolvedEntry.createdAt)} at ${DateFormat('HH:mm').format(resolvedEntry.createdAt)}\nUpdated ${DateFormat('EEEE, d MMMM yyyy').format(resolvedEntry.updatedAt)} at ${DateFormat('HH:mm').format(resolvedEntry.updatedAt)}',
                    accentColor: AppColors.grey700,
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppColors.error.withOpacity(0.25),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: AppColors.error,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.delete_outline,
                                color: AppColors.white,
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              l10n.delete,
                              style: AppText.h6.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.error,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Remove this note only if you no longer want to keep it in your private history.',
                          style: AppText.body.copyWith(
                            color: AppColors.grey800,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          width: double.infinity,
                          child: OutlineButton(
                            label: l10n.delete,
                            onPressed: () async {
                              await ref.read(journalProvider.notifier).delete(resolvedEntry.id);
                              if (context.mounted) context.go('/journal');
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class JournalEditorScreen extends ConsumerStatefulWidget {
  const JournalEditorScreen({super.key, this.entryId});

  final String? entryId;

  @override
  ConsumerState<JournalEditorScreen> createState() => _JournalEditorScreenState();
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
    _titleController.addListener(_refresh);
    _contentController.addListener(_refresh);
  }

  @override
  void dispose() {
    _titleController
      ..removeListener(_refresh)
      ..dispose();
    _contentController
      ..removeListener(_refresh)
      ..dispose();
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  bool get _canSave =>
      _titleController.text.trim().isNotEmpty || _contentController.text.trim().isNotEmpty;

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
            const SizedBox(height: 18),
            Text('Mood', style: AppText.label.copyWith(color: AppColors.grey800)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _moods.map((mood) {
                final selected = _mood == mood.$1;
                final tone = _JournalMoodTone.fromMood(mood.$1);
                return GestureDetector(
                  onTap: () => setState(() => _mood = mood.$1),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: selected ? tone.softBackground : AppColors.grey100,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: selected ? tone.accent : AppColors.grey200),
                    ),
                    child: Text(
                      mood.$2,
                      style: AppText.label.copyWith(
                        color: selected ? tone.accent : AppColors.grey700,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 18),
            Text('Title', style: AppText.label.copyWith(color: AppColors.grey800)),
            const SizedBox(height: 8),
            PillTextField(hint: 'Today I want to remember...', controller: _titleController),
            const SizedBox(height: 18),
            Text('Your note', style: AppText.label.copyWith(color: AppColors.grey800)),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                        await ref.read(journalProvider.notifier).delete(_existing!.id);
                        if (mounted) context.go('/journal');
                      },
                    ),
                  ),
                if (_existing != null) const SizedBox(width: 12),
                Expanded(
                  child: PrimaryButton(
                    label: l10n.saveEntry,
                    onPressed: _canSave ? _save : null,
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

  String _formattedDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}

class _QuickLogComposer extends StatelessWidget {
  const _QuickLogComposer({
    required this.value,
    required this.selectedMood,
    required this.moods,
    required this.onMoodSelected,
    required this.onOpenSheet,
    required this.controller,
    required this.onSave,
  });

  final String value;
  final String selectedMood;
  final List<(String, String)> moods;
  final ValueChanged<String> onMoodSelected;
  final VoidCallback onOpenSheet;
  final TextEditingController controller;
  final Future<void> Function() onSave;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final canSave = value.trim().isNotEmpty;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(l10n.newEntry, style: AppText.h5)),
              TextButton(
                onPressed: onOpenSheet,
                child: Text(
                  'Expand',
                  style: AppText.caption.copyWith(
                    color: AppColors.primary500,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            l10n.writeFreelyHint,
            style: AppText.caption.copyWith(color: AppColors.grey600),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: moods.map((item) {
              final selected = selectedMood == item.$1;
              final tone = _JournalMoodTone.fromMood(item.$1);
              return GestureDetector(
                onTap: () => onMoodSelected(item.$1),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: selected ? tone.softBackground : AppColors.grey100,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: selected ? tone.accent : AppColors.grey200),
                  ),
                  child: Text(
                    item.$2,
                    style: AppText.caption.copyWith(
                      color: selected ? tone.accent : AppColors.grey700,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),
          Container(
            decoration: BoxDecoration(
              color: AppColors.grey100,
              borderRadius: BorderRadius.circular(22),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            child: TextField(
              controller: controller,
              minLines: 3,
              maxLines: 5,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: l10n.writeFreelyHint,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Quick log',
                  style: AppText.caption.copyWith(
                    color: AppColors.grey600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                width: 132,
                child: PrimaryButton(
                  label: l10n.saveEntry,
                  onPressed: canSave ? onSave : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
class _WeekDayChip extends StatelessWidget {
  const _WeekDayChip({
    required this.date,
    required this.isSelected,
    required this.isToday,
    required this.hasEntry,
    required this.onTap,
  });

  final DateTime date;
  final bool isSelected;
  final bool isToday;
  final bool hasEntry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 68,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.white : AppColors.white.withOpacity(0.55),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: isSelected ? AppColors.primary200 : AppColors.grey200),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat('E').format(date),
              style: AppText.caption.copyWith(
                color: isToday ? AppColors.primary500 : AppColors.grey600,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${date.day}',
              style: AppText.label.copyWith(
                color: AppColors.grey900,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: hasEntry ? AppColors.primary400 : Colors.transparent,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _JournalMetaChip extends StatelessWidget {
  const _JournalMetaChip({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: AppColors.grey600,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppText.label.copyWith(
              color: AppColors.grey600,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _JournalDetailCard extends StatelessWidget {
  const _JournalDetailCard({
    required this.icon,
    required this.title,
    required this.content,
    required this.accentColor,
  });

  final IconData icon;
  final String title;
  final String content;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.grey200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.04),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: accentColor,
                  size: 16,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: AppText.h6.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.grey900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: AppText.body.copyWith(
              color: AppColors.grey800,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _JournalCard extends StatelessWidget {
  const _JournalCard({required this.entry});

  final JournalEntry entry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tone = _JournalMoodTone.fromMood(entry.mood);
    final title = entry.title.isEmpty ? l10n.untitledNote : entry.title;
    final preview = entry.content.isEmpty ? l10n.noDetailsYet : entry.content;
    return GestureDetector(
      onTap: () => context.go('/journal/detail/${entry.id}'),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
        decoration: BoxDecoration(
          color: AppColors.white.withOpacity(0.85),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.grey200),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 10,
              height: 10,
              margin: const EdgeInsets.only(top: 6),
              decoration: BoxDecoration(color: tone.accent, shape: BoxShape.circle),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.label.copyWith(
                            color: AppColors.grey900,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        DateFormat('HH:mm').format(entry.updatedAt),
                        style: AppText.caption.copyWith(color: AppColors.grey500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    preview,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.body.copyWith(color: AppColors.grey700, height: 1.4),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: tone.softBackground,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      tone.label,
                      style: AppText.caption.copyWith(
                        color: tone.accent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return now.year == date.year && now.month == date.month && now.day == date.day;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 28, 22, 28),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.78),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.primary50,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.edit_note_rounded, size: 30, color: AppColors.primary500),
          ),
          const SizedBox(height: 14),
          Text(
            hasQuery
                ? l10n.noMatchingNotes
                : (_isToday(selectedDate) ? l10n.journalEmpty : 'No entry for this day'),
            textAlign: TextAlign.center,
            style: AppText.h5,
          ),
          const SizedBox(height: 8),
          Text(
            hasQuery
                ? l10n.tryAnotherKeyword
                : (_isToday(selectedDate)
                    ? l10n.startFirstNote
                    : 'Use quick log to capture this moment.'),
            textAlign: TextAlign.center,
            style: AppText.body.copyWith(color: AppColors.grey600),
          ),
        ],
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.grey200),
        ),
        child: Icon(icon, color: AppColors.grey700, size: 21),
      ),
    );
  }
}

class _JournalMoodTone {
  const _JournalMoodTone({
    required this.label,
    required this.accent,
    required this.softBackground,
  });

  final String label;
  final Color accent;
  final Color softBackground;

  factory _JournalMoodTone.fromMood(String mood) {
    switch (mood) {
      case 'happy':
        return const _JournalMoodTone(
          label: 'Happy',
          accent: Color(0xFFB46900),
          softBackground: Color(0xFFFFF1D6),
        );
      case 'sad':
        return const _JournalMoodTone(
          label: 'Sad',
          accent: AppColors.info700,
          softBackground: AppColors.info50,
        );
      case 'anxious':
        return const _JournalMoodTone(
          label: 'Anxious',
          accent: AppColors.secondary600,
          softBackground: AppColors.secondary100,
        );
      case 'tired':
        return const _JournalMoodTone(
          label: 'Tired',
          accent: Color(0xFF8A6A43),
          softBackground: Color(0xFFF2E9DF),
        );
      default:
        return const _JournalMoodTone(
          label: 'Calm',
          accent: AppColors.primary500,
          softBackground: AppColors.primary50,
        );
    }
  }
}
