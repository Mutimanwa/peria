import 'package:flutter_test/flutter_test.dart';
import 'package:peria_app/features/educatif/data/localization/education_article_translations.dart';
import 'package:peria_app/features/educatif/data/repositories/education_content_repository.dart';

void main() {
  const repository = EducationContentRepository();

  group('Education article localization', () {
    test('provides English copy for every French source article', () {
      final sourceArticles = repository.getAllArticles();
      final englishArticles = sourceArticles
          .map((article) => article.localizedFor('en'))
          .toList();

      expect(englishArticles, hasLength(sourceArticles.length));
      for (var index = 0; index < sourceArticles.length; index++) {
        final source = sourceArticles[index];
        final english = englishArticles[index];
        expect(english.id, source.id);
        expect(english.title, isNot(source.title));
        expect(english.explanation, isNot(source.explanation));
        expect(english.observations, isNotEmpty);
        expect(english.advice, isNotEmpty);
        expect(english.whenToConsult, isNotEmpty);
        expect(english.tags, isNotEmpty);
      }
    });

    test('preserves French copy and stable article IDs for French locale', () {
      for (final article in repository.getAllArticles()) {
        final french = article.localizedFor('fr');
        expect(french.id, article.id);
        expect(french.title, article.title);
        expect(french.explanation, article.explanation);
        expect(french.tags, article.tags);
      }
    });

    test('keeps health guidance cautious in the English copy', () {
      final englishArticles = repository
          .getAllArticles()
          .map((article) => article.localizedFor('en'));
      final combined = englishArticles
          .map((article) => [
                article.explanation,
                article.observations,
                article.advice,
                article.whenToConsult,
              ].join(' '))
          .join(' ')
          .toLowerCase();

      expect(combined, contains('not a way to prevent pregnancy'));
      expect(combined, contains('an app cannot diagnose'));
      expect(RegExp(r'\b\d+\s*mg\b').hasMatch(combined), isFalse);
      expect(RegExp(r'\b\d+\s*mcg\b').hasMatch(combined), isFalse);
    });
  });
}
