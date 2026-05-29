import 'dart:async';

import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/analytics/meta_analytics_service.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/config/logs/logs.dart';
import 'package:qizlar_academy_mobile/config/router/app_routes.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/bloc/auth_session_cubit.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/repository/profile_repository.dart';

mixin RegisterScreenMixin<T extends StatefulWidget> on State<T> {
  bool isSubmitting = false;

  Future<void> onBackTap() async {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(Routes.main);
  }

  Future<void> onContinueTap({
    required String firstName,
    required String lastName,
  }) async {
    if (isSubmitting) return;

    final trimmedFirst = firstName.trim();
    final trimmedLast = lastName.trim();

    if (trimmedFirst.isEmpty) {
      AppToast.warning(context, message: context.l10n.enterFirstName);
      return;
    }
    if (trimmedLast.isEmpty) {
      AppToast.warning(context, message: context.l10n.enterLastName);
      return;
    }

    setState(() => isSubmitting = true);
    try {
      await getIt<ProfileRepository>().updatePersonalInfo(
        firstName: trimmedFirst,
        lastName: trimmedLast,
      );

      if (!mounted) return;
      getIt<AuthSessionCubit>().markProfileRegistrationComplete();
      unawaited(
        getIt<MetaAnalyticsService>().logCompletedRegistration(
          method: 'phone_otp',
        ),
      );
      if (!mounted) return;
      context.go(Routes.main);
    } on DioException catch (error, stackTrace) {
      AppLogger.e(
        'Register personal info failed',
        error: error,
        stackTrace: stackTrace,
      );
      if (!mounted) return;
      AppToast.error(
        context,
        message: context.l10n.saveProfileErrorMessage,
      );
    } catch (error, stackTrace) {
      AppLogger.e(
        'Register personal info unexpected error',
        error: error,
        stackTrace: stackTrace,
      );
      if (!mounted) return;
      AppToast.error(
        context,
        message: context.l10n.saveProfileErrorMessage,
      );
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }
}

