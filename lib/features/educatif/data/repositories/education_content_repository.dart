import 'package:flutter/foundation.dart';
import 'package:perla_app/features/educatif/data/models/education_article.dart';
import 'package:perla_app/features/educatif/data/repositories/education_repository.dart';

class EducationContentRepository {
  const EducationContentRepository();

  List<EducationArticle> getAllArticles() {
    final articles = EducationArticleDatabase.articles;
    debugPrint(
      '[EducationContentRepository] getAllArticles count=${articles.length}',
    );
    return articles;
  }

  List<EducationCategory> getAllCategories() {
    final categories = EducationArticleDatabase.getAllCategories();
    debugPrint(
      '[EducationContentRepository] getAllCategories count=${categories.length}',
    );
    return categories;
  }

  List<EducationArticle> getArticlesByAxis(EducationAxis axis) {
    final articles = EducationArticleDatabase.getArticlesByAxis(axis);
    debugPrint(
      '[EducationContentRepository] getArticlesByAxis axis=${axis.name} count=${articles.length}',
    );
    return articles;
  }

  EducationArticle? getArticleById(String id) {
    final article = EducationArticleDatabase.getArticleById(id);
    debugPrint(
      '[EducationContentRepository] getArticleById id=$id found=${article != null}',
    );
    return article;
  }

  List<EducationArticle> searchByTag(String tag) {
    final normalizedTag = tag.toLowerCase();
    final articles = EducationArticleDatabase.searchByTag(normalizedTag);
    debugPrint(
      '[EducationContentRepository] searchByTag tag=$normalizedTag count=${articles.length}',
    );
    return articles;
  }
}
