import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_keys.dart';
import 'package:qizlar_academy_mobile/config/logs/app_logger.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/bloc/auth_session_cubit.dart';
import 'package:qizlar_academy_mobile/feature/notification/domain/repository/notification_repository.dart';

/// Registered sessiya uchun FCM tokenni backend `global` kanaliga bog‘laydi.
final class PushSubscriptionSyncService {
  PushSubscriptionSyncService({
    required NotificationRepository notificationRepository,
    required AuthSessionCubit authSessionCubit,
    required SharedPreferences prefs,
    required Future<String?> Function() ensurePushToken,
  }) : _notificationRepository = notificationRepository,
       _authSessionCubit = authSessionCubit,
       _prefs = prefs,
       _ensurePushToken = ensurePushToken;

  final NotificationRepository _notificationRepository;
  final AuthSessionCubit _authSessionCubit;
  final SharedPreferences _prefs;
  final Future<String?> Function() _ensurePushToken;

  String? _lastSyncedToken;
  Future<void>? _syncInFlight;

  bool get isOptedOut => _prefs.getBool(StorageKey.pushOptedOut.name) ?? false;

  bool get _canUsePushApi {
    final state = _authSessionCubit.state;
    return state.isRegistered && (state.accessToken ?? '').isNotEmpty;
  }

  Future<void> setUserOptedOut(bool optedOut) async {
    await _prefs.setBool(StorageKey.pushOptedOut.name, optedOut);
    if (optedOut) {
      _lastSyncedToken = null;
      await unbindDevice();
      return;
    }
    await syncRegisteredDevice(force: true);
  }

  Future<void> syncRegisteredDevice({bool force = false}) {
    final inFlight = _syncInFlight;
    if (inFlight != null) return inFlight;

    final future = _syncRegisteredDevice(force: force);
    _syncInFlight = future;
    return future.whenComplete(() {
      if (identical(_syncInFlight, future)) {
        _syncInFlight = null;
      }
    });
  }

  Future<void> _syncRegisteredDevice({required bool force}) async {
    if (!_canUsePushApi || isOptedOut) return;
    final token = await _ensurePushToken();
    if (token == null || token.isEmpty) return;
    if (!force && _lastSyncedToken == token) return;
    try {
      await _notificationRepository.subscribePushToken(token);
      _lastSyncedToken = token;
    } catch (error, stackTrace) {
      AppLogger.w(
        'Push subscribe failed',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> unbindDevice() async {
    final token = _prefs.getString(StorageKey.fcmToken.name);
    _lastSyncedToken = null;
    if (token == null || token.isEmpty || !_canUsePushApi) return;
    try {
      await _notificationRepository.unsubscribePushToken(token);
    } catch (error, stackTrace) {
      AppLogger.w(
        'Push unsubscribe failed',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> onFcmTokenChanged(String? oldToken, String nextToken) async {
    if (nextToken.isEmpty) return;
    if (!_canUsePushApi || isOptedOut) return;
    if (oldToken != null && oldToken.isNotEmpty && oldToken != nextToken) {
      try {
        await _notificationRepository.unsubscribePushToken(oldToken);
      } catch (error, stackTrace) {
        AppLogger.w(
          'Push unsubscribe old token failed',
          error: error,
          stackTrace: stackTrace,
        );
      }
    }
    await syncRegisteredDevice(force: true);
  }
}
