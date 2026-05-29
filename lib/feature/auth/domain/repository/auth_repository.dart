import 'package:qizlar_academy_mobile/feature/auth/domain/model/auth_otp_bot_response.dart';
import 'package:qizlar_academy_mobile/feature/auth/domain/model/auth_session_model.dart';

abstract interface class AuthRepository {
  Future<AuthSessionModel> readSession();

  Future<AuthSessionModel> setAnonymousSession();

  Future<String> sendOtpToPhoneNumber({required String phone});

  Future<AuthOtpBotResponse> sendOtpViaTelegramBot({required String phone});

  Future<AuthSessionModel> signInWithOtp({
    required String phone,
    required int code,
    required String keyHash,
  });

  Future<AuthSessionModel> signInWithGoogle({
    required String idToken,
    required String firstname,
    required String lastname,
  });

  Future<AuthSessionModel> setRegisteredSession({
    required String accessToken,
    required String refreshToken,
    String tokenType,
  });

  Future<void> clearSession();

  Future<AuthSessionModel> refreshToken({required String refreshToken});
}
