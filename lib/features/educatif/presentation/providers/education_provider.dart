import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:perla_app/features/calendar/presentation/providers/symptom_provider.dart';
import 'package:perla_app/features/cycle/presentation/providers/cycle_provider.dart';
import 'package:perla_app/features/educatif/data/models/education_article.dart';
import 'package:perla_app/features/educatif/data/repositories/education_content_repository.dart';
import 'package:perla_app/features/educatif/domain/education_context_service.dart';
import 'package:perla_app/features/journal/presentation/providers/journal_provider.dart';

final educationContentRepositoryProvider =
    Provider<EducationContentRepository>((ref) {
  return const EducationContentRepository();
});

final allEducationArticlesProvider = Provider<List<EducationArticle>>((ref) {
  return ref.watch(educationContentRepositoryProvider).getAllArticles();
});

final educationCategoriesProvider = Provider<List<EducationCategory>>((ref) {
  return ref.watch(educationContentRepositoryProvider).getAllCategories();
});

final educationArticlesByAxisProvider =
    Provider.family<List<EducationArticle>, EducationAxis>((ref, axis) {
  return ref.watch(educationContentRepositoryProvider).getArticlesByAxis(axis);
});

final educationArticleProvider =
    Provider.family<EducationArticle?, String>((ref, id) {
  return ref.watch(educationContentRepositoryProvider).getArticleById(id);
});

final educationArticlesByTagProvider =
    Provider.family<List<EducationArticle>, String>((ref, tag) {
  return ref.watch(educationContentRepositoryProvider).searchByTag(tag);
});

class EducationSearchNotifier extends StateNotifier<String> {
  EducationSearchNotifier() : super('');

  void updateQuery(String query) {
    state = query.toLowerCase();
  }

  void clear() {
    state = '';
  }
}

final educationSearchProvider =
    StateNotifierProvider<EducationSearchNotifier, String>((ref) {
  return EducationSearchNotifier();
});

final filteredEducationArticlesProvider = Provider<List<EducationArticle>>((ref) {
  final query = ref.watch(educationSearchProvider);
  final articles = ref.watch(allEducationArticlesProvider);

  if (query.isEmpty) {
    return articles;
  }

  return articles.where((article) {
    final titleMatch = article.title.toLowerCase().contains(query);
    final descMatch = article.shortDescription.toLowerCase().contains(query);
    final tagMatch = article.tags.any((tag) => tag.contains(query));

    return titleMatch || descMatch || tagMatch;
  }).toList();
});

class SelectedAxisNotifier extends StateNotifier<EducationAxis> {
  SelectedAxisNotifier() : super(EducationAxis.cycleBasics);

  void selectAxis(EducationAxis axis) {
    state = axis;
  }
}

final selectedEducationAxisProvider =
    StateNotifierProvider<SelectedAxisNotifier, EducationAxis>((ref) {
  return SelectedAxisNotifier();
});

final filteredArticlesByAxisProvider = Provider<List<EducationArticle>>((ref) {
  final selectedAxis = ref.watch(selectedEducationAxisProvider);
  final query = ref.watch(educationSearchProvider);
  final articlesByAxis = ref
      .watch(educationContentRepositoryProvider)
      .getArticlesByAxis(selectedAxis);

  if (query.isEmpty) {
    return articlesByAxis;
  }

  return articlesByAxis.where((article) {
    final titleMatch = article.title.toLowerCase().contains(query);
    final descMatch = article.shortDescription.toLowerCase().contains(query);
    final tagMatch = article.tags.any((tag) => tag.contains(query));

    return titleMatch || descMatch || tagMatch;
  }).toList();
});

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

final readArticlesProvider =
    StateNotifierProvider<ReadArticlesNotifier, Set<String>>((ref) {
  return ReadArticlesNotifier();
});

final totalReadingTimeProvider = Provider<int>((ref) {
  final articles = ref.watch(allEducationArticlesProvider);
  return articles.fold(0, (sum, article) => sum + article.readingTimeMinutes);
});

final readingTimeByAxisProvider =
    Provider.family<int, EducationAxis>((ref, axis) {
  final articles = ref.watch(educationArticlesByAxisProvider(axis));
  return articles.fold(0, (sum, article) => sum + article.readingTimeMinutes);
});

final contextualArticleSuggestionsProvider =
    Provider.family<List<EducationArticle>, String>((ref, contextTag) {
  return ref.watch(educationContentRepositoryProvider).searchByTag(contextTag);
});

final educationContextTagsProvider = Provider<List<String>>((ref) {
  final cycleStatus = ref.watch(cycleStatusProvider);
  final symptomLogs = ref.watch(symptomLogsProvider).value ?? const [];
  final journalEntries = ref.watch(journalProvider).value ?? const [];
  return EducationContextService.buildTags(
    cycleStatus: cycleStatus,
    symptomLogs: symptomLogs,
    journalEntries: journalEntries,
  );
});

final personalizedEducationSuggestionsProvider =
    Provider<List<EducationArticle>>((ref) {
  final tags = ref.watch(educationContextTagsProvider);
  final seen = <String>{};
  final suggestions = <EducationArticle>[];
  final repository = ref.watch(educationContentRepositoryProvider);

  for (final tag in tags) {
    final matches = repository.searchByTag(tag);
    for (final article in matches) {
      if (seen.add(article.id)) {
        suggestions.add(article);
      }
      if (suggestions.length >= 6) {
        return suggestions;
      }
    }
  }

  return suggestions;
});
