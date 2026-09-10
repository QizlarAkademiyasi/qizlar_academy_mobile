import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_keys.dart';
import 'package:qizlar_academy_mobile/config/constants/enum/user_type.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/core/push/push_subscription_sync_service.dart';
import 'package:qizlar_academy_mobile/feature/auth/domain/model/auth_otp_bot_response.dart';
import 'package:qizlar_academy_mobile/feature/auth/domain/model/auth_session_model.dart';
import 'package:qizlar_academy_mobile/feature/auth/domain/repository/auth_repository.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/bloc/auth_session_cubit.dart';
import 'package:qizlar_academy_mobile/feature/notification/domain/model/notification_item_model.dart';
import 'package:qizlar_academy_mobile/feature/notification/domain/model/notification_topic_model.dart';
import 'package:qizlar_academy_mobile/feature/notification/domain/repository/notification_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SharedPreferences prefs;
  late AuthSessionCubit cubit;
  late _FakeNotificationRepository repository;
  late PushSubscriptionSyncService sync;

  setUp(() async {
    SharedPreferences.setMockInitialValues({
      StorageKey.fcmToken.name: 'tok-1',
    });
    prefs = await SharedPreferences.getInstance();
    cubit = AuthSessionCubit(_FakeAuthRepository());
    repository = _FakeNotificationRepository();
    sync = PushSubscriptionSyncService(
      notificationRepository: repository,
      authSessionCubit: cubit,
      prefs: prefs,
      ensurePushToken: () async =>
          prefs.getString(StorageKey.fcmToken.name) ?? 'tok-1',
    );
  });

  tearDown(() async {
    await cubit.close();
    await getIt.reset();
  });

  Future<void> registerUser() {
    return cubit.setRegisteredSession(accessToken: 'a', refreshToken: 'r');
  }

  test('registered session subscribes token', () async {
    await registerUser();
    await sync.syncRegisteredDevice();
    expect(repository.subscribeTokens, ['tok-1']);
    expect(repository.unsubscribeTokens, isEmpty);
  });

  test('guest session does not subscribe', () async {
    await cubit.continueAsGuest();
    await sync.syncRegisteredDevice();
    expect(repository.subscribeTokens, isEmpty);
  });

  test('opt-out skips subscribe and unsubscribes', () async {
    await registerUser();
    await sync.setUserOptedOut(true);
    expect(repository.unsubscribeTokens, ['tok-1']);
    repository.subscribeTokens.clear();
    await sync.syncRegisteredDevice(force: true);
    expect(repository.subscribeTokens, isEmpty);
  });

  test('token refresh unsubscribes old and subscribes new', () async {
    await registerUser();
    await sync.onFcmTokenChanged('old-tok', 'tok-1');
    expect(repository.unsubscribeTokens, ['old-tok']);
    expect(repository.subscribeTokens, ['tok-1']);
  });

  test('unbind runs while session is still registered', () async {
    await registerUser();
    getIt.registerSingleton<PushSubscriptionSyncService>(sync);
    expect(cubit.state.isRegistered, isTrue);
    await cubit.continueAsGuest();
    expect(repository.unsubscribeTokens, ['tok-1']);
    expect(cubit.state.isAnonymous, isTrue);
  });

  test('same token is not subscribed twice without force', () async {
    await registerUser();
    await sync.syncRegisteredDevice();
    await sync.syncRegisteredDevice();
    expect(repository.subscribeTokens, ['tok-1']);
  });
}

class _FakeNotificationRepository implements NotificationRepository {
  final List<String> subscribeTokens = [];
  final List<String> unsubscribeTokens = [];

  @override
  Future<NotificationPageModel> fetchPage({
    required NotificationChannelType type,
    required int pageNumber,
    int pageSize = 10,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<void> markAllAsRead() async {}

  @override
  Future<void> markAsRead({required String notificationId}) async {}

  @override
  Future<NotificationTopicPageModel> fetchTopicsPage({
    required int pageNumber,
    int pageSize = 10,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<bool> toggleTopic({required String topicId}) async => false;

  @override
  Future<void> subscribePushToken(String token) async {
    subscribeTokens.add(token);
  }

  @override
  Future<void> unsubscribePushToken(String token) async {
    unsubscribeTokens.add(token);
  }
}

class _FakeAuthRepository implements AuthRepository {
  @override
  Future<void> clearSession() async {}

  @override
  Future<AuthSessionModel> readSession() async =>
      const AuthSessionModel(userType: UserType.guest);

  @override
  Future<AuthSessionModel> refreshToken({required String refreshToken}) async =>
      const AuthSessionModel(userType: UserType.user);

  @override
  Future<String> sendOtpToPhoneNumber({required String phone}) async => 'k';

  @override
  Future<AuthOtpBotResponse> sendOtpViaTelegramBot({required String phone}) {
    throw UnimplementedError();
  }

  @override
  Future<AuthSessionModel> setAnonymousSession() async =>
      const AuthSessionModel(userType: UserType.guest);

  @override
  Future<AuthSessionModel> setRegisteredSession({
    required String accessToken,
    required String refreshToken,
    String tokenType = 'Bearer',
  }) async {
    return AuthSessionModel(
      userType: UserType.user,
      accessToken: accessToken,
      refreshToken: refreshToken,
      tokenType: tokenType,
    );
  }

  @override
  Future<AuthSessionModel> signInWithGoogle({
    required String idToken,
    required String firstname,
    required String lastname,
  }) async => const AuthSessionModel(userType: UserType.user);

  @override
  Future<AuthSessionModel> signInWithOtp({
    required String phone,
    required int code,
    required String keyHash,
  }) async => const AuthSessionModel(userType: UserType.user);
}
