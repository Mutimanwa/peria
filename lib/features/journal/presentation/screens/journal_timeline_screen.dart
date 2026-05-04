import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:peria_app/core/theme/theme.dart';
import 'package:peria_app/features/journal/data/models/journal_entry.dart';
import 'package:peria_app/features/journal/data/models/mood.dart';
import 'package:peria_app/features/journal/presentation/providers/journal_provider.dart';
import 'package:peria_app/shared/widgets/common_widgets.dart';

class JournalTimelineScreen extends ConsumerWidget {
  const JournalTimelineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(journalProvider);

    return PageScaffold(
      showBack: true,
      onBack: () => context.go('/journal'),
      showTitle: true,
      title: "Timeline",
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 80, 22, 0),
        child: state.when(
          data: (entries) {
            if (entries.isEmpty) {
              return Center(
                child: EmptyJournal(
                  hasQuery: false,
                  selectedDate: DateTime.now(),
                ),
              );
            }

            final grouped = _groupEntries(entries);
            final keys = grouped.keys.toList();

            return ListView.builder(
              padding: const EdgeInsets.only(bottom: 100),
              itemCount: keys.length,
              itemBuilder: (context, index) {
                final date = keys[index];
                final dayEntries = grouped[date]!;
                return _TimelineSection(date: date, entries: dayEntries);
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text("Error: $err")),
        ),
      ),
    );
  }

  Map<DateTime, List<JournalEntry>> _groupEntries(List<JournalEntry> entries) {
    final Map<DateTime, List<JournalEntry>> grouped = {};
    for (final entry in entries) {
      final date = DateTime(
          entry.createdAt.year, entry.createdAt.month, entry.createdAt.day);
      if (!grouped.containsKey(date)) grouped[date] = [];
      grouped[date]!.add(entry);
    }
    return grouped;
  }
}

class _TimelineSection extends StatelessWidget {
  final DateTime date;
  final List<JournalEntry> entries;

  const _TimelineSection({required this.date, required this.entries});

  @override
  Widget build(BuildContext context) {
    final isToday = _isSameDay(date, DateTime.now());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            children: [
              Text(
                isToday ? "Today" : DateFormat('EEEE, d MMM').format(date),
                style: AppText.h5.copyWith(color: AppColors.grey900),
              ),
              const SizedBox(width: 8),
              Expanded(child: Divider(color: AppColors.grey200)),
            ],
          ),
        ),
        ...entries.map((e) => _TimelineCard(entry: e)),
      ],
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

class _TimelineCard extends StatelessWidget {
  final JournalEntry entry;
  const _TimelineCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    final mood = Mood.fromId(entry.mood);
    return GestureDetector(
      onTap: () => context.go('/journal/detail/${entry.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.grey200),
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: 4,
                decoration: BoxDecoration(
                  color: mood.accent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(mood.icon, color: mood.accent, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            entry.title.isNotEmpty
                                ? entry.title
                                : "Untitled note",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.label
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          DateFormat('HH:mm').format(entry.updatedAt),
                          style: AppText.caption
                              .copyWith(color: AppColors.grey500),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      entry.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.body
                          .copyWith(color: AppColors.grey700, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
