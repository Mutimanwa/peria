import 'package:flutter_test/flutter_test.dart';
import 'package:peria_app/features/onboarding/domain/minimum_age.dart';

void main() {
  final today = DateTime(2026, 10, 15);

  test('allows someone who turned 10 today', () {
    expect(
      isAtLeastMinimumAge(DateTime(2016, 10, 15), today),
      isTrue,
    );
    expect(ageInYears(DateTime(2016, 10, 15), today), 10);
  });

  test('blocks someone who turns 10 tomorrow', () {
    expect(
      isAtLeastMinimumAge(DateTime(2016, 10, 16), today),
      isFalse,
    );
    expect(ageInYears(DateTime(2016, 10, 16), today), 9);
  });

  test('blocks a child and a future date', () {
    expect(isAtLeastMinimumAge(DateTime(2020, 1, 1), today), isFalse);
    expect(isAtLeastMinimumAge(DateTime(2027, 1, 1), today), isFalse);
  });

  test('clamps impossible days such as 31 February', () {
    expect(calendarDate(2024, 2, 31), DateTime(2024, 2, 29));
    expect(calendarDate(2025, 2, 31), DateTime(2025, 2, 28));
  });
}
