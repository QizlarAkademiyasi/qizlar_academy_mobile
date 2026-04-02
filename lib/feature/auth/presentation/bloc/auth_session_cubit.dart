import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/user_type.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/config/logs/logs.dart';
import 'package:qizlar_academy_mobile/feature/auth/domain/model/auth_session_model.dart';
import 'package:qizlar_academy_mobile/feature/auth/domain/repository/auth_repository.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/bloc/auth_session_state.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/exception/profile_registration_required_exception.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/repository/profile_repository.dart';

class AuthSessionCubit extends Cubit<AuthSessionState> {
  AuthSessionCubit(this._repository) : super(const AuthSessionState.initial());

  final AuthRepository _repository;

  Future<void> loadSession() async {
    final model = await _repository.readSession();
    emit(state.fromModel(model));
  }

  Future<void> continueAsGuest() async {
    final model = await _repository.setAnonymousSession();
    emit(state.fromModel(model));
  }

  Future<String> requestOtpForPhone({required String phone}) {
    return _repository.sendOtpToPhoneNumber(phone: phone);
  }

  Future<void> signInWithOtp({
    required String phone,
    required int code,
    required String keyHash,
  }) async {
    final model = await _repository.signInWithOtp(
      phone: phone,
      code: code,
      keyHash: keyHash,
    );
    emit(state.fromModel(model));
  }

  Future<void> signInWithGoogle({
    required String idToken,
    required String firstname,
    required String lastname,
  }) async {
    final model = await _repository.signInWithGoogle(
      idToken: idToken,
      firstname: firstname,
      lastname: lastname,
    );
    emit(state.fromModel(model));
  }

  Future<void> setRegisteredSession({
    required String accessToken,
    required String refreshToken,
    String tokenType = 'Bearer',
  }) async {
    final model = await _repository.setRegisteredSession(
      accessToken: accessToken,
      refreshToken: refreshToken,
      tokenType: tokenType,
    );
    emit(state.fromModel(model));
  }

  Future<void> clearSession() async {
    await _repository.clearSession();
    emit(state.fromModel(const AuthSessionModel(userType: UserType.guest)));
  }

  Future<String?> refreshAccessToken() async {
    final refreshToken = state.refreshToken;
    if ((refreshToken ?? '').isEmpty) return null;
    try {
      final model = await _repository.refreshToken(refreshToken: refreshToken!);
      emit(state.fromModel(model, resetProfileGate: false));
      return model.accessToken;
    } catch (error, stackTrace) {
      AppLogger.w('Token refresh failed', error: error, stackTrace: stackTrace);
      await clearSession();
      return null;
    }
  }

  Future<void> ensureProfileGateResolved() async {
    if (!state.isRegistered) {
      if (!state.profileGateResolved) {
        emit(
          state.copyWith(
            profileGateResolved: true,
            needsProfileRegistration: false,
          ),
        );
      }
      return;
    }
    if (state.profileGateResolved) return;

    try {
      final overview = await getIt<ProfileRepository>().getProfileOverview();
      final needs = overview.user.firstName.trim().isEmpty;
      emit(
        state.copyWith(
          profileGateResolved: true,
          needsProfileRegistration: needs,
        ),
      );
    } on ProfileRegistrationRequiredException {
      emit(
        state.copyWith(
          profileGateResolved: true,
          needsProfileRegistration: true,
        ),
      );
    } catch (error, stackTrace) {
      AppLogger.w(
        'Profile gate check failed; allowing main',
        error: error,
        stackTrace: stackTrace,
      );
      emit(
        state.copyWith(
          profileGateResolved: true,
          needsProfileRegistration: false,
        ),
      );
    }
  }

  void markProfileRegistrationComplete() {
    emit(
      state.copyWith(
        profileGateResolved: true,
        needsProfileRegistration: false,
      ),
    );
  }
}
