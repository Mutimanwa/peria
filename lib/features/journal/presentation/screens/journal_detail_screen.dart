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
  int _currentIndex = 0;
  List<JournalEntry> _allEntries = [];
  bool _isControllerInitialized = false;

  @override
  void initState() {
    super.initState();
    // On initialise le controller par défaut, on ajustera la page dès que les données seront là
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // --- LOGIQUE MÉTIER RELOCALISÉE ICI POUR ACCÉDER À L'ÉTAT ---
  void _editEntry(JournalEntry entry) {
    context.go('/journal/edit/${entry.id}');
  }

  void _deleteEntry(JournalEntry entry) {
    // 1. On ouvre directement le dialogue de confirmation en lui passant l'entrée
    _confirmDelete(context, ref, entry);
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, JournalEntry entry) {
    HapticFeedback
        .heavyImpact(); // Super effet pour marquer la gravité de l'action !

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        title: const Text("Delete this memory?"),
        content: const Text("This action is permanent and cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            onPressed: () async {
              // 2. Appel de ton provider avec la bonne méthode 'delete'
              await ref.read(journalProvider.notifier).delete(entry.id);

              if (!context.mounted) return;

              // 3. Fermer le dialogue d'abord en utilisant son propre contexte
              Navigator.pop(dialogContext);

              // 4. Rediriger l'utilisatrice vers la liste des journaux
              context.go('/journal');
            },
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showOptions(BuildContext context, JournalEntry currentEntry) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Modifier'),
                onTap: () {
                  Navigator.pop(context);
                  _editEntry(currentEntry);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Supprimer'),
                onTap: () {
                  Navigator.pop(context);
                  _deleteEntry(currentEntry);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final entriesAsync = ref.watch(journalProvider);

    return entriesAsync.when(
      data: (entries) {
        if (entries.isEmpty) return _buildEmptyState(l10n);

        _allEntries = entries;

        // Trouver l'index correspondant à l'ID passé en paramètre
        if (!_isControllerInitialized) {
          final matchedIndex =
              _allEntries.indexWhere((e) => e.id == widget.entryId);
          _currentIndex = matchedIndex != -1 ? matchedIndex : 0;

          // Réinitialiser le controller avec la bonne page initiale une seule fois
          _pageController = PageController(initialPage: _currentIndex);
          _isControllerInitialized = true;
        }

        final currentEntry = _allEntries[_currentIndex];

        return PageScaffold(
          onBack: () => context.go('/journal'),
          actions: [
            IconButton(
              onPressed: () => _showOptions(context, currentEntry),
              icon: const Icon(Icons.more_vert),
            )
          ],
          child: PageView.builder(
            controller: _pageController,
            itemCount: _allEntries.length,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemBuilder: (context, index) {
              return _JournalEntryPage(entry: _allEntries[index]);
            },
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
      onBack: () => context.go('/journal'),
      showTitle: true,
      title: l10n.journalTitle,
      child: Center(
        child: EmptyJournal(hasQuery: false, selectedDate: DateTime.now()),
      ),
    );
  }
}

// Les sous-widgets restent inchangés et restent optimisés en performance (ConsumerWidget & StatelessWidget)
class _JournalEntryPage extends StatelessWidget {
  final JournalEntry entry;
  const _JournalEntryPage({required this.entry});

  @override
  Widget build(BuildContext context) {
    final mood = Mood.fromId(entry.mood);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          _HeroSection(entry: entry, mood: mood),
          _ContentSection(entry: entry),
          const SizedBox(height: 100),
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
      duration: const Duration(
          milliseconds: 600), // Légèrement plus rapide pour la réactivité UI
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 15 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(28, 40, 28,
            20), // Ajusté le padding haut pour éviter les débordements du Scaffold
        child: Column(
          children: [
            const SizedBox(height: 40),
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: mood.accent.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 1,
                  ),
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
                color: AppColors.grey900,
                fontWeight: FontWeight.w800,
              ),
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
        duration: const Duration(milliseconds: 800),
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
