import 'dart:async';
import 'package:flutter/services.dart';
import 'package:qizlar_academy_mobile/app.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/config/flavor/env_config.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

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

      // Flutter framework xatolarini (build, layout, render) Crashlytics ga yuborish
      FlutterError.onError = (FlutterErrorDetails details) {
        FlutterError.presentError(details);
        FirebaseCrashlytics.instance.recordFlutterFatalError(details);
      };

      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      runApp(const MyApp());
    },
    (Object error, StackTrace stackTrace) {
      try {
        FirebaseCrashlytics.instance.recordError(
          error,
          stackTrace,
          fatal: true,
        );
      } catch (e) {
        // debugPrint("FIREBASE ERROR V: $e");
      }
    },
  );
}
