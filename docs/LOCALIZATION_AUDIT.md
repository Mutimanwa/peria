# Audit de la localisation EN/FR

**Date :** 2026-10-14

## Conclusion

Peria dispose d’une infrastructure EN/FR et la localisation a été raccordée aux principaux écrans et contenus de l’application. Le français reste la source du contenu éducatif; les 16 articles disposent maintenant d’une version anglaise. Les textes fixes de Self Care et des écrans de démonstration de l’assistant ont également des traductions françaises et anglaises.

La vérification statique confirme la parité des clés ARB, la présence des déclarations et implémentations de localisation dans les deux classes, ainsi que l’absence de clés `l10n` non déclarées dans les widgets inspectés. Cette vérification ne remplace pas une compilation Flutter, une revue éditoriale complète ni un contrôle visuel sur appareils.

## Changement de langue

- `AppLocaleNotifier` mémorise `en` ou `fr` localement avec `SharedPreferences`; sans préférence, l’application continue de suivre la langue du système. Ce choix reste sur l’appareil et n’est pas transmis à Firebase; la politique de confidentialité le précise.
- Un sélecteur **EN / FR** est accessible depuis l’écran Welcome, avant l’acceptation de la politique, et depuis **Settings → Language**.
- Changer de langue sur Welcome réinitialise la case d’acceptation de la politique afin que l’utilisateur confirme à nouveau dans la langue choisie.
- La préférence locale de langue est décrite dans la politique; les acceptations de versions antérieures doivent être renouvelées.
- Les notifications locales reprennent la langue choisie dans l’application, plutôt que toujours celle du système.

## Couverture raccordée

| Zone | État |
| --- | --- |
| Welcome et politique de confidentialité | Contenu EN/FR; l’accord reste lié à la langue affichée. |
| Authentification et onboarding | Titres, champs, boutons, dialogues et choix; noms de mois et dates formatés selon la locale. |
| Cycle, calendrier et symptômes | Phases, états, actions, feuilles de saisie, catégories et options; dates et jours de semaine localisés. |
| Journal | Écrans, recherche, humeur, états vides, erreurs, verrou et paramètres de synchronisation. Le journal reste local par défaut; la synchronisation demeure facultative, contrôlable et soumise au consentement explicite. |
| Self Care | Filtres, sections, cartes, étapes, méditation, minuteurs, dialogues et article de santé reliés aux traductions EN/FR. |
| Assistant et rendez-vous de démonstration | Conversation statique, suggestions, carte calendrier, libellés et confirmation de rendez-vous localisés. |
| Éducation | Les 16 articles, axes, catégories, durées de lecture, recherche et suggestions disposent d’un affichage localisé; les tags contextuels français restent recherchés sur les données source avant traduction. |
| Profil, sécurité, notifications et paramètres | Libellés, actions, dialogues, états d’erreur et valeurs partagées principales localisés. |

Les noms propres (par exemple Peria, Perry ou le nom du médecin), les courriels, les contenus saisis par l’utilisateur et les valeurs numériques/horaires ne sont pas traduits comme du texte d’interface. Les dates visibles sont formatées avec la locale lorsqu’un formatage de date est utilisé.

## Contrôles effectués et limites

- `app_en.arb` et `app_fr.arb` sont valides en JSON et contiennent le même ensemble de clés et de métadonnées de placeholders.
- Les clés présentes dans les ARB ont des déclarations et des implémentations correspondantes dans `app_localizations.dart`, `app_localizations_en.dart` et `app_localizations_fr.dart`.
- Les références de localisation relevées dans le code n’utilisent pas de clés manquantes.
- Des tests couvrent la localisation éducative, le contenu Self Care et plusieurs comportements de confidentialité/cycle.
- Flutter et Dart ne sont pas installés dans l’environnement de travail : `flutter test` et `flutter analyze` n’ont donc pas pu être exécutés. Les textes français longs doivent encore être vérifiés visuellement pour détecter tout débordement.

## Suite recommandée

Exécuter `flutter gen-l10n`, `flutter analyze` et l’ensemble des tests dans un environnement Flutter, puis effectuer une revue visuelle écran par écran en anglais et en français sur petits et grands formats. Corriger les éventuels débordements et faire valider les traductions et le contenu santé par un relecteur francophone qualifié.
