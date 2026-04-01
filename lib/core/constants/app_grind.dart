class AppGrid {
  AppGrid._();

  // ─── Mobile Grid (from style guide) ──────────────────────────────────────
  static const int    columns      = 4;
  static const double margin       = 24.0;  // horizontal screen margin
  static const double gutter       = 12.0;  // space between columns
  static const String columnWidth  = 'Auto (74px based on 390px screen)';

  // ─── Breakpoints ──────────────────────────────────────────────────────────
  static const double mobileMax  = 767.0;
  static const double tabletMin  = 768.0;
  static const double tabletMax  = 1023.0;
  static const double desktopMin = 1024.0;



  static double columnWidthFromScreen(double screenWidth) {
  final availableWidth = screenWidth - (margin * 2) - (gutter * (columns - 1));
  return availableWidth / columns;
}
}
