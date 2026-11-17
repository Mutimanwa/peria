import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// ---------------------------------------------------------------------------
// Signature de release
//
// `android/key.properties` n'est pas dans le dépôt (voir android/.gitignore) :
// la CI l'écrit depuis les secrets avant de compiler, avec
//   storeFile=keystore/release.jks
//   storePassword=…
//   keyAlias=…
//   keyPassword=…
// Sans ce fichier (poste de dev sans les secrets), on retombe sur la clé de
// debug pour que la compilation continue de fonctionner.
// ---------------------------------------------------------------------------
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    FileInputStream(keystorePropertiesFile).use { keystoreProperties.load(it) }
}
val hasReleaseKeystore = keystorePropertiesFile.exists()

android {
    namespace = "com.example.peria"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    // Version mise à jour pour éviter le message "deprecated"
    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID
        applicationId = "com.example.peria"
        
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true
    }

    signingConfigs {
        if (hasReleaseKeystore) {
            create("release") {
                keyAlias = keystoreProperties.getProperty("keyAlias")
                keyPassword = keystoreProperties.getProperty("keyPassword")
                storeFile = rootProject.file(keystoreProperties.getProperty("storeFile"))
                storePassword = keystoreProperties.getProperty("storePassword")
            }
        }
    }

    buildTypes {
        release {
            // Clé de release dès qu'elle est disponible. Sinon la clé de debug :
            // une telle APK ne remplace pas une installation signée autrement
            // (INSTALL_FAILED_UPDATE_INCOMPATIBLE) et le Play Store la refuse.
            signingConfig = if (hasReleaseKeystore) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}
