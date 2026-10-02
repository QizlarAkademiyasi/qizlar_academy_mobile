import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/enum/user_type.dart';
import 'package:qizlar_academy_mobile/core/network/daily_streak_daily_fetch_service.dart';
import 'package:qizlar_academy_mobile/feature/auth/domain/model/auth_otp_bot_response.dart';
import 'package:qizlar_academy_mobile/feature/auth/domain/model/auth_session_model.dart';
import 'package:qizlar_academy_mobile/feature/auth/domain/repository/auth_repository.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/bloc/auth_session_cubit.dart';
import 'package:qizlar_academy_mobile/feature/daily_coin/domain/model/daily_streak_model.dart';
import 'package:qizlar_academy_mobile/feature/daily_coin/domain/repository/daily_coin_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('fetches once and reuses the typed snapshot for the same day', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final auth = AuthSessionCubit(_FakeAuthRepository());
    addTearDown(auth.close);
    await auth.setRegisteredSession(
      accessToken: 'access-token',
      refreshToken: 'refresh-token',
    );
    final repository = _CountingDailyCoinRepository();
    final service = DailyStreakDailyFetchService(prefs, repository, auth);

    final first = await service.ensureFetchedOnceToday();
    final second = await service.ensureFetchedOnceToday();

    expect(first, const DailyStreakModel(streakCount: 3, isClaimed: false));
    expect(second, first);
    expect(repository.fetchCount, 1);
  });

  test('saveSnapshot replaces the cached claim state', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final auth = AuthSessionCubit(_FakeAuthRepository());
    addTearDown(auth.close);
    await auth.setRegisteredSession(
      accessToken: 'access-token',
      refreshToken: 'refresh-token',
    );
    final repository = _CountingDailyCoinRepository();
    final service = DailyStreakDailyFetchService(prefs, repository, auth);

    await service.ensureFetchedOnceToday();
    await service.saveSnapshot(
      const DailyStreakModel(streakCount: 3, isClaimed: true),
    );

    expect(
      await service.ensureFetchedOnceToday(),
      const DailyStreakModel(streakCount: 3, isClaimed: true),
    );
    expect(repository.fetchCount, 1);
  });

  test('concurrent callers share one streak request', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final auth = AuthSessionCubit(_FakeAuthRepository());
    addTearDown(auth.close);
    await auth.setRegisteredSession(
      accessToken: 'access-token',
      refreshToken: 'refresh-token',
    );
    final repository = _CountingDailyCoinRepository();
    final service = DailyStreakDailyFetchService(prefs, repository, auth);

    final results = await Future.wait([
      service.ensureFetchedOnceToday(),
      service.ensureFetchedOnceToday(),
      service.ensureFetchedOnceToday(),
    ]);

    expect(results.toSet(), {
      const DailyStreakModel(streakCount: 3, isClaimed: false),
    });
    expect(repository.fetchCount, 1);
  });
}

final class _CountingDailyCoinRepository implements DailyCoinRepository {
  int fetchCount = 0;

  @override
  Future<void> claimStreak() async {}

  @override
  Future<DailyStreakModel> fetchStreak() async {
    fetchCount++;
    await Future<void>.delayed(const Duration(milliseconds: 10));
    return const DailyStreakModel(streakCount: 3, isClaimed: false);
  }
}

final class _FakeAuthRepository implements AuthRepository {
  @override
  Future<void> clearSession() async {}

  @override
  Future<AuthSessionModel> readSession() async =>
      const AuthSessionModel(userType: UserType.guest);

  @override
  Future<AuthSessionModel> refreshToken({required String refreshToken}) async =>
      const AuthSessionModel(userType: UserType.user);

  @override
  Future<String> sendOtpToPhoneNumber({required String phone}) async => 'key';

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
