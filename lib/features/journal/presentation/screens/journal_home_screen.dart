import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:peria_app/core/theme/theme.dart';
import 'package:peria_app/features/journal/data/models/journal_entry.dart';
import 'package:peria_app/features/journal/data/models/mood.dart';
import 'package:peria_app/features/journal/presentation/providers/journal_provider.dart';
import 'package:peria_app/features/journal/presentation/widgets/journal_skeleton.dart';
import 'package:peria_app/l10n/app_localizations.dart';
import 'package:peria_app/shared/widgets/common_widgets.dart';

class JournalHomeScreen extends ConsumerStatefulWidget {
  const JournalHomeScreen({super.key});

  @override
  ConsumerState<JournalHomeScreen> createState() => _JournalHomeScreenState();
}

class _JournalHomeScreenState extends ConsumerState<JournalHomeScreen> {
  final _quickLogController = TextEditingController();
  String _selectedMoodId = 'calm';
  bool _isQuickLogExpanded = false;

  @override
  void dispose() {
    _quickLogController.dispose();
    super.dispose();
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
            mood: _selectedMoodId,
          ),
        );
    if (!mounted) return;
    setState(() {
      _quickLogController.clear();
      _isQuickLogExpanded = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Quick thought saved 😌")),
    );
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(l10n),
              Expanded(
                child: state.when(
                  data: (entries) => ListView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    children: [
                      _buildDailyQuote(),
                      const SizedBox(height: 24),
                      _buildQuickLogComposer(l10n),
                      const SizedBox(height: 32),
                      _buildRecentActivity(entries, l10n),
                      const SizedBox(height: 80),
                    ],
                  ),
                  loading: () => const JournalSkeleton(count: 3),
                  error: (err, _) => Center(child: Text("Error: $err")),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/journal/new'),
        backgroundColor: AppColors.grey900,
        icon: const Icon(Icons.edit_document, color: Colors.white),
        label: const Text("New Entry",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.journalTitle, style: AppText.h2),
              Row(
                children: [
                  IconButton(
                    onPressed: () => context.go('/journal/timeline'),
                    icon: const Icon(Icons.calendar_month_outlined,
                        color: AppColors.grey700),
                  ),
                  IconButton(
                    onPressed: () => context.go('/journal/search'),
                    icon: const Icon(Icons.search_rounded,
                        color: AppColors.grey700),
                  ),
                ],
              ),
            ],
          ),
          Text(
            DateFormat('EEEE, d MMMM').format(DateTime.now()),
            style: AppText.body.copyWith(color: AppColors.grey500),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyQuote() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary50,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.format_quote, color: AppColors.primary500, size: 32),
          const SizedBox(height: 8),
          Text(
            "“Every moment is a fresh beginning.”",
            style: AppText.h4.copyWith(
                fontStyle: FontStyle.italic, color: AppColors.grey800),
          ),
          const SizedBox(height: 4),
          Text("– T.S. Eliot",
              style: AppText.caption.copyWith(color: AppColors.grey500)),
        ],
      ),
    );
  }

  Widget _buildQuickLogComposer(AppLocalizations l10n) {
    return Column(
      children: [
        _buildJournalStats(),
        const SizedBox(height: 24),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.grey200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text("Quick thought", style: AppText.h5),
                  const Spacer(),
                  if (!_isQuickLogExpanded)
                    TextButton(
                      onPressed: () =>
                          setState(() => _isQuickLogExpanded = true),
                      child: const Text("Write"),
                    ),
                ],
              ),
              if (_isQuickLogExpanded) ...[
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  children: Mood.all.take(5).map((m) {
                    final isSelected = m.id == _selectedMoodId;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedMoodId = m.id),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? m.color : AppColors.grey100,
                          borderRadius: BorderRadius.circular(15),
                          border:
                              isSelected ? Border.all(color: m.accent) : null,
                        ),
                        child: Text(m.emoji),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _quickLogController,
                  maxLines: 3,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: "What's on your mind?",
                    border: InputBorder.none,
                    hintStyle: AppText.body.copyWith(color: AppColors.grey400),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () =>
                          setState(() => _isQuickLogExpanded = false),
                      child: const Text("Cancel"),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _saveQuickEntry,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.grey900,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                      ),
                      child: const Text("Save",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ] else
                Text(
                  "Tap to capture a quick moment...",
                  style: AppText.body.copyWith(color: AppColors.grey400),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildJournalStats() {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: "Streak",
            value: "5 Days",
            icon: Icons.fireplace_rounded,
            color: Colors.orangeAccent,
            onTap: () => context.go('/journal/timeline'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _StatCard(
            label: "Insights",
            value: "Weekly",
            icon: Icons.query_stats_rounded,
            color: AppColors.primary500,
            onTap: () => context.go('/journal/insights'),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentActivity(
      List<JournalEntry> entries, AppLocalizations l10n) {
    final recent = entries.take(3).toList();
    if (recent.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Text("No entries yet",
              style: AppText.body.copyWith(color: AppColors.grey400)),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
            "Recent entries", () => context.go('/journal/timeline')),
        const SizedBox(height: 12),
        ...recent.map((entry) => _SimpleJournalCard(entry: entry)),
      ],
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onSeeAll) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppText.h4),
        TextButton(
          onPressed: onSeeAll,
          child: const Text("See all"),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(value, style: AppText.h5.copyWith(color: AppColors.grey900)),
            Text(label, style: AppText.caption.copyWith(color: color)),
          ],
        ),
      ),
    );
  }
}

class _SimpleJournalCard extends StatelessWidget {
  final JournalEntry entry;
  const _SimpleJournalCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    final mood = Mood.fromId(entry.mood);
    return GestureDetector(
      onTap: () => context.go('/journal/detail/${entry.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.grey200),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration:
                  BoxDecoration(color: mood.color, shape: BoxShape.circle),
              child: Center(
                  child:
                      Text(mood.emoji, style: const TextStyle(fontSize: 24))),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.title.isNotEmpty ? entry.title : "Untitled note",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.label.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    DateFormat('d MMMM • HH:mm').format(entry.updatedAt),
                    style: AppText.caption.copyWith(color: AppColors.grey500),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.grey400),
          ],
        ),
      ),
    );
  }
}
