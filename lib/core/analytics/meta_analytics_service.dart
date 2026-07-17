import 'package:flutter/foundation.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/facebook_config.dart';
import 'package:qizlar_academy_mobile/config/logs/logs.dart';

/// Meta (Facebook) App Events bilan ishlash uchun yagona service.
///
/// - Native Info.plist / AndroidManifest dagi `FacebookAppID` /
///   `com.facebook.sdk.ApplicationId` qiymati [FacebookConfig.appId] bilan
///   sinxron bo‘lishi shart.
/// - `iOS` da ATT prompt yoqilmagan: [FacebookAppEvents.setAdvertiserTracking]
///   `enabled: false` bilan chaqiriladi (IDFA yo‘q; AEM/SKAdNetwork orqali
///   attribution ba'zi imkoniyatlari saqlanadi).
/// - `app activate` event'i [FacebookAppEvents.setAutoLogAppEventsEnabled]
///   yordamida avtomatik yuboriladi (0.19.x da `activateApp()` mavjud emas).
/// - Init muvaffaqiyatsiz bo‘lsa barcha log* metodlari sukut bilan no-op
///   (xato faqat [AppLogger] ga yoziladi).
class MetaAnalyticsService {
  MetaAnalyticsService();

  final FacebookAppEvents _events = FacebookAppEvents();
  bool _initialized = false;
  Future<void>? _initialization;

  bool get isInitialized => _initialized;

  /// SDK sozlash. Bir martagina init qilinadi; takroriy chaqiruv no-op.
  /// Agar [FacebookConfig.isConfigured] `false` bo‘lsa init skip qilinadi.
  Future<void> initialize() => _initialization ??= _initialize();

