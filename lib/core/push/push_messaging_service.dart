import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_keys.dart';
import 'package:qizlar_academy_mobile/config/logs/app_logger.dart';
import 'package:qizlar_academy_mobile/core/deeplink/app_deep_link_coordinator.dart';

/// Firebase Cloud Messaging: ruxsatlar, token saqlash, foreground’da lokal bildirishnoma.
class PushMessagingService {
  PushMessagingService(this._prefs, this._deepLinks);

  final SharedPreferences _prefs;
  final AppDeepLinkCoordinator _deepLinks;
  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  static const String _androidChannelId = 'qizlar_academy_push';

  bool _initialized = false;

  /// iOS: APNS uchun bir marta uzoq kutamiz; keyingi [getToken] chaqiriqlarida qayta bloklanmaymiz.
  bool _apnsWaitAttempted = false;

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }
    _initialized = true;

    await _local.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        // Ruxsatni faqat FirebaseMessaging.requestPermission orqali so‘raymiz (ikkilanishsiz).
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
      onDidReceiveNotificationResponse: _onNotificationResponse,
    );

    // Foregroundda ko‘rsatilgan lokal bildirishnoma orqali ilova o‘chiq holda ochilganda
    // [FirebaseMessaging.getInitialMessage] bo‘sh bo‘ladi — marshrut shu yerda keladi.
    try {
      final launchDetails = await _local.getNotificationAppLaunchDetails();
      if (launchDetails?.didNotificationLaunchApp ?? false) {
        _handleNotificationPayload(
          launchDetails!.notificationResponse?.payload,
          source: 'local_notification_cold_start',
        );
      }
    } catch (e, st) {
      AppLogger.e(
        'getNotificationAppLaunchDetails failed',
        error: e,
        stackTrace: st,
      );
    }

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      await _local
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(
            const AndroidNotificationChannel(
              _androidChannelId,
              'Push',
              description: 'Firebase push',
              importance: Importance.high,
            ),
          );
    }

    await _requestPermissions();
    await _logNotificationAuthIfApple();

    await _persistToken(await _tryGetFcmToken());

    FirebaseMessaging.instance.onTokenRefresh.listen(_persistToken);

    FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _deepLinks.handlePushData(
        Map<String, dynamic>.from(message.data),
        source: 'fcm_on_message_opened_app',
      );
    });

    final initialOpened = await FirebaseMessaging.instance.getInitialMessage();
    if (initialOpened != null) {
      _deepLinks.handlePushData(
        Map<String, dynamic>.from(initialOpened.data),
        source: 'fcm_get_initial_message',
      );
    }

    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
            alert: true,
            badge: true,
            sound: true,
          );
    }
  }

  /// Profil switcher: yoqishdan oldin ruxsat + yangi token.
  Future<String?> ensureTokenForSubscribe() async {
    await _requestPermissions();
    await _logNotificationAuthIfApple();
    if (await _notificationAccessBlockedOnApple()) {
      AppLogger.i(
        'FCM: bildirishnoma ruxsati yo‘q — iOS Sozlamalar > Qizlar Akademiyasi > Bildirishnomalar',
      );
      return null;
    }
    var token = _prefs.getString(StorageKey.fcmToken.name);
    if (token != null && token.isNotEmpty) {
      return token;
    }
    token = await _tryGetFcmTokenWithRetries();
    await _persistToken(token);
    return token;
  }

  bool _isApplePlatform() =>
      defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.macOS;

  Future<void> _logNotificationAuthIfApple() async {
    if (!_isApplePlatform()) return;
    final s = await FirebaseMessaging.instance.getNotificationSettings();
    AppLogger.i(
      'FCM: iOS bildirishnoma holati: ${s.authorizationStatus} (alert: ${s.alert})',
    );
  }

  Future<bool> _notificationAccessBlockedOnApple() async {
    if (!_isApplePlatform()) return false;
    final s = await FirebaseMessaging.instance.getNotificationSettings();
    return s.authorizationStatus == AuthorizationStatus.denied;
  }

  Future<void> _ensureApnsWaitOnce() async {
    if (!_isApplePlatform() || _apnsWaitAttempted) {
      return;
    }
    _apnsWaitAttempted = true;
    await _waitForApnsDeviceToken();
  }

  /// APNS tayyor bo‘lguncha kutamiz, keyin [getToken] — aks holda [apns-token-not-set].
  Future<String?> _tryGetFcmToken() async {
    if (_isApplePlatform()) {
      await _ensureApnsWaitOnce();
    }
    try {
      return await FirebaseMessaging.instance.getToken();
    } on FirebaseException catch (e, st) {
      if (e.code == 'apns-token-not-set') {
        await _logApnsDiagnostics();
        return null;
      }
      AppLogger.e('FCM getToken failed', error: e, stackTrace: st);
      return null;
    } catch (e, st) {
      AppLogger.e('FCM getToken failed', error: e, stackTrace: st);
      return null;
    }
  }

  Future<void> _waitForApnsDeviceToken() async {
    // ~20s: yetarli bo‘lsa yetadi; ortiqcha bloklamaymiz.
    const attempts = 50;
    for (var i = 0; i < attempts; i++) {
      final apns = await FirebaseMessaging.instance.getAPNSToken();
      if (apns != null && apns.isNotEmpty) {
        if (i > 0) {
          AppLogger.d('FCM: APNS token ${i * 400}ms dan keyin keldi');
        }
        return;
      }
      if (i == 5) {
        AppLogger.i(
          'FCM: APNS kutilmoqda — haqiqiy qurilma, Sozlamalar > Bildirishnomalar (Yoqilgan), '
          'Xcode Push capability, Apple Developer’da Push yoqilgan profil',
        );
      }
      await Future<void>.delayed(const Duration(milliseconds: 400));
    }
    await _logApnsDiagnostics();
  }

  Future<void> _logApnsDiagnostics() async {
    final s = await FirebaseMessaging.instance.getNotificationSettings();
    AppLogger.i(
      'FCM: APNS yo‘q. authorizationStatus=${s.authorizationStatus} '
      'alert=${s.alert} sound=${s.sound} badge=${s.badge}',
    );
  }

  /// iOS: [getAPNSToken] + [getToken] ketma-ketligi; Android: oddiy [getToken].
  Future<String?> _tryGetFcmTokenWithRetries() async {
    const attemptsApple = 3;
    const attemptsOther = 2;
    final n = _isApplePlatform() ? attemptsApple : attemptsOther;
    for (var i = 0; i < n; i++) {
      final token = await _tryGetFcmToken();
      if (token != null && token.isNotEmpty) {
        return token;
      }
      if (i < n - 1) {
        await Future<void>.delayed(Duration(milliseconds: 600 + i * 400));
      }
    }
    return null;
  }

  Future<void> _requestPermissions() async {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      final status = await Permission.notification.status;
      if (!status.isGranted) {
        await Permission.notification.request();
      }
    }

    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  Future<void> _persistToken(String? token) async {
    if (token == null || token.isEmpty) {
      return;
    }
    await _prefs.setString(StorageKey.fcmToken.name, token);
  }

  void _onNotificationResponse(NotificationResponse response) {
    _handleNotificationPayload(
      response.payload,
      source: 'local_notification_tap',
    );
  }

  void _handleNotificationPayload(String? payload, {required String source}) {
    if (payload == null || payload.isEmpty) {
      return;
    }
    try {
      final decoded = jsonDecode(payload);
      if (decoded is Map) {
        final map = <String, dynamic>{};
        decoded.forEach((Object? k, Object? v) {
          map[k.toString()] = v;
        });
        _deepLinks.handlePushData(map, source: source);
      }
    } catch (e, st) {
      AppLogger.e(
        'Push notification payload decode failed',
        error: e,
        stackTrace: st,
      );
    }
  }

  Future<void> _onForegroundMessage(RemoteMessage message) async {
    // Ilova ochiq: marshrutni faqat lokal notifikatsiya bosilishiga bog‘lash ba’zi
    // qurilmalarda ishlamay qoladi — `data` bo‘lsa darhol yo‘naltiramiz.
    if (message.data.isNotEmpty) {
      _deepLinks.handlePushData(
        Map<String, dynamic>.from(message.data),
        source: 'fcm_foreground_on_message',
      );
    }

    final notification = message.notification;
    if (notification == null) {
      return;
    }

    await _local.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannelId,
          'Push',
          channelDescription: 'Firebase push',
          importance: Importance.max,
          priority: Priority.high,
          icon: notification.android?.smallIcon ?? '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: message.data.isEmpty ? null : jsonEncode(message.data),
    );
  }
}
