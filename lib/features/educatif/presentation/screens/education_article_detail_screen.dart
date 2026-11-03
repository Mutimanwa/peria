import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:peria_app/core/constants/app_assets.dart';
import 'package:peria_app/core/theme/theme.dart';
import 'package:peria_app/features/educatif/data/models/education_article.dart';
import 'package:peria_app/features/educatif/presentation/providers/education_provider.dart';
import 'package:peria_app/features/educatif/presentation/widgets/article_feedback_sheet.dart';
import 'package:peria_app/l10n/app_localizations.dart';
import 'package:peria_app/shared/widgets/common_widgets.dart';
import 'package:peria_app/shared/widgets/health_information_notice.dart';

class EducationArticleDetailScreen extends ConsumerWidget {
  final String articleId;

  const EducationArticleDetailScreen({
    super.key,
    required this.articleId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final article = ref.watch(educationArticleProvider(articleId));
    final isSaved = ref.watch(savedArticlesProvider).contains(articleId);
    final vote = ref.watch(articleFeedbackProvider)[articleId];

    if (article == null) {
      return Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.page,
                  12,
                  AppSpacing.page,
                  0,
                ),
                child: Row(
                  children: [
                    _RoundIconButton(
                      icon: Icons.chevron_left_rounded,
                      onTap: () =>
                          safeRouterBack(context, fallbackRoute: '/education'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.page,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        AppAssets.mascotSearch,
                        height: 200,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.educationArticleNotFound,
                        textAlign: TextAlign.center,
                        style: AppText.h5.copyWith(color: AppColors.grey600),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () => safeRouterBack(
                          context,
                          fallbackRoute: '/education',
                        ),
                        child: Text(
                          l10n.backToEducation,
                          style: AppText.label.copyWith(
                            color: AppColors.primary500,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.page,
                12,
                AppSpacing.page,
                4,
              ),
              child: Row(
                children: [
                  _RoundIconButton(
                    icon: Icons.chevron_left_rounded,
                    onTap: () =>
                        safeRouterBack(context, fallbackRoute: '/education'),
                  ),
                  const Spacer(),
                  _RoundIconButton(
                    icon: isSaved
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_outline_rounded,
                    iconColor: isSaved ? AppColors.primary400 : AppColors.grey700,
                    onTap: () => ref
                        .read(savedArticlesProvider.notifier)
                        .toggle(article.id),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.page,
                  8,
                  AppSpacing.page,
                  24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ArticleHero(article: article, l10n: l10n),
                    const SizedBox(height: 16),
                    _ArticleMeta(article: article, l10n: l10n),
                    const SizedBox(height: 12),
                    Text(
                      article.title,
                      style: AppText.h2.copyWith(
                        color: AppColors.grey900,
                        height: 1.22,
                      ),
                    ),
                    if (article.shortDescription.trim().isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Text(
                        article.shortDescription,
                        style: AppText.body.copyWith(
                          color: AppColors.grey900,
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    _ArticleSection(
                      icon: Icons.water_drop_outlined,
                      title: l10n.educationExplanation,
                      content: article.explanation,
                    ),
                    _ArticleSection(
                      icon: Icons.search_rounded,
                      title: l10n.educationObserve,
                      content: article.observations,
                    ),
                    _ArticleSection(
                      icon: Icons.spa_outlined,
                      title: l10n.educationAdvice,
                      content: article.advice,
                    ),
                    if (article.whenToConsult.trim().isNotEmpty)
                      _ArticleSection(
                        icon: Icons.warning_amber_rounded,
                        title: l10n.educationWhenToConsult,
                        content: article.whenToConsult,
                        isWarning: true,
                      ),
                    const SizedBox(height: 4),
                    HealthInformationNotice(
                      title: l10n.educationHealthNoticeTitle,
                      message: l10n.educationHealthNoticeBody,
                    ),
                    const SizedBox(height: 22),
                    _ArticleFeedbackRow(
                      vote: vote,
                      onVote: (nextVote) async {
                        await ref
                            .read(articleFeedbackProvider.notifier)
                            .setVote(article.id, nextVote);
                        if (!context.mounted) return;
                        if (nextVote == 'up') {
                          await showArticleFeedbackThanks(context);
                        } else {
                          await _openFeedbackSheet(context, article.id);
                        }
                      },
                      addCommentLabel: l10n.articleAddComment,
                      onAddComment: () => _openFeedbackSheet(context, article.id),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openFeedbackSheet(BuildContext context, String articleId) async {
    final sent = await showArticleFeedbackSheet(context, articleId: articleId);
    if (sent != true || !context.mounted) return;
    await showArticleFeedbackThanks(context);
  }
}

/// Pastel header card with the mascot and the axis label.
class _ArticleHero extends StatelessWidget {
  const _ArticleHero({required this.article, required this.l10n});

  final EducationArticle article;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 232,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              AppAssets.mascotArticle,
              fit: BoxFit.contain,
              alignment: Alignment.bottomCenter,
            ),
          ),
          Positioned(
            left: 12,
            top: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.92),
                borderRadius: BorderRadius.circular(99),
              ),
              child: Text(
                article.axis.localizedLabel(l10n),
                style: AppText.label.copyWith(
                  color: AppColors.primary500,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ArticleMeta extends StatelessWidget {
  const _ArticleMeta({required this.article, required this.l10n});

  final EducationArticle article;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    return Row(
      children: [
        Flexible(
          child: Text(
            DateFormat.yMMMMd(locale).format(article.lastUpdated),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.caption.copyWith(color: AppColors.grey500),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 4,
          height: 4,
          decoration: const BoxDecoration(
            color: AppColors.grey400,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          l10n.educationReadingTime(article.readingTimeMinutes),
          style: AppText.caption.copyWith(color: AppColors.grey500),
        ),
      ],
    );
  }
}

/// One icon-titled block; plain lines become paragraphs, prefixed lines become
/// bullets, matching the article mockup.
class _ArticleSection extends StatelessWidget {
  const _ArticleSection({
    required this.icon,
    required this.title,
    required this.content,
    this.isWarning = false,
  });

  final IconData icon;
  final String title;
  final String content;
  final bool isWarning;

  Color get accent => isWarning ? AppColors.error : AppColors.primary400;

  @override
  Widget build(BuildContext context) {
    final lines = content
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(icon, size: 17, color: accent),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: AppText.h6.copyWith(
                    color: AppColors.grey900,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          for (final line in lines)
            Padding(
              padding: const EdgeInsets.only(bottom: 4, left: 2),
              child: _SectionLine(text: line),
            ),
        ],
      ),
    );
  }
}

class _SectionLine extends StatelessWidget {
  const _SectionLine({required this.text});

  final String text;

  static const _bulletPrefixes = ['•', '-', '*'];

  @override
  Widget build(BuildContext context) {
    final hasBullet = _bulletPrefixes.any(text.startsWith);
    final value = hasBullet ? text.substring(1).trim() : text;
    final style = AppText.body.copyWith(
      color: AppColors.grey800,
      height: 1.55,
    );

    if (!hasBullet) {
      return Text(value, style: style);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 8),
          width: 5,
          height: 5,
          decoration: const BoxDecoration(
            color: AppColors.primary300,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(child: Text(value, style: style)),
      ],
    );
  }
}

class _ArticleFeedbackRow extends StatelessWidget {
  const _ArticleFeedbackRow({
    required this.vote,
    required this.onVote,
    required this.addCommentLabel,
    required this.onAddComment,
  });

  final String? vote;
  final ValueChanged<String> onVote;
  final String addCommentLabel;
  final VoidCallback onAddComment;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _VoteButton(
              icon: Icons.thumb_down_alt_outlined,
              tooltip: l10n.articleNotHelpful,
              selected: vote == 'down',
              onTap: () => onVote('down'),
            ),
            const SizedBox(width: 28),
            _VoteButton(
              icon: Icons.thumb_up_alt_outlined,
              tooltip: l10n.articleHelpful,
              selected: vote == 'up',
              onTap: () => onVote('up'),
            ),
          ],
        ),
        const SizedBox(height: 18),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: onAddComment,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.grey900,
              foregroundColor: AppColors.white,
              elevation: 0,
              shape: const StadiumBorder(),
            ),
            child: Text(addCommentLabel, style: AppText.btnPrimary),
          ),
        ),
      ],
    );
  }
}

class _VoteButton extends StatelessWidget {
  const _VoteButton({
    required this.icon,
    required this.tooltip,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: selected ? AppColors.warning50 : AppColors.grey100,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: SizedBox(
            width: 64,
            height: 64,
            child: Icon(
              icon,
              size: 26,
              color: selected ? AppColors.grey900 : AppColors.grey600,
            ),
          ),
        ),
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({
    required this.icon,
    required this.onTap,
    this.iconColor = AppColors.grey900,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.grey200),
          ),
          child: Icon(icon, color: iconColor),
        ),
      ),
    );
  }
}