  Future<void> _initialize() async {
    if (!FacebookConfig.isConfigured) {
      AppLogger.w('Meta App Events: init skipped (FACEBOOK_APP_ID empty)');
      return;
    }
    try {
      final nativeAppId = (await _events.getApplicationId())?.trim();
      if (nativeAppId != FacebookConfig.appId) {
        AppLogger.e(<String, dynamic>{
          'meta_analytics': 'app_id_mismatch',
          'expected_app_id': FacebookConfig.appId,
          'native_app_id': nativeAppId,
        });
        return;
      }

      String trackingStatus = 'not_applicable';
      if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
        var status = await AppTrackingTransparency.trackingAuthorizationStatus;
        if (status == TrackingStatus.notDetermined) {
          status = await AppTrackingTransparency.requestTrackingAuthorization();
        }
        final trackingEnabled = status == TrackingStatus.authorized;
        await _events.setAdvertiserTracking(
          enabled: trackingEnabled,
          collectId: trackingEnabled,
        );
        trackingStatus = status.name;
      }

      await _events.setAutoLogAppEventsEnabled(true);
      _initialized = true;
      AppLogger.i(<String, dynamic>{
        'meta_analytics': 'initialized',
        'app_id': nativeAppId,
        'tracking_status': trackingStatus,
      });
    } catch (e, st) {
      AppLogger.e('Meta App Events init failed', error: e, stackTrace: st);
    }
  }

  Future<bool> _ensureInitialized() async {
    await initialize();
    return _initialized;
  }

  /// Ro‘yxatdan o‘tish yakunlanganda (OTP success, profile create va h.k.).
  ///
  /// `fb_mobile_complete_registration` standard event sifatida yuboriladi.
  Future<void> logCompletedRegistration({
    String? method,
    Map<String, dynamic>? extraParameters,
  }) async {
    if (!await _ensureInitialized()) return;
    try {
      await _events.logEvent(
        name: FacebookAppEvents.eventNameCompletedRegistration,
        parameters: <String, dynamic>{
          FacebookAppEvents.paramNameRegistrationMethod: ?method,
          ...?extraParameters,
        },
      );
      AppLogger.d(<String, dynamic>{
        'meta_event': FacebookAppEvents.eventNameCompletedRegistration,
        'method': method,
      });
    } catch (e, st) {
      AppLogger.e(
        'Meta App Events completedRegistration failed',
        error: e,
        stackTrace: st,
      );
    }
  }

  /// Foydalanuvchi muhim sahifa/elementni ko‘rganda
  /// (kurs detail, store product detail va h.k.).
  ///
  /// `fb_mobile_content_view` standard event sifatida yuboriladi; qo‘shimcha
  /// parametrlar (`fb_content_name` kabi) [extraParameters] orqali uzatiladi.
  Future<void> logViewContent({
    required String contentId,
    required String contentType,
    String? currency,
    double? price,
    Map<String, dynamic>? extraParameters,
  }) async {
    if (!await _ensureInitialized()) return;
    try {
      await _events.logEvent(
        name: FacebookAppEvents.eventNameViewedContent,
        parameters: <String, dynamic>{
          FacebookAppEvents.paramNameContentId: contentId,
          FacebookAppEvents.paramNameContentType: contentType,
          FacebookAppEvents.paramNameCurrency: ?currency,
          ...?extraParameters,
        },
        valueToSum: price,
      );
      AppLogger.d(<String, dynamic>{
        'meta_event': FacebookAppEvents.eventNameViewedContent,
        'content_id': contentId,
        'content_type': contentType,
      });
    } catch (e, st) {
      AppLogger.e(
        'Meta App Events viewContent failed',
        error: e,
        stackTrace: st,
      );
    }
  }

  /// Real pul (ISO currency) bilan buyurtma yakunlanganda. Hozircha akademiya
  /// virtual coin do‘konini logging uchun [logStoreOrderCompleted] ishlatiladi.
  Future<void> logPurchase({
    required double amount,
    required String currency,
    Map<String, dynamic>? parameters,
  }) async {
    if (!await _ensureInitialized()) return;
    try {
      await _events.logPurchase(
        amount: amount,
        currency: currency,
        parameters: parameters,
      );
      AppLogger.d(<String, dynamic>{
        'meta_event': 'fb_mobile_purchase',
        'amount': amount,
        'currency': currency,
      });
    } catch (e, st) {
      AppLogger.e('Meta App Events purchase failed', error: e, stackTrace: st);
    }
  }

  /// Akademiya ichki coin do‘konida buyurtma yakunlanganda.
  ///
  /// Real pul ishtirok etmaydi, shuning uchun [logPurchase] o‘rniga maxsus
  /// custom event sifatida yuboriladi (`qa_store_order_completed`).
  Future<void> logStoreOrderCompleted({
    required String orderId,
    String? productId,
    String? variantId,
    int? unitPriceCoins,
  }) async {
    await logEvent(
      name: 'qa_store_order_completed',
      parameters: <String, dynamic>{
        'order_id': orderId,
        'product_id': ?productId,
        'variant_id': ?variantId,
        'unit_price_coins': ?unitPriceCoins,
      },
      valueToSum: unitPriceCoins?.toDouble(),
    );
  }

  /// Kursga yozilish muvaffaqiyatli bo‘lganda.
  ///
  /// Meta standard eventlari ichida enroll uchun universal kalit yo‘q, shuning uchun
  /// custom event sifatida yuboramiz: `enrolled_courses`.
  Future<void> logEnrolledCourse({
    required String courseId,
    String? courseTitle,
    String? source,
  }) async {
    await logEvent(
      name: 'enrolled_courses',
      parameters: <String, dynamic>{
        'course_id': courseId,
        'course_title': ?courseTitle,
        'source': ?source,
      },
    );
  }

  /// Dars yakunlanganda (manual complete yoki video oxiri).
  Future<void> logLessonCompleted({
    required String courseId,
    required String lessonId,
    String? completionSource,
  }) async {
    await logEvent(
      name: 'lesson_completed',
      parameters: <String, dynamic>{
        'course_id': courseId,
        'lesson_id': lessonId,
        'completion_source': ?completionSource,
      },
    );
  }

  /// Maxsus event yuborish. `name` – Meta Event Manager'da ko‘rinadigan kalit.
  Future<void> logEvent({
    required String name,
    Map<String, dynamic>? parameters,
    double? valueToSum,
  }) async {
    if (!await _ensureInitialized()) return;
    try {
      await _events.logEvent(
        name: name,
        parameters: parameters,
        valueToSum: valueToSum,
      );
      AppLogger.d(<String, dynamic>{
        'meta_event': name,
        'parameters': parameters,
        'value_to_sum': valueToSum,
      });
    } catch (e, st) {
      AppLogger.e('Meta App Events logEvent failed', error: e, stackTrace: st);
    }
  }

  /// Login bo‘lgandan keyin user identifikatorini bog‘lash (audience uchun).
  Future<void> setUserId(String userId) async {
    if (!await _ensureInitialized()) return;
    try {
      await _events.setUserID(userId);
    } catch (e, st) {
      AppLogger.e('Meta App Events setUserID failed', error: e, stackTrace: st);
    }
  }

  /// Sign-out paytida saqlangan user identifikatorlarni tozalash.
  Future<void> clearUser() async {
    if (!await _ensureInitialized()) return;
    try {
      await _events.clearUserID();
      await _events.clearUserData();
    } catch (e, st) {
      AppLogger.e('Meta App Events clearUser failed', error: e, stackTrace: st);
    }
  }
}
