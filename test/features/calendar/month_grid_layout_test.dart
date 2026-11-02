import 'package:flutter_test/flutter_test.dart';
import 'package:peria_app/features/calendar/presentation/widgets/month_grid_layout.dart';

void main() {
  test('a 31-day month starting on Sunday still reserves every date', () {
    // Sunday is weekday 7, Monday-based offset is 6.
    const startOffset = 6;
    const dayCount = 31;
    expect(
      MonthGridLayout.rowCount(startOffset: startOffset, dayCount: dayCount),
      6,
    );
    expect(
      MonthGridLayout.cellCount(startOffset: startOffset, dayCount: dayCount),
      42,
    );
    final height = MonthGridLayout.heightFor(width: 280, rows: 6);
    expect(height, greaterThan(0));
    // Six rows must be taller than five, otherwise the last dates are clipped.
    expect(
      height,
      greaterThan(MonthGridLayout.heightFor(width: 280, rows: 5)),
    );
  });
}
