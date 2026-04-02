import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/config/logs/logs.dart';
import 'package:qizlar_academy_mobile/config/router/app_routes.dart';
import 'package:qizlar_academy_mobile/core/network/auth_otp_phone_api_error.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/bloc/auth_session_cubit.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/components/sign_in_phone_field.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/components/sign_in_social_button.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/screens/verification_args.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/services/guest_tap_gate_service.dart';

mixin SignInScreenMixin<T extends StatefulWidget> on State<T> {
  Future<void> onSignInTap({required String localPhone}) async {
    final normalizedPhone = _digitsOnly(localPhone);
    if (normalizedPhone.length != SignInPhoneField.nationalDigitsLength) {
      AppToast.warning(
        context,
        title: context.l10n.signInPhoneTitle,
        message: context.l10n.signInPhoneIncompleteMessage,
      );
      return;
    }

    final fullPhone = '998$normalizedPhone';
    try {
      final keyHash = await getIt<AuthSessionCubit>().requestOtpForPhone(
        phone: fullPhone,
      );
      if (!mounted) return;
      context.push(
        Routes.verification,
        extra: VerificationArgs(phone: fullPhone, keyHash: keyHash),
      );
    } on DioException catch (error, stackTrace) {
      AppLogger.e(
        'Sign-in OTP request failed',
        error: _buildDioLogPayload(error),
        stackTrace: stackTrace,
      );
      if (!mounted) return;
      final message = isAuthOtpPhoneThrottledResponse(error)
          ? context.l10n.authOtpTooManyRequestsMessage
          : isAuthOtpPhoneOperatorRestrictedResponse(error)
          ? context.l10n.authPhoneOperatorRestrictedMessage
          : context.l10n.connectionErrorMessage;
      AppToast.error(context, message: message);
    } catch (error, stackTrace) {
      AppLogger.e(
        'Unexpected sign-in OTP request failure',
        error: error,
        stackTrace: stackTrace,
      );
      if (!mounted) return;
      AppToast.error(
        context,
        message: context.l10n.connectionErrorMessage,
      );
    }
  }

  void onBackTap() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(Routes.main);
  }

  Future<void> onGoogleTap() async {
    try {
      final googleSignIn = GoogleSignIn.instance;
      final account = await googleSignIn.authenticate();

      final googleAuth = account.authentication;
      final googleIdToken = googleAuth.idToken;

      if ((googleIdToken ?? '').isEmpty) {
        throw Exception('Google Sign-In failed: missing Google idToken');
      }

      // Google token -> Firebase credential -> Firebase ID token.
      final credential = GoogleAuthProvider.credential(
        idToken: googleIdToken,
      );
      final firebaseCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      final firebaseUser = firebaseCredential.user;
      final firebaseIdToken = await firebaseUser?.getIdToken();
      if ((firebaseIdToken ?? '').isEmpty) {
        throw Exception('Google Sign-In failed: Firebase ID token not found');
      }

      final firstname = account.displayName?.split(' ').first ?? 'Google';
      final lastname =
          account.displayName?.split(' ').length != null &&
              account.displayName!.split(' ').length > 1
          ? account.displayName!.split(' ').sublist(1).join(' ')
          : 'User';

      await getIt<AuthSessionCubit>().signInWithGoogle(
        idToken: firebaseIdToken!,
        firstname: firstname,
        lastname: lastname,
      );

      if (!mounted) return;
      await _navigateAfterAuth();
    } on GoogleSignInException catch (error, stackTrace) {
      if (error.code == GoogleSignInExceptionCode.canceled ||
          error.code == GoogleSignInExceptionCode.interrupted ||
          error.code == GoogleSignInExceptionCode.uiUnavailable) {
        AppLogger.i('Google sign-in canceled or unavailable');
        return;
      }
      AppLogger.e(
        'Google sign-in failed',
        error: error,
        stackTrace: stackTrace,
      );
      if (mounted) {
        AppToast.error(
          context,
          message: context.l10n.googleSignInErrorMessage,
        );
      }
    } catch (error, stackTrace) {
      AppLogger.e(
        'Google sign-in unexpected error',
        error: error,
        stackTrace: stackTrace,
      );
      if (mounted) {
        AppToast.error(
          context,
          message: context.l10n.googleSignInErrorMessage,
        );
      }
    }
  }

  Future<void> _navigateAfterAuth() async {
    getIt<GuestTapGateService>().reset();
    await getIt<AuthSessionCubit>().ensureProfileGateResolved();
    if (!mounted) return;
    context.go(Routes.main);
  }

  void onTelegramTap() {
    AppToast.info(
      context,
      title: context.l10n.comingSoonTitle,
      message: context.l10n.telegramSignInComingSoonMessage,
    );
  }

  Widget buildPhoneField(
    BuildContext context, {
    required TextEditingController controller,
    required ValueChanged<String> onChanged,
  }) {
    return SignInPhoneField(controller: controller, onChanged: onChanged);
  }

  Widget buildGoogleButton(
    BuildContext context, {
    bool isLoading = false,
    VoidCallback? onPressed,
  }) {
    return SignInSocialButton(
      provider: SignInSocialProvider.google,
      label: context.l10n.signInWithGoogle,
      onPressed: onPressed ?? () => onGoogleTap(),
      isLoading: isLoading,
    );
  }

  Widget buildTelegramButton(BuildContext context) {
    return SignInSocialButton(
      provider: SignInSocialProvider.telegram,
      label: context.l10n.signInWithTelegram,
      onPressed: onTelegramTap,
    );
  }

  String _digitsOnly(String raw) => raw.replaceAll(RegExp(r'[^0-9]'), '');

  Map<String, dynamic> _buildDioLogPayload(DioException error) {
    final resolvedMessage = error.message?.trim().isNotEmpty == true
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
}
