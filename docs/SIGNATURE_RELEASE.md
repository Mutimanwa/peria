# Signature de release et mises à jour

Objectif : que la version suivante de Peria **remplace** celle déjà installée,
au lieu d'être refusée par Android. Cela dépend d'une seule chose : toutes les
versions doivent être signées avec **la même clé**.

## Pourquoi la CI actuelle ne peut pas mettre à jour l'application

Tant qu'aucun keystore n'est configuré, `android/app/build.gradle.kts` signe
avec la clé de debug. Sur un runner GitHub, cette clé est recréée de zéro à
chaque exécution : deux builds de la CI n'ont donc pas le même certificat, et
Android répond `INSTALL_FAILED_UPDATE_INCOMPATIBLE` (« Application non
installée »). Aucune mise à jour n'est possible sans clé de release.

## 1. Générer la clé (une seule fois)

Sur votre machine, avec un JDK installé :

```bash
bash tool/generate_release_keystore.sh
```

Le script :

- refuse d'écraser une clé existante (en perdre une rend les mises à jour
  impossibles) ;
- crée `android/keystore/release.jks` — RSA 4096, alias `peria`, 10 000 jours —
  et `android/key.properties` avec des mots de passe aléatoires ;
- ignore ces fichiers côté git (`android/.gitignore`) ;
- affiche l'empreinte SHA-256 du certificat et les quatre commandes `gh secret
  set` correspondantes.

### Sous Windows

Deux chemins, même résultat.

**PowerShell natif** (pas besoin de Git Bash) :

```powershell
powershell -ExecutionPolicy Bypass -File tool\Generate-ReleaseKeystore.ps1
```

**Git Bash** (inclus avec Git for Windows) :

```bash
bash tool/generate_release_keystore.sh
```

Dans les deux cas il faut un **JDK 17** installé (`keytool`), puis rouvrir le
terminal pour que `PATH` et `JAVA_HOME` soient pris en compte. Vérification :

```powershell
keytool -help
```

Trois pièges Windows, tous traités par les scripts et le `.gitattributes` :

- **Fins de ligne** : un `.sh` récupéré en CRLF échoue avec
  `$'\r': command not found`. `.gitattributes` force LF pour les scripts ;
  en cas de doute, `git config core.autocrlf false` puis re-checkout du fichier.
- **Redirection `<`** : PowerShell ne la gère pas. Utilisez
  `gh secret set ANDROID_KEYSTORE_BASE64 --body ([System.IO.File]::ReadAllText('android\keystore\release.jks.b64'))`
  au lieu de `< fichier`.
- **BOM** : un `key.properties` enregistré « UTF-8 avec BOM » casse la première
  clé lue par Java. Le script PowerShell écrit sans BOM ; si vous éditez le
  fichier à la main, enregistrez-le en UTF-8 sans BOM ou en ASCII.

## 2. Sauvegarder la clé (avant tout le reste)

Copiez hors du dépôt, dans un endroit sûr et sauvegardé :

```
android/keystore/release.jks
android/key.properties
```

Sans eux, plus aucune mise à jour n'est possible : les téléphones qui ont déjà
l'application refuseront une signature différente, et le Play Store refuse
définitivement un paquet signé avec une autre clé que le premier envoi.

## 3. Créer les quatre secrets

*Settings → Secrets and variables → Actions*, ou avec `gh` :

```bash
# Git Bash / macOS / Linux
gh secret set ANDROID_KEYSTORE_BASE64 < android/keystore/release.jks.b64
gh secret set ANDROID_KEYSTORE_PASSWORD --body '…'
gh secret set ANDROID_KEY_ALIAS         --body 'peria'
gh secret set ANDROID_KEY_PASSWORD      --body '…'
```

```powershell
# PowerShell (la redirection < n'existe pas)
$b64 = [System.IO.File]::ReadAllText('android\keystore\release.jks.b64')
gh secret set ANDROID_KEYSTORE_BASE64 --body $b64
gh secret set ANDROID_KEYSTORE_PASSWORD --body '…'
gh secret set ANDROID_KEY_ALIAS         --body 'peria'
gh secret set ANDROID_KEY_PASSWORD      --body '…'
```

| Secret | Contenu |
| --- | --- |
| `ANDROID_KEYSTORE_BASE64` | le fichier `.jks` encodé en base64, sur une ligne |
| `ANDROID_KEYSTORE_PASSWORD` | `storePassword` de `key.properties` |
| `ANDROID_KEY_ALIAS` | `keyAlias`, ici `peria` |
| `ANDROID_KEY_PASSWORD` | `keyPassword` de `key.properties` — **même valeur** que `ANDROID_KEYSTORE_PASSWORD` : un keystore PKCS12 n'a qu'un mot de passe |

## 4. Vérifier

Au prochain push sur `main`, le job Android doit afficher :

```
Keystore de release installe (… octets).
…
Signer #1 certificate SHA-256 digest: <empreinte affichée à l'étape 1>
```

Si l'empreinte est la même que celle du certificat de la clé, les prochaines
APK remplaceront les installations existantes.

## 5. Ce que fait la CI ensuite

- **`versionCode` unique** : les builds release reçoivent
  `--build-number=<numéro de run>`, donc un `versionCode` strictement croissant.
  Sans cela, le Play Store refuse un envoi et les téléphones ne voient pas de
  nouvelle version.
- **Release gardée** : le job *Release automatique* ne publie rien tant que
  `signed` vaut `false`. Une APK signée en debug ne devient donc jamais une
  release officielle — elle serait ininstallable par-dessus l'existante.
- **Tag par build** : `v<version>-b<numéro de run>`, avec des fichiers
  `peria-<version>-b<build>.apk/.aab/-ios.zip`. Deux publications de la même
  version ne s'écrasent plus.

Pour publier une nouvelle version : fusionnez la PR dans `main`. Le tag, les
binaires et le `versionCode` sont produits automatiquement.

## 6. Dépannage

| Symptôme | Cause | Solution |
| --- | --- | --- |
| `INSTALL_FAILED_UPDATE_INCOMPATIBLE` | signature différente de l'installation existante | réinstaller après désinstallation **ou** publier avec la clé de release |
| release non publiée, journal vert | secrets absents : `signed=false` | créer les quatre secrets |
| `Keystore was tampered with` | mot de passe ou fichier base64 corrompu | regénérer le secret depuis le `.jks` sauvegardé |
| « You already have a signing key with key ID … » au Play Store | envoi signé avec une autre clé | utiliser le keystore d'origine, jamais un nouveau |
| `$'\r': command not found` (Windows, Git Bash) | script récupéré en CRLF | `.gitattributes` force LF ; sinon `git config core.autocrlf false` et re-checkout |
| `ParserError` / `<` inattendu dans PowerShell | PowerShell ne gère pas la redirection `<` | `gh secret set … --body ([System.IO.File]::ReadAllText('…'))` |
| `Keystore was tampered with` juste après génération | `key.properties` lu avec un BOM, ou mot de passe différent de `storePassword` | réécrire le fichier sans BOM ; PKCS12 n'a qu'un mot de passe, `keyPassword` = `storePassword` |

## 7. Installer une mise à jour depuis une release

Décision du projet : la distribution passe par les **releases GitHub**, pas par
le Play Store. L'identifiant `com.example.peria` reste donc en l'état — le
renommage décrit plus bas n'est nécessaire que le jour d'un premier envoi sur le
Play Store.

1. Onglet *Releases* du dépôt → dernière release `v<version>-b<build>`.
2. Télécharger le fichier `peria-<version>-b<build>.apk`.
3. L'ouvrir sur le téléphone : Android propose « Mettre à jour » si la signature
   est la même que l'installation existante.

La première fois après la bascule vers la clé de release, il faut désinstaller
l'application installée avec la clé de debug, puis réinstaller. Les mises à jour
suivantes se font sans désinstallation.

## 8. Play Store : identifiant de paquet

L'`applicationId` actuel est `com.example.peria`. Google Play **refuse tout
identifiant commençant par `com.example`** : avant le premier envoi, il faudra
renommer l'identifiant (par exemple `com.peria.app`). Ce renommage change le
paquet : les installations existantes ne seront pas mises à jour, mais
remplacées (désinstallation puis réinstallation). Il faut aussi enregistrer la
nouvelle application Android dans Firebase et remplacer `google-services.json`.
Pour une distribution par APK/GitHub Releases, aucun renommage n'est nécessaire.

Activez ensuite **Play App Signing** : Google conserve la clé de signature
finale, et le keystore local ne sert plus qu'à signer les envois. Une perte de
clé locale devient alors réparable auprès de Google.
