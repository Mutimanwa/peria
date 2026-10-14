import 'package:flutter_test/flutter_test.dart';
import 'package:peria_app/features/educatif/data/repositories/education_content_repository.dart';

void main() {
  const repository = EducationContentRepository();

  String allArticleText() {
    return repository.getAllArticles().map((article) {
      return [
        article.title,
        article.shortDescription,
        article.explanation,
        article.observations,
        article.advice,
        article.whenToConsult,
      ].join(' ');
    }).join(' ').toLowerCase();
  }

  group('Education health-content safety', () {
    test('does not prescribe medication or supplement doses', () {
      final text = allArticleText();

      expect(RegExp(r'\b\d+\s*mg\b').hasMatch(text), isFalse);
      expect(RegExp(r'\b\d+\s*mcg\b').hasMatch(text), isFalse);
    });

    test('does not present cycle tracking as contraception', () {
      final text = allArticleText();

      expect(text, isNot(contains('85%')));
      expect(text, contains('ne te fie pas à l’application ou au calendrier'));
      expect(text, contains('pas une méthode'));
    });

    test('does not use home blood-volume cutoffs as a diagnosis', () {
      final text = allArticleText();

      expect(RegExp(r'\b\d+\s*ml\b').hasMatch(text), isFalse);
      expect(text, contains('il est difficile de mesurer le volume à la maison'));
    });

    test('every article explains when to seek professional advice', () {
      final articles = repository.getAllArticles();

      expect(articles, isNotEmpty);
      expect(
        articles.every((article) => article.whenToConsult.trim().isNotEmpty),
        isTrue,
      );
    });
  });
}
