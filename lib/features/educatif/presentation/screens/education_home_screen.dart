import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:perla_app/l10n/app_localizations.dart';
import 'package:perla_app/core/theme/theme.dart';
import 'package:perla_app/features/educatif/data/models/education_article.dart';
import 'package:perla_app/features/educatif/presentation/providers/education_provider.dart';

class EducationHomeScreen extends ConsumerStatefulWidget {
  const EducationHomeScreen({super.key});

  @override
  ConsumerState<EducationHomeScreen> createState() => _EducationHomeScreenState();
}

class _EducationHomeScreenState extends ConsumerState<EducationHomeScreen> {
  EducationAxis _selectedAxis = EducationAxis.cycleBasics;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  void _clearSearch() {
    _searchController.clear();
    ref.read(educationSearchProvider.notifier).clear();
    setState(() => _isSearching = false);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final searchQuery = ref.watch(educationSearchProvider);
    final filteredArticles = searchQuery.isEmpty
        ? ref.watch(educationArticlesByAxisProvider(_selectedAxis))
        : ref.watch(filteredEducationArticlesProvider);
    final categories = ref.watch(educationCategoriesProvider);
    final personalizedSuggestions =
        ref.watch(personalizedEducationSuggestionsProvider);
    final contextTags = ref.watch(educationContextTagsProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(gradient: AppColors.bgGradient),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => context.go('/profile'),
                                  child: const CircleAvatar(
                                    radius: 18,
                                    backgroundImage: AssetImage(
                                      'assets/images/onboarding/Avatar-21.png',
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l10n.educationGreeting,
                                      style: AppText.label.copyWith(
                                        color: AppColors.grey900,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      l10n.educationSpace,
                                      style: AppText.caption.copyWith(
                                        color: AppColors.grey600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () => context.go('/profile/notifications'),
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: AppColors.white.withOpacity(0.75),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: AppColors.grey200),
                                ),
                                child: const Icon(
                                  Icons.notifications_none_rounded,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Text(
                          l10n.educationWhatToLearn,
                          style: AppText.h2,
                        ),
                        const SizedBox(height: 16),
                        _buildAxisChips(categories, l10n),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              searchQuery.isEmpty
                                  ? l10n.educationRecentArticles
                                  : l10n.educationSearchResults,
                              style: AppText.h5.copyWith(
                                color: AppColors.grey900,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (_isSearching && _searchController.text.isNotEmpty) {
                                  _clearSearch();
                                  return;
                                }
                                setState(() => _isSearching = !_isSearching);
                              },
                              child: Text(
                                _isSearching ? l10n.cancelAction : l10n.searchAction,
                                style: AppText.caption.copyWith(
                                  color: AppColors.primary400,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (_isSearching) ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.grey100,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: TextField(
                              controller: _searchController,
                              autofocus: true,
                              style: AppText.body,
                              decoration: InputDecoration(
                                hintText: l10n.educationSearchHint,
                                hintStyle: AppText.caption.copyWith(
                                  color: AppColors.grey500,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                              onChanged: (value) {
                                ref
                                    .read(educationSearchProvider.notifier)
                                    .updateQuery(value);
                              },
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (searchQuery.isEmpty && personalizedSuggestions.isNotEmpty) ...[
                    const SizedBox(height: 18),
                    _ContextSuggestionsCard(
                      tags: contextTags,
                      articles: personalizedSuggestions,
                      onOpenArticle: (articleId) {
                        context.push('/education/article/$articleId');
                      },
                    ),
                  ],
                  const SizedBox(height: 24),
                  if (filteredArticles.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 48),
                      child: Center(
                        child: Column(
                          children: [
                            const Icon(
                              Icons.search_off,
                              size: 48,
                              color: AppColors.grey400,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _isSearching
                                  ? l10n.educationNoArticleFound
                                  : l10n.educationNoArticles,
                              style: AppText.h5.copyWith(
                                color: AppColors.grey600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _isSearching
                                  ? l10n.educationTryAnotherSearch
                                  : l10n.educationChooseCategory,
                              style: AppText.caption.copyWith(
                                color: AppColors.grey500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    SizedBox(
                      height: 200,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        itemCount: filteredArticles.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 14),
                        itemBuilder: (context, index) {
                          final article = filteredArticles[index];
                          return SizedBox(
                            width: 280,
                            child: _ArticleCard(
                              article: article,
                              onTap: () {
                                context.push('/education/article/${article.id}');
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 24),
                  _EducationHeroCard(
                    title: l10n.educationHeroTitle,
                    subtitle: l10n.educationHeroSubtitle,
                    footer: l10n.educationHeroFooter,
                    accent: AppColors.primary300,
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAxisChips(
    List<EducationCategory> categories,
    AppLocalizations l10n,
  ) {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final category = categories[index];
          final selected = _selectedAxis == category.axis;
          return GestureDetector(
            onTap: () => setState(() => _selectedAxis = category.axis),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: selected ? AppColors.grey900 : AppColors.grey100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                category.axis.localizedLabel(l10n),
                style: AppText.caption.copyWith(
                  color: selected ? AppColors.white : AppColors.grey700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ContextSuggestionsCard extends StatelessWidget {
  const _ContextSuggestionsCard({
    required this.tags,
    required this.articles,
    required this.onOpenArticle,
  });

  final List<String> tags;
  final List<EducationArticle> articles;
  final ValueChanged<String> onOpenArticle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.primary50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.auto_awesome_outlined,
                  color: AppColors.primary500,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.educationSuggestionsTitle,
                      style: AppText.h5.copyWith(color: AppColors.grey900),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.educationSuggestionsSubtitle,
                      style: AppText.caption.copyWith(color: AppColors.grey600),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (tags.isNotEmpty) ...[
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: tags.take(5).map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.grey100,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    tag,
                    style: AppText.caption.copyWith(
                      color: AppColors.grey700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
          const SizedBox(height: 14),
          ...articles.take(3).map(
            (article) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GestureDetector(
                onTap: () => onOpenArticle(article.id),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.grey50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.grey200),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: article.axis.color.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          article.axis.icon,
                          color: article.axis.color,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              article.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppText.label.copyWith(
                                color: AppColors.grey900,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              article.shortDescription,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppText.caption.copyWith(
                                color: AppColors.grey600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.grey500,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EducationHeroCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String footer;
  final Color accent;

  const _EducationHeroCard({
    required this.title,
    required this.subtitle,
    required this.footer,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: [accent.withOpacity(0.95), accent.withOpacity(0.45)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: accent.withOpacity(0.18),
            blurRadius: 18,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppText.h4.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: AppText.body.copyWith(
              color: AppColors.white.withOpacity(0.92),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.16),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.lightbulb_outline,
                  color: AppColors.white,
                  size: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    footer,
                    style: AppText.caption.copyWith(
                      color: AppColors.white,
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
}

class _ArticleCard extends StatelessWidget {
  final EducationArticle article;
  final VoidCallback onTap;

  const _ArticleCard({
    required this.article,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    article.title,
                    style: AppText.h6.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getDifficultyColor(article.difficultyLevel),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    _getDifficultyLabel(l10n, article.difficultyLevel),
                    style: AppText.caption.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              article.shortDescription,
              style: AppText.caption.copyWith(
                color: AppColors.grey600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: article.tags
                        .take(2)
                        .map(
                          (tag) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.grey100,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              tag,
                              style: AppText.label.copyWith(
                                color: AppColors.grey700,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.grey50,
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
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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

  String _getDifficultyLabel(AppLocalizations l10n, int level) {
    if (level == 1) return l10n.difficultyEasy;
    if (level == 2) return l10n.difficultyMedium;
    return l10n.difficultyAdvanced;
  }
}
