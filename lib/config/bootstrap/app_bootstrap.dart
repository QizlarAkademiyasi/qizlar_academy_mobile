import 'dart:async';

import 'package:flutter/services.dart';
import 'package:qizlar_academy_mobile/app.dart';
import 'package:qizlar_academy_mobile/config/constants/google_sign_in_config.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/config/flavor/app_remote_config.dart';
import 'package:qizlar_academy_mobile/core/analytics/meta_analytics_service.dart';
import 'package:qizlar_academy_mobile/core/deeplink/app_deep_link_coordinator.dart';
import 'package:qizlar_academy_mobile/core/push/fcm_background_handler.dart';
import 'package:qizlar_academy_mobile/core/push/push_messaging_service.dart';
import 'package:qizlar_academy_mobile/config/logs/logs.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:google_sign_in/google_sign_in.dart' as gsi;

/// Ilova ishga tushishi: binding, plugin init, DI, [runApp].
///
/// Native splash `runApp` + birinchi freymgacha ko‘rinadi. PDF (pdfrx), Google
/// Sign-In, Meta analytics va push (FCM/APNS) shu freymdan keyin parallel
/// yuklanadi — splash vaqtini qisqartirish uchun.
abstract final class AppBootstrap {
  AppBootstrap._();

  static Future<void> start() async {
    WidgetsFlutterBinding.ensureInitialized();
    _muteVerboseInAppWebViewLogs();

    final telemetry = _StartupTelemetry();
    // PDF / Google / Meta SDK’lar birinchi freym uchun shart emas — native splash
    // `runApp` gacha bloklanmasin. Birinchi freymdan keyin parallel yuklanadi.
    await _initLocator(telemetry);
    FirebaseMessaging.onBackgroundMessage(fcmBackgroundHandler);
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
      unawaited(_runDeferredHeavyStartup(telemetry));
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
    try {
      await pdfrxFlutterInitialize(dismissPdfiumWasmWarnings: true);
    } catch (e, st) {
      AppLogger.e('pdfrxFlutterInitialize failed', error: e, stackTrace: st);
    }
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

  static Future<void> _initMetaAnalytics(_StartupTelemetry t) async {
    final sw = Stopwatch()..start();
    try {
      await getIt<MetaAnalyticsService>().initialize();
    } catch (e, st) {
      AppLogger.e(
        'MetaAnalyticsService.initialize failed',
        error: e,
        stackTrace: st,
      );
    }
    t.phase('MetaAnalyticsService.initialize', sw);
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
      AppLogger.e(
        'AppDeepLinkCoordinator.start failed',
        error: e,
        stackTrace: st,
      );
    }
  }

  /// Birinchi freymdan keyin: PDF, Google Sign-In, Meta, push — [runApp] gacha emas.
  static Future<void> _runDeferredHeavyStartup(
    _StartupTelemetry telemetry,
  ) async {
    final sw = Stopwatch()..start();
    await Future.wait<void>([
      _initPdfrx(telemetry),
      if (AppRemoteConfig.instance.googleSignInEnabled)
        _initGoogleSignIn(telemetry),
      _initMetaThenPush(telemetry),
    ]);
    AppLogger.i(<String, dynamic>{
      'startup_phase': 'after_first_frame_deferred_total',
      'ms': sw.elapsedMilliseconds,
    });
  }

  /// iOS bir vaqtning o‘zida ikkita native permission dialogini ko‘rsatmaydi.
  /// ATT yakunlangachgina notification permission so‘raladi.
  static Future<void> _initMetaThenPush(_StartupTelemetry telemetry) async {
    await _initMetaAnalytics(telemetry);
    await _bindPushMessagingAfterUi();
  }

  /// Birinchi freym chizilgach — iOS’da APNS kutishi [runApp] ni bloklamasligi uchun.
  static Future<void> _bindPushMessagingAfterUi() async {
    final sw = Stopwatch()..start();
    try {
      await getIt<PushMessagingService>().initialize();
    } catch (e, st) {
      AppLogger.e(
        'PushMessagingService.initialize failed',
        error: e,
        stackTrace: st,
      );
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
