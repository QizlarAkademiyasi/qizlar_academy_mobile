import 'dart:async';
import 'package:flutter/services.dart';
import 'package:qizlar_academy_mobile/app.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/config/flavor/env_config.dart';
import 'package:qizlar_academy_mobile/config/logs/logs.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:google_sign_in/google_sign_in.dart' as gsi;

void main() {
  // main_dev.dart yoki main_prod.dart orqali ishga tushirilmagan bo'lsa,
  // prod konfiguratsiya bilan ishga tushiriladi.
  if (!EnvConfig.isInitialized) {
    EnvConfig.initialize(
      appName: 'Qizlar Akademiyasi',
      flavor: AppFlavors.prod,
    );
  }

  runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await setupLocator();
      try {
        // Uses native Firebase/Google configuration from platform files.
        await gsi.GoogleSignIn.instance.initialize();
      } catch (e) {
        AppLogger.e('Failed to initialize GoogleSignIn: $e');
      }

      // Flutter framework xatolarini (build, layout, render) Crashlytics ga yuborish
      FlutterError.onError = (FlutterErrorDetails details) {
        FlutterError.presentError(details);
        AppLogger.e(
          'Flutter framework error',
          error: details.exception,
          stackTrace: details.stack,
        );
        FirebaseCrashlytics.instance.recordFlutterFatalError(details);
      };

      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      runApp(const MyApp());
    },
    (Object error, StackTrace stackTrace) {
      AppLogger.f('Uncaught zone error', error: error, stackTrace: stackTrace);
      try {
        FirebaseCrashlytics.instance.recordError(
          error,
          stackTrace,
          fatal: true,
        );
      } catch (firebaseError, firebaseStackTrace) {
        AppLogger.e(
          'Crashlytics recordError failed',
          error: firebaseError,
          stackTrace: firebaseStackTrace,
        );
      }
    },
  );
}
