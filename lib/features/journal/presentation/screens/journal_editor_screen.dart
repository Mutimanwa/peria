import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:perla_app/core/theme/theme.dart';
import 'package:perla_app/features/journal/data/models/journal_entry.dart';
import 'package:perla_app/features/journal/presentation/providers/journal_provider.dart';
import 'package:perla_app/l10n/app_localizations.dart';
import 'package:perla_app/shared/widgets/common_widgets.dart';

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
      onBack: () => context.go('/journal'),
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
                final tone = JournalMoodTone.fromMood(mood.$1);
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
                        if (!context.mounted) return;
                        context.go('/journal');
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
    if (!context.mounted) return;
    // ignore: use_build_context_synchronously
    context.go('/journal');
  }

  String _formattedDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}
