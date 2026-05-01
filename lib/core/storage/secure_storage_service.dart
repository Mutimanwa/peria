import 'dart:convert';
import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  SecureStorageService._();

  static const _encryptionKeyName = 'secure.hive_encryption_key.v1';
  static const _storage = FlutterSecureStorage();

  static Future<List<int>> getEncryptionKey() async {
    final rawKey = await _storage.read(key: _encryptionKeyName);
    if (rawKey != null && rawKey.isNotEmpty) {
      return base64Decode(rawKey);
    }

    final key = List<int>.generate(32, (_) => Random.secure().nextInt(256));
    await _storage.write(key: _encryptionKeyName, value: base64Encode(key));
    return key;
  }
}
