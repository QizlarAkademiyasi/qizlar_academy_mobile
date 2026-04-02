import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/user_type.dart';
import 'package:qizlar_academy_mobile/feature/auth/domain/model/auth_session_model.dart';

class AuthSessionState extends Equatable {
  const AuthSessionState({
    required this.isInitialized,
    required this.userType,
    required this.profileGateResolved,
    required this.needsProfileRegistration,
    this.accessToken,
    this.refreshToken,
    this.tokenType = 'Bearer',
  });

  const AuthSessionState.initial()
    : isInitialized = false,
      userType = UserType.guest,
      profileGateResolved = false,
      needsProfileRegistration = false,
      accessToken = null,
      refreshToken = null,
      tokenType = 'Bearer';

  final bool isInitialized;
  final UserType userType;
  final bool profileGateResolved;
  final bool needsProfileRegistration;
  final String? accessToken;
  final String? refreshToken;
  final String tokenType;

  bool get isAnonymous => userType == UserType.guest;
  bool get isRegistered => userType == UserType.user;

  AuthSessionModel toSessionModel() {
    return AuthSessionModel(
      userType: userType,
      accessToken: accessToken,
      refreshToken: refreshToken,
      tokenType: tokenType,
    );
  }

  AuthSessionState fromModel(
    AuthSessionModel model, {
    bool initialized = true,
    bool resetProfileGate = true,
  }) {
    final isGuest = model.userType == UserType.guest;
    final nextProfileGateResolved = resetProfileGate
        ? (isGuest ? true : false)
        : profileGateResolved;
    final nextNeedsProfileRegistration = resetProfileGate
        ? false
        : needsProfileRegistration;

    return copyWith(
      isInitialized: initialized,
      userType: model.userType,
      accessToken: model.accessToken,
      refreshToken: model.refreshToken,
      tokenType: model.tokenType,
      profileGateResolved: nextProfileGateResolved,
      needsProfileRegistration: nextNeedsProfileRegistration,
    );
  }

  AuthSessionState copyWith({
    bool? isInitialized,
    UserType? userType,
    bool? profileGateResolved,
    bool? needsProfileRegistration,
    String? accessToken,
    String? refreshToken,
    String? tokenType,
  }) {
    return AuthSessionState(
      isInitialized: isInitialized ?? this.isInitialized,
      userType: userType ?? this.userType,
      profileGateResolved: profileGateResolved ?? this.profileGateResolved,
      needsProfileRegistration:
          needsProfileRegistration ?? this.needsProfileRegistration,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      tokenType: tokenType ?? this.tokenType,
    );
  }

  @override
  List<Object?> get props => [
    isInitialized,
    userType,
    profileGateResolved,
    needsProfileRegistration,
    accessToken,
    refreshToken,
    tokenType,
  ];
}
