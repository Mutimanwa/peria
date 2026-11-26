<#
.SYNOPSIS
    Génère la clé de signature de release de Peria sous Windows.

.DESCRIPTION
    Équivalent PowerShell de tool/generate_release_keystore.sh, à lancer UNE
    SEULE FOIS, sur la machine du propriétaire du projet :

        powershell -ExecutionPolicy Bypass -File tool\Generate-ReleaseKeystore.ps1

    Prérequis : un JDK (17 de préférence) et keytool accessible dans le PATH.
    Vérification :  keytool -help

    La clé produite ici est la seule qui pourra signer les futures mises à jour :
    Android refuse d'installer par-dessus une application signée avec une autre
    clé. Sauvegardez android\keystore\release.jks et android\key.properties hors
    du dépôt, sinon les mises à jour deviennent impossibles.
#>

$ErrorActionPreference = 'Stop'

$root          = Split-Path -Parent $PSScriptRoot
$keystoreDir   = Join-Path $root 'android\keystore'
$keystorePath  = Join-Path $keystoreDir 'release.jks'
$base64Path    = Join-Path $keystoreDir 'release.jks.b64'
$propertiesPath = Join-Path $root 'android\key.properties'
$alias         = 'peria'

function Stop-WithError([string]$message) {
    Write-Host "Erreur : $message" -ForegroundColor Red
    exit 1
}

if (-not (Get-Command keytool -ErrorAction SilentlyContinue)) {
    Stop-WithError "keytool est introuvable. Installez un JDK 17 (Temurin, Oracle ou Microsoft OpenJDK), puis rouvrez le terminal pour que PATH et JAVA_HOME soient pris en compte."
}
if (Test-Path $keystorePath) {
    Stop-WithError "$keystorePath existe déjà. Supprimer une clé de signature casse toutes les mises à jour : le script refuse de l'écraser. Déplacez l'ancienne clé puis relancez si vous savez ce que vous faites."
}
if (Test-Path $propertiesPath) {
    Stop-WithError "$propertiesPath existe déjà. Même raison : le script ne l'écrase pas."
}

# Alphanumérique uniquement : aucun caractère à échapper dans keytool, dans
# key.properties ou dans une commande shell.
function New-SafePassword {
    $alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
    $bytes = New-Object 'byte[]' 28
    $rng = [System.Security.Cryptography.RandomNumberGenerator]::Create()
    $rng.GetBytes($bytes)
    $rng.Dispose()
    $builder = New-Object System.Text.StringBuilder
    foreach ($byte in $bytes) {
        [void]$builder.Append($alphabet[$byte % $alphabet.Length])
    }
    return $builder.ToString()
}

# Un seul mot de passe : un keystore PKCS12 n'en stocke qu'un, keytool ignore
# -keypass s'il diffère de -storepass, et la signature échouerait ensuite.
$password = New-SafePassword

New-Item -ItemType Directory -Force -Path $keystoreDir | Out-Null

Write-Host 'Génération de la clé (RSA 4096, valide 10 000 jours)…'
& keytool -genkeypair `
    -keystore $keystorePath `
    -storetype PKCS12 `
    -alias $alias `
    -keyalg RSA `
    -keysize 4096 `
    -validity 10000 `
    -storepass $password `
    -keypass $password `
    -dname 'CN=Peria, OU=Mobile, O=Peria, L=Gitega, ST=Gitega, C=BI' `
    -noprompt | Out-Null

if ($LASTEXITCODE -ne 0 -or -not (Test-Path $keystorePath)) {
    Stop-WithError 'keytool a échoué : la clé n''a pas été créée.'
}

# Chemins relatifs au dossier android\, comme le lit build.gradle.kts.
# WriteAllText avec un encodage sans BOM : un BOM casserait la première clé lue
# par Java.
$properties = @(
    'storeFile=keystore/release.jks'
    "storePassword=$password"
    "keyAlias=$alias"
    "keyPassword=$password"
) -join "`r`n"
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($propertiesPath, $properties, $utf8NoBom)

# Base64 sur une seule ligne, sans BOM : la CI le décode avec base64 -d.
$base64 = [Convert]::ToBase64String([System.IO.File]::ReadAllBytes($keystorePath))
[System.IO.File]::WriteAllText($base64Path, $base64, $utf8NoBom)

$fingerprint = (& keytool -list -v -keystore $keystorePath -alias $alias -storepass $password 2>$null |
    Select-String -Pattern 'SHA256:' |
    Select-Object -First 1).ToString()
$fingerprint = ($fingerprint -replace '.*SHA256:\s*', '').Trim()

Write-Host ''
Write-Host 'Clé créée :'
Write-Host "  $keystorePath"
Write-Host "  $propertiesPath"
Write-Host 'Empreinte SHA-256 du certificat :'
Write-Host "  $fingerprint"
Write-Host ''
Write-Host '--- 1. Sauvegarde (obligatoire avant tout le reste) -------------------------'
Write-Host ''
Write-Host 'Copiez ces deux fichiers dans un coffre-fort (gestionnaire de mots de passe,'
Write-Host 'disque chiffré, clé USB rangée). Sans eux, aucune mise à jour ne sera plus'
Write-Host 'possible : l''application installée refusera toute autre signature.'
Write-Host ''
Write-Host '  android\keystore\release.jks'
Write-Host '  android\key.properties'
Write-Host ''
Write-Host '--- 2. Secrets GitHub à créer ----------------------------------------------'
Write-Host ''
Write-Host 'Dépôt > Settings > Secrets and variables > Actions > New repository secret :'
Write-Host ''
Write-Host '  ANDROID_KEYSTORE_BASE64   = contenu de android\keystore\release.jks.b64'
Write-Host "  ANDROID_KEYSTORE_PASSWORD = $password"
Write-Host "  ANDROID_KEY_ALIAS         = $alias"
Write-Host "  ANDROID_KEY_PASSWORD      = $password   (identique : PKCS12 n'a qu'un mot de passe)"
Write-Host ''
Write-Host 'Le base64 complet est enregistré dans android\keystore\release.jks.b64.'
Write-Host 'Ouvrez-le avec le Bloc-notes et copiez tout son contenu (une seule ligne).'
Write-Host ''
Write-Host 'Avec GitHub CLI (PowerShell : la redirection < n''existe pas, on passe --body) :'
Write-Host ''
Write-Host "  gh secret set ANDROID_KEYSTORE_BASE64 --body ([System.IO.File]::ReadAllText('$base64Path'))"
Write-Host "  gh secret set ANDROID_KEYSTORE_PASSWORD --body '$password'"
Write-Host "  gh secret set ANDROID_KEY_ALIAS --body '$alias'"
Write-Host "  gh secret set ANDROID_KEY_PASSWORD --body '$password'"
Write-Host ''
Write-Host '--- 3. Vérification -------------------------------------------------------'
Write-Host ''
Write-Host 'Après le prochain push sur main, le journal du job Android doit afficher'
Write-Host '« Keystore de release installe (… octets). » puis, à l''étape suivante,'
Write-Host "« Signer #1 certificate SHA-256 digest: $fingerprint »."
Write-Host 'La release GitHub n''est publiée que si l''APK est signé avec cette clé.'
