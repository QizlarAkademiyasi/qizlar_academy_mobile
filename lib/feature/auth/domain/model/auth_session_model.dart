import 'package:qizlar_academy_mobile/config/constants/enum/user_type.dart';

class AuthSessionModel {
  const AuthSessionModel({required this.userType, this.accessToken, this.refreshToken, this.tokenType = 'Bearer'});

  final UserType userType;
  final String? accessToken;
  final String? refreshToken;
  final String tokenType;

  bool get hasAccessToken => (accessToken ?? '').isNotEmpty;
  bool get hasRefreshToken => (refreshToken ?? '').isNotEmpty;
  bool get isRegistered => userType == UserType.user;
}
