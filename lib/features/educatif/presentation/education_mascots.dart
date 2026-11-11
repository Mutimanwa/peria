import 'package:peria_app/core/constants/app_assets.dart';
import 'package:peria_app/features/educatif/data/models/education_article.dart';

/// Topic-aware mascot used by the education cards and article heroes.
///
/// Ovulation, periods and relief/medication each have their own illustration so
/// the module feels contextual instead of repeating one generic character.
String mascotForAxis(EducationAxis axis) {
  return switch (axis) {
    EducationAxis.ovulationFertility => AppAssets.mascotOvulation,
    EducationAxis.menstruationSymptoms => AppAssets.mascotPeriod,
    EducationAxis.solutionsWellbeing => AppAssets.mascotMedication,
    EducationAxis.normalVsAbnormal => AppAssets.mascotSearch,
    EducationAxis.cycleBasics => AppAssets.mascotArticle,
  };
}
