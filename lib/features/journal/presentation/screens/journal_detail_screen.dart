import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:peria_app/core/theme/theme.dart';
import 'package:peria_app/features/cycle/presentation/providers/cycle_provider.dart';
import 'package:peria_app/features/journal/data/models/journal_entry.dart';
import 'package:peria_app/features/journal/data/models/mood.dart';
import 'package:peria_app/features/journal/presentation/journal_content.dart';
import 'package:peria_app/features/journal/presentation/mood_localization.dart';
import 'package:peria_app/features/journal/presentation/providers/journal_provider.dart';
import 'package:peria_app/features/journal/presentation/widgets/journal_attachment_view.dart';
import 'package:peria_app/l10n/app_localizations.dart';
import 'package:peria_app/shared/widgets/common_widgets.dart';

/// Reading view of a memory.
///
/// The entry is shown like a page of a book: a mood-tinted header, a soft card
/// for the text, then the pictures. Swiping moves to the neighbouring note, so
/// the journal keeps the feeling of a notebook instead of a list of records.
class JournalDetailScreen extends ConsumerStatefulWidget {
  const JournalDetailScreen({super.key, required this.entryId});

  final String entryId;

  @override
  ConsumerState<JournalDetailScreen> createState() =>
      _JournalDetailScreenState();
}

class _JournalDetailScreenState extends ConsumerState<JournalDetailScreen> {
  PageController? _pageController;
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  void _editEntry(JournalEntry entry) {
    context.push('/journal/edit/${entry.id}');
  }

  Future<void> _copyEntry(JournalEntry entry) async {
    final l10n = AppLocalizations.of(context);
    final content = journalContentView(entry);
    final buffer = StringBuffer();
    if (entry.title.trim().isNotEmpty) {
      buffer.writeln(entry.title.trim());
      buffer.writeln();
    }
    if (content.text.trim().isNotEmpty) buffer.write(content.text.trim());

    final text = buffer.toString().trim();
    if (text.isEmpty) {
      _showSnack(l10n.noDetailsYet);
      return;
    }

    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    _showSnack(l10n.journalCopied);
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
  }

  Future<void> _confirmDelete(JournalEntry entry) async {
    final l10n = AppLocalizations.of(context);
    HapticFeedback.heavyImpact();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(l10n.journalDeleteMemoryTitle),
        content: Text(l10n.journalDeleteMemoryBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error700,
              foregroundColor: AppColors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      await ref.read(journalProvider.notifier).delete(entry.id);
    } catch (_) {
      if (!mounted) return;
      _showSnack(l10n.journalSaveError);
      return;
    }

    if (!mounted) return;
    // The note is gone: leave the reading view instead of staying on a page
    // that no longer exists.
    safeRouterBack(context, fallbackRoute: '/journal');
  }

  @override
  
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final entriesAsync = ref.watch(journalProvider);

