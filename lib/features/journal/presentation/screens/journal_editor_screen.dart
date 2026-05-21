import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:peria_app/core/theme/app_colors.dart';
import 'package:peria_app/core/theme/app_text.dart';
import 'package:peria_app/features/journal/data/models/mood.dart';
import 'package:peria_app/features/journal/data/models/journal_entry.dart';
import 'package:peria_app/features/journal/presentation/providers/journal_provider.dart';
import 'package:peria_app/l10n/app_localizations.dart';

class JournalEditorScreen extends ConsumerStatefulWidget {
  const JournalEditorScreen({super.key, this.entryId});

  final String? entryId;

  @override
  ConsumerState<JournalEditorScreen> createState() => _JournalEditorScreenState();
}

class _JournalEditorScreenState extends ConsumerState<JournalEditorScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String _moodId = 'calm';
  JournalEntry? _existing;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadExistingEntry();
  }

  void _loadExistingEntry() {
    final entries = ref.read(journalProvider).value ?? const <JournalEntry>[];
    if (widget.entryId != null) {
      _existing = entries.cast<JournalEntry?>().firstWhere(
            (item) => item?.id == widget.entryId,
            orElse: () => null,
          );
      if (_existing != null) {
        _titleController.text = _existing!.title;
        _contentController.text = _existing!.content;
        _moodId = _existing!.mood;
      }
    }
  }

  Future<void> _save() async {
    if (_titleController.text.isEmpty && _contentController.text.isEmpty) return;
    
    setState(() => _isSaving = true);
    final now = DateTime.now();
    final entry = (_existing ??
            JournalEntry(
              id: now.microsecondsSinceEpoch.toString(),
              createdAt: now,
              updatedAt: now,
              title: '',
              content: '',
              mood: _moodId,
            ))
        .copyWith(
      updatedAt: now,
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      mood: _moodId,
    );

    await ref.read(journalProvider.notifier).upsert(entry);
    setState(() => _isSaving = false);
    if (mounted) context.go('/journal');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dateStr = DateFormat('d MMM yyyy', 'fr').format(_existing?.createdAt ?? DateTime.now());
    final timeStr = DateFormat('HH:mm').format(_existing?.createdAt ?? DateTime.now());

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB), // Fond très clair comme l'image
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.grey700),
          onPressed: () => context.go('/journal'),
        ),
        actions: [
          // Bouton "Save" compact et bleu
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: ElevatedButton(
              onPressed: _isSaving ? null : _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary500,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              child: _isSaving 
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Text("Save", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  // Date et Heure (Le style de l'image)
                  Row(
                    children: [
                      Text(dateStr, style: AppText.body.copyWith(fontWeight: FontWeight.bold, color: AppColors.grey900)),
                      const SizedBox(width: 8),
                      Text(timeStr, style: AppText.body.copyWith(color: AppColors.grey400)),
                      const Spacer(),
                      const Icon(Icons.more_horiz, color: AppColors.grey400),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Titre
                  TextField(
                    controller: _titleController,
                    style: AppText.h3.copyWith(fontWeight: FontWeight.w800, fontSize: 24),
                    decoration: const InputDecoration(
                      hintText: "C'est mon journal...",
                      hintStyle: TextStyle(color: AppColors.grey300),
                      border: InputBorder.none,
                    ),
                  ),
                  // Contenu
                  TextField(
                    controller: _contentController,
                    maxLines: null,
                    style: AppText.body.copyWith(fontSize: 17, height: 1.5, color: AppColors.grey800),
                    decoration: const InputDecoration(
                      hintText: "Raconte ta journée...",
                      hintStyle: TextStyle(color: AppColors.grey300),
                      border: InputBorder.none,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Barre d'outils flottante en bas
          _buildBottomToolbar(),
        ],
      ),
    );
  }

  Widget _buildBottomToolbar() {
    final currentMood = Mood.fromId(_moodId);
    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 10, top: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.grey200, width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const _ToolbarIcon(Icons.image_outlined),
          const _ToolbarIcon(Icons.format_list_bulleted),
          const _ToolbarIcon(Icons.check_box_outlined),
          const _ToolbarIcon(Icons.text_fields),
          // Bouton Humeur
          GestureDetector(
            onTap: () => _showMoodPicker(),
            child: Icon(currentMood.icon, color: currentMood.accent),
          ),
          const _ToolbarIcon(Icons.mic_none),
        ],
      ),
    );
  }

  void _showMoodPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Comment te sens-tu ?", style: AppText.h4),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: Mood.values.map((m) => GestureDetector(
                onTap: () {
                  setState(() => _moodId = m.id);
                  Navigator.pop(context);
                },
                child: Icon(m.icon, size: 40, color: _moodId == m.id ? m.accent : AppColors.grey300),
              )).toList(),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _ToolbarIcon extends StatelessWidget {
  final IconData icon;
  const _ToolbarIcon(this.icon);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, color: AppColors.grey500, size: 22),
      onPressed: () {}, // À implémenter selon tes besoins
    );
  }
}