import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:peria_app/firebase_options.dart';

class FirebaseService {
  static Future<void> initialize() async {
    try {
      if (kDebugMode) {
        debugPrint('[FirebaseService] initialize start');
      }
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      await FirebaseFirestore.instance.enablePersistence(
        const PersistenceSettings(synchronizeTabs: true)
      );
      if (kDebugMode) {
        debugPrint('[FirebaseService] Firebase + Firestore offline ready');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[FirebaseService] Firebase initialization failed: $e');
      }
   }
  }
}
