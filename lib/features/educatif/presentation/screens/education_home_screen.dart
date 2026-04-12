import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:perla_app/core/theme/theme.dart';
import 'package:perla_app/features/educatif/data/models/education_article.dart';
import 'package:perla_app/features/educatif/presentation/providers/education_provider.dart';

class EducationHomeScreen extends ConsumerStatefulWidget {
  const EducationHomeScreen({super.key});

  @override
  ConsumerState<EducationHomeScreen> createState() => _EducationHomeScreenState();
}

class _EducationHomeScreenState extends ConsumerState<EducationHomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 5,
      vsync: this,
      initialIndex: 0,
    );
    _tabController.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      final axes = [
        EducationAxis.cycleBasics,
        EducationAxis.ovulationFertility,
        EducationAxis.menstruationSymptoms,
        EducationAxis.normalVsAbnormal,
        EducationAxis.solutionsWellbeing,
      ];
      ref.read(selectedEducationAxisProvider.notifier).selectAxis(axes[_tabController.index]);
    }
  }

  void _clearSearch() {
    _searchController.clear();
    ref.read(educationSearchProvider.notifier).clear();
    setState(() => _isSearching = false);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredArticles = ref.watch(filteredArticlesByAxisProvider);
    final categories = ref.watch(educationCategoriesProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(gradient: AppColors.bgGradient),
          ),
          SafeArea(
            child: Column(
              children: [
                // Header with search
                Container(
                  padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
                  color: AppColors.white.withOpacity(0.95),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (!_isSearching)
                            const Text(
                              'Biblioteca\nEducatif',
                              style: AppText.h3,
                            )
                          else
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                autofocus: true,
                                style: AppText.body,
                                decoration: InputDecoration(
                                  hintText: 'Rechercher un article...',
                                  hintStyle: AppText.caption.copyWith(
                                    color: AppColors.grey500,
                                  ),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                onChanged: (value) {
                                  ref
                                      .read(
                                          educationSearchProvider.notifier)
                                      .updateQuery(value);
                                },
                              ),
                            ),
                          GestureDetector(
                            onTap: () {
                              if (_isSearching) {
                                _clearSearch();
                              } else {
                                setState(() => _isSearching = true);
                              }
                            },
                            child: Icon(
                              _isSearching ? Icons.close : Icons.search,
                              color: AppColors.grey700,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                      if (!_isSearching) ...[
                        const SizedBox(height: 12),
                        Text(
                          'Comprendre votre cycle et votre bien-être',
                          style: AppText.caption.copyWith(
                            color: AppColors.grey600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Tabs
                Container(
                  color: AppColors.white.withOpacity(0.95),
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    labelPadding: const EdgeInsets.symmetric(horizontal: 12),
                    indicatorColor: AppColors.grey900,
                    labelColor: AppColors.grey900,
                    unselectedLabelColor: AppColors.grey600,
                    labelStyle: AppText.caption.copyWith(fontWeight: FontWeight.w600),
                    unselectedLabelStyle: AppText.caption,
                    tabs: [
                      _buildTabLabel('Comprendre\nle cycle', categories[0].articleCount),
                      _buildTabLabel('Ovulation &\nfertilité', categories[1].articleCount),
                      _buildTabLabel('Règles &\nsymptômes', categories[2].articleCount),
                      _buildTabLabel('Normal vs\npas normal', categories[3].articleCount),
                      _buildTabLabel('Solutions &\nbien-être', categories[4].articleCount),
                    ],
                  ),
                ),

                // Articles list
                Expanded(
                  child: filteredArticles.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 48,
                                color: AppColors.grey400,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                _isSearching
                                    ? 'Aucun article trouvé'
                                    : 'Pas d\'articles',
                                style: AppText.h5.copyWith(
                                  color: AppColors.grey600,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _isSearching
                                    ? 'Essayez une autre recherche'
                                    : 'Choisissez une catégorie',
                                style: AppText.caption.copyWith(
                                  color: AppColors.grey500,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(18, 16, 18, 120),
                          itemCount: filteredArticles.length,
                          itemBuilder: (context, index) {
                            final article = filteredArticles[index];
                            return _ArticleCard(
                              article: article,
                              onTap: () {
                                context.push(
                                  '/education/article/${article.id}',
                                );
                              },
                            );
                          },
                        ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabLabel(String label, int count) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.grey100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '$count articles',
            style: AppText.caption.copyWith(
              fontSize: 10,
              color: AppColors.grey600,
            ),
          ),
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════════
// ARTICLE CARD COMPONENT
// ════════════════════════════════════════════════════════════════

class _ArticleCard extends StatelessWidget {
  final EducationArticle article;
  final VoidCallback onTap;

  const _ArticleCard({
    required this.article,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
            // Title + Difficulty
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
                    _getDifficultyLabel(article.difficultyLevel),
                    style: AppText.caption.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Short description
            Text(
              article.shortDescription,
              style: AppText.caption.copyWith(
                color: AppColors.grey600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),

            // Tags + Reading time
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Tags
                Expanded(
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: article.tags
                        .take(2)
                        .map((tag) => Container(
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
                            ))
                        .toList(),
                  ),
                ),
                // Reading time
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
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getDifficultyColor(int level) {
    if (level == 1) return AppColors.success; // Facile
    if (level == 2) return AppColors.warning; // Moyen
    return AppColors.error; // Difficile
  }

  String _getDifficultyLabel(int level) {
    if (level == 1) return 'Facile';
    if (level == 2) return 'Moyen';
    return 'Avancé';
  }
}
