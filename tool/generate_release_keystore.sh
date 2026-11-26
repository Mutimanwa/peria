#!/usr/bin/env bash
#
# Génère la clé de signature de release de Peria et la liste des secrets GitHub
# à créer. À lancer UNE SEULE FOIS, sur la machine du propriétaire du projet.
#
#   bash tool/generate_release_keystore.sh          (Linux, macOS, Git Bash)
#   tool\Generate-ReleaseKeystore.ps1               (Windows natif)
#
# Prérequis : Java (keytool) et openssl.
#
# La clé produite ici est la seule qui pourra signer les futures mises à jour :
# Android refuse d'installer par-dessus une application signée avec une autre
# clé, et le Play Store refuse définitivement un paquet signé avec une autre clé
# que celle du premier envoi. Sauvegardez android/keystore/release.jks et
# android/key.properties hors du dépôt, sinon les mises à jour deviennent
# impossibles.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
KEYSTORE_DIR="$ROOT/android/keystore"
KEYSTORE="$KEYSTORE_DIR/release.jks"
PROPERTIES="$ROOT/android/key.properties"
ALIAS="peria"

fail() {
  echo "Erreur : $*" >&2
  exit 1
}

command -v keytool >/dev/null 2>&1 ||
  fail "keytool est introuvable. Installez un JDK (17 de préférence) puis relancez."
command -v openssl >/dev/null 2>&1 ||
  fail "openssl est introuvable : il sert à générer les mots de passe."

if [ -f "$KEYSTORE" ]; then
  fail "$KEYSTORE existe déjà. Supprimer une clé de signature casse toutes les mises à jour : le script refuse de l'écraser. Pour repartir de zéro en connaissance de cause, déplacez l'ancienne clé puis relancez."
fi
if [ -f "$PROPERTIES" ]; then
  fail "$PROPERTIES existe déjà. Même raison : le script ne l'écrase pas."
fi

# Un mot de passe par valeur, sans caractère qui casse le shell ou les
# propriétés Java (ni $, ni \, ni espace).
generate_password() {
  openssl rand -base64 32 | tr -d '/+=\n' | cut -c1-28
}

# Un seul mot de passe : un keystore PKCS12 n'en stocke qu'un, keytool ignore
# -keypass s'il diffère de -storepass, et la signature échouerait alors avec un
# mot de passe qui ne correspond pas à key.properties.
STORE_PASSWORD="$(generate_password)"
KEY_PASSWORD="$STORE_PASSWORD"

mkdir -p "$KEYSTORE_DIR"

echo "Génération de la clé (RSA 4096, valide 10 000 jours)…"
keytool -genkeypair \
  -keystore "$KEYSTORE" \
  -storetype PKCS12 \
  -alias "$ALIAS" \
  -keyalg RSA \
  -keysize 4096 \
  -validity 10000 \
  -storepass "$STORE_PASSWORD" \
  -keypass "$KEY_PASSWORD" \
  -dname "CN=Peria, OU=Mobile, O=Peria, L=Gitega, ST=Gitega, C=BI" \
  -noprompt >/dev/null

# Format attendu par android/app/build.gradle.kts : les chemins sont relatifs au
# dossier android/.
cat >"$PROPERTIES" <<EOF
storeFile=keystore/release.jks
storePassword=$STORE_PASSWORD
keyAlias=$ALIAS
keyPassword=$KEY_PASSWORD
EOF

chmod 600 "$KEYSTORE" "$PROPERTIES"

FINGERPRINT="$(keytool -list -v -keystore "$KEYSTORE" -alias "$ALIAS" \
  -storepass "$STORE_PASSWORD" 2>/dev/null |
  grep -m1 "SHA256:" | sed 's/.*SHA256: *//')"

BASE64="$(base64 <"$KEYSTORE" | tr -d '\n')"

cat <<EOF

Clé créée :
  $KEYSTORE
  $PROPERTIES
Empreinte SHA-256 du certificat :
  $FINGERPRINT

--- 1. Sauvegarde (obligatoire avant tout le reste) -------------------------

Copiez ces deux fichiers dans un coffre-fort (gestionnaire de mots de passe,
disque chiffré, clé USB rangée). Sans eux, aucune mise à jour ne sera plus
possible : l'application installée refusera toute autre signature.

  android/keystore/release.jks
  android/key.properties

--- 2. Secrets GitHub à créer ----------------------------------------------

Dépôt > Settings > Secrets and variables > Actions > New repository secret,
quatre secrets avec exactement ces noms :

  ANDROID_KEYSTORE_BASE64  = le contenu de release.jks encodé en base64
  ANDROID_KEYSTORE_PASSWORD = $STORE_PASSWORD
  ANDROID_KEY_ALIAS         = $ALIAS
  ANDROID_KEY_PASSWORD      = $KEY_PASSWORD   (identique : PKCS12 n'a qu'un mot de passe)

Si la CLI gh est authentifiée avec un compte propriétaire du dépôt, les quatre
commandes ci-dessous font la même chose :

  gh secret set ANDROID_KEYSTORE_BASE64 < <(base64 < android/keystore/release.jks)
  gh secret set ANDROID_KEYSTORE_PASSWORD --body '$STORE_PASSWORD'
  gh secret set ANDROID_KEY_ALIAS --body '$ALIAS'
  gh secret set ANDROID_KEY_PASSWORD --body '$KEY_PASSWORD'

--- 3. Vérification --------------------------------------------------------

Après le prochain push sur main, le journal du job Android doit afficher
« Keystore de release installe (… octets). » puis, à l'étape suivante,
« Signer #1 certificate SHA-256 digest: $FINGERPRINT ».
La release GitHub n'est publiée que si l'APK est signé avec cette clé.
EOF
