import 'package:qizlar_academy_mobile/feature/auth/data/datasource/auth_local_datasource.dart';
import 'package:qizlar_academy_mobile/feature/auth/data/datasource/auth_remote_datasource.dart';
import 'package:qizlar_academy_mobile/feature/auth/domain/model/auth_otp_bot_response.dart';
import 'package:qizlar_academy_mobile/feature/auth/domain/model/auth_session_model.dart';
import 'package:qizlar_academy_mobile/feature/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._localDatasource, this._remoteDatasource);

  final AuthLocalDatasource _localDatasource;
  final AuthRemoteDatasource _remoteDatasource;

  @override
  Future<AuthSessionModel> readSession() => _localDatasource.readSession();

  @override
  Future<AuthSessionModel> setAnonymousSession() {
    return _localDatasource.saveAnonymousSession();
  }

  @override
  Future<String> sendOtpToPhoneNumber({required String phone}) async {
    final response = await _remoteDatasource.sendOtpToPhoneNumber(phone: phone);
    return response.keyHash;
  }

  @override
  Future<AuthOtpBotResponse> sendOtpViaTelegramBot({required String phone}) {
    return _remoteDatasource.sendOtpViaTelegramBot(phone: phone);
  }

  @override
  Future<AuthSessionModel> signInWithOtp({
    required String phone,
    required int code,
    required String keyHash,
  }) async {
    final response = await _remoteDatasource.signInWithOtp(
      phone: phone,
      code: code,
      keyHash: keyHash,
    );
    return _localDatasource.saveRegisteredSession(
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
      tokenType: response.tokenType,
    );
  }

  @override
  Future<AuthSessionModel> signInWithGoogle({
    required String idToken,
    required String firstname,
    required String lastname,
  }) async {
    final response = await _remoteDatasource.signInWithGoogle(
      idToken: idToken,
      firstname: firstname,
      lastname: lastname,
    );
    return _localDatasource.saveRegisteredSession(
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
      tokenType: response.tokenType,
    );
  }

  @override
  Future<AuthSessionModel> setRegisteredSession({
    required String accessToken,
    required String refreshToken,
    String tokenType = 'Bearer',
  }) {
    return _localDatasource.saveRegisteredSession(
      accessToken: accessToken,
      refreshToken: refreshToken,
      tokenType: tokenType,
    );
  }

  @override
  Future<void> clearSession() => _localDatasource.clearSession();

  @override
  Future<AuthSessionModel> refreshToken({required String refreshToken}) async {
    final refreshed = await _remoteDatasource.refreshToken(
      refreshToken: refreshToken,
    );
    return _localDatasource.saveRegisteredSession(
      accessToken: refreshed.accessToken,
      refreshToken: refreshed.refreshToken,
      tokenType: refreshed.tokenType,
    );
  }
}
