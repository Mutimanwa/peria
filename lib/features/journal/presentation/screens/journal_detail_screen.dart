import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:perla_app/core/theme/theme.dart';
import 'package:perla_app/features/journal/presentation/providers/journal_provider.dart';
import 'package:perla_app/l10n/app_localizations.dart';
import 'package:perla_app/shared/widgets/common_widgets.dart';

class JournalDetailScreen extends ConsumerWidget {
  const JournalDetailScreen({super.key, required this.entryId});

  final String entryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final entryContext = ref.watch(journalEntryContextByIdProvider(entryId));
    final entry = entryContext?.entry;

    if (entry == null) {
      return PageScaffold(
        showBack: true,
        onBack: () => context.pop(),
        showTitle: true,
        title: l10n.journalTitle,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 88, 22, 24),
          child: Center(
            child: EmptyJournal(
              hasQuery: false,
              selectedDate: DateTime.now(),
            ),
          ),
        ),
      );
    }

    final resolvedEntry = entry;
    final tone = JournalMoodTone.fromMood(resolvedEntry.mood);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          // 1. Le fond dégradé 
          Container(
            decoration: const BoxDecoration(gradient: AppColors.bgGradient),
          ),

          // 2. Le contenu qui scrolle
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 80, 18, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          tone.accent.withOpacity(0.14),
                          tone.softBackground.withOpacity(0.65),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: tone.accent.withOpacity(0.22),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: tone.accent.withOpacity(0.08),
                          offset: const Offset(0, 4),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: tone.accent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            tone.label,
                            style: AppText.caption.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          resolvedEntry.title.isEmpty
                              ? l10n.untitledNote
                              : resolvedEntry.title,
                          style: AppText.h4.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.grey900,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            JournalMetaChip(
                              icon: Icons.calendar_today_outlined,
                              label: DateFormat('d MMM yyyy')
                                  .format(resolvedEntry.createdAt),
                            ),
                            JournalMetaChip(
                              icon: Icons.schedule,
                              label: DateFormat('HH:mm')
                                  .format(resolvedEntry.updatedAt),
                            ),
                            if (entryContext?.cycleDay != null)
                              JournalMetaChip(
                                icon: Icons.autorenew_rounded,
                                label: '${l10n.day} ${entryContext!.cycleDay}',
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  _JournalDetailCard(
                    icon: Icons.menu_book_outlined,
                    title: 'Note',
                    content: resolvedEntry.content.isEmpty
                        ? l10n.noDetailsYet
                        : resolvedEntry.content,
                    accentColor: tone.accent,
                  ),
                  const SizedBox(height: 14),
                  _JournalDetailCard(
                    icon: Icons.info_outline,
                    title: 'Details',
                    content:
                        'Created ${DateFormat('EEEE, d MMMM yyyy').format(resolvedEntry.createdAt)} at ${DateFormat('HH:mm').format(resolvedEntry.createdAt)}\nUpdated ${DateFormat('EEEE, d MMMM yyyy').format(resolvedEntry.updatedAt)} at ${DateFormat('HH:mm').format(resolvedEntry.updatedAt)}',
                    accentColor: AppColors.grey700,
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.error.withOpacity(0.25),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: AppColors.error,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.delete_outline,
                                color: AppColors.white,
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              l10n.delete,
                              style: AppText.h6.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.error,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Remove this note only if you no longer want to keep it in your private history.',
                          style: AppText.body.copyWith(
                            color: AppColors.grey800,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          width: double.infinity,
                          child: OutlineButton(
                            label: l10n.delete,
                            onPressed: () async {
                              await ref
                                  .read(journalProvider.notifier)
                                  .delete(resolvedEntry.id);
                              if (context.mounted) context.go('/journal');
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. L'en-tête FIXE 
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: Container(

                color: AppColors.white.withOpacity(0.95),
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BackIconButton(
                      onPressed: () => context.go('/journal'),
                    ),
                    Text(
                      l10n.journalTitle,
                      style: AppText.h2,
                    ),
                    IconButtonWidget(
                      onPressed: () =>
                          context.go('/journal/edit/${resolvedEntry.id}'),
                      icon: Icons.edit_outlined,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _JournalDetailCard extends StatelessWidget {
  const _JournalDetailCard({
    required this.icon,
    required this.title,
    required this.content,
    required this.accentColor,
  });

  final IconData icon;
  final String title;
  final String content;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.grey200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.04),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Icon(
                  icon,
                  color: accentColor,
                  size: 16,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                title.toUpperCase(),
                style: AppText.h6.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.grey900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            // premier lettre en majuscule, le reste normal
            content.isNotEmpty
                ? content[0].toUpperCase() + content.substring(1)
                : content,
            style: AppText.body.copyWith(
              color: AppColors.grey800,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
