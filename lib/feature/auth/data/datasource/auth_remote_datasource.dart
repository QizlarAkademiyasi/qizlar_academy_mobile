import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/apis.dart';
import 'package:qizlar_academy_mobile/core/network/token_refresh_interceptor.dart';

class AuthRefreshResponseModel {
  const AuthRefreshResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
  });

  final String accessToken;
  final String refreshToken;
  final String tokenType;
}

class AuthOtpResponseModel {
  const AuthOtpResponseModel({required this.keyHash});

  final String keyHash;
}

class AuthSignInResponseModel {
  const AuthSignInResponseModel({
    required this.accessToken,
    required this.refreshToken,
    this.tokenType = 'Bearer',
  });

  final String accessToken;
  final String refreshToken;
  final String tokenType;
}

abstract interface class AuthRemoteDatasource {
  Future<AuthOtpResponseModel> sendOtpToPhoneNumber({required String phone});

  Future<AuthSignInResponseModel> signInWithOtp({
    required String phone,
    required int code,
    required String keyHash,
  });

  Future<AuthSignInResponseModel> signInWithGoogle({
    required String idToken,
    required String firstname,
    required String lastname,
  });

  Future<AuthRefreshResponseModel> refreshToken({required String refreshToken});
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  const AuthRemoteDatasourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<AuthOtpResponseModel> sendOtpToPhoneNumber({
    required String phone,
  }) async {
    final response = await _dio.post<dynamic>(
      Apis.authOtpPhoneNumber,
      data: <String, dynamic>{'phone': phone},
      options: Options(extra: <String, dynamic>{skipAuthRefresh: true}),
    );
    final keyHash = _extractDataMap(response.data)['keyHash']?.toString() ?? '';
    if (keyHash.isEmpty) {
      throw const FormatException('OTP response keyHash is missing');
    }
    return AuthOtpResponseModel(keyHash: keyHash);
  }

  @override
  Future<AuthSignInResponseModel> signInWithOtp({
    required String phone,
    required int code,
    required String keyHash,
  }) async {
    final response = await _dio.post<dynamic>(
      Apis.authSignIn,
      data: <String, dynamic>{
        'phone': phone,
        'code': code,
        'keyHash': keyHash,
      },
      options: Options(extra: <String, dynamic>{skipAuthRefresh: true}),
    );
    final map = _extractDataMap(response.data);
    final access = _readToken(map, keys: const ['accessToken', 'access_token']);
    final refresh = _readToken(
      map,
      keys: const ['refreshToken', 'refresh_token'],
    );
    final type = (map['tokenType'] ?? map['token_type'] ?? 'Bearer').toString();
    if (access.isEmpty || refresh.isEmpty) {
      throw const FormatException('Sign-in response token fields are missing');
    }
    return AuthSignInResponseModel(
      accessToken: access,
      refreshToken: refresh,
      tokenType: type,
    );
  }

  @override
  Future<AuthSignInResponseModel> signInWithGoogle({
    required String idToken,
    required String firstname,
    required String lastname,
  }) async {
    final response = await _dio.post<dynamic>(
      Apis.authGoogle,
      data: <String, dynamic>{
        'idToken': idToken,
        'firstname': firstname,
        'lastname': lastname,
      },
      options: Options(extra: <String, dynamic>{skipAuthRefresh: true}),
    );
    final map = _extractDataMap(response.data);
    final access = _readToken(map, keys: const ['accessToken', 'access_token']);
    final refresh = _readToken(
      map,
      keys: const ['refreshToken', 'refresh_token'],
    );
    final type = (map['tokenType'] ?? map['token_type'] ?? 'Bearer').toString();
    if (access.isEmpty || refresh.isEmpty) {
      throw const FormatException('Sign-in response token fields are missing');
    }
    return AuthSignInResponseModel(
      accessToken: access,
      refreshToken: refresh,
      tokenType: type,
    );
  }

  @override
  Future<AuthRefreshResponseModel> refreshToken({
    required String refreshToken,
  }) async {
    final response = await _dio.post<dynamic>(
      Apis.authRefresh,
      data: <String, dynamic>{'token': refreshToken},
      options: Options(extra: <String, dynamic>{skipAuthRefresh: true}),
    );
    final map = _extractDataMap(response.data);
    final access = _readToken(map, keys: const ['access_token', 'accessToken']);
    final nextRefresh = _readToken(
      map,
      keys: const ['refresh_token', 'refreshToken'],
    );
    final type = (map['token_type'] ?? map['tokenType'] ?? 'Bearer').toString();
    if (access.isEmpty || nextRefresh.isEmpty) {
      throw const FormatException('Refresh response token fields are missing');
    }
    return AuthRefreshResponseModel(
      accessToken: access,
      refreshToken: nextRefresh,
      tokenType: type,
    );
  }

  String _readToken(Map<String, dynamic> map, {required List<String> keys}) {
    for (final key in keys) {
      final value = map[key];
      if (value is String && value.isNotEmpty) return value;
    }
    return '';
  }

  Map<String, dynamic> _asMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) {
      return data.map((key, value) => MapEntry(key.toString(), value));
    }
    throw const FormatException('Unexpected refresh response format');
  }

  Map<String, dynamic> _extractDataMap(dynamic responseData) {
    final root = _asMap(responseData);
    final nestedData = root['data'];
    if (nestedData is Map<String, dynamic>) return nestedData;
    if (nestedData is Map) {
      return nestedData.map((key, value) => MapEntry(key.toString(), value));
    }
    return root;
  }
}
