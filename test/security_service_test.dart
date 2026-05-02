import 'package:flutter_test/flutter_test.dart';
import 'package:peria_app/core/services/security_service.dart';

void main() {
  group('PIN Validation', () {
    test('createPin should reject PINs that are too short', () async {
      await expectLater(
        () => SecurityService.createPin('123'),
        throwsA(isA<SecurityException>())
      );
    });

    test('createPin should reject PINs that are too long', () async {
      await expectLater(
        () => SecurityService.createPin('1234567'),
        throwsA(isA<SecurityException>())
      );
    });

    test('createPin should reject non-numeric PINs', () async {
      await expectLater(
        () => SecurityService.createPin('12a45'),
        throwsA(isA<SecurityException>())
      );
    });

    test('createPin should reject empty PINs', () async {
      await expectLater(
        () => SecurityService.createPin(''),
        throwsA(isA<SecurityException>())
      );
    });
  });

  // Note: Full unit testing of SecurityService is challenging due to static dependencies
  // on platform channels. These tests focus on validation logic that can be tested
  // without platform dependencies. Integration tests would be better for full coverage
  // of storage, authentication, and session management features.
}