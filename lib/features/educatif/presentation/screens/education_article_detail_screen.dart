import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:perla_app/core/errors/app_error_handler.dart';
import 'package:perla_app/l10n/app_localizations.dart';
import 'package:perla_app/core/theme/theme.dart';
import 'package:perla_app/features/educatif/data/models/education_article.dart';
import 'package:perla_app/features/educatif/presentation/providers/education_provider.dart';

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

    if (article == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          leading: GestureDetector(
            onTap: () => context.pop(),
            child: const Icon(Icons.chevron_left_rounded, color: AppColors.grey900),
          ),
        ),
        body: Center(
          child: Text(l10n.educationArticleNotFound),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(gradient: AppColors.bgGradient),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.white.withOpacity(0.75),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.grey200),
                          ),
                          child: const Icon(
                            Icons.chevron_left_rounded,
                            color: AppColors.grey900,
                            size: 18,
                          ),
                        ),
                      ),
                      Text(
                        article.axis.localizedLabel(l10n),
                        style: AppText.h4.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.grey700,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          AppErrorHandler.showSuccess(
                            context,
                            l10n.educationArticleSaved,
                          );
                        },
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.white.withOpacity(0.75),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.grey200),
                          ),
                          child: const Icon(
                            Icons.bookmark_outline,
                            color: AppColors.grey700,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          article.axis.color.withOpacity(0.12),
                          article.axis.color.withOpacity(0.04),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: article.axis.color.withOpacity(0.2),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: article.axis.color.withOpacity(0.08),
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
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: article.axis.color,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            article.axis.localizedLabel(l10n),
                            style: AppText.caption.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          article.title,
                          style: AppText.h4.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.grey900,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.grey100,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.schedule,
                                    size: 12,
                                    color: AppColors.grey600,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${article.readingTimeMinutes}min',
                                    style: AppText.label.copyWith(
                                      color: AppColors.grey600,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _getDifficultyColor(
                                  article.difficultyLevel,
                                ).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                _getDifficultyLabel(l10n, article.difficultyLevel),
                                style: AppText.label.copyWith(
                                  color: _getDifficultyColor(
                                    article.difficultyLevel,
                                  ),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _ArticleContentCard(
                    icon: Icons.lightbulb_outline,
                    title: l10n.educationExplanation,
                    content: article.explanation,
                    accentColor: article.axis.color,
                  ),
                  const SizedBox(height: 14),
                  _ArticleContentCard(
                    icon: Icons.visibility_outlined,
                    title: l10n.educationObserve,
                    content: article.observations,
                    accentColor: article.axis.color,
                  ),
                  const SizedBox(height: 14),
                  _ArticleContentCard(
                    icon: Icons.recommend_outlined,
                    title: l10n.educationAdvice,
                    content: article.advice,
                    accentColor: article.axis.color,
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(14),
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
                                Icons.warning_outlined,
                                color: AppColors.white,
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              l10n.educationWhenToConsult,
                              style: AppText.h6.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.error,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          article.whenToConsult,
                          style: AppText.body.copyWith(
                            color: AppColors.grey800,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (article.tags.isNotEmpty) ...[
                    Text(
                      l10n.educationRelatedTags,
                      style: AppText.h6.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: article.tags
                          .map(
                            (tag) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.grey100,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                tag,
                                style: AppText.caption.copyWith(
                                  color: AppColors.grey700,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                  ],
                  Center(
                    child: Text(
                      l10n.educationUpdated(_formatDate(l10n, article.lastUpdated)),
                      style: AppText.caption.copyWith(
                        color: AppColors.grey500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(int level) {
    if (level == 1) return AppColors.success;
    if (level == 2) return AppColors.warning;
    return AppColors.error;
  }

  String _getDifficultyLabel(AppLocalizations l10n, int level) {
    if (level == 1) return l10n.difficultyEasy;
    if (level == 2) return l10n.difficultyMedium;
    return l10n.difficultyAdvanced;
  }

  String _formatDate(AppLocalizations l10n, DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return l10n.todayLabel;
    } else if (difference.inDays == 1) {
      return l10n.yesterdayLabel;
    } else if (difference.inDays < 7) {
      return l10n.daysAgo(difference.inDays);
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return l10n.weeksAgo(weeks);
    } else {
      final months = (difference.inDays / 30).floor();
      return l10n.monthsAgo(months);
    }
  }
}

class _ArticleContentCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;
  final Color accentColor;

  const _ArticleContentCard({
    required this.icon,
    required this.title,
    required this.content,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
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
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: accentColor,
                  size: 16,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: AppText.h6.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.grey900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
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
