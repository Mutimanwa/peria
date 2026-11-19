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

1. attend la fin des jobs `android` et `ios`, et vérifie que l'APK a été signé
   avec la clé de release (`signed == 'true'`, voir §4) ;
2. lit `version:` et le numéro de run, et fabrique le tag `v<version>-b<run>`,
   par exemple `v1.0.0+1-b42` ;
3. crée la Release GitHub avec notes générées automatiquement et trois fichiers :
   - `peria-1.0.0+1-b42.apk`
   - `peria-1.0.0+1-b42.aab`
   - `peria-1.0.0+1-b42-ios.zip`

Le numéro de build dans le tag évite qu'un nouveau build écrase les binaires
d'une version précédente. Relancer le **même** run met à jour la release
existante au lieu de provoquer une erreur.

Le `versionCode` de l'APK/AAB n'est plus celui de `pubspec.yaml` seul : la CI
passe `--build-number=<numéro de run>`, donc il augmente à chaque build. Un
`versionCode` qui stagne fait refuser l'envoi par le Play Store et empêche les
téléphones de voir la mise à jour.

**Publier une nouvelle version** revient donc à incrémenter `version:` dans
`pubspec.yaml` dans la PR qui part vers `main` :

```yaml
version: 1.0.1+2   # correctif : +0.0.1 et numéro de build +1
```

Aucun tag n'est créé à la main.

La distribution se fait par ces releases (`com.example.peria` assumé) ; la
procédure d'installation d'une mise à jour est dans `docs/SIGNATURE_RELEASE.md`,
section 7.

## 4. Signature Android

Une mise à jour ne s'installe que si la nouvelle APK est signée avec **le même
certificat** que celle déjà présente sur le téléphone. Sinon Android répond
`INSTALL_FAILED_UPDATE_INCOMPATIBLE`, que le téléphone traduit par « Application
non installée » ou « Conflit avec un paquet existant ».

Sans keystore de release, `android/app/build.gradle.kts` signe avec la clé de
debug. Or cette clé est créée automatiquement dans `~/.android/debug.keystore`
avec une paire de clés **aléatoire** : chaque runner GitHub démarre avec un
`$HOME` vide, donc **chaque exécution de la CI produit une signature différente**.
Deux APK de la CI ne peuvent pas se remplacer l'un l'autre, et le Play Store
refuse un bundle signé en debug.

La procédure complète, pas à pas, est dans **`docs/SIGNATURE_RELEASE.md`**.
Résumé :

### Créer le keystore (une seule fois)

```bash
bash tool/generate_release_keystore.sh
```

Le script génère `android/keystore/release.jks` et `android/key.properties`,
refuse d'écraser une clé existante, et affiche l'empreinte SHA-256 ainsi que les
commandes de création des secrets.

> **À conserver hors du dépôt, avec une sauvegarde.** Sans ce fichier et ses mots
> de passe, plus aucune mise à jour n'est possible sur le Play Store : il faudrait
> publier une application sous un autre identifiant.

### Déposer les secrets

Le keystore voyage en base64, dans quatre secrets du dépôt
(*Settings → Secrets and variables → Actions*) :

```bash
base64 -w0 peria-upload.jks > peria-upload.jks.b64
# macOS : base64 -i peria-upload.jks -o peria-upload.jks.b64

gh secret set ANDROID_KEYSTORE_BASE64 < peria-upload.jks.b64
gh secret set ANDROID_KEYSTORE_PASSWORD   # mot de passe du keystore
gh secret set ANDROID_KEY_ALIAS           # peria
gh secret set ANDROID_KEY_PASSWORD        # mot de passe de la clé
```

### Ce que fait la CI

L'étape « Configure release signing » écrit `android/keystore/release.jks` et
`android/key.properties` à partir des secrets (les deux sont ignorés par git).
`build.gradle.kts` lit ce fichier et signe les builds release avec la clé de
release ; en son absence — poste de dev sans les secrets — il retombe sur la clé
de debug pour ne pas bloquer la compilation, et le job affiche un avertissement.

L'étape « Print signing certificate » affiche l'empreinte SHA-256 du certificat
de l'APK produit dans les logs du job `android` : c'est la valeur à comparer
quand une installation est refusée.

Deux garde-fous ont été ajoutés :

- les builds release reçoivent `--build-number=<numéro de run>`, donc un
  `versionCode` strictement croissant — condition pour que le Play Store accepte
  un envoi et pour que les téléphones voient la mise à jour ;
- le job *Release automatique* est conditionné à `needs.android.outputs.signed
  == 'true'` : sans secrets, l'APK est signé en debug et **aucune release n'est
  publiée**, car elle serait ininstallable par-dessus l'existante.

### Vérifier un APK à la main

```bash
apksigner verify --print-certs peria-1.0.0+1.apk
```

Deux APK qui peuvent se remplacer l'un l'autre affichent la même empreinte.

## 5. iOS : ce qui est fait, ce qui reste

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

## 6. Lancer la CI à la main

Onglet *Actions* → *Flutter CI/CD* → *Run workflow*, ou :

```bash
gh workflow run dart.yml --ref develop
```

Une release ne peut pas être déclenchée depuis une autre branche que `main`.
