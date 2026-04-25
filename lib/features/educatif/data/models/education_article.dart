import 'package:flutter/material.dart';
import 'package:perla_app/l10n/app_localizations.dart';

/// Les 5 axes principaux du module éducatif
enum EducationAxis {
  cycleBasics, // Comprendre le cycle
  ovulationFertility, // Ovulation et fertilité
  menstruationSymptoms, // Règles et symptômes
  normalVsAbnormal, // Normal vs pas normal
  solutionsWellbeing, // Solutions et bien-être
}

extension EducationAxisX on EducationAxis {
  String get label {
    return switch (this) {
      EducationAxis.cycleBasics => 'Comprendre le cycle',
      EducationAxis.ovulationFertility => 'Ovulation et fertilité',
      EducationAxis.menstruationSymptoms => 'Règles et symptômes',
      EducationAxis.normalVsAbnormal => 'Normal vs pas normal',
      EducationAxis.solutionsWellbeing => 'Solutions et bien-être',
    };
  }

  String get description {
    return switch (this) {
      EducationAxis.cycleBasics =>
        'Phases, durée et irrégularités du cycle menstruel',
      EducationAxis.ovulationFertility =>
        'Signes d\'ovulation et fenêtre fertile',
      EducationAxis.menstruationSymptoms =>
        'Douleurs, fatigue, flux et variations normales',
      EducationAxis.normalVsAbnormal =>
        'Repères clairs pour rassurer ou alerter',
      EducationAxis.solutionsWellbeing =>
        'Soulagement et habitudes utiles',
    };
  }

  IconData get icon {
    return switch (this) {
      EducationAxis.cycleBasics => Icons.calendar_today,
      EducationAxis.ovulationFertility => Icons.favorite,
      EducationAxis.menstruationSymptoms => Icons.health_and_safety,
      EducationAxis.normalVsAbnormal => Icons.help_outline,
      EducationAxis.solutionsWellbeing => Icons.spa,
    };
  }

  Color get color {
    return switch (this) {
      EducationAxis.cycleBasics => const Color(0xFF6366F1), // Indigo
      EducationAxis.ovulationFertility => const Color(0xFFEC4899), // Pink
      EducationAxis.menstruationSymptoms => const Color(0xFFF97316), // Orange
      EducationAxis.normalVsAbnormal => const Color(0xFFF59E0B), // Amber
      EducationAxis.solutionsWellbeing => const Color(0xFF10B981), // Green
    };
  }

  String localizedLabel(AppLocalizations l10n) {
    return switch (this) {
      EducationAxis.cycleBasics => l10n.educationAxisCycleBasics,
      EducationAxis.ovulationFertility => l10n.educationAxisOvulationFertility,
      EducationAxis.menstruationSymptoms => l10n.educationAxisMenstruationSymptoms,
      EducationAxis.normalVsAbnormal => l10n.educationAxisNormalVsAbnormal,
      EducationAxis.solutionsWellbeing => l10n.educationAxisSolutionsWellbeing,
    };
  }
}

/// Modèle pour un article éducatif complet
class EducationArticle {
  final String id;
  final String title;
  final String shortDescription;
  final EducationAxis axis;

  /// Structure d'un article : explication → observation → conseils → quand consulter
  final String explanation;
  final String observations;
  final String advice;
  final String whenToConsult;

  /// Pour un futur support de schémas/images
  final List<String> imageUrls;

  /// Tags pour la recherche et le contexte (ex: "douleur", "ovulation")
  final List<String> tags;

  /// Niveau de priorité : 1 = basique, 2 = intermédiaire, 3 = approfondi
  final int difficultyLevel;

  /// Durée estimée de lecture en minutes
  final int readingTimeMinutes;

  /// Timestamp de création/mise à jour
  final DateTime lastUpdated;

  EducationArticle({
    required this.id,
    required this.title,
    required this.shortDescription,
    required this.axis,
    required this.explanation,
    required this.observations,
    required this.advice,
    required this.whenToConsult,
    this.imageUrls = const [],
    this.tags = const [],
    this.difficultyLevel = 1,
    this.readingTimeMinutes = 5,
    DateTime? lastUpdated,
  }) : lastUpdated = lastUpdated ?? DateTime.now();

  /// Crée une copie avec des valeurs potentiellement modifiées
  EducationArticle copyWith({
    String? id,
    String? title,
    String? shortDescription,
    EducationAxis? axis,
    String? explanation,
    String? observations,
    String? advice,
    String? whenToConsult,
    List<String>? imageUrls,
    List<String>? tags,
    int? difficultyLevel,
    int? readingTimeMinutes,
    DateTime? lastUpdated,
  }) {
    return EducationArticle(
      id: id ?? this.id,
      title: title ?? this.title,
      shortDescription: shortDescription ?? this.shortDescription,
      axis: axis ?? this.axis,
      explanation: explanation ?? this.explanation,
      observations: observations ?? this.observations,
      advice: advice ?? this.advice,
      whenToConsult: whenToConsult ?? this.whenToConsult,
      imageUrls: imageUrls ?? this.imageUrls,
      tags: tags ?? this.tags,
      difficultyLevel: difficultyLevel ?? this.difficultyLevel,
      readingTimeMinutes: readingTimeMinutes ?? this.readingTimeMinutes,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

/// Conteneur pour les articles groupés par axe
class EducationCategory {
  final EducationAxis axis;
  final List<EducationArticle> articles;

  EducationCategory({
    required this.axis,
    required this.articles,
  });

  /// Nombre total d'articles dans cette catégorie
  int get articleCount => articles.length;

  /// Durée totale de lecture estimée
  int get totalReadingTime =>
      articles.fold(0, (sum, article) => sum + article.readingTimeMinutes);
}
