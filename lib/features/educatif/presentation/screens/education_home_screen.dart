import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:peria_app/core/constants/app_assets.dart';
import 'package:peria_app/l10n/app_localizations.dart';
import 'package:peria_app/core/theme/theme.dart';
import 'package:peria_app/features/educatif/data/models/education_article.dart';
import 'package:peria_app/features/educatif/presentation/education_mascots.dart';
import 'package:peria_app/features/educatif/presentation/providers/education_provider.dart';
import 'package:peria_app/features/profile/presentation/providers/user_profile_provider.dart';
import 'package:peria_app/shared/widgets/profile_avatar.dart';
import 'package:peria_app/shared/widgets/common_widgets.dart';

class EducationHomeScreen extends ConsumerStatefulWidget {
  const EducationHomeScreen({super.key});

  @override
  ConsumerState<EducationHomeScreen> createState() => _EducationHomeScreenState();
}

class _EducationHomeScreenState extends ConsumerState<EducationHomeScreen> {
  EducationAxis? _selectedAxis; // null = all axes ("Tout")
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
    final allArticles = ref.watch(allEducationArticlesProvider);
    final categories = ref.watch(educationCategoriesProvider);
    final personalizedSuggestions =
        ref.watch(personalizedEducationSuggestionsProvider);
    final contextTags = ref.watch(educationContextTagsProvider);
    final savedIds = ref.watch(savedArticlesProvider);
    final savedArticles = allArticles
        .where((article) => savedIds.contains(article.id))
        .toList(growable: false);

    final filteredByAxis = _selectedAxis == null
        ? allArticles
        : allArticles
            .where((article) => article.axis == _selectedAxis)
            .toList(growable: false);
    final articles = searchQuery.isEmpty
        ? filteredByAxis
        : ref.watch(filteredEducationArticlesProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(gradient: AppColors.bgGradient),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 8, bottom: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(l10n),
                  const SizedBox(height: 22),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                    ),
                    child: Text(
                      l10n.educationWhatToLearn,
                      textAlign: TextAlign.center,
                      style: AppText.h2.copyWith(
                        color: AppColors.grey900,
                        fontWeight: FontWeight.w800,
                        height: 1.25,
                      ),
                    ),
                  ),
                  if (_isSearching) ...[
                    const SizedBox(height: 18),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.page,
                      ),
                      child: Container(
                        height: 48,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(99),
                          border: Border.all(color: AppColors.grey200),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.search_rounded,
                              size: 19,
                              color: AppColors.grey500,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                autofocus: true,
                                style: AppText.body,
                                decoration: InputDecoration(
                                  hintText: l10n.educationSearchHint,
                                  hintStyle: AppText.body.copyWith(
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
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 18),
                  _buildAxisChips(categories, l10n),
                  const SizedBox(height: 24),
                  if (searchQuery.isEmpty && savedArticles.isNotEmpty) ...[
                    _SectionTitle(label: l10n.savedArticles),
                    const SizedBox(height: 12),
                    _buildCarousel(savedArticles),
                    const SizedBox(height: 22),
                  ],
                  if (searchQuery.isEmpty && personalizedSuggestions.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.page,
                      ),
                      child: _ContextSuggestionsCard(
                        tags: contextTags,
                        articles: personalizedSuggestions,
                        onOpenArticle: (articleId) {
                          context.push('/education/article/$articleId');
                        },
                      ),
                    ),
                    const SizedBox(height: 22),
                  ],
                  _SectionTitle(
                    label: searchQuery.isEmpty
                        ? l10n.educationRecentArticles
                        : l10n.educationSearchResults,
                  ),
                  const SizedBox(height: 12),
                  if (articles.isEmpty)
                    _buildEmptyState(l10n)
                  else
                    _buildCarousel(articles),
                  const SizedBox(height: 26),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.page,
                    ),
                    child: _EducationHeroCard(
                      title: l10n.educationHeroTitle,
                      subtitle: l10n.educationHeroSubtitle,
                      footer: l10n.educationHeroFooter,
                      accent: AppColors.primary400,
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

  Widget _buildHeader(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
      child: Row(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => context.push('/profile'),
              customBorder: const CircleBorder(),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: ProfileAvatar(
                  avatarBase64:
                      ref.watch(userProfileProvider).value?.avatarBase64,
                  radius: 20,
                ),
              ),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(AppAssets.logo, height: 20),
                const SizedBox(width: 6),
                Text(
                  'Peria',
                  style: AppText.h5.copyWith(
                    color: AppColors.primary500,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          HeaderIconButton(
            icon: _isSearching ? Icons.close_rounded : Icons.search_rounded,
            onTap: () {
              if (_isSearching && _searchController.text.isNotEmpty) {
                _clearSearch();
                return;
              }
              setState(() => _isSearching = !_isSearching);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCarousel(List<EducationArticle> articles) {
    return SizedBox(
      height: 236,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
        itemCount: articles.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final article = articles[index];
          return _ArticleCard(
            article: article,
            onTap: () => context.push('/education/article/${article.id}'),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      child: Center(
        child: Column(
          children: [
            Image.asset(
              AppAssets.mascotSearch,
              height: 164,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 4),
            Text(
              _isSearching ? l10n.educationNoArticleFound : l10n.educationNoArticles,
              textAlign: TextAlign.center,
              style: AppText.h5.copyWith(color: AppColors.grey600),
            ),
            const SizedBox(height: 6),
            Text(
              _isSearching
                  ? l10n.educationTryAnotherSearch
                  : l10n.educationChooseCategory,
              textAlign: TextAlign.center,
              style: AppText.caption.copyWith(color: AppColors.grey500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAxisChips(
    List<EducationCategory> categories,
    AppLocalizations l10n,
  ) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
        itemCount: categories.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final isAll = index == 0;
          final axis = isAll ? null : categories[index - 1].axis;
          final selected = _selectedAxis == axis;
          return GestureDetector(
            onTap: () => setState(() => _selectedAxis = axis),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                color: selected ? AppColors.grey900 : AppColors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: selected ? AppColors.grey900 : AppColors.grey200,
                ),
              ),
              child: Text(
                isAll ? l10n.educationAxisAll : axis!.localizedLabel(l10n),
                style: AppText.label.copyWith(
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

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
      child: Text(
        label,
        style: AppText.h4.copyWith(
          color: AppColors.grey900,
          fontWeight: FontWeight.w700,
        ),
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
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
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          mascotForAxis(article.axis),
                          width: 44,
                          height: 44,
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
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
                  ],
                ),
              ),
              const SizedBox(width: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: 84,
                  height: 84,
                  color: AppColors.white,
                  child: Image.asset(
                    AppAssets.mascotArticle,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                ),
              ),
            ],
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

/// Article tile used across the education home carousels: topic mascot on a
/// soft pink tile, title and reading time underneath (see `moc/Self-Care.jpg`).
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
        width: 176,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.grey200),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.04),
              offset: const Offset(0, 4),
              blurRadius: 12,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              child: SizedBox(
                height: 132,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      mascotForAxis(article.axis),
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.primary100.withOpacity(0.30),
                            AppColors.primary50.withOpacity(0.05),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.label.copyWith(
                      color: AppColors.grey900,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.schedule_rounded,
                        size: 13,
                        color: AppColors.grey500,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          l10n.educationReadingTime(
                            article.readingTimeMinutes,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.caption.copyWith(
                            color: AppColors.grey500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
