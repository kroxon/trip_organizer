import java.util.Properties
import java.io.FileInputStream

val localProperties = Properties()
val localPropertiesFile = rootProject.file("local.properties")
if (localPropertiesFile.exists()) {
    localProperties.load(FileInputStream(localPropertiesFile))
}

val googleMapsApiKey: String? = localProperties.getProperty("googleMapsApiKey")
    ?: System.getenv("YOUR_GOOGLE_API_KEY")

plugins {
    id("com.android.application")
    id("com.google.gms.google-services")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.trip_organizer"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    buildFeatures {
        buildConfig = true
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.trip_organizer"
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        manifestPlaceholders["googleMapsApiKey"] = googleMapsApiKey ?: ""
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug") // Replace with your release signing config
        }
    }
}

flutter {
    source = "../.."
}