import 'package:flutter_test/flutter_test.dart';
import 'package:peria_app/features/auth/domain/auth_validators.dart';

void main() {
  group('AuthValidators.isEmailValid', () {
    test('accepts a normal address', () {
      expect(AuthValidators.isEmailValid('sogandasari77@gmail.com'), isTrue);
    });

    test('rejects incomplete or padded values', () {
      expect(AuthValidators.isEmailValid(''), isFalse);
      expect(AuthValidators.isEmailValid('peria'), isFalse);
      expect(AuthValidators.isEmailValid('peria@localhost'), isFalse);
      expect(AuthValidators.isEmailValid('per ia@gmail.com'), isFalse);
    });
  });

  group('AuthValidators.isPasswordValid', () {
    test('requires eight characters', () {
      expect(AuthValidators.isPasswordValid('1234567'), isFalse);
      expect(AuthValidators.isPasswordValid('12345678'), isTrue);
    });

    test('ignores surrounding whitespace when counting', () {
      expect(AuthValidators.isPasswordValid('  12345678  '), isTrue);
      expect(AuthValidators.isPasswordValid('   short  '), isFalse);
    });
  });
}
