# Contrastes — ce qui a changé, ce qui reste

Mesures WCAG 2.1 sur fond blanc (`lib/core/theme/contrast.dart`, testé dans
`test/core/theme/contrast_test.dart`).

## Avant

| Couleur | Hex | Ratio | Usage réel | Verdict |
|---|---|---|---|---|
| `grey400` | `#BDBDBD` | **1,88:1** | descriptions, légendes, aides | échec |
| `grey500` | `#989898` | **2,88:1** | textes secondaires, puces | échec |
| `grey600` | `#7C7C7C` | **4,17:1** | sous-titres, textes courants | échec AA (petit texte) |
| `error` | `#EF4444` | **3,76:1** | messages d'erreur | partiel |
| `success` | `#22C55E` | **2,28:1** | confirmations | échec |
| `primary` | `#FD587A` | **3,06:1** | liens, boutons texte | partiel |

## Après

| Jeton | Hex | Ratio | Remplace |
|---|---|---|---|
| `textSecondary` | `#6B6B6B` | **5,33:1** | `grey300`, `grey400`, `grey500`, `grey600` utilisés comme texte |
| `textError` | `#B91C1C` | **6,47:1** | `error` utilisé comme texte |
| `textSuccess` | `#15803D` | **5,02:1** | `success` utilisé comme texte |
| `primary600` | `#C10F46` | **6,13:1** | libellés des boutons texte et contour, liens |

## Ce qui a été modifié

- **129 styles de texte** (`AppText.*.copyWith(color: …)`) passent aux jetons ci-dessus, sur 45 fichiers.
- **Thème global** : `hintStyle` des champs (tous les placeholders), `errorStyle`, `textButtonTheme`, `outlinedButtonTheme`.
- Cas isolés : légende « Made by IM » de l'écran de démarrage, puces d'humeur du journal.
- Un test verrouille le seuil : si quelqu'un éclaircit `textSecondary`, le CI échoue.

## Ce qui reste (à valider visuellement)

- **Icônes grises** : chevrons de liste (`grey400`, 1,88:1), œil des champs de mot de passe. Le seuil WCAG « éléments non textuels » est de 3:1. Les assombrir change visiblement les listes — je préfère ton accord avant.
- **Gris décoratifs** : poignées de feuille (`grey300`) et traits de séparation — purement décoratifs, hors périmètre.
- **Textes sur fond coloré** (cartes de phase, badges) : à mesurer carte par carte, les fonds n'étant pas tous blancs.
