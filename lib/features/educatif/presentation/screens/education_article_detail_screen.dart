import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
    final article = ref.watch(educationArticleProvider(articleId));

    if (article == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          leading: GestureDetector(
            onTap: () => context.pop(),
            child: const Icon(Icons.arrow_back, color: AppColors.grey900),
          ),
        ),
        body: const Center(
          child: Text('Article non trouvé'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: const Icon(Icons.arrow_back, color: AppColors.grey900),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18),
            child: GestureDetector(
              onTap: () {
                // TODO: Bookmark article
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Article ajouté à vos favoris'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: Icon(
                Icons.bookmark_outline,
                color: AppColors.grey700,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ════════════════════════════════════════════════════════════════
            // HEADER
            // ════════════════════════════════════════════════════════════════

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: article.axis.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Axis badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: article.axis.color,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      article.axis.label,
                      style: AppText.caption.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Title
                  Text(
                    article.title,
                    style: AppText.h3.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Meta info
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
                            Icon(
                              Icons.schedule,
                              size: 12,
                              color: AppColors.grey600,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${article.readingTimeMinutes}min',
                              style: AppText.label.copyWith(
                                color: AppColors.grey600,
                                fontSize: 11,
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
                          color: _getDifficultyColor(article.difficultyLevel)
                              .withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _getDifficultyLabel(article.difficultyLevel),
                          style: AppText.label.copyWith(
                            color: _getDifficultyColor(article.difficultyLevel),
                            fontSize: 11,
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

            // ════════════════════════════════════════════════════════════════
            // CONTENT SECTIONS
            // ════════════════════════════════════════════════════════════════

            // Explanation
            _ContentSection(
              icon: Icons.lightbulb_outline,
              title: 'Explication',
              content: article.explanation,
            ),
            const SizedBox(height: 20),

            // Observations
            _ContentSection(
              icon: Icons.visibility_outlined,
              title: 'À observer',
              content: article.observations,
            ),
            const SizedBox(height: 20),

            // Advice
            _ContentSection(
              icon: Icons.recommend_outlined,
              title: 'Conseils',
              content: article.advice,
            ),
            const SizedBox(height: 20),

            // When to consult
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.error.withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.warning_outlined,
                        color: AppColors.error,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Quand consulter',
                        style: AppText.h6.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.error,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
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

            // ════════════════════════════════════════════════════════════════
            // TAGS & METADATA
            // ════════════════════════════════════════════════════════════════

            if (article.tags.isNotEmpty) ...[
              Text(
                'Tags',
                style: AppText.h6.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: article.tags
                    .map((tag) => Container(
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
                        ))
                    .toList(),
              ),
              const SizedBox(height: 20),
            ],

            // Last updated
            Text(
              'Mis à jour: ${_formatDate(article.lastUpdated)}',
              style: AppText.caption.copyWith(
                color: AppColors.grey500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getDifficultyColor(int level) {
    if (level == 1) return AppColors.success;
    if (level == 2) return AppColors.warning;
    return AppColors.error;
  }

  String _getDifficultyLabel(int level) {
    if (level == 1) return 'Facile';
    if (level == 2) return 'Moyen';
    return 'Avancé';
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Aujourd\'hui';
    } else if (difference.inDays == 1) {
      return 'Hier';
    } else if (difference.inDays < 7) {
      return 'Il y a ${difference.inDays} jours';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return 'Il y a $weeks semaine${weeks > 1 ? 's' : ''}';
    } else {
      final months = (difference.inDays / 30).floor();
      return 'Il y a $months mois';
    }
  }
}

// ════════════════════════════════════════════════════════════════
// CONTENT SECTION COMPONENT
// ════════════════════════════════════════════════════════════════

class _ContentSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;

  const _ContentSection({
    required this.icon,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: AppColors.grey700,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: AppText.h6.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          content,
          style: AppText.body.copyWith(
            color: AppColors.grey800,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}
