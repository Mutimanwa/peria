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

        return Scaffold(
          backgroundColor: AppColors.white,
          extendBodyBehindAppBar: true,
          appBar: _JournalBlurredAppBar(
            onBack: () => context.go('/journal'),
            onEdit: () =>
                context.go('/journal/edit/${_allEntries[_currentIndex].id}'),
          ),
          body: PageView.builder(
            controller: _pageController,
            itemCount: _allEntries.length,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemBuilder: (context, index) {
              final entry = _allEntries[index];
              return _JournalEntryPage(entry: entry);
            },
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () =>
                context.go('/journal/edit/${_allEntries[_currentIndex].id}'),
            backgroundColor: AppColors.grey900,
            icon: const Icon(Icons.edit_rounded, color: Colors.white, size: 20),
            label: const Text("Edit Entry",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, __) => Scaffold(body: Center(child: Text("Error: $e"))),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return PageScaffold(
      showBack: true,
      onBack: () => context.pop(),
      showTitle: true,
      title: l10n.journalTitle,
      child: Center(
          child: EmptyJournal(hasQuery: false, selectedDate: DateTime.now())),
    );
  }
}

class _JournalBlurredAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final VoidCallback onBack;
  final VoidCallback onEdit;

  const _JournalBlurredAppBar({required this.onBack, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AppBar(
          backgroundColor: AppColors.white.withOpacity(0.7),
          elevation: 0,
          leading: BackIconButton(onPressed: onBack),
          centerTitle: true,
          title: Text(
            "Journal",
            style: AppText.h3.copyWith(fontSize: 18, color: AppColors.grey900),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.more_horiz_rounded,
                  color: AppColors.grey700),
              onPressed: () => _showMoreActions(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showMoreActions(BuildContext context) {
    // Placeholder for more actions menu
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
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
          _MetaSection(entry: entry),
          const SizedBox(height: 120), // Space for FAB
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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              mood.color.withOpacity(0.4),
              AppColors.white,
            ],
          ),
        ),
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
              child: Center(
                  child:
                      Text(mood.emoji, style: const TextStyle(fontSize: 40))),
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

class _MetaSection extends ConsumerWidget {
  final JournalEntry entry;
  const _MetaSection({required this.entry});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 40, 28, 20),
      child: Column(
        children: [
          _buildActionTile(
            icon: Icons.favorite_border_rounded,
            title: "Mark as favorite",
            color: Colors.pinkAccent,
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _buildActionTile(
            icon: Icons.copy_rounded,
            title: "Duplicate entry",
            color: AppColors.primary500,
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _buildActionTile(
            icon: Icons.ios_share_rounded,
            title: "Export memory",
            color: AppColors.grey700,
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _buildActionTile(
            icon: Icons.share_rounded,
            title: "Share moment",
            color: AppColors.primary500,
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _buildActionTile(
            icon: Icons.delete_outline_rounded,
            title: "Delete entry",
            color: Colors.redAccent,
            onTap: () => _confirmDelete(context, ref),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.grey50,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.grey100),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 16),
            Text(title,
                style: AppText.label.copyWith(
                    color: AppColors.grey800, fontWeight: FontWeight.bold)),
            const Spacer(),
            Icon(Icons.chevron_right_rounded, color: AppColors.grey400),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    HapticFeedback.heavyImpact();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        title: const Text("Delete this memory?"),
        content: const Text("This action is permanent and cannot be undone."),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
            ),
            onPressed: () async {
              await ref.read(journalProvider.notifier).delete(entry.id);
              if (!context.mounted) return;
              Navigator.pop(context);
              context.go('/journal');
            },
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
