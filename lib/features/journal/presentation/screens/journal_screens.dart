
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:peria_app/core/theme/theme.dart';
import 'package:peria_app/features/cycle/presentation/providers/cycle_provider.dart';
import 'package:peria_app/features/journal/data/models/journal_entry.dart';
import 'package:peria_app/features/journal/presentation/providers/journal_provider.dart';
import 'package:peria_app/features/journal/presentation/widgets/journal_skeleton.dart';
import 'package:peria_app/l10n/app_localizations.dart';
import 'package:peria_app/shared/widgets/common_widgets.dart';

class JournalScreens extends ConsumerStatefulWidget {
  const JournalScreens({super.key});

  @override
  ConsumerState<JournalScreens> createState() => _JournalScreenState();
}

class _JournalScreenState extends ConsumerState<JournalScreens> {
  late DateTime _selectedDate;
  final _searchController = TextEditingController();
  final _quickLogController = TextEditingController();
  bool _searchOpen = false;
  String _query = '';
  // String _quickMood = 'calm';

  // static const _moods = [
  //   ('calm', 'Calm'),
  //   ('happy', 'Happy'),
  //   ('sad', 'Sad'),
  //   ('anxious', 'Anxious'),
  //   ('tired', 'Tired'),
  // ];

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

  // Future<void> _saveQuickEntry() async {
  //   final note = _quickLogController.text.trim();
  //   if (note.isEmpty) return;
  //   final now = DateTime.now();
  //   await ref.read(journalProvider.notifier).upsert(
  //         JournalEntry(
  //           id: now.microsecondsSinceEpoch.toString(),
  //           createdAt: now,
  //           updatedAt: now,
  //           title: '',
  //           content: note,
  //           mood: _quickMood,
  //         ),
  //       );
  //   if (!mounted) return;
  //   setState(() {
  //     _selectedDate = now;
  //     _quickMood = 'calm';
  //     _quickLogController.clear();
  //   });
  // }

