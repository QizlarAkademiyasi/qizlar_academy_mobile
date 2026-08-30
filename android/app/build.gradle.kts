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
    ndkVersion = "28.2.13676358"

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
        // App Links canonical host — `android/local.properties` da
        // `deeplink.host=sizning.domen` orqali almashtirish mumkin.
        // `www` varianti manifestda alohida verify qilinadi.
        manifestPlaceholders["deepLinkHost"] =
            localProperties.getProperty("deeplink.host") ?: "qizlarakademiyasi.uz"

        // Meta App Events (Facebook SDK).
        // - `facebook.appId` — lib/config/constants/facebook_config.dart `_appId` bilan
        //   sinxron. Hard-lock qilingan, local override qo‘llanmaydi.
        // - `facebook.clientToken` — Meta Developer Console → Settings → Advanced → Client Token.
        //   Bo‘sh bo‘lsa SDK App Events ni init qila olmaydi (analytics ishlamaydi).
        //   Qiymatlar `android/gradle.properties` ichidan olinadi.
        val facebookAppId = providers.gradleProperty("facebook.appId").orNull?.trim().orEmpty()
        val facebookClientToken = providers.gradleProperty("facebook.clientToken").orNull?.trim().orEmpty()
        require(facebookAppId.isNotEmpty()) { "facebook.appId is required in android/gradle.properties" }
        require(facebookClientToken.isNotEmpty()) { "facebook.clientToken is required in android/gradle.properties" }
        manifestPlaceholders["facebookAppId"] = facebookAppId
        manifestPlaceholders["facebookClientToken"] = facebookClientToken
        // Manifest da `@string/facebook_app_id` ko‘rinishida ishlatamiz — XML
        // raqamli stringni integer qilib parse qilib qo‘yishi xavfini oldini oladi.
        resValue("string", "facebook_app_id", facebookAppId)
        resValue("string", "facebook_client_token", facebookClientToken)
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
            isShrinkResources = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
    implementation("androidx.core:core-splashscreen:1.0.1")
    // Flutter embedder references Play Feature Delivery types when R8 runs; use modular SDK (not legacy play:core).
    // feature-delivery 2.1.0+ is required for targetSdk 34+ (broadcast receiver compatibility).
    implementation("com.google.android.play:feature-delivery:2.1.0")
}

flutter {
    source = "../.."
}
