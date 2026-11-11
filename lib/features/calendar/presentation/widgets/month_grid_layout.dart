/// Layout math for a 7-column month grid so every date is given a real cell.
class MonthGridLayout {
  static int rowCount({required int startOffset, required int dayCount}) {
    if (dayCount <= 0) return 0;
    final offset = startOffset < 0 ? 0 : startOffset;
    return ((offset + dayCount) / 7).ceil();
  }

  static int cellCount({required int startOffset, required int dayCount}) {
    return rowCount(startOffset: startOffset, dayCount: dayCount) * 7;
  }

  /// Height required to paint [rows] without clipping, matching a
  /// [SliverGridDelegateWithFixedCrossAxisCount] of 7 columns.
  static double heightFor({
    required double width,
    required int rows,
    double crossAxisSpacing = 4,
    double mainAxisSpacing = 4,
    double childAspectRatio = 1,
    double? mainAxisExtent,
  }) {
    if (rows <= 0 || width <= 0) return 0;
    final cellWidth = (width - crossAxisSpacing * 6) / 7;
    if (cellWidth <= 0) return 0;
    // When the grid pins a fixed row height (mainAxisExtent) the aspect ratio
    // is irrelevant: the height must follow that extent, otherwise the last
    // row is clipped.
    final cellHeight = mainAxisExtent ?? (childAspectRatio <= 0 ? 0 : cellWidth / childAspectRatio);
    // Extra pixels avoid a sub-pixel clip of the last date row.
    return rows * cellHeight + (rows - 1) * mainAxisSpacing + 2;
  }
}
