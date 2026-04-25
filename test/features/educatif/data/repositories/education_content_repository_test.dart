import 'package:flutter_test/flutter_test.dart';
import 'package:perla_app/features/educatif/data/models/education_article.dart';
import 'package:perla_app/features/educatif/data/repositories/education_content_repository.dart';

void main() {
  group('EducationContentRepository', () {
    const repository = EducationContentRepository();

    test('returns all seeded articles', () {
      final articles = repository.getAllArticles();

      expect(articles, isNotEmpty);
      expect(articles.length, greaterThanOrEqualTo(10));
    });

    test('returns categories mapped by axis', () {
      final categories = repository.getAllCategories();

      expect(categories.length, EducationAxis.values.length);
      expect(categories.every((category) => category.articles.isNotEmpty), isTrue);
    });

    test('returns article by id when it exists', () {
      final article = repository.getArticleById('cycle-001');

      expect(article, isNotNull);
      expect(article!.axis, EducationAxis.cycleBasics);
    });

    test('searchByTag is case-insensitive', () {
      final lower = repository.searchByTag('stress');
      final upper = repository.searchByTag('STRESS');

      expect(lower, isNotEmpty);
      expect(upper.map((article) => article.id), lower.map((article) => article.id));
    });
  });
}
