plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.rouwhite"
    compileSdk = 36  // Usar SDK 36 para compatibilidad con plugins modernos
    ndkVersion = "27.0.12077973"  // NDK actualizado para compatibilidad

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = "1.8"
    }

    // Optimizaciones avanzadas para CI/CD
    packagingOptions {
        resources {
            excludes += setOf(
                "META-INF/DEPENDENCIES",
                "META-INF/LICENSE",
                "META-INF/LICENSE.txt",
                "META-INF/NOTICE",
                "META-INF/NOTICE.txt"
            )
        }
    }

    // Configuración de memoria para builds grandes (método moderno)
    androidComponents {
        beforeVariants { variantBuilder ->
            variantBuilder.enable = true
        }
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.rouwhite"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = 36
        versionCode = 7
        versionName = "1.0.6"
        
        // Configuración de memoria para builds grandes
        multiDexEnabled = true
    }

    signingConfigs {
        create("release") {
            keyAlias = "rouwhite"
            keyPassword = "rouwhite123"
            storeFile = file("../key.jks")
            storePassword = "rouwhite123"
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}
