import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

val localProperties = Properties()
val localPropertiesFile = rootProject.file("local.properties")
if (localPropertiesFile.exists()) {
    localPropertiesFile.inputStream().use { localProperties.load(it) }
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystorePropertiesFile.inputStream().use { keystoreProperties.load(it) }
}

android {
    namespace = "uz.globalmove.girls_academy"
    compileSdk = 36
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    defaultConfig {
        applicationId = "uz.globalmove.girls_academy"
        minSdk = flutter.minSdkVersion
        targetSdk = 35
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true
        // App Links host — `android/local.properties` da `deeplink.host=sizning.domen` (ixtiyoriy).
        // Default host: lib/config/constants/app_deep_link_config.dart → defaultUniversalLinkHost bilan bir xil.
        manifestPlaceholders["deepLinkHost"] =
            localProperties.getProperty("deeplink.host") ?: "www.qizlarakademiyasi.uz"
    }

    flavorDimensions += "flavors"

    productFlavors {
        create("dev") {
            dimension = "flavors"
            applicationId = "uz.globalmove.girls_academy_dev"
            versionNameSuffix = "-dev"
            manifestPlaceholders["appName"] = "Qizlar Akademiyasi (Dev)"
            resValue("string", "app_name", "Qizlar Akademiyasi (Dev)")
        }
        create("prod") {
            dimension = "flavors"
            applicationId = "uz.globalmove.girls_academy"
            manifestPlaceholders["appName"] = "Qizlar Akademiyasi"
            resValue("string", "app_name", "Qizlar Akademiyasi")
        }
    }

    val releaseSigningConfigured = run {
        val alias = keystoreProperties["keyAlias"] as? String
        val storePass = keystoreProperties["storePassword"] as? String
        val keyPass = keystoreProperties["keyPassword"] as? String
        val storePath = keystoreProperties["storeFile"] as? String
        if (alias.isNullOrBlank() || storePass.isNullOrBlank() || keyPass.isNullOrBlank() || storePath.isNullOrBlank()) {
            false
        } else {
            file(storePath).isFile
        }
    }

    signingConfigs {
        create("release") {
            if (releaseSigningConfigured) {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storePassword = keystoreProperties["storePassword"] as String
                storeFile = file(keystoreProperties["storeFile"] as String)
                val storeType = keystoreProperties["storeType"] as? String
                if (!storeType.isNullOrBlank()) {
                    this.storeType = storeType
                }
            }
        }
    }

    buildTypes {
        release {
            signingConfig = if (releaseSigningConfigured) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
}

flutter {
    source = "../.."
}
