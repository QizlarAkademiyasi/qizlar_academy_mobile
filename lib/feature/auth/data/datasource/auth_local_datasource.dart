import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_keys.dart';
import 'package:qizlar_academy_mobile/config/constants/user_type.dart';
import 'package:qizlar_academy_mobile/feature/auth/domain/model/auth_session_model.dart';

abstract interface class AuthLocalDatasource {
  Future<AuthSessionModel> readSession();

  Future<AuthSessionModel> saveAnonymousSession();

  Future<AuthSessionModel> saveRegisteredSession({
    required String accessToken,
    required String refreshToken,
    String tokenType,
  });

  Future<void> clearSession();
}

class AuthLocalDatasourceImpl implements AuthLocalDatasource {
  const AuthLocalDatasourceImpl(this._prefs);

  final SharedPreferences _prefs;

  @override
  Future<AuthSessionModel> readSession() async {
    final userTypeName = _prefs.getString(StorageKey.userType.name);
    final accessToken = _prefs.getString(StorageKey.accessToken.name);
    final refreshToken = _prefs.getString(StorageKey.refreshToken.name);
    final tokenType =
        _prefs.getString(StorageKey.tokenType.name) ?? _defaultTokenType;

    final resolvedUserType = UserType.values
        .where((item) => item.name == userTypeName)
        .firstOrNull;
    final hasAccessToken = (accessToken ?? '').isNotEmpty;
    final hasRefreshToken = (refreshToken ?? '').isNotEmpty;

    // userType saqlanmagan yoki session to'liq emas bo'lsa, xavfsiz default — anonymous.
    if (resolvedUserType == UserType.registered && hasAccessToken && hasRefreshToken) {
      return AuthSessionModel(
        userType: UserType.registered,
        accessToken: accessToken,
        refreshToken: refreshToken,
        tokenType: tokenType,
      );
    }

    if (resolvedUserType == UserType.anonymous) {
      return const AuthSessionModel(userType: UserType.anonymous);
    }

    await clearSession();
    return const AuthSessionModel(userType: UserType.anonymous);
  }

  @override
  Future<AuthSessionModel> saveAnonymousSession() async {
    await _prefs.setString(StorageKey.userType.name, UserType.anonymous.name);
    await _prefs.remove(StorageKey.accessToken.name);
    await _prefs.remove(StorageKey.refreshToken.name);
    await _prefs.remove(StorageKey.tokenType.name);
    return const AuthSessionModel(userType: UserType.anonymous);
  }

  @override
  Future<AuthSessionModel> saveRegisteredSession({
    required String accessToken,
    required String refreshToken,
    String tokenType = _defaultTokenType,
  }) async {
    await _prefs.setString(StorageKey.userType.name, UserType.registered.name);
    await _prefs.setString(StorageKey.accessToken.name, accessToken);
    await _prefs.setString(StorageKey.refreshToken.name, refreshToken);
    await _prefs.setString(StorageKey.tokenType.name, tokenType);
    return AuthSessionModel(
      userType: UserType.registered,
      accessToken: accessToken,
      refreshToken: refreshToken,
      tokenType: tokenType,
    );
  }

  @override
  Future<void> clearSession() async {
    await _prefs.remove(StorageKey.userType.name);
    await _prefs.remove(StorageKey.accessToken.name);
    await _prefs.remove(StorageKey.refreshToken.name);
    await _prefs.remove(StorageKey.tokenType.name);
  }
}

const String _defaultTokenType = 'Bearer';
