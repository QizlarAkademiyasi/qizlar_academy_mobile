import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/user_type.dart';
import 'package:qizlar_academy_mobile/feature/auth/domain/model/auth_session_model.dart';

class AuthSessionState extends Equatable {
  const AuthSessionState({
    required this.isInitialized,
    required this.userType,
    this.accessToken,
    this.refreshToken,
    this.tokenType = 'Bearer',
  });

  const AuthSessionState.initial()
    : isInitialized = false,
      userType = UserType.anonymous,
      accessToken = null,
      refreshToken = null,
      tokenType = 'Bearer';

  final bool isInitialized;
  final UserType userType;
  final String? accessToken;
  final String? refreshToken;
  final String tokenType;

  bool get isAnonymous => userType == UserType.anonymous;
  bool get isRegistered => userType == UserType.registered;

  AuthSessionModel toSessionModel() {
    return AuthSessionModel(
      userType: userType,
      accessToken: accessToken,
      refreshToken: refreshToken,
      tokenType: tokenType,
    );
  }

  AuthSessionState fromModel(AuthSessionModel model, {bool initialized = true}) {
    return copyWith(
      isInitialized: initialized,
      userType: model.userType,
      accessToken: model.accessToken,
      refreshToken: model.refreshToken,
      tokenType: model.tokenType,
    );
  }

  AuthSessionState copyWith({
    bool? isInitialized,
    UserType? userType,
    String? accessToken,
    String? refreshToken,
    String? tokenType,
  }) {
    return AuthSessionState(
      isInitialized: isInitialized ?? this.isInitialized,
      userType: userType ?? this.userType,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      tokenType: tokenType ?? this.tokenType,
    );
  }

  @override
  List<Object?> get props => [
    isInitialized,
    userType,
    accessToken,
    refreshToken,
    tokenType,
  ];
}
