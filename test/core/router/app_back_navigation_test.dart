import 'package:flutter_test/flutter_test.dart';
import 'package:peria_app/core/router/app_back_navigation.dart';

void main() {
  test('system back walks to the logical parent instead of exiting', () {
    expect(resolveAppBackTarget('/calendar'), '/cycle');
    expect(resolveAppBackTarget('/symptoms'), '/cycle');
    expect(resolveAppBackTarget('/notification'), '/cycle');
    expect(resolveAppBackTarget('/notifications'), '/cycle');
    expect(resolveAppBackTarget('/profile'), '/cycle');
    expect(resolveAppBackTarget('/profile/notifications'), '/profile');
    expect(resolveAppBackTarget('/profile/personal-info'), '/profile');
    expect(resolveAppBackTarget('/journal'), '/cycle');
    expect(resolveAppBackTarget('/journal/detail/abc'), '/journal');
    expect(resolveAppBackTarget('/education/article/cycle-001'), '/education');
    expect(resolveAppBackTarget('/date-of-birth'), '/ask-name');
    expect(resolveAppBackTarget('/last-period'), '/date-of-birth');
  });

  test('root screens do not invent a parent', () {
    expect(resolveAppBackTarget('/cycle'), isNull);
    expect(resolveAppBackTarget('/welcome'), isNull);
    expect(resolveAppBackTarget('/ask-name'), isNull);
    expect(resolveAppBackTarget('/splash'), isNull);
  });

  test('age gate stays open on the birth-date form', () {
    expect(isAgeGateExempt('/date-of-birth'), isTrue);
    expect(isAgeGateExempt('/ask-name'), isTrue);
    expect(isAgeGateExempt('/cycle'), isFalse);
    expect(isAgeGateExempt('/symptoms'), isFalse);
    expect(isAgeGateExempt('/notification'), isFalse);
  });
}
