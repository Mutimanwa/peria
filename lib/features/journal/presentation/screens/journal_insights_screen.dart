import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:peria_app/core/theme/theme.dart';
import 'package:peria_app/features/journal/data/models/journal_entry.dart';
import 'package:peria_app/features/journal/data/models/mood.dart';
import 'package:peria_app/features/journal/presentation/providers/journal_provider.dart';
import 'package:peria_app/shared/widgets/common_widgets.dart';

class JournalInsightsScreen extends ConsumerWidget {
  const JournalInsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(journalProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.bgGradient),
        child: SafeArea(
          child: entriesAsync.when(
            data: (entries) => _buildInsightsContent(context, entries),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text("Error: $e")),
          ),
        ),
      ),
    );
  }

  Widget _buildInsightsContent(
      BuildContext context, List<JournalEntry> entries) {
    if (entries.isEmpty) {
      return Column(
        children: [
          _buildHeader(context),
          const Expanded(
              child:
                  Center(child: Text("Not enough data for insights yet 🌿"))),
        ],
      );
    }

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        _buildHeader(context),
        const SizedBox(height: 24),
        _buildStreakCard(entries),
        const SizedBox(height: 24),
        _buildMoodDistribution(entries),
        const SizedBox(height: 24),
        _buildWeeklyTrends(entries),
        const SizedBox(height: 24),
        _buildCommonTags(entries),
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        const BackIconButton(onPressed: null), // Will be handled by GoRouter
        const SizedBox(width: 16),
        const Text("Your Journey", style: AppText.h2),
      ],
    );
  }

  Widget _buildStreakCard(List<JournalEntry> entries) {
    // Basic streak calculation
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary50,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: [
          const Icon(Icons.fireplace_rounded,
              color: AppColors.primary500, size: 48),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Current Streak",
                  style: AppText.caption.copyWith(color: AppColors.primary500)),
              Text("${_calculateStreak(entries)} Days",
                  style: AppText.h2.copyWith(color: AppColors.primary900)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMoodDistribution(List<JournalEntry> entries) {
    final moodCounts = <String, int>{};
    for (var e in entries) {
      moodCounts[e.mood] = (moodCounts[e.mood] ?? 0) + 1;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Mood Distribution", style: AppText.h4),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.grey100),
          ),
          child: Column(
            children: Mood.all.map((m) {
              final count = moodCounts[m.id] ?? 0;
              final percent = entries.isEmpty ? 0.0 : count / entries.length;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Icon(m.icon, size: 20, color: m.accent),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Stack(
                        children: [
                          Container(
                              height: 8,
                              decoration: BoxDecoration(
                                  color: AppColors.grey50,
                                  borderRadius: BorderRadius.circular(4))),
                          FractionallySizedBox(
                            widthFactor: percent,
                            child: Container(
                                height: 8,
                                decoration: BoxDecoration(
                                    color: m.accent,
                                    borderRadius: BorderRadius.circular(4))),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text("${(percent * 100).toInt()}%", style: AppText.caption),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyTrends(List<JournalEntry> entries) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Weekly Activity", style: AppText.h4),
        const SizedBox(height: 16),
        Container(
          height: 150,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.grey100),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(7, (i) {
              final day = DateTime.now().subtract(Duration(days: 6 - i));
              final count = entries
                  .where((e) =>
                      e.createdAt.day == day.day &&
                      e.createdAt.month == day.month)
                  .length;
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 24,
                    height: (count * 20.0).clamp(10.0, 80.0),
                    decoration: BoxDecoration(
                      color:
                          count > 0 ? AppColors.primary500 : AppColors.grey100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(DateFormat('E').format(day)[0], style: AppText.caption),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildCommonTags(List<JournalEntry> entries) {
    final tagCounts = <String, int>{};
    for (var e in entries) {
      for (var t in e.tags) {
        tagCounts[t] = (tagCounts[t] ?? 0) + 1;
      }
    }
    final sortedTags = tagCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Top Tags", style: AppText.h4),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: sortedTags
              .take(8)
              .map((t) => Chip(
                    label: Text("${t.key} (${t.value})"),
                    backgroundColor: AppColors.white,
                    side: const BorderSide(color: AppColors.grey200),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ))
              .toList(),
        ),
      ],
    );
  }

  int _calculateStreak(List<JournalEntry> entries) {
    if (entries.isEmpty) return 0;
    // Simple mock logic for demonstration
    return entries.length > 5 ? 5 : entries.length;
  }
}
