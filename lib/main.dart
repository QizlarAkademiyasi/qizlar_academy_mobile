import 'dart:async';
import 'package:flutter/services.dart';
import 'package:qizlar_academy_mobile/app.dart';
import 'package:qizlar_academy_mobile/config/constants/google_sign_in_config.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/core/push/fcm_background_handler.dart';
import 'package:qizlar_academy_mobile/config/flavor/env_config.dart';
import 'package:qizlar_academy_mobile/config/logs/logs.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:google_sign_in/google_sign_in.dart' as gsi;

void main() {
  // main_dev.dart yoki main_prod.dart orqali ishga tushirilmagan bo'lsa,
  // prod konfiguratsiya bilan ishga tushiriladi.
  if (!EnvConfig.isInitialized) {
    EnvConfig.initialize(appName: 'Qizlar Akademiyasi', flavor: AppFlavors.dev);
  }

  runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      // YouTube (InAppWebView) kanalidagi spam: "IOSInAppWebViewController ... calling VideoTime".
      PlatformInAppWebViewController.debugLoggingSettings.enabled = false;
      // pdfrx Web uchun ~4MB pdfium.wasm ni barcha platformalarga asset qilib qo‘shadi; iOS/Android faqat native PDFium ishlatadi.
      // Debugda shu haqda ogohlantirish chiqmasin va birinchi init shu yerda bo‘lsin (sertifikat ekranidan oldin).
      await pdfrxFlutterInitialize(dismissPdfiumWasmWarnings: true);
      await setupLocator();
      FirebaseMessaging.onBackgroundMessage(fcmBackgroundHandler);
      try {
        // Android CredentialManager uchun serverClientId (Web OAuth client) majburiy;
        // iOS o‘z GoogleService-Info.plist konfiguratsiyasidan foydalanadi.
        await gsi.GoogleSignIn.instance.initialize(serverClientId: GoogleSignInConfig.serverClientIdForInitialize);
      } catch (e) {
        AppLogger.e('Failed to initialize GoogleSignIn: $e');
      }

      // Flutter framework xatolarini (build, layout, render) Crashlytics ga yuborish
      FlutterError.onError = (FlutterErrorDetails details) {
        FlutterError.presentError(details);
        AppLogger.e('Flutter framework error', error: details.exception, stackTrace: details.stack);
        if (Firebase.apps.isNotEmpty) {
          FirebaseCrashlytics.instance.recordFlutterFatalError(details);
        }
      };

      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

      runApp(const MyApp());
    },
    (Object error, StackTrace stackTrace) {
      AppLogger.f('Uncaught zone error', error: error, stackTrace: stackTrace);
      if (Firebase.apps.isEmpty) return;
      try {
        FirebaseCrashlytics.instance.recordError(error, stackTrace, fatal: true);
      } catch (firebaseError, firebaseStackTrace) {
        AppLogger.e('Crashlytics recordError failed', error: firebaseError, stackTrace: firebaseStackTrace);
      }
    },
  );
}

// For app assets generation:
// cd packages/qizlar_academy_kit && dart run build_runner build --delete-conflicting-outputs
//
