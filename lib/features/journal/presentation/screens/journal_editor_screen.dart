import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:peria_app/core/theme/theme.dart';
import 'package:peria_app/features/journal/data/models/journal_entry.dart';
import 'package:peria_app/features/journal/data/models/mood.dart';
import 'package:peria_app/features/journal/presentation/providers/journal_provider.dart';
import 'package:peria_app/l10n/app_localizations.dart';

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
  String _moodId = 'calm';
  JournalEntry? _existing;
  Timer? _autoSaveTimer;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadExistingEntry();
    _titleController.addListener(_onChanged);
    _contentController.addListener(_onChanged);
  }

  void _loadExistingEntry() {
    final entries = ref.read(journalProvider).value ?? const <JournalEntry>[];
    if (widget.entryId != null) {
      _existing = entries.cast<JournalEntry?>().firstWhere(
            (item) => item?.id == widget.entryId,
            orElse: () => null,
          );
      if (_existing != null) {
        // Use setInternal to avoid triggering auto-save on initial load
        _titleController.text = _existing!.title;
        _contentController.text = _existing!.content;
        _moodId = _existing!.mood;
      }
    }
  }

  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _onChanged() {
    _autoSaveTimer?.cancel();
    _autoSaveTimer = Timer(const Duration(seconds: 2), _autoSave);
  }

  Future<void> _autoSave() async {
    if (_titleController.text.isEmpty && _contentController.text.isEmpty) {
      return;
    }

    setState(() => _isSaving = true);
    await _performSave();
    if (mounted) setState(() => _isSaving = false);
  }

  Future<void> _performSave() async {
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
      mood: _moodId,
    );

    await ref.read(journalProvider.notifier).upsert(entry);
    _existing = entry; // Update local existing reference
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final currentMood = Mood.fromId(_moodId);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      color: currentMood.color,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.chevron_left,
                color: AppColors.grey800, size: 28),
            onPressed: () => context.go('/journal'),
          ),
          actions: [
            if (_isSaving)
              const Center(
                child: Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: AppColors.grey400),
                  ),
                ),
              )
            else if (_existing != null)
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: Text(
                    "Saved",
                    style: AppText.caption.copyWith(color: AppColors.grey400),
                  ),
                ),
              ),
          ],
        ),
        body: Column(
          children: [
            // Focused Content Area
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(28, 12, 28, 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _titleController,
                      style: AppText.h2
                          .copyWith(color: AppColors.grey900, fontSize: 28),
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: "Title...",
                        hintStyle: AppText.h2.copyWith(
                          color: AppColors.grey400.withOpacity(0.4),
                          fontSize: 28,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _contentController,
                      style: AppText.body.copyWith(
                        color: AppColors.grey800,
                        height: 1.6,
                        fontSize: 18,
                      ),
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: l10n.writeFreelyHint,
                        hintStyle: AppText.body.copyWith(
                          color: AppColors.grey400.withOpacity(0.4),
                          fontSize: 18,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: _FloatingToolbar(
          moodId: _moodId,
          onMoodChanged: (id) {
            setState(() => _moodId = id);
            _autoSave(); // Save mood change immediately
          },
          onMagicTap: () {
            _showGuidedModePrompts(context);
          },
          onDelete: _existing != null ? _deleteEntry : null,
        ),
      ),
    );
  }

  void _showGuidedModePrompts(BuildContext context) {
    final prompts = [
      "What made you smile today?",
      "What's one thing you're grateful for?",
      "What was the most challenging part of your day?",
      "What would you do differently tomorrow?",
      "Describe a moment of peace you felt today.",
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Guided Writing", style: AppText.h3),
            const SizedBox(height: 8),
            Text("Need a spark? Choose a prompt to start writing.",
                style: AppText.body.copyWith(color: AppColors.grey500)),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: ListView.builder(
                itemCount: prompts.length,
                itemBuilder: (context, index) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(prompts[index],
                      style:
                          AppText.label.copyWith(fontWeight: FontWeight.bold)),
                  trailing:
                      const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                  onTap: () {
                    final currentContent = _contentController.text;
                    final prefix = currentContent.isEmpty ? "" : "\n\n";
                    _contentController.text =
                        "$currentContent$prefix${prompts[index]}\n";
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteEntry() async {
    if (_existing == null) return;
    await ref.read(journalProvider.notifier).delete(_existing!.id);
    if (!context.mounted) return;
    context.go('/journal');
  }
}

class _FloatingToolbar extends StatelessWidget {
  final String moodId;
  final ValueChanged<String> onMoodChanged;
  final VoidCallback onMagicTap;
  final VoidCallback? onDelete;

  const _FloatingToolbar({
    required this.moodId,
    required this.onMoodChanged,
    required this.onMagicTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Mood Trigger
          _ToolbarAction(
            child: Icon(
              Mood.fromId(moodId).icon,
              size: 24,
              color: AppColors.grey700,
            ),
            onTap: () => _showMoodPicker(context),
          ),
          const _VerticalDivider(),
          _ToolbarAction(
            icon: Icons.auto_awesome_outlined,
            color: AppColors.secondary500,
            onTap: onMagicTap,
          ),
          if (onDelete != null) ...[
            const _VerticalDivider(),
            _ToolbarAction(
              icon: Icons.delete_outline_rounded,
              color: Colors.redAccent,
              onTap: onDelete!,
            ),
          ],
          const SizedBox(width: 8),
          // Simple Finish Button (Alternative to total auto-save check)
          GestureDetector(
            onTap: () => context.go('/journal'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.grey900,
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Text(
                "Finish",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showMoodPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("How are you feeling?", style: AppText.h3),
            const SizedBox(height: 20),
            SizedBox(
              height: 100,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: Mood.all.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final m = Mood.all[index];
                  final isSelected = m.id == moodId;
                  return GestureDetector(
                    onTap: () {
                      onMoodChanged(m.id);
                      Navigator.pop(context);
                    },
                    child: Column(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: isSelected ? m.color : AppColors.grey100,
                            shape: BoxShape.circle,
                            border: isSelected
                                ? Border.all(color: m.accent, width: 2)
                                : null,
                          ),
                          child: Center(
                            child: Icon(
                              m.icon,
                              size: 28,
                              color:
                                  isSelected ? Colors.white : AppColors.grey500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(m.label,
                            style: AppText.caption.copyWith(
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isSelected ? m.accent : AppColors.grey600,
                            )),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ToolbarAction extends StatelessWidget {
  final IconData? icon;
  final Widget? child;
  final Color? color;
  final VoidCallback onTap;

  const _ToolbarAction(
      {this.icon, this.child, this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: child ?? Icon(icon, color: color ?? AppColors.grey700, size: 24),
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 24,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      color: AppColors.grey200,
    );
  }
}
