import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:perla_app/features/educatif/data/models/education_article.dart';
import 'package:perla_app/features/educatif/data/repositories/education_repository.dart';

/// Provider pour tous les articles
final allEducationArticlesProvider = Provider<List<EducationArticle>>((ref) {
  return EducationArticleDatabase.articles;
});

/// Provider pour les catégories groupées par axe
final educationCategoriesProvider = Provider<List<EducationCategory>>((ref) {
  return EducationArticleDatabase.getAllCategories();
});

/// Provider pour les articles d'un axe spécifique
final educationArticlesByAxisProvider =
    Provider.family<List<EducationArticle>, EducationAxis>((ref, axis) {
  return EducationArticleDatabase.getArticlesByAxis(axis);
});

/// Provider pour un article spécifique par ID
final educationArticleProvider =
    Provider.family<EducationArticle?, String>((ref, id) {
  return EducationArticleDatabase.getArticleById(id);
});

/// Provider pour recherche par tags
final educationArticlesByTagProvider =
    Provider.family<List<EducationArticle>, String>((ref, tag) {
  return EducationArticleDatabase.searchByTag(tag);
});

/// State notifier pour gestion de la recherche
class EducationSearchNotifier extends StateNotifier<String> {
  EducationSearchNotifier() : super('');

  void updateQuery(String query) {
    state = query.toLowerCase();
  }

  void clear() {
    state = '';
  }
}

/// Provider pour l'état de recherche
final educationSearchProvider =
    StateNotifierProvider<EducationSearchNotifier, String>((ref) {
  return EducationSearchNotifier();
});

/// Provider pour articles filtrés par recherche (tous les axes)
final filteredEducationArticlesProvider =
    Provider<List<EducationArticle>>((ref) {
  final query = ref.watch(educationSearchProvider);
  final articles = ref.watch(allEducationArticlesProvider);

  if (query.isEmpty) {
    return articles;
  }

  return articles.where((article) {
    final titleMatch = article.title.toLowerCase().contains(query);
    final descMatch =
        article.shortDescription.toLowerCase().contains(query);
    final tagMatch = article.tags.any((tag) => tag.contains(query));

    return titleMatch || descMatch || tagMatch;
  }).toList();
});

/// State notifier pour sélection d'axe
class SelectedAxisNotifier extends StateNotifier<EducationAxis> {
  SelectedAxisNotifier() : super(EducationAxis.cycleBasics);

  void selectAxis(EducationAxis axis) {
    state = axis;
  }
}

/// Provider pour axe sélectionné
final selectedEducationAxisProvider =
    StateNotifierProvider<SelectedAxisNotifier, EducationAxis>((ref) {
  return SelectedAxisNotifier();
});

/// Provider pour articles filtrés par axe sélectionné ET recherche
final filteredArticlesByAxisProvider = Provider<List<EducationArticle>>((ref) {
  final selectedAxis = ref.watch(selectedEducationAxisProvider);
  final query = ref.watch(educationSearchProvider);

  final articlesByAxis =
      EducationArticleDatabase.getArticlesByAxis(selectedAxis);

  if (query.isEmpty) {
    return articlesByAxis;
  }

  return articlesByAxis.where((article) {
    final titleMatch = article.title.toLowerCase().contains(query);
    final descMatch =
        article.shortDescription.toLowerCase().contains(query);
    final tagMatch = article.tags.any((tag) => tag.contains(query));

    return titleMatch || descMatch || tagMatch;
  }).toList();
});

/// State notifier pour gérer les articles lus
class ReadArticlesNotifier extends StateNotifier<Set<String>> {
  ReadArticlesNotifier() : super(<String>{});

  void markAsRead(String articleId) {
    state = {...state, articleId};
  }

  void markAsUnread(String articleId) {
    state = state.where((id) => id != articleId).toSet();
  }

  void clear() {
    state = <String>{};
  }
}

/// Compteur d'articles lus (à développer avec persistence)
final readArticlesProvider = StateNotifierProvider<
    ReadArticlesNotifier,
    Set<String>>((ref) {
  return ReadArticlesNotifier();
});

/// Provider pour temps de lecture total
final totalReadingTimeProvider = Provider<int>((ref) {
  final articles = ref.watch(allEducationArticlesProvider);
  return articles.fold(0, (sum, article) => sum + article.readingTimeMinutes);
});

/// Provider pour temps de lecture par axe
final readingTimeByAxisProvider =
    Provider.family<int, EducationAxis>((ref, axis) {
  final articles = ref.watch(educationArticlesByAxisProvider(axis));
  return articles.fold(0, (sum, article) => sum + article.readingTimeMinutes);
});

/// Provider pour suggestions contextuelles (exemples de tags)
final contextualArticleSuggestionsProvider =
    Provider.family<List<EducationArticle>, String>((ref, contextTag) {
  return EducationArticleDatabase.searchByTag(contextTag);
});
