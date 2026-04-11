import 'package:flutter/scheduler.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/logs/app_logger.dart';
import 'package:qizlar_academy_mobile/config/router/app_routes.dart';
import 'package:qizlar_academy_mobile/core/deeplink/app_deep_link_parser.dart';

/// `app_links` oqimi va pushdan kelgan marshrutlarni [GoRouter] ga uzatadi.
final class AppDeepLinkCoordinator {
  AppDeepLinkCoordinator({
    required GoRouter router,
    required AppDeepLinkParser parser,
  }) : _router = router,
       _parser = parser;

  final GoRouter _router;
  final AppDeepLinkParser _parser;
  final AppLinks _appLinks = AppLinks();

  bool _started = false;

  /// [GoRouter.redirect] splashda ushlab turishi mumkin — splash tugaguncha saqlanadi.
  String? _deferredUntilAfterSplash;

  Future<void> start() async {
    if (_started) {
      return;
    }
    _started = true;

    try {
      final initial = await _appLinks.getInitialLink();
      if (initial != null) {
        handleUri(initial, source: 'initial_link');
      }
    } catch (e, st) {
      AppLogger.e('app_links getInitialLink failed', error: e, stackTrace: st);
    }

    _appLinks.uriLinkStream.listen(
      (uri) => handleUri(uri, source: 'uri_stream'),
      onError: (Object e, StackTrace st) {
        AppLogger.e('app_links uriLinkStream error', error: e, stackTrace: st);
      },
    );
  }

  /// FCM `data` yoki lokal bildirishnoma `payload` dan decode qilingan map.
  void handlePushData(Map<String, dynamic> data, {String source = 'push'}) {
    final location = _parser.parseFromFcmData(data);
    if (location == null) {
      if (data.isNotEmpty) {
        AppLogger.d(
          'Push deep link: marshrut topilmadi ($source). Kalitlar: ${data.keys.join(", ")}',
        );
      }
      return;
    }
    _scheduleGo(location, source: source);
  }

  void handleUri(Uri uri, {String source = 'uri'}) {
    final location = _parser.parseUriToLocation(uri);
    if (location == null) {
      AppLogger.d('Deep link: parse natijasi bo‘sh ($source): $uri');
      return;
    }
    _scheduleGo(location, source: source);
  }

  void _scheduleGo(String location, {required String source}) {
    final binding = SchedulerBinding.instance;
    binding.addPostFrameCallback((_) {
      try {
        AppLogger.d('Deep link: go ($source) → $location');
        _router.go(location);
        _maybeDeferUntilAfterSplash(location, source);
        binding.addPostFrameCallback((_) {
          _maybeDeferUntilAfterSplash(location, source);
        });
      } catch (e, st) {
        AppLogger.e('Deep link go failed: $location', error: e, stackTrace: st);
      }
    });
  }

  void _maybeDeferUntilAfterSplash(String requested, String source) {
    if (requested == Routes.splash) {
      return;
    }
    final current = _router.state.matchedLocation;
    if (current == Routes.splash) {
      _deferredUntilAfterSplash = requested;
      AppLogger.d(
        'Deep link: splash tugaguncha qoldirildi ($source) → $requested',
      );
    }
  }

  /// [SplashScreen] chiqishida chaqiriladi — redirect splashni yengib o‘tganidan keyin.
  String? consumeDeferredPushNavigation() {
    final v = _deferredUntilAfterSplash;
    _deferredUntilAfterSplash = null;
    return v;
  }

}
