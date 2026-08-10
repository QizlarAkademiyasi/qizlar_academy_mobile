import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_mobile/config/constants/enum/user_type.dart';
import 'package:qizlar_academy_mobile/feature/auth/domain/model/auth_otp_bot_response.dart';
import 'package:qizlar_academy_mobile/feature/auth/domain/model/auth_session_model.dart';
import 'package:qizlar_academy_mobile/feature/auth/domain/repository/auth_repository.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/bloc/auth_session_cubit.dart';

void main() {
  group('AuthSessionCubit token refresh', () {
    test(
      'shares one refresh request across concurrent 401 responses',
      () async {
        final repository = _ControlledAuthRepository();
        final cubit = AuthSessionCubit(repository);
        addTearDown(cubit.close);

        await cubit.setRegisteredSession(
          accessToken: 'expired-access',
          refreshToken: 'shared-refresh',
        );

        final first = cubit.refreshAccessToken();
        final second = cubit.refreshAccessToken();
        final third = cubit.refreshAccessToken();

        expect(repository.refreshCallCount, 1);
        repository.completeRefresh(
          const AuthSessionModel(
            userType: UserType.user,
            accessToken: 'fresh-access',
            refreshToken: 'fresh-refresh',
          ),
        );

        expect(
          await Future.wait([first, second, third]),
          everyElement('fresh-access'),
        );
        expect(repository.refreshCallCount, 1);
        expect(cubit.state.accessToken, 'fresh-access');
      },
    );

    test(
      'clears an invalid session only once for concurrent callers',
      () async {
        final repository = _ControlledAuthRepository();
        final cubit = AuthSessionCubit(repository);
        addTearDown(cubit.close);

        await cubit.setRegisteredSession(
          accessToken: 'expired-access',
          refreshToken: 'invalid-refresh',
        );

        final first = cubit.refreshAccessToken();
        final second = cubit.refreshAccessToken();
        repository.failRefresh(StateError('refresh rejected'));

        expect(await Future.wait([first, second]), everyElement(isNull));
        expect(repository.refreshCallCount, 1);
        expect(repository.clearSessionCallCount, 1);
        expect(cubit.state.isAnonymous, isTrue);
      },
    );
  });
}

final class _ControlledAuthRepository implements AuthRepository {
  final Completer<AuthSessionModel> _refreshCompleter =
      Completer<AuthSessionModel>();
  int refreshCallCount = 0;
  int clearSessionCallCount = 0;

  void completeRefresh(AuthSessionModel model) {
    _refreshCompleter.complete(model);
  }

  void failRefresh(Object error) {
    _refreshCompleter.completeError(error, StackTrace.current);
  }

  @override
  Future<AuthSessionModel> refreshToken({required String refreshToken}) {
    refreshCallCount += 1;
    return _refreshCompleter.future;
  }

  @override
  Future<void> clearSession() async {
    clearSessionCallCount += 1;
  }

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
  Future<AuthSessionModel> readSession() async {
    return const AuthSessionModel(userType: UserType.guest);
  }

  @override
  Future<AuthSessionModel> setAnonymousSession() async {
    return const AuthSessionModel(userType: UserType.guest);
  }

  @override
  Future<String> sendOtpToPhoneNumber({required String phone}) {
    throw UnimplementedError();
  }

  @override
  Future<AuthOtpBotResponse> sendOtpViaTelegramBot({required String phone}) {
    throw UnimplementedError();
  }

  @override
  Future<AuthSessionModel> signInWithOtp({
    required String phone,
    required int code,
    required String keyHash,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<AuthSessionModel> signInWithGoogle({
    required String idToken,
    required String firstname,
    required String lastname,
  }) {
    throw UnimplementedError();
  }
}
