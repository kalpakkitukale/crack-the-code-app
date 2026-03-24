import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Load keystore properties for release signing
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.streamshaala.streamshaala"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        // Enable core library desugaring for flutter_local_notifications
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // Base Application ID - will be modified by flavors
        applicationId = "com.streamshaala.streamshaala"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // ═══════════════════════════════════════════════════════════════════════
    // Product Flavors for Multi-Segment Architecture
    // ═══════════════════════════════════════════════════════════════════════
    flavorDimensions += "segment"

    productFlavors {
        // Junior variant (Grades 1-7)
        create("junior") {
            dimension = "segment"
            applicationIdSuffix = ".junior"
            versionNameSuffix = "-junior"
            resValue("string", "app_name", "StreamShaala Junior")
        }

        // Middle variant (Grades 7-9) - for future use
        create("middle") {
            dimension = "segment"
            applicationIdSuffix = ".middle"
            versionNameSuffix = "-middle"
            resValue("string", "app_name", "StreamShaala")
        }

        // PreBoard variant (Grade 10) - for future use
        create("preboard") {
            dimension = "segment"
            applicationIdSuffix = ".preboard"
            versionNameSuffix = "-preboard"
            resValue("string", "app_name", "StreamShaala Board Prep")
        }

        // SpellShaala variant (English Spelling Learning)
        create("spelling") {
            dimension = "segment"
            applicationIdSuffix = ".spelling"
            versionNameSuffix = "-spelling"
            resValue("string", "app_name", "SpellShaala")
        }

        // Senior variant (Grades 11-12) - current production app
        create("senior") {
            dimension = "segment"
            // No suffix - this is the original app ID for existing users
            applicationIdSuffix = ""
            versionNameSuffix = ""
            resValue("string", "app_name", "StreamShaala")
        }
    }

    // ═══════════════════════════════════════════════════════════════════════
    // Signing Configurations
    // ═══════════════════════════════════════════════════════════════════════
    signingConfigs {
        create("release") {
            if (keystorePropertiesFile.exists()) {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
            }
        }
    }

    buildTypes {
        release {
            // Use release signing if key.properties exists, otherwise fall back to debug
            signingConfig = if (keystorePropertiesFile.exists()) {
                signingConfigs.getByName("release")
            } else {
                // Fall back to debug for development builds without keystore
                signingConfigs.getByName("debug")
            }

            // Enable code shrinking and obfuscation for release builds
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }

        debug {
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = false
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Core library desugaring for Java 8+ APIs on older Android versions
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
