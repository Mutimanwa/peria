import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:peria_app/core/router/router.dart';

/// Service for protecting app content when in background or during multitasking
class MultitaskProtectionService {
  static const MethodChannel _platformChannel =
      MethodChannel('peria_app/security');

  static OverlayEntry? _blurOverlay;

  /// Initialize multitask protection
  static Future<void> initialize() async {
    // Set up platform-specific protection
    if (Platform.isAndroid) {
      await _enableAndroidSecureFlag();
    }

    // Listen to app lifecycle changes for iOS blur overlay
    SystemChannels.lifecycle.setMessageHandler((message) async {
      if (message == AppLifecycleState.paused.toString()) {
        _showBlurOverlay();
      } else if (message == AppLifecycleState.resumed.toString()) {
        _hideBlurOverlay();
      }
      return null;
    });
  }

  /// Enable FLAG_SECURE on Android to prevent screenshots
  static Future<void> _enableAndroidSecureFlag() async {
    try {
      await _platformChannel.invokeMethod('enableSecureFlag');
    } on PlatformException catch (e) {
      debugPrint('Failed to enable secure flag: ${e.message}');
    }
  }

  /// Show blur overlay (used on iOS when app goes to background)
  static void _showBlurOverlay() {
    if (_blurOverlay != null) return;

    final overlay = Overlay.of(navigatorKey.currentContext!);
    _blurOverlay = OverlayEntry(
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          color: Colors.black.withOpacity(0.1),
          child: const Center(
            child: Icon(
              Icons.lock,
              size: 48,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );

    overlay.insert(_blurOverlay!);
  }

  /// Hide blur overlay
  static void _hideBlurOverlay() {
    _blurOverlay?.remove();
    _blurOverlay = null;
  }

  /// Manually show protection overlay (for testing or custom scenarios)
  static void showProtectionOverlay(BuildContext context) {
    _showBlurOverlay();
  }

  /// Manually hide protection overlay
  static void hideProtectionOverlay() {
    _hideBlurOverlay();
  }
}
