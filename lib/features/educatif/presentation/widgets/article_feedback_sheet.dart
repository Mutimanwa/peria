import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peria_app/core/constants/app_assets.dart';
import 'package:peria_app/core/theme/theme.dart';
import 'package:peria_app/features/educatif/presentation/providers/education_provider.dart';
import 'package:peria_app/l10n/app_localizations.dart';
import 'package:peria_app/shared/widgets/common_widgets.dart';

/// Reasons listed in the "not satisfied" sheet, in display order.
enum ArticleFeedbackReason {
  references,
  unclearMechanism,
  insufficientEvidence,
  sideEffects,
  translation,
  design,
  others,
}

extension ArticleFeedbackReasonX on ArticleFeedbackReason {
  String label(AppLocalizations l10n) {
    return switch (this) {
      ArticleFeedbackReason.references => l10n.articleFeedbackReferences,
      ArticleFeedbackReason.unclearMechanism =>
        l10n.articleFeedbackUnclearMechanism,
      ArticleFeedbackReason.insufficientEvidence =>
        l10n.articleFeedbackInsufficientEvidence,
      ArticleFeedbackReason.sideEffects => l10n.articleFeedbackSideEffects,
      ArticleFeedbackReason.translation => l10n.articleFeedbackTranslation,
      ArticleFeedbackReason.design => l10n.articleFeedbackDesign,
      ArticleFeedbackReason.others => l10n.articleFeedbackOthers,
    };
  }

  IconData get icon {
    return switch (this) {
      ArticleFeedbackReason.references => Icons.menu_book_outlined,
      ArticleFeedbackReason.unclearMechanism => Icons.help_outline_rounded,
      ArticleFeedbackReason.insufficientEvidence =>
        Icons.search_rounded,
      ArticleFeedbackReason.sideEffects => Icons.priority_high_rounded,
      ArticleFeedbackReason.translation => Icons.language_rounded,
      ArticleFeedbackReason.design => Icons.brush_outlined,
      ArticleFeedbackReason.others => Icons.add_rounded,
    };
  }
}

/// Bottom sheet used by the article screen: mascot, reason chips, free note.
/// Returns `true` when the reader sent feedback.
Future<bool?> showArticleFeedbackSheet(
  BuildContext context, {
  required String articleId,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.46),
    elevation: 0,
    builder: (context) => _ArticleFeedbackSheet(articleId: articleId),
  );
}

class _ArticleFeedbackSheet extends ConsumerStatefulWidget {
  const _ArticleFeedbackSheet({required this.articleId});

  final String articleId;

  @override
  ConsumerState<_ArticleFeedbackSheet> createState() =>
      _ArticleFeedbackSheetState();
}

class _ArticleFeedbackSheetState extends ConsumerState<_ArticleFeedbackSheet> {
  final _noteController = TextEditingController();
  final _selected = <ArticleFeedbackReason>{};

  @override
  void initState() {
    super.initState();
    _noteController.addListener(_refresh);
  }

  @override
  void dispose() {
    _noteController
      ..removeListener(_refresh)
      ..dispose();
    super.dispose();
  }

  void _refresh() => setState(() {});

  bool get _canSend => _selected.isNotEmpty || _noteController.text.trim().isNotEmpty;

  Future<void> _send() async {
    await ref
        .read(articleFeedbackProvider.notifier)
        .setVote(widget.articleId, 'down');
    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: EdgeInsets.only(
        top: 28,
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.22),
              blurRadius: 28,
              spreadRadius: 2,
              offset: const Offset(0, -10),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.grey300,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                const SizedBox(height: 12),
                Image.asset(
                  AppAssets.mascotFeedback,
                  height: 148,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.articleFeedbackQuestion,
                  textAlign: TextAlign.center,
                  style: AppText.h3.copyWith(
                    color: AppColors.grey900,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 20),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (final reason in ArticleFeedbackReason.values)
                      _ReasonChip(
                        reason: reason,
                        label: reason.label(l10n),
                        selected: _selected.contains(reason),
                        onTap: () {
                          setState(() {
                            if (!_selected.remove(reason)) _selected.add(reason);
                          });
                        },
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.grey100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: TextField(
                    controller: _noteController,
                    minLines: 4,
                    maxLines: 6,
                    textInputAction: TextInputAction.newline,
                    style: AppText.body.copyWith(color: AppColors.grey900),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: l10n.articleFeedbackNoteHint,
                      hintStyle:
                          AppText.body.copyWith(color: AppColors.grey500),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                PrimaryButton(
                  label: l10n.articleAddComment,
                  onPressed: _canSend ? _send : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ReasonChip extends StatelessWidget {
  const _ReasonChip({
    required this.reason,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final ArticleFeedbackReason reason;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = AppColors.primary400;
    return Material(
      color: selected ? AppColors.primary50 : AppColors.grey100,
      borderRadius: BorderRadius.circular(99),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(99),
        child: Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(99),
            border: Border.all(
              color: selected ? accent.withOpacity(0.45) : Colors.transparent,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                reason.icon,
                size: 18,
                color: selected ? accent : AppColors.primary300,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: AppText.label.copyWith(
                  color: selected ? accent : AppColors.grey700,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Confirmation card shown after a vote or a comment.
Future<void> showArticleFeedbackThanks(BuildContext context) {
  final l10n = AppLocalizations.of(context);
  return showDialog<void>(
    context: context,
    barrierColor: Colors.black.withOpacity(0.46),
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 132,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    AppAssets.mascotThanks,
                    height: 132,
                    fit: BoxFit.contain,
                  ),
                  Positioned(
                    right: 24,
                    bottom: 6,
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.success, width: 2.5),
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        size: 20,
                        color: AppColors.success,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Text(
              l10n.articleFeedbackThanksTitle,
              textAlign: TextAlign.center,
              style: AppText.h3.copyWith(color: AppColors.grey900),
            ),
            const SizedBox(height: 10),
            Text(
              l10n.articleFeedbackThanksBody,
              textAlign: TextAlign.center,
              style: AppText.body.copyWith(
                color: AppColors.grey600,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 180,
              child: PrimaryButton(
                label: l10n.articleFeedbackOk,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
