import 'dart:async';

import 'package:flutter/scheduler.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/logs/app_logger.dart';
import 'package:qizlar_academy_mobile/config/router/app_routes.dart';
import 'package:qizlar_academy_mobile/core/deeplink/app_deep_link_parser.dart';
import 'package:qizlar_academy_mobile/feature/referral/domain/service/referral_use_service.dart';

/// `app_links` oqimi va pushdan kelgan marshrutlarni [GoRouter] ga uzatadi.
///
/// "Ichki" (detail) marshrut uchun avval `/main` ga `go`, keyin `push` —
/// shu bilan pop har doim main'ga qaytaradi. Referral, kurs, vakansiya
/// kabi har qanday yangi deeplink ham shu mexanizm orqali ishlaydi.
final class AppDeepLinkCoordinator {
  AppDeepLinkCoordinator({
    required GoRouter router,
    required AppDeepLinkParser parser,
    required ReferralUseService referralUseService,
  }) : _router = router,
       _parser = parser,
       _referralUseService = referralUseService;

  final GoRouter _router;
  final AppDeepLinkParser _parser;
  final ReferralUseService _referralUseService;
  final AppLinks _appLinks = AppLinks();

  /// Root (shell) marshrut — `go()` bilan to'g'ridan-to'g'ri o'tiladi.
  /// Bu ro'yxatda bo'lmagan har qanday marshrut "ichki" hisoblanadi
  /// va `main` ustiga `push` qilinadi.
  static const Set<String> _rootLocations = {
    '/',
    '/main',
    '/main/guest',
    '/main/user',
    '/sign-in',
    '/register',
    '/verification',
  };

  bool _started = false;

  /// [GoRouter.redirect] splashda ushlab turishi mumkin — splash tugaguncha saqlanadi.
  String? _deferredUntilAfterSplash;
  String? _lastHandledLocation;
  DateTime? _lastHandledAt;

  static const Duration _duplicateWindow = Duration(seconds: 3);
  final Completer<void> _initialLinkResolved = Completer<void>();

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
    } finally {
      if (!_initialLinkResolved.isCompleted) {
        _initialLinkResolved.complete();
      }
    }

    _appLinks.uriLinkStream.listen(
      (uri) => handleUri(uri, source: 'uri_stream'),
      onError: (Object e, StackTrace st) {
        AppLogger.e('app_links uriLinkStream error', error: e, stackTrace: st);
      },
    );
  }

  /// Cold start paytida initial link parser ishlashi tugaguncha kutish.
  /// Splashdan keyingi yo'naltirishda race-conditionni kamaytiradi.
  Future<void> waitForInitialLinkResolved({
    Duration timeout = const Duration(milliseconds: 1800),
  }) async {
    if (_initialLinkResolved.isCompleted) return;
    try {
      await _initialLinkResolved.future.timeout(timeout);
    } catch (_) {
      // Timeout bo'lsa ham app flow bloklanmaydi.
    }
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
    _extractAndCaptureReferral(uri);

    final location = _parser.parseUriToLocation(uri);
    if (location == null) {
      AppLogger.d('Deep link: parse natijasi bo‘sh ($source): $uri');
      return;
    }
    _scheduleGo(location, source: source);
  }

  void _extractAndCaptureReferral(Uri uri) {
    final ref = uri.queryParameters['ref'];
    if (ref == null || ref.trim().isEmpty) return;
    unawaited(_referralUseService.captureReferralCode(ref));
  }

  void _scheduleGo(String location, {required String source}) {
    final binding = SchedulerBinding.instance;
    binding.addPostFrameCallback((_) {
      try {
        if (_isRecentlyHandled(location)) {
          AppLogger.d('Deep link: duplicate skip ($source) → $location');
          return;
        }

        // Cold start paytida router ko'pincha Splash'da bo'ladi.
        // Shu vaqtda darhol navigate qilsak, keyin Splash exit ham deferred'ni
        // yana navigate qiladi va bir xil sahifa 2 marta ochilib qoladi.
        final current = _router.state.matchedLocation;
        if (current == Routes.splash && location != Routes.splash) {
          if (_deferredUntilAfterSplash == location) {
            AppLogger.d(
              'Deep link: deferred duplicate skip ($source) → $location',
            );
            return;
          }
          _deferredUntilAfterSplash = location;
          AppLogger.d(
            'Deep link: splash tugaguncha qoldirildi ($source) → $location',
          );
          return;
        }

        if (current == location) {
          _rememberHandled(location);
          AppLogger.d('Deep link: already on route skip ($source) → $location');
          return;
        }

        if (isDetailPath(location)) {
          AppLogger.d('Deep link: go→main + push ($source) → $location');
          _router.go(Routes.main);
          binding.addPostFrameCallback((_) {
            if (_router.state.matchedLocation == location) {
              _rememberHandled(location);
              AppLogger.d(
                'Deep link: already opened before push skip ($source) → $location',
              );
              return;
            }
            _router.push(location);
            _rememberHandled(location);
          });
        } else {
          AppLogger.d('Deep link: go ($source) → $location');
          _router.go(location);
          _rememberHandled(location);
        }
      } catch (e, st) {
        AppLogger.e('Deep link go failed: $location', error: e, stackTrace: st);
      }
    });
  }

  /// Root marshrut emas — main ustiga push kerak.
  static bool isDetailPath(String location) {
    return !_rootLocations.contains(location);
  }

  /// [SplashScreen] chiqishida chaqiriladi — redirect splashni yengib o‘tganidan keyin.
  String? consumeDeferredPushNavigation() {
    final v = _deferredUntilAfterSplash;
    _deferredUntilAfterSplash = null;
    if (v != null && v.isNotEmpty) {
      _rememberHandled(v);
    }
    return v;
  }

  bool _isRecentlyHandled(String location) {
    final last = _lastHandledLocation;
    final at = _lastHandledAt;
    if (last == null || at == null) {
      return false;
    }
    if (last != location) {
      return false;
    }
    return DateTime.now().difference(at) <= _duplicateWindow;
  }

  void _rememberHandled(String location) {
    _lastHandledLocation = location;
    _lastHandledAt = DateTime.now();
  }

}
