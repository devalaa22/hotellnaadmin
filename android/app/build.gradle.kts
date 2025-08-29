plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services") // ✅ مهم لتشغيل Firebase
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.novel.hotellnaadmin"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
       
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.novel.hotellnaadmin"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = 4
        versionName = "3.0.0"
        multiDexEnabled = true
    }

      signingConfigs {
    create("release") {
        storeFile = file("C:\\Users\\momf\\fnoon\\android\\app\\AymanAltairi.jks")
        storePassword = "AymanAltairi"  // كلمة مرور keystore
        keyAlias = "AymanAltairi"  // اسم alias الخاص بالمفتاح
        keyPassword = "AymanAltairi"  // كلمة مرور المفتاح
    }
}

buildTypes {
    getByName("release") {
        signingConfig = signingConfigs.getByName("release")
        isMinifyEnabled = true  // لتقليص الكود
        isShrinkResources = true  // لتقليص الموارد
        proguardFiles(
            getDefaultProguardFile("proguard-android-optimize.txt"),
            "proguard-rules.pro"
        )
    }
}
}
dependencies {
    implementation("org.jetbrains.kotlin:kotlin-stdlib:1.9.10")
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")  // فقط هذه
}
flutter {
    source = "../.."
}
