import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:perla_app/firebase_options.dart';

class FirebaseService {
  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      if (kDebugMode) {
        print('✅ Firebase initialized');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Firebase init error: $e');
      }
      rethrow;
    }
  }
}
