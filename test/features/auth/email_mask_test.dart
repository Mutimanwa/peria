import 'package:flutter_test/flutter_test.dart';
import 'package:peria_app/features/auth/domain/email_mask.dart';

void main() {
  test('keeps the domain and two local characters', () {
    expect(maskEmail('sogandasari77@gmail.com'), 'so***@gmail.com');
  });

  test('works with very short local parts', () {
    expect(maskEmail('a@peria.app'), 'a***@peria.app');
    expect(maskEmail('ab@peria.app'), 'a***@peria.app');
  });

  test('leaves unusable input untouched', () {
    expect(maskEmail(''), '');
    expect(maskEmail('not-an-email'), 'not-an-email');
    expect(maskEmail('@peria.app'), '@peria.app');
  });

  test('trims before masking', () {
    expect(maskEmail('  hello@peria.app '), 'he***@peria.app');
  });
}