  String _summaryLabel(DateTime date, int count) {
    final day = DateFormat('EEEE, d MMMM' , 'fr').format(date);
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
                        // if (_query.isEmpty)
                        //   Padding(
                        //     padding: const EdgeInsets.only(bottom: 16),
                        //     child: _QuickLogComposer(
                        //       value: _quickLogController.text,
                        //       selectedMood: _quickMood,
                        //       moods: _moods,
                        //       onMoodSelected: (mood) => setState(() => _quickMood = mood),
                        //       onOpenSheet: () => context.go('/journal/new'),
                        //       controller: _quickLogController,
                        //       onSave: _saveQuickEntry,
                        //     ),
                        //   ),
                        if (filtered.isEmpty)
                          EmptyJournal(hasQuery: _query.isNotEmpty, selectedDate: _selectedDate)
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
                  const SizedBox(height: 80),
                ],
              );
              
            },
            loading: () => Column(
              children: [
                _buildHeader(l10n),
                _buildWeekCalendarSkeleton(),
                _buildSummaryBarSkeleton(),
                const Expanded(child: JournalSkeleton(count: 4)),
              ],
            ),
            error: (err, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: AppColors.grey400),
                  const SizedBox(height: 16),
                  Text(l10n.unableToLoadJournal,
                      style: AppText.h3.copyWith(color: AppColors.grey700)),
                  const SizedBox(height: 8),
                  Text(err.toString(),
                      style: AppText.body.copyWith(color: AppColors.grey500),
                      textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 90, right: 30),
        child: HeaderIconButton(
          icon: Icons.add, onTap: () => {context.go('/journal/new')}
        )
      ),
    );
  }

  /// Skeleton for week calendar during loading
  Widget _buildWeekCalendarSkeleton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: List.generate(
          7,
          (i) => Expanded(
            child: Container(
              height: 80,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: AppColors.grey100,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Skeleton for summary bar during loading
  Widget _buildSummaryBarSkeleton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.grey100,
          borderRadius: BorderRadius.circular(12),
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
                      style: AppText.h2,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _query.isNotEmpty ? l10n.tryAnotherKeyword : l10n.journalSubtitle,
                      style: AppText.body.copyWith(color: AppColors.grey600),
                    ),
                  ],
                ),
              ),
              HeaderIconButton(
                icon: _searchOpen ? Icons.close_rounded : Icons.search_rounded,
                onTap: () {
                  context.go('/journal/search');
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          // if (_searchOpen)
          //   Container(
          //     height: 52,
          //     padding: const EdgeInsets.symmetric(horizontal: 14),
          //     decoration: BoxDecoration(
          //       color: AppColors.white,
          //       borderRadius: BorderRadius.circular(18),
          //       border: Border.all(color: AppColors.grey200),
          //     ),
          //     child: TextField(
          //       controller: _searchController,
          //       onChanged: (value) => setState(() => _query = value.trim().toLowerCase()),
          //       decoration: InputDecoration(
          //         border: InputBorder.none,
          //         hintText: l10n.searchJournalHint,
          //         hintStyle: AppText.body.copyWith(color: AppColors.grey400),
          //         icon: const Icon(Icons.search_rounded, color: AppColors.grey500, size: 20),
          //       ),
          //     ),
          //   )
          // else
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
                      l10n.privateByDefault,
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
        borderRadius: BorderRadius.circular(10),
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
            _isSameDay(_selectedDate, DateTime.now()) ? 'Aujourd\'hui' : DateFormat('EEE', 'fr').format(_selectedDate).toUpperCase(),
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


// class _QuickLogComposer extends StatelessWidget {
//   const _QuickLogComposer({
//     required this.value,
//     required this.selectedMood,
//     required this.moods,
//     required this.onMoodSelected,
//     required this.onOpenSheet,
//     required this.controller,
//     required this.onSave,
//   });

//   final String value;
//   final String selectedMood;
//   final List<(String, String)> moods;
//   final ValueChanged<String> onMoodSelected;
//   final VoidCallback onOpenSheet;
//   final TextEditingController controller;
//   final Future<void> Function() onSave;

//   @override
//   Widget build(BuildContext context) {
//     final l10n = AppLocalizations.of(context);
//     final canSave = value.trim().length > 5;
//     return Container(
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         color: AppColors.white.withOpacity(0.8),
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: AppColors.grey200),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Expanded(child: Text(l10n.newEntry, style: AppText.h5)),
//               TextButton(
//                 onPressed: onOpenSheet,
//                 child: Text(
//                   'Expand',
//                   style: AppText.caption.copyWith(
//                     color: AppColors.primary500,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 4),
//           Text(
//             l10n.writeFreelyHint,
//             style: AppText.caption.copyWith(color: AppColors.grey600),
//           ),
//           const SizedBox(height: 14),
//           Wrap(
//             spacing: 8,
//             runSpacing: 8,
//             children: moods.map((item) {
//               final selected = selectedMood == item.$1;
//               final tone = JournalMoodTone.fromMood(item.$1);
//               return GestureDetector(
//                 onTap: () => onMoodSelected(item.$1),
//                 child: AnimatedContainer(
//                   duration: const Duration(milliseconds: 180),
//                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                   decoration: BoxDecoration(
//                     color: selected ? tone.softBackground : AppColors.grey100,
//                     borderRadius: BorderRadius.circular(999),
//                     border: Border.all(color: selected ? tone.accent : AppColors.grey200),
//                   ),
//                   child: Text(
//                     item.$2,
//                     style: AppText.caption.copyWith(
//                       color: selected ? tone.accent : AppColors.grey700,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                 ),
//               );
//             }).toList(),
//           ),
//           const SizedBox(height: 14),
//           Container(
//             decoration: BoxDecoration(
//               color: AppColors.grey100,
//               borderRadius: BorderRadius.circular(10),
//             ),
//             padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
//             child: TextField(
//               controller: controller,
//               minLines: 3,
//               maxLines: 5,
//               decoration: InputDecoration(
//                 border: InputBorder.none,
//                 hintText: l10n.writeFreelyHint,
//               ),
//             ),
//           ),
//           const SizedBox(height: 14),
//           Row(
//             children: [
//               Expanded(
//                 child: Text(
//                   'Quick log',
//                   style: AppText.caption.copyWith(
//                     color: AppColors.grey600,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 width: 132,
//                 height: 45,
//                 child: PrimaryButton(
//                   label: l10n.saveEntry,
//                   onPressed: canSave ? onSave : null,
//                   fullWidth: true,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

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
        width: 58,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.white : AppColors.white.withOpacity(0.55),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isSelected ? AppColors.primary200 : AppColors.grey200),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat('E' , 'fr').format(date).toUpperCase(),
              style: AppText.caption.copyWith(
                color: isToday ? AppColors.primary500 : AppColors.grey600,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              '${date.day}',
              style: AppText.label.copyWith(
                color: AppColors.grey900,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
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

class _JournalCard extends StatelessWidget {
  const _JournalCard({required this.entry});

  final JournalEntry entry;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final l10n = AppLocalizations.of(context);
        final tone = JournalMoodTone.fromMood(entry.mood);
        final title = entry.title.isEmpty ? l10n.untitledNote : entry.title;
        final preview = entry.content.isEmpty ? l10n.noDetailsYet : entry.content;
        final cycleDay = ref.watch(cycleDayForDateProvider(entry.createdAt));
        return GestureDetector(
          onTap: () => context.go('/journal/detail/${entry.id}'),
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.85),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.grey200),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.only(top: 6),
                  decoration:
                      BoxDecoration(color: tone.accent, shape: BoxShape.circle),
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
                        style: AppText.body.copyWith(
                          color: AppColors.grey700,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
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
                          if (cycleDay != null)
                            JournalMetaChip(
                              icon: Icons.autorenew_rounded,
                              label: '${l10n.day} $cycleDay',
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

