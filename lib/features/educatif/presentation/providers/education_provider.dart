import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:peria_app/core/services/app_locale_provider.dart';
import 'package:peria_app/features/calendar/presentation/providers/symptom_provider.dart';
import 'package:peria_app/features/cycle/presentation/providers/cycle_provider.dart';
import 'package:peria_app/features/educatif/data/models/education_article.dart';
import 'package:peria_app/features/educatif/data/localization/education_article_translations.dart';
import 'package:peria_app/features/educatif/data/repositories/education_content_repository.dart';
import 'package:peria_app/features/educatif/domain/education_context_service.dart';
import 'package:peria_app/features/journal/presentation/providers/journal_provider.dart';

final educationContentRepositoryProvider =
    Provider<EducationContentRepository>((ref) {
  return const EducationContentRepository();
});

final educationLanguageCodeProvider = Provider<String>((ref) {
  final selectedLocale = ref.watch(appLocaleProvider);
  final deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
  final languageCode = (selectedLocale ?? deviceLocale).languageCode;
  return languageCode == 'fr' ? 'fr' : 'en';
});

final allEducationArticlesProvider = Provider<List<EducationArticle>>((ref) {
  final languageCode = ref.watch(educationLanguageCodeProvider);
  return ref
      .watch(educationContentRepositoryProvider)
      .getAllArticles()
      .map((article) => article.localizedFor(languageCode))
      .toList(growable: false);
});

final educationCategoriesProvider = Provider<List<EducationCategory>>((ref) {
  final articles = ref.watch(allEducationArticlesProvider);
  return EducationAxis.values
      .map(
        (axis) => EducationCategory(
          axis: axis,
          articles: articles.where((article) => article.axis == axis).toList(),
        ),
      )
      .toList(growable: false);
});

final educationArticlesByAxisProvider =
    Provider.family<List<EducationArticle>, EducationAxis>((ref, axis) {
  return ref
      .watch(allEducationArticlesProvider)
      .where((article) => article.axis == axis)
      .toList(growable: false);
});

final educationArticleProvider =
    Provider.family<EducationArticle?, String>((ref, id) {
  for (final article in ref.watch(allEducationArticlesProvider)) {
    if (article.id == id) return article;
  }
  return null;
});

final educationArticlesByTagProvider =
    Provider.family<List<EducationArticle>, String>((ref, tag) {
  final languageCode = ref.watch(educationLanguageCodeProvider);
  return ref
      .watch(educationContentRepositoryProvider)
      .searchByTag(tag)
      .map((article) => article.localizedFor(languageCode))
      .toList(growable: false);
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
    final tagMatch = article.tags.any((tag) => tag.toLowerCase().contains(query));

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
  final articlesByAxis =
      ref.watch(educationArticlesByAxisProvider(selectedAxis));

  if (query.isEmpty) {
    return articlesByAxis;
  }

  return articlesByAxis.where((article) {
    final titleMatch = article.title.toLowerCase().contains(query);
    final descMatch = article.shortDescription.toLowerCase().contains(query);
    final tagMatch = article.tags.any((tag) => tag.toLowerCase().contains(query));

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

class SavedArticlesNotifier extends StateNotifier<Set<String>> {
  SavedArticlesNotifier() : super(<String>{}) {
    _load();
  }

  static const _storageKey = 'education.saved_articles';

  Future<void> _load() async {
    final preferences = await SharedPreferences.getInstance();
    final saved = preferences.getStringList(_storageKey);
    if (saved == null) return;
    state = saved.toSet();
  }

  Future<void> toggle(String articleId) async {
    final next = {...state};
    if (!next.add(articleId)) {
      next.remove(articleId);
    }
    state = next;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setStringList(_storageKey, next.toList());
  }
}

final savedArticlesProvider =
    StateNotifierProvider<SavedArticlesNotifier, Set<String>>((ref) {
  return SavedArticlesNotifier();
});

/// "Helpful" / "not helpful" vote kept on the device for each article.
class ArticleFeedbackNotifier extends StateNotifier<Map<String, String>> {
  ArticleFeedbackNotifier() : super(const <String, String>{}) {
    _load();
  }

  static const _storageKey = 'education.article_feedback';

  Future<void> _load() async {
    final preferences = await SharedPreferences.getInstance();
    final saved = preferences.getStringList(_storageKey);
    if (saved == null) return;
    final votes = <String, String>{};
    for (final entry in saved) {
      final separator = entry.indexOf('|');
      if (separator <= 0) continue;
      votes[entry.substring(0, separator)] = entry.substring(separator + 1);
    }
    state = votes;
  }

  /// [vote] is 'up' or 'down'.
  Future<void> setVote(String articleId, String vote) async {
    final next = {...state, articleId: vote};
    state = next;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setStringList(
      _storageKey,
      [for (final entry in next.entries) '${entry.key}|${entry.value}'],
    );
  }
}

final articleFeedbackProvider =
    StateNotifierProvider<ArticleFeedbackNotifier, Map<String, String>>((ref) {
  return ArticleFeedbackNotifier();
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
  return ref.watch(educationArticlesByTagProvider(contextTag));
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
  final languageCode = ref.watch(educationLanguageCodeProvider);

  for (final tag in tags) {
    final matches = repository.searchByTag(tag);
    for (final sourceArticle in matches) {
      final article = sourceArticle.localizedFor(languageCode);
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
