import 'dart:async';

import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/config/logs/logs.dart';
import 'package:qizlar_academy_mobile/core/format/phone_display_format.dart';
import 'package:qizlar_academy_mobile/core/network/auth_otp_phone_api_error.dart';
import 'package:qizlar_academy_mobile/core/network/auth_signin_api_error.dart';
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
  bool otpPinError = false;

  bool get canResendCode => resendSecondsLeft <= 0 && !isResending;

  /// Bo'sh maydonlarda qizil holatni saqlab, foydalanuvchi yozishni boshlaganda errorni olib tashlaydi.
  void onOtpPinEdited(String value) {
    if (!otpPinError || value.isEmpty) return;
    setState(() => otpPinError = false);
  }

  void resetOtpPinErrorState() {
    if (!otpPinError) return;
    setState(() => otpPinError = false);
  }

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

  String formatPhoneForUi(String fullPhone) => formatPhoneForDisplay(fullPhone);

  Future<void> requestVerificationExit(BuildContext context) async {
    final l10n = context.l10n;
    final confirmed = await showAppPrimaryConfirmDialog(
      context,
      title: l10n.verificationBackConfirmTitle,
      description: l10n.verificationBackConfirmMessage,
      cancelLabel: l10n.verificationBackConfirmStay,
      confirmLabel: l10n.verificationBackConfirmLeave,
    );
    if (confirmed == true && context.mounted) {
      context.pop();
    }
  }

  Future<void> verifyCode({
    required String phone,
    required String keyHash,
    required String code,
    VoidCallback? onOtpRejectedByServer,
  }) async {
    if (isVerifying) return;
    if (code.length != 6) return;

    final parsedCode = int.tryParse(code);
    if (parsedCode == null) {
      AppToast.warning(
        context,
        message: context.l10n.otpDigitsOnlyMessage,
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
      if (isAuthSignInOtpRejectedResponse(error)) {
        Gaimon.error();
        onOtpRejectedByServer?.call();
        setState(() => otpPinError = true);
        AppToast.error(
          context,
          message: context.l10n.otpInvalidOrExpiredMessage,
        );
        return;
      }
      setState(() => otpPinError = false);
      final message = isAuthOtpPhoneOperatorRestrictedResponse(error)
          ? context.l10n.authPhoneOperatorRestrictedMessage
          : context.l10n.connectionErrorMessage;
      AppToast.error(context, message: message);
    } catch (error, stackTrace) {
      AppLogger.e(
        'Unexpected OTP verification failure',
        error: error,
        stackTrace: stackTrace,
      );
      if (!mounted) return;
      setState(() => otpPinError = false);
      AppToast.error(
        context,
        message: context.l10n.connectionErrorMessage,
      );
    } finally {
      if (mounted) setState(() => isVerifying = false);
    }
  }

  Future<void> _navigateAfterAuth() async {
    getIt<GuestTapGateService>().reset();
    await getIt<AuthSessionCubit>().ensureProfileGateResolved();
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
      AppToast.success(context, message: context.l10n.otpSentAgain);
      return keyHash;
    } on DioException catch (error, stackTrace) {
      AppLogger.e(
        'OTP resend failed',
        error: _buildDioLogPayload(error),
        stackTrace: stackTrace,
      );
      if (mounted) {
        final message = isAuthOtpPhoneThrottledResponse(error)
            ? context.l10n.authOtpTooManyRequestsMessage
            : isAuthOtpPhoneOperatorRestrictedResponse(error)
            ? context.l10n.authPhoneOperatorRestrictedMessage
            : context.l10n.connectionErrorMessage;
        AppToast.error(context, message: message);
      }
      return null;
    } catch (error, stackTrace) {
      AppLogger.e(
        'Unexpected OTP resend failure',
        error: error,
        stackTrace: stackTrace,
      );
      AppToast.error(
        context,
        message: context.l10n.connectionErrorMessage,
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
