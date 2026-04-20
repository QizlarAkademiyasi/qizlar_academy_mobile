import 'dart:async';

import 'package:flutter/services.dart';
import 'package:qizlar_academy_mobile/app.dart';
import 'package:qizlar_academy_mobile/config/constants/google_sign_in_config.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/config/flavor/app_remote_config.dart';
import 'package:qizlar_academy_mobile/core/deeplink/app_deep_link_coordinator.dart';
import 'package:qizlar_academy_mobile/core/push/fcm_background_handler.dart';
import 'package:qizlar_academy_mobile/core/push/push_messaging_service.dart';
import 'package:qizlar_academy_mobile/config/logs/logs.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:google_sign_in/google_sign_in.dart' as gsi;

/// Ilova ishga tushishi: binding, plugin init, DI, [runApp].
///
/// Og‘ir yoki UI talab qiladigan ishlar (masalan FCM token / APNS) birinchi
/// freymdan keyin [WidgetsBinding.addPostFrameCallback] orqali ishga tushadi.
abstract final class AppBootstrap {
  AppBootstrap._();

  static Future<void> start() async {
    WidgetsFlutterBinding.ensureInitialized();
    _muteVerboseInAppWebViewLogs();

    final telemetry = _StartupTelemetry();
    await _initPdfrx(telemetry);
    await _initLocator(telemetry);
    FirebaseMessaging.onBackgroundMessage(fcmBackgroundHandler);
    if (AppRemoteConfig.instance.googleSignInEnabled) {
      await _initGoogleSignIn(telemetry);
    }
    _bindFlutterErrorToCrashlytics();
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Deep link listenerni runApp'dan oldin ishga tushiramiz:
    // cold start (app killed) holatda initial linkni imkon qadar erta ushlash uchun.
    unawaited(_startDeepLinkCoordinator());

    telemetry.logTotalBeforeRunApp();
    runApp(const MyApp());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_bindPushMessagingAfterUi());
    });
  }

  static void onUncaughtZoneError(Object error, StackTrace stackTrace) {
    AppLogger.f('Uncaught zone error', error: error, stackTrace: stackTrace);
    if (Firebase.apps.isEmpty) return;
    try {
      FirebaseCrashlytics.instance.recordError(error, stackTrace, fatal: true);
    } catch (e, st) {
      AppLogger.e('Crashlytics recordError failed', error: e, stackTrace: st);
    }
  }

  static void _muteVerboseInAppWebViewLogs() {
    PlatformInAppWebViewController.debugLoggingSettings.enabled = false;
  }

  static Future<void> _initPdfrx(_StartupTelemetry t) async {
    final sw = Stopwatch()..start();
    await pdfrxFlutterInitialize(dismissPdfiumWasmWarnings: true);
    t.phase('pdfrxFlutterInitialize', sw);
  }

  static Future<void> _initLocator(_StartupTelemetry t) async {
    final sw = Stopwatch()..start();
    await setupLocator();
    t.phase('setupLocator_total', sw);
  }

  static Future<void> _initGoogleSignIn(_StartupTelemetry t) async {
    final sw = Stopwatch()..start();
    try {
      await gsi.GoogleSignIn.instance.initialize(
        serverClientId: GoogleSignInConfig.serverClientIdForInitialize,
      );
    } catch (e, st) {
      AppLogger.e('GoogleSignIn.initialize failed', error: e, stackTrace: st);
    }
    t.phase('GoogleSignIn.initialize', sw);
  }

  static void _bindFlutterErrorToCrashlytics() {
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      AppLogger.e(
        'Flutter framework error',
        error: details.exception,
        stackTrace: details.stack,
      );
      if (Firebase.apps.isNotEmpty) {
        FirebaseCrashlytics.instance.recordFlutterFatalError(details);
      }
    };
  }

  static Future<void> _startDeepLinkCoordinator() async {
    try {
      await getIt<AppDeepLinkCoordinator>().start();
    } catch (e, st) {
      AppLogger.e('AppDeepLinkCoordinator.start failed', error: e, stackTrace: st);
    }
  }

  /// Birinchi freym chizilgach — iOS’da APNS kutishi [runApp] ni bloklamasligi uchun.
  static Future<void> _bindPushMessagingAfterUi() async {
    final sw = Stopwatch()..start();
    try {
      await getIt<PushMessagingService>().initialize();
    } catch (e, st) {
      AppLogger.e('PushMessagingService.initialize failed', error: e, stackTrace: st);
      return;
    }
    AppLogger.i(<String, dynamic>{
      'startup_phase': 'PushMessagingService.initialize_deferred',
      'ms': sw.elapsedMilliseconds,
    });
  }
}

final class _StartupTelemetry {
  _StartupTelemetry() : _total = Stopwatch()..start();

  final Stopwatch _total;

  void phase(String name, Stopwatch phaseStopwatch) {
    AppLogger.i(<String, dynamic>{
      'startup_phase': name,
      'ms': phaseStopwatch.elapsedMilliseconds,
    });
  }

  void logTotalBeforeRunApp() {
    AppLogger.i(<String, dynamic>{
      'startup_phase': 'before_runApp_total',
      'ms': _total.elapsedMilliseconds,
    });
  }
}
