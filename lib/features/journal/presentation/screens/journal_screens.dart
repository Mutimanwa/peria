import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:perla_app/core/theme/theme.dart';
import 'package:perla_app/features/journal/data/models/journal_entry.dart';
import 'package:perla_app/features/journal/presentation/providers/journal_provider.dart';
import 'package:perla_app/shared/widgets/common_widgets.dart';
import 'package:perla_app/shared/widgets/custom_bottom_nav.dart';
import 'package:perla_app/l10n/app_localizations.dart';

class JournalScreen extends ConsumerStatefulWidget {
  const JournalScreen({super.key});

  @override
  ConsumerState<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends ConsumerState<JournalScreen> {
  NavItem _activeTab = NavItem.journal;
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(journalProvider);
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          Container(
              decoration: const BoxDecoration(gradient: AppColors.bgGradient)),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 12, 22, 110),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.go('/profile'),
                        child: const CircleAvatar(
                          radius: 18,
                          backgroundImage: AssetImage(
                              'assets/images/onboarding/Avatar-21.png'),
                        ),
                      ),
                      const Spacer(),
                      Text(l10n.journalTitle, style: AppText.h4),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => context.go('/notification'),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.white.withOpacity(.8),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.grey200),
                          ),
                          child:
                              const Icon(Icons.lock_outline_rounded, size: 18),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    l10n.journalSubtitle,
                    style: AppText.body.copyWith(color: AppColors.grey600),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.grey100,
                      borderRadius: BorderRadius.circular(26),
                    ),
                    child: TextField(
                      onChanged: (value) =>
                          setState(() => _query = value.trim().toLowerCase()),
                      decoration: InputDecoration(
                        hintText: l10n.searchJournalHint,
                        hintStyle:
                            AppText.body.copyWith(color: AppColors.grey400),
                        prefixIcon:
                            const Icon(Icons.search, color: AppColors.grey400),
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: OutlineButton(
                          label: l10n.clearAll,
                          onPressed: () => _showClearDialog(context),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: PrimaryButton(
                          label: l10n.newEntry,
                          onPressed: () => context.go('/journal/new'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: state.when(
                      data: (entries) {
                        final filtered = entries.where((entry) {
                          if (_query.isEmpty) return true;
                          return entry.title.toLowerCase().contains(_query) ||
                              entry.content.toLowerCase().contains(_query) ||
                              entry.mood.toLowerCase().contains(_query);
                        }).toList();

                        if (filtered.isEmpty) {
                          return _EmptyJournal(hasQuery: _query.isNotEmpty);
                        }

                        return ListView.separated(
                          itemCount: filtered.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final entry = filtered[index];
                            return _JournalCard(entry: entry);
                          },
                        );
                      },
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (_, __) =>
                          const Center(child: Text('Unable to load journal')),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CustomBottomNav(
              currentIndex: _activeTab,
              onTap: (tab) {
                setState(() => _activeTab = tab);
                if (tab == NavItem.cycle) {
                  context.go('/home');
                } else if (tab == NavItem.ai) {
                  context.go('/ai');
                } else if (tab == NavItem.journal) {
                  context.go('/journal');
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showClearDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.delete_outline_rounded,
                size: 52, color: AppColors.error),
            const SizedBox(height: 14),
            const Text('Delete all notes?', style: AppText.h4),
            const SizedBox(height: 8),
            Text(
              'This will permanently remove all journal entries stored on this device.',
              textAlign: TextAlign.center,
              style: AppText.body.copyWith(color: AppColors.grey600),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Cancel',
                        style:
                            AppText.label.copyWith(color: AppColors.grey700)),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        ref.read(journalProvider.notifier).clearAll();
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.grey900,
                        shape: const StadiumBorder(),
                      ),
                      child: Text('Delete',
                          style:
                              AppText.label.copyWith(color: AppColors.white)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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
  const _EmptyJournal({required this.hasQuery});

  final bool hasQuery;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.menu_book_outlined,
              size: 64, color: AppColors.grey400),
          const SizedBox(height: 14),
          Text(
            hasQuery ? l10n.noMatchingNotes : l10n.journalEmpty,
            style: AppText.h5,
          ),
          const SizedBox(height: 8),
          Text(
            hasQuery ? l10n.tryAnotherKeyword : l10n.startFirstNote,
            textAlign: TextAlign.center,
            style: AppText.body.copyWith(color: AppColors.grey600),
          ),
        ],
      ),
    );
  }
}
