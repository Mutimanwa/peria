# Intégration et livraison continues

Ce document décrit la CI/CD de Peria : ce qui s'exécute, sur quelles branches,
comment une version est publiée et ce qu'il reste à brancher côté Apple.

## 1. Branches

| Branche | Rôle | CI |
| --- | --- | --- |
| `develop` | Intégration du travail en cours. C'est ici qu'arrivent les PR de features. | Build + tests (Android et iOS), **pas** de release. |
| `main` | Code livré. Une PR `develop → main` n'y entre qu'une fois la CI verte. | Build + tests + **release automatique**. |
| `feature/…`, `arena/…` | Branche de travail, une par sujet. PR vers `develop`. | Build + tests, sans release. |

Créer `develop` une seule fois (elle n'existe pas encore) :

```bash
git switch main
git pull
git push origin main:develop
```

Ensuite, dans *Settings → Branches*, protéger `main` (PR obligatoire, CI verte,
pas de poussée directe) et, si besoin, faire de `develop` la branche par défaut
des PR.

## 2. Jobs GitHub Actions

Fichier : `.github/workflows/dart.yml`. Déclencheurs : `push` et
`pull_request` sur `main` et `develop`.

| Job | Runner | Contenu |
| --- | --- | --- |
| `android` | `ubuntu-latest` | `flutter analyze`, `flutter test`, `flutter build apk --release`, `flutter build appbundle --release`, artefacts APK et AAB. |
| `ios` | `macos-latest` | `flutter build ios --release --no-codesign`, puis archive `.app` en `.zip`. |
| `release` | `ubuntu-latest` | Uniquement sur un push vers `main` : crée le tag et la Release GitHub avec les trois binaires. |

L'analyse et les tests ne tournent que sur le job Android : les minutes macOS
coûtent environ dix fois plus cher, inutile de les dupliquer.

## 3. Version et release

La version de l'application vient de `pubspec.yaml` :

```yaml
version: 1.0.0+1
```

À chaque poussée sur `main`, le workflow :

1. attend la fin des jobs `android` et `ios` ;
2. lit `version:` et fabrique le tag `v<version>`, par exemple `v1.0.0+1` ;
3. crée la Release GitHub avec notes générées automatiquement et trois fichiers :
   - `peria-1.0.0+1.apk`
   - `peria-1.0.0+1.aab`
   - `peria-1.0.0+1-ios.zip`

Si la release du tag existe déjà (relance manuelle du workflow), les binaires
sont remplacés au lieu de provoquer une erreur.

**Publier une nouvelle version** revient donc à incrémenter `version:` dans
`pubspec.yaml` dans la PR qui part vers `main` :

```yaml
version: 1.0.1+2   # correctif : +0.0.1 et numéro de build +1
```

Aucun tag n'est créé à la main.

## 4. iOS : ce qui est fait, ce qui reste

Le job `ios` compile l'application en release **sans signature** : c'est une
vérification de compilation, pas un binaire installable.

Pour distribuer sur TestFlight ou l'App Store, il faudra ajouter un certificat
de distribution et un profil de provisionnement :

1. créer un certificat *Apple Distribution* et un profil *App Store* ;
2. les stocker en secrets (`BUILD_CERTIFICATE_BASE64`, `P12_PASSWORD`,
   `PROVISIONING_PROFILE_BASE64`, `KEYCHAIN_PASSWORD`) ;
3. remplacer `--no-codesign` par `flutter build ipa --release --export-options-plist=…` ;
4. publier avec `xcrun altool` / `fastlane pilot` ou l'action `apple-actions/upload-testflight-build`.

Ces étapes demandent un compte Apple Developer payant ; tant qu'il n'existe
pas, la compilation non signée reste la meilleure vérification possible.

## 5. Lancer la CI à la main

Onglet *Actions* → *Flutter CI/CD* → *Run workflow*, ou :

```bash
gh workflow run dart.yml --ref develop
```

Une release ne peut pas être déclenchée depuis une autre branche que `main`.
