plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin") 
}

android {
    namespace = "com.example.hajj_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973" 

    defaultConfig {
        applicationId = "com.lskit.hajj_app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true
    }
    

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8 
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = "1.8" 
    }

    signingConfigs {
    create("release") {
        storeFile = file("keystore.jks")
        storePassword = "98765432"
        keyAlias = "key"
        keyPassword = "98765432"
    }
}


    buildTypes {
        getByName("release") {
            isMinifyEnabled = true
            isShrinkResources = true
            signingConfig = signingConfigs.getByName("release")
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.."
}
