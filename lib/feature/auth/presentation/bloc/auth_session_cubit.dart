import 'dart:async';

import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/enum/user_type.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/config/logs/logs.dart';
import 'package:qizlar_academy_mobile/feature/auth/domain/model/auth_otp_bot_response.dart';
import 'package:qizlar_academy_mobile/feature/personal_info_gate/data/personal_info_gate_checker.dart';
import 'package:qizlar_academy_mobile/feature/auth/domain/model/auth_session_model.dart';
import 'package:qizlar_academy_mobile/feature/auth/domain/repository/auth_repository.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/bloc/auth_session_state.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/exception/profile_registration_required_exception.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/repository/profile_repository.dart';
import 'package:qizlar_academy_mobile/feature/referral/domain/service/referral_use_service.dart';

class AuthSessionCubit extends Cubit<AuthSessionState> {
  AuthSessionCubit(this._repository) : super(const AuthSessionState.initial());

  final AuthRepository _repository;

  /// Bir vaqtning o‘zida bir nechta `ensureProfileGateResolved` chaqiruvlarini
  /// (router redirect, splash, verification, app_bootstrap) bo‘g‘ib qo‘yadi.
  Future<void>? _profileGateInFlight;

  /// Bir nechta API so'rovi bir vaqtda 401 qaytarganda refresh token faqat bir
  /// marta ishlatiladi. Qolgan so'rovlar shu Future natijasini kutadi.
  Future<String?>? _refreshInFlight;

  Future<void> loadSession() async {
    final model = await _repository.readSession();
    emit(state.fromModel(model));
    if (state.isRegistered) {
      unawaited(_applyPendingReferral());
    }
  }

  Future<void> continueAsGuest() async {
    final model = await _repository.setAnonymousSession();
    emit(state.fromModel(model));
  }

  Future<String> requestOtpForPhone({required String phone}) {
    return _repository.sendOtpToPhoneNumber(phone: phone);
  }

  Future<AuthOtpBotResponse> requestTelegramBotOtpForPhone({
    required String phone,
  }) {
    return _repository.sendOtpViaTelegramBot(phone: phone);
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
    unawaited(_applyPendingReferral());
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
    unawaited(_applyPendingReferral());
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
    unawaited(_applyPendingReferral());
  }

  Future<void> _applyPendingReferral() async {
    if (!getIt.isRegistered<ReferralUseService>()) return;
    try {
      await getIt<ReferralUseService>().applyPendingIfPossible();
    } catch (error, stackTrace) {
      AppLogger.w(
        'Referral auto-apply after auth failed',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> clearSession() async {
    await _repository.clearSession();
    if (getIt.isRegistered<PersonalInfoGateChecker>()) {
      await getIt<PersonalInfoGateChecker>().reset();
    }
    emit(state.fromModel(const AuthSessionModel(userType: UserType.guest)));
  }

  Future<String?> refreshAccessToken() {
    final inFlight = _refreshInFlight;
    if (inFlight != null) return inFlight;

    final future = _performAccessTokenRefresh();
    _refreshInFlight = future;
    return future.whenComplete(() {
      if (identical(_refreshInFlight, future)) {
        _refreshInFlight = null;
      }
    });
  }

  Future<String?> _performAccessTokenRefresh() async {
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

  Future<void> ensureProfileGateResolved() {
    if (!state.isRegistered) {
      if (!state.profileGateResolved) {
        emit(
          state.copyWith(
            profileGateResolved: true,
            needsProfileRegistration: false,
          ),
        );
      }
      return Future<void>.value();
    }
    if (state.profileGateResolved) return Future<void>.value();

    final inFlight = _profileGateInFlight;
    if (inFlight != null) return inFlight;

    final future = _resolveProfileGate();
    _profileGateInFlight = future;
    return future.whenComplete(() {
      if (identical(_profileGateInFlight, future)) {
        _profileGateInFlight = null;
      }
    });
  }

  Future<void> _resolveProfileGate() async {
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
