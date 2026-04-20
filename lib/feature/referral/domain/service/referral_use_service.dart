import 'package:qizlar_academy_mobile/config/logs/app_logger.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/bloc/auth_session_cubit.dart';
import 'package:qizlar_academy_mobile/feature/referral/domain/repository/referral_repository.dart';

/// Deep link orqali kelgan referral kodni boshqaradi:
/// - Guest holatda `SharedPreferences` ga saqlaydi.
/// - Authenticated holatda darhol `POST /api/v1/referral/use` yuboradi.
/// - Login muvaffaqiyatidan keyin pending kodni avtomatik apply qiladi.
class ReferralUseService {
  ReferralUseService(this._repository, this._authCubit);

  final ReferralRepository _repository;
  final AuthSessionCubit _authCubit;

  /// Deep linkdan olingan `ref` qiymatini qabul qiladi.
  /// Authenticated bo'lsa darhol yuboradi, aks holda saqlaydi.
  Future<void> captureReferralCode(String code) async {
    final trimmed = code.trim();
    if (trimmed.isEmpty) return;

    await _repository.savePendingCode(trimmed);
    AppLogger.d('Referral: code captured → $trimmed');

    if (_authCubit.state.isRegistered) {
      await applyPendingIfPossible();
    }
  }

  /// Pending referral kodni API ga yuborishga urinadi.
  /// Muvaffaqiyatli bo'lsa pending tozalanadi, xatoda saqlanib qoladi.
  Future<void> applyPendingIfPossible() async {
    final pending = _repository.readPendingCode();
    if (pending == null) return;

    if (!_authCubit.state.isRegistered) return;

    try {
      await _repository.useReferralCode(code: pending);
      await _repository.clearPendingCode();
      AppLogger.i('Referral: code applied successfully → $pending');
    } catch (error, stackTrace) {
      AppLogger.w(
        'Referral: apply failed, keeping pending',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
