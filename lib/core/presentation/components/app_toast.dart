import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:qizlar_academy_mobile/config/enum/app_toast_type.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

/// Ilova bo'ylab yagona toast API.
/// SnackBar o'rniga shu helperdan foydalaniladi.
abstract class AppToast {
  AppToast._();

  static void success(
    BuildContext context, {
    required String message,
    String? title,
  }) {
    _show(context, type: AppToastType.success, message: message, title: title);
  }

  static void error(
    BuildContext context, {
    required String message,
    String? title,
  }) {
    _show(context, type: AppToastType.error, message: message, title: title);
  }

  static void warning(
    BuildContext context, {
    required String message,
    String? title,
  }) {
    _show(context, type: AppToastType.warning, message: message, title: title);
  }

  static void info(
    BuildContext context, {
    required String message,
    String? title,
  }) {
    _show(context, type: AppToastType.info, message: message, title: title);
  }

  static void _show(
    BuildContext context, {
    required AppToastType type,
    required String message,
    String? title,
  }) {
    DelightToastBar(
      autoDismiss: true,
      snackbarDuration: const Duration(milliseconds: 2600),
      position: DelightSnackbarPosition.top,
      builder: (_) => _AppToastCard(
        type: type,
        title: title ?? _defaultTitle(type),
        message: message,
      ),
    ).show(context);
  }

  static String _defaultTitle(AppToastType type) {
    return switch (type) {
      AppToastType.success => 'Muvaffaqiyatli',
      AppToastType.error => 'Xatolik',
      AppToastType.warning => 'Ogohlantirish',
      AppToastType.info => 'Ma\'lumot',
    };
  }
}

class _AppToastCard extends StatelessWidget {
  const _AppToastCard({
    required this.type,
    required this.title,
    required this.message,
  });

  final AppToastType type;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final scheme = _ToastVisualScheme.from(type);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: context.appColors.onContainer,
        borderRadius: AppRadius.radius2xl,
        border: Border.all(color: scheme.borderColor),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.09),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 46,
            height: 46,
            child: Lottie.asset(
              scheme.tgsAsset,
              fit: BoxFit.contain,
              repeat: true,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodyMediumSemibold.copyWith(
                    color: scheme.titleColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  message,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodySmallRegular.copyWith(
                    color: context.appColors.text,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ToastVisualScheme {
  const _ToastVisualScheme({
    required this.borderColor,
    required this.titleColor,
    required this.tgsAsset,
  });

  final Color borderColor;
  final Color titleColor;
  final String tgsAsset;

  factory _ToastVisualScheme.from(AppToastType type) {
    return switch (type) {
      AppToastType.success => _ToastVisualScheme(
        borderColor: Color(0xFF86D39E),
        titleColor: Color(0xFF2E7D32),
        tgsAsset: UiKitAssets.lottie.rabbit.greatRabbit,
      ),
      AppToastType.error => _ToastVisualScheme(
        borderColor: Color(0xFFEFA4A1),
        titleColor: Color(0xFFB3261E),
        tgsAsset: UiKitAssets.lottie.rabbit.cryedRabbit,
      ),
      AppToastType.warning => _ToastVisualScheme(
        borderColor: Color(0xFFFFDA8A),
        titleColor: Color(0xFFB26A00),
        tgsAsset: UiKitAssets.lottie.rabbit.whatRabbit,
      ),
      AppToastType.info => _ToastVisualScheme(
        borderColor: AppColors.primary,
        titleColor: AppColors.otherPink,
        tgsAsset: UiKitAssets.lottie.rabbit.hiRabbit,
      ),
    };
  }
}
