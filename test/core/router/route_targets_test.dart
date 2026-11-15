import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Routes volontairement hors du routeur : les écrans self-care et IA sont
/// conservés pour la v2 et ne sont atteignables depuis aucune page livrée.
const _unpluggedPrefixes = <String>['/self-care', '/ai'];

RegExp _routeMatcher(String path) {
  final pattern = path.replaceAll(RegExp(r':\w+'), '[^/]+');
  return RegExp('^$pattern\$');
}

void main() {
  test('every location pushed by the app exists in the router', () {
    final routerSource = File('lib/core/router/router.dart').readAsStringSync();
    final routes = RegExp(r"path: '([^']+)'")
        .allMatches(routerSource)
        .map((match) => _routeMatcher(match.group(1)!))
        .toList();

    final callPattern = RegExp(r"\.(?:go|push|replace)\('(/[^']*)'");
    final missing = <String>{};

    for (final entity in Directory('lib').listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      for (final call in callPattern.allMatches(entity.readAsStringSync())) {
        final location = call.group(1)!;
        if (_unpluggedPrefixes.any(location.startsWith)) continue;
        // Les segments interpolés (`/journal/detail/$id`) sont vérifiés par
        // leur forme dans le routeur, pas par leur valeur.
        if (location.contains(r'$')) continue;
        if (!routes.any((route) => route.hasMatch(location))) {
          missing.add('$location (${entity.path})');
        }
      }
    }

    // Un appel vers une route absente affiche la page d'erreur de GoRouter
    // (l'ecran « null » constate apres la connexion avec `/home`).
    expect(missing, isEmpty, reason: 'Routes absentes du routeur');
  });
}