    return entriesAsync.when(
      data: (entries) {
        if (entries.isEmpty) return _buildEmptyState(l10n);

        final index = entries.indexWhere((entry) => entry.id == widget.entryId);
        if (index == -1) {
          return PageScaffold(
            onBack: () => safeRouterBack(context, fallbackRoute: '/journal'),
            title: l10n.journalTitle,
            child: Center(child: Text(l10n.unableToLoadJournal)),
          );
        }

        if (_pageController == null) {
          _currentIndex = index;
          _pageController = PageController(initialPage: index);
        }
        final safeIndex = _currentIndex.clamp(0, entries.length - 1);
        final currentEntry = entries[safeIndex];

        return Scaffold(
          backgroundColor: AppColors.white,
          body: Container(
            decoration: const BoxDecoration(gradient: AppColors.bgGradient),
            child: SafeArea(
              bottom: false,
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _pageController!,
                    itemCount: entries.length,
                    onPageChanged: (value) =>
                        setState(() => _currentIndex = value),
                    itemBuilder: (context, i) => _EntryPage(
                      entry: entries[i],
                      onOpenImage: _openImage,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 16,
                    right: 16,
                    child: Row(
                      children: [
                        BackIconButton(
                          onPressed: () =>
                              safeRouterBack(context, fallbackRoute: '/journal'),
                        ),
                      ],
                    ),
                  ),
                  if (entries.length > 1)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 92 + MediaQuery.of(context).padding.bottom,
                      child: _PageDots(
                        count: entries.length,
                        index: safeIndex,
                      ),
                    ),
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 16 + MediaQuery.of(context).padding.bottom,
                    child: _DetailActionBar(
                      onEdit: () => _editEntry(currentEntry),
                      onCopy: () => _copyEntry(currentEntry),
                      onDelete: () => _confirmDelete(currentEntry),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, __) =>
          Scaffold(body: Center(child: Text(l10n.unableToLoadJournal))),
    );
  }

  void _openImage(String path) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.92),
      builder: (dialogContext) {
        final size = MediaQuery.of(dialogContext).size;
        return GestureDetector(
          onTap: () => Navigator.pop(dialogContext),
          child: InteractiveViewer(
            maxScale: 4,
            child: Center(
              child: journalAttachmentView(
                path,
                width: size.width,
                height: size.height * 0.75,
                fit: BoxFit.contain,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return PageScaffold(
      showBack: true,
      onBack: () => safeRouterBack(context, fallbackRoute: '/journal'),
      showTitle: true,
      title: l10n.journalTitle,
      child: Center(
        child: EmptyJournal(hasQuery: false, selectedDate: DateTime.now()),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Page
// ─────────────────────────────────────────────────────────────────────────────

class _EntryPage extends StatelessWidget {
  const _EntryPage({required this.entry, required this.onOpenImage});

  final JournalEntry entry;
  final ValueChanged<String> onOpenImage;

  @override
  Widget build(BuildContext context) {
    final mood = Mood.fromId(entry.mood);
    final content = journalContentView(entry);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 132),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _MoodHeader(entry: entry, mood: mood),
          _ContentCard(
            entry: entry,
            content: content,
            onOpenImage: onOpenImage,
          ),
          const SizedBox(height: 16),
          _MetaFooter(entry: entry, content: content),
        ],
      ),
    );
  }
}

class _MoodHeader extends StatelessWidget {
  const _MoodHeader({required this.entry, required this.mood});

  final JournalEntry entry;
  final Mood mood;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final title = entry.title.trim().isEmpty
        ? l10n.journalQuietMoment
        : entry.title.trim();

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      tween: Tween(begin: 0, end: 1),
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(offset: Offset(0, 12 * (1 - value)), child: child),
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 84, 24, 34),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              mood.color,
              mood.color.withOpacity(0.45),
              mood.color.withOpacity(0),
            ],
          ),
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(36)),
        ),
        child: Column(
          children: [
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: mood.accent.withOpacity(0.28),
                    blurRadius: 26,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Icon(mood.icon, size: 40, color: mood.accent),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.85),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: mood.accent.withOpacity(0.22)),
              ),
              child: Text(
                mood.localizedLabel(l10n),
                style: AppText.caption.copyWith(
                  color: mood.accent,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: AppText.h2.copyWith(
                color: AppColors.grey900,
                fontWeight: FontWeight.w800,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              DateFormat('EEEE d MMMM yyyy • HH:mm', locale).format(entry.createdAt),
              textAlign: TextAlign.center,
              style: AppText.body.copyWith(
                color: AppColors.grey700,
                fontSize: 13.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContentCard extends StatelessWidget {
  const _ContentCard({
    required this.entry,
    required this.content,
    required this.onOpenImage,
  });

  final JournalEntry entry;
  final JournalContentView content;
  final ValueChanged<String> onOpenImage;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hasText = content.text.trim().isNotEmpty;

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOut,
      tween: Tween(begin: 0, end: 1),
      builder: (context, value, child) => Opacity(opacity: value, child: child),
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 22, 20, 0),
        padding: const EdgeInsets.fromLTRB(22, 22, 22, 24),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: AppColors.grey100),
          boxShadow: [
            BoxShadow(
              color: AppColors.grey900.withOpacity(0.06),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (content.images.isNotEmpty) ...[
              _ImageGallery(
                images: content.images,
                onOpenImage: onOpenImage,
              ),
              if (hasText) ...[
                const SizedBox(height: 20),
                Container(height: 1, color: AppColors.grey100),
                const SizedBox(height: 20),
              ],
            ],
            if (hasText)
              Text(
                content.text,
                style: AppText.body.copyWith(
                  color: AppColors.grey800,
                  fontSize: 17.5,
                  height: 1.75,
                  letterSpacing: 0.1,
                ),
              )
            else
              Text(
                l10n.noDetailsYet,
                style: AppText.body.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ImageGallery extends StatelessWidget {
  const _ImageGallery({required this.images, required this.onOpenImage});

  final List<String> images;
  final ValueChanged<String> onOpenImage;

  @override
  Widget build(BuildContext context) {
    if (images.length == 1) {
      return GestureDetector(
        onTap: () => onOpenImage(images.first),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: SizedBox(
            width: double.infinity,
            height: 210,
            child: journalAttachmentView(images.first),
          ),
        ),
      );
    }

    return SizedBox(
      height: 170,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final path = images[index];
          return GestureDetector(
            onTap: () => onOpenImage(path),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: SizedBox(
                width: 170,
                height: 170,
                child: journalAttachmentView(path),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Small facts under the card: reading time, cycle day and the last edit.
class _MetaFooter extends ConsumerWidget {
  const _MetaFooter({required this.entry, required this.content});

  final JournalEntry entry;
  final JournalContentView content;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final cycleDay = ref.watch(cycleDayForDateProvider(entry.createdAt));

    final words = content.text
            .trim()
            .isEmpty
        ? 0
        : content.text.trim().split(RegExp(r'\s+')).length;
    final minutes = math.max(1, (words / 200).ceil());
    final edited = entry.updatedAt.difference(entry.createdAt).inMinutes.abs() >= 1;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        children: [
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              if (words > 0)
                JournalMetaChip(
                  icon: Icons.schedule_rounded,
                  label: l10n.journalReadingTime(minutes),
                ),
              if (cycleDay != null)
                JournalMetaChip(
                  icon: Icons.autorenew_rounded,
                  label: '${l10n.day} $cycleDay',
                ),
              if (content.images.isNotEmpty)
                JournalMetaChip(
                  icon: Icons.photo_outlined,
                  label: '${content.images.length}',
                ),
            ],
          ),
          if (edited) ...[
            const SizedBox(height: 10),
            Text(
              '${l10n.journalEditedLabel} · '
              '${DateFormat('d MMM • HH:mm', locale).format(entry.updatedAt.toLocal())}',
              style: AppText.caption.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ],
      ),
    );
  }
}

class _PageDots extends StatelessWidget {
  const _PageDots({required this.count, required this.index});

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: active ? 18 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: active ? AppColors.grey900 : AppColors.grey300,
            borderRadius: BorderRadius.circular(999),
          ),
        );
      }),
    );
  }
}

/// Sticky actions: edit is the main gesture, copy and delete stay secondary.
class _DetailActionBar extends StatelessWidget {
  const _DetailActionBar({
    required this.onEdit,
    required this.onCopy,
    required this.onDelete,
  });

  final VoidCallback onEdit;
  final VoidCallback onCopy;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppColors.grey100),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey900.withOpacity(0.10),
            blurRadius: 26,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onEdit,
              behavior: HitTestBehavior.opaque,
              child: Semantics(
                button: true,
                label: l10n.journalEditAction,
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary500,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary500.withOpacity(0.32),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.edit_outlined,
                          size: 18, color: AppColors.white),
                      const SizedBox(width: 8),
                      Text(
                        l10n.journalEditAction,
                        style: AppText.label.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          _BarIcon(
            icon: Icons.copy_rounded,
            label: l10n.journalCopyText,
            onTap: onCopy,
          ),
          const SizedBox(width: 8),
          _BarIcon(
            icon: Icons.delete_outline_rounded,
            label: l10n.delete,
            onTap: onDelete,
            danger: true,
          ),
        ],
      ),
    );
  }
}

class _BarIcon extends StatelessWidget {
  const _BarIcon({
    required this.icon,
    required this.label,
    required this.onTap,
    this.danger = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final background = danger ? AppColors.error50 : AppColors.grey100;
    final foreground = danger ? AppColors.error700 : AppColors.grey700;
    return Semantics(
      button: true,
      label: label,
      child: ExcludeSemantics(
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, size: 21, color: foreground),
          ),
        ),
      ),
    );
  }
}
