import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:peria_app/core/theme/theme.dart';
import 'package:peria_app/features/journal/data/models/journal_entry.dart';
import 'package:peria_app/features/journal/data/models/mood.dart';
import 'package:peria_app/features/journal/presentation/providers/journal_provider.dart';
import 'package:peria_app/l10n/app_localizations.dart';
import 'package:peria_app/shared/widgets/common_widgets.dart';

class JournalDetailScreen extends ConsumerStatefulWidget {
  const JournalDetailScreen({super.key, required this.entryId});
  final String entryId;

  @override
  ConsumerState<JournalDetailScreen> createState() =>
      _JournalDetailScreenState();
}

class _JournalDetailScreenState extends ConsumerState<JournalDetailScreen> {
  late PageController _pageController;
  late int _currentIndex;
  List<JournalEntry> _allEntries = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final entriesAsync = ref.watch(journalProvider);

    return entriesAsync.when(
      data: (entries) {
        if (entries.isEmpty) return _buildEmptyState(l10n);

        _allEntries = entries;
        _currentIndex = _allEntries.indexWhere((e) => e.id == widget.entryId);
        if (_currentIndex == -1) _currentIndex = 0;

        // Reset page controller to matched index on first load
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_pageController.hasClients &&
              _pageController.page?.round() != _currentIndex) {
            _pageController.jumpToPage(_currentIndex);
          }
        });

        return PageScaffold(
            onBack: () => context.go('/journal'),
            actions: [
              // HeaderIconButton(icon: Icons.more_horiz_sharp, onTap: () => context.go('')),
              IconButton(onPressed: () => _showOptions(context), icon: const Icon(Icons.more_vert))
            ],
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _allEntries.length,
                    onPageChanged: (index) =>
                        setState(() => _currentIndex = index),
                    itemBuilder: (context, index) {
                      final entry = _allEntries[index];
                      return _JournalEntryPage(entry: entry);
                    },
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.all(10),
                //   child: HeaderIconButton(
                //       icon: Icons.edit_rounded,
                //       onTap: () => {
                //             context.go(
                //                 '/journal/edit/${_allEntries[_currentIndex].id}')
                //           }),
                // ),
              ],
            ));
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, __) => Scaffold(body: Center(child: Text("Error: $e"))),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return PageScaffold(
      showBack: true,
      onBack: () => context.go('/journal'),
      showTitle: true,
      title: l10n.journalTitle,
      child: Center(
          child: EmptyJournal(hasQuery: false, selectedDate: DateTime.now())),
    );
  }
}
void _showOptions(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    builder: (context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10,),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Modifier'),
            onTap: () {
              Navigator.pop(context);
              _editEntry();
            },
          ),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Partager'),
            onTap: () {
              Navigator.pop(context);
              _shareEntry();
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Supprimer'),
            onTap: () {
              Navigator.pop(context);
              _deleteEntry();
            },
          ),
        ],
      );
    },
  );
}

class _JournalEntryPage extends ConsumerWidget {
  final JournalEntry entry;
  const _JournalEntryPage({required this.entry});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mood = Mood.fromId(entry.mood);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          _HeroSection(entry: entry, mood: mood),
          _ContentSection(entry: entry),
          // _MetaSection(entry: entry),
          const SizedBox(height: 100), // Space for FAB
        ],
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  final JournalEntry entry;
  final Mood mood;

  const _HeroSection({required this.entry, required this.mood});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 800),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(28, 120, 28, 40),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: mood.accent.withOpacity(0.2),
                      blurRadius: 20,
                      spreadRadius: 5),
                ],
              ),
              child:
                  Center(child: Icon(mood.icon, size: 40, color: mood.accent)),
            ),
            const SizedBox(height: 24),
            Text(
              mood.label,
              style: AppText.caption.copyWith(
                color: mood.accent,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              entry.title.isNotEmpty ? entry.title : "A quiet moment",
              textAlign: TextAlign.center,
              style: AppText.h2.copyWith(
                  color: AppColors.grey900, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 16),
            Text(
              DateFormat('EEEE, d MMMM • HH:mm').format(entry.createdAt),
              style:
                  AppText.body.copyWith(color: AppColors.grey500, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContentSection extends StatelessWidget {
  final JournalEntry entry;
  const _ContentSection({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 1000),
        tween: Tween(begin: 0.0, end: 1.0),
        builder: (context, value, child) =>
            Opacity(opacity: value, child: child),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(height: 40, color: AppColors.grey100),
            Text(
              entry.content,
              style: AppText.body.copyWith(
                color: AppColors.grey800,
                fontSize: 18,
                height: 1.8,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _editEntry() {
  print('Modifier');
}

void _deleteEntry() {
  print('Supprimer');
}

void _shareEntry() {
  print('Partager');
}