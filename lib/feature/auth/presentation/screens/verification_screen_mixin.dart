import 'dart:async';

import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/config/logs/logs.dart';
import 'package:qizlar_academy_mobile/config/router/app_routes.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/bloc/auth_session_cubit.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/services/guest_tap_gate_service.dart';

mixin VerificationScreenMixin<T extends StatefulWidget> on State<T> {
  static const int _defaultCountdown = 60;

  Timer? _resendTimer;
  int resendSecondsLeft = _defaultCountdown;
  bool isVerifying = false;
  bool isResending = false;

  bool get canResendCode => resendSecondsLeft <= 0 && !isResending;

  void startResendCountdown({int seconds = _defaultCountdown}) {
    _resendTimer?.cancel();
    setState(() => resendSecondsLeft = seconds);
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (resendSecondsLeft <= 0) {
        timer.cancel();
        return;
      }
      setState(() => resendSecondsLeft -= 1);
    });
  }

  String formatResendCountdown() {
    final minute = (resendSecondsLeft ~/ 60).toString().padLeft(2, '0');
    final second = (resendSecondsLeft % 60).toString().padLeft(2, '0');
    return '$minute:$second';
  }

  String formatPhoneForUi(String fullPhone) {
    final digits = fullPhone.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length < 12) return fullPhone;
    final code = digits.substring(0, 3);
    final first = digits.substring(3, 5);
    final second = digits.substring(5, 8);
    final third = digits.substring(8, 10);
    final fourth = digits.substring(10, 12);
    return '+$code $first $second-$third-$fourth';
  }

  Future<void> verifyCode({
    required String phone,
    required String keyHash,
    required String code,
  }) async {
    if (isVerifying) return;
    if (code.length != 6) return;

    final parsedCode = int.tryParse(code);
    if (parsedCode == null) {
      AppToast.warning(
        context,
        message: 'Kod faqat raqamlardan iborat bo‘lishi kerak.',
      );
      return;
    }

    setState(() => isVerifying = true);
    try {
      await getIt<AuthSessionCubit>().signInWithOtp(
        phone: phone,
        code: parsedCode,
        keyHash: keyHash,
      );
      if (!mounted) return;
      await _navigateAfterAuth();
    } on DioException catch (error, stackTrace) {
      AppLogger.e(
        'OTP verification failed',
        error: _buildDioLogPayload(error),
        stackTrace: stackTrace,
      );
      if (!mounted) return;
      AppToast.error(
        context,
        message: 'Ulanishda xatolik yuz berdi. Iltimos, qayta urinib ko‘ring.',
      );
    } catch (error, stackTrace) {
      AppLogger.e(
        'Unexpected OTP verification failure',
        error: error,
        stackTrace: stackTrace,
      );
      if (!mounted) return;
      AppToast.error(
        context,
        message: 'Ulanishda xatolik yuz berdi. Iltimos, qayta urinib ko‘ring.',
      );
    } finally {
      if (mounted) setState(() => isVerifying = false);
    }
  }

  Future<void> _navigateAfterAuth() async {
    getIt<GuestTapGateService>().reset();
    if (!mounted) return;
    context.go(Routes.main);
  }

  Future<String?> resendCode({required String phone}) async {
    if (!canResendCode || isResending) return null;
    setState(() => isResending = true);
    try {
      final keyHash = await getIt<AuthSessionCubit>().requestOtpForPhone(
        phone: phone,
      );
      if (!mounted) return keyHash;
      startResendCountdown();
      AppToast.success(context, message: 'Tasdiqlash kodi qayta yuborildi.');
      return keyHash;
    } on DioException catch (error, stackTrace) {
      AppLogger.e(
        'OTP resend failed',
        error: _buildDioLogPayload(error),
        stackTrace: stackTrace,
      );
      AppToast.error(
        context,
        message: 'Ulanishda xatolik yuz berdi. Iltimos, qayta urinib ko‘ring.',
      );
      return null;
    } catch (error, stackTrace) {
      AppLogger.e(
        'Unexpected OTP resend failure',
        error: error,
        stackTrace: stackTrace,
      );
      AppToast.error(
        context,
        message: 'Ulanishda xatolik yuz berdi. Iltimos, qayta urinib ko‘ring.',
      );
      return null;
    } finally {
      if (mounted) setState(() => isResending = false);
    }
  }

  Map<String, dynamic> _buildDioLogPayload(DioException error) {
    final resolvedMessage =
        error.message?.trim().isNotEmpty == true
        ? error.message
        : error.error?.toString();
    return <String, dynamic>{
      'message': resolvedMessage ?? 'No exception message',
      'type': error.type.name,
      'statusCode': error.response?.statusCode,
      'path': error.requestOptions.path,
      'method': error.requestOptions.method,
      if (error.error != null) 'error': error.error.toString(),
      'responseData': error.response?.data,
    };
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    super.dispose();
  }
}
