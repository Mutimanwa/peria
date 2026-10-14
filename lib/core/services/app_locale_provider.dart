import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peria_app/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _appLocalePreferenceKey = 'peria_app_locale';

final appLocaleProvider =
    StateNotifierProvider<AppLocaleNotifier, Locale?>((ref) {
  final notifier = AppLocaleNotifier();
  unawaited(notifier.loadSavedLocale());
  return notifier;
});

/// Stores the user's language choice locally; null means follow the device.
class AppLocaleNotifier extends StateNotifier<Locale?> {
  AppLocaleNotifier() : super(null);

  bool _userChangedLocale = false;

  Future<void> loadSavedLocale() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      if (_userChangedLocale) return;

      final languageCode = preferences.getString(_appLocalePreferenceKey);
      if (languageCode == null) return;

      final isSupported = AppLocalizations.supportedLocales.any(
        (locale) => locale.languageCode == languageCode,
      );
      if (isSupported) state = Locale(languageCode);
    } catch (_) {
      // If preferences cannot be read, keep following the device locale.
    }
  }

  Future<void> setLanguageCode(String languageCode) async {
    final isSupported = AppLocalizations.supportedLocales.any(
      (locale) => locale.languageCode == languageCode,
    );
    if (!isSupported) {
      throw ArgumentError.value(languageCode, 'languageCode', 'Unsupported');
    }

    final previousLocale = state;
    final previouslyChanged = _userChangedLocale;
    _userChangedLocale = true;
    state = Locale(languageCode);

    try {
      final preferences = await SharedPreferences.getInstance();
      final saved = await preferences.setString(
        _appLocalePreferenceKey,
        languageCode,
      );
      if (!saved) throw StateError('Could not persist the selected language.');
    } catch (_) {
      state = previousLocale;
      _userChangedLocale = previouslyChanged;
      rethrow;
    }
  }
}
