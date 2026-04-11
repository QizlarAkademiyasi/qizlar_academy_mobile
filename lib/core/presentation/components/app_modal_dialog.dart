import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_radius.dart';
import 'package:qizlar_academy_mobile/config/constants/app_tablet_layout.dart';
import 'package:qizlar_academy_mobile/config/constants/colors.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/theme_extension.dart';
import 'package:qizlar_academy_mobile/core/assets/assets.gen.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/primary_button.dart';

/// Ilova bo‘ylab bir xil modal dialog: barrier, bottom-sheet fon rasmi, chekka, tablet chegarasi.
abstract final class AppModalDialog {
  AppModalDialog._();

  static Color get barrierColor => Colors.black.withValues(alpha: 0.45);

  static Future<T?> show<T>(BuildContext context, {required Widget Function(BuildContext dialogContext) builder, bool barrierDismissible = true}) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      builder: (dialogContext) {
        return PopScope(
          canPop: barrierDismissible,
          child: AppModalDialogShell(child: builder(dialogContext)),
        );
      },
    );
  }
}

/// [AppModalDialog.show] ichidagi konteyner — bottom sheet illustration + border.
class AppModalDialogShell extends StatelessWidget {
  const AppModalDialogShell({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isTablet = AppTabletLayout.isTabletSized(size);
    final horizontalInset = 24.0;
    final safeW = (size.width - horizontalInset * 2).clamp(0.0, double.infinity);
    final maxDialogW = isTablet ? AppTabletLayout.modalMaxWidthPoints.clamp(0.0, safeW) : double.infinity;

    return Dialog(
      backgroundColor: context.appColors.onContainer,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxDialogW),
        child: SizedBox(
          width: double.infinity,
          child: ClipRRect(
            borderRadius: AppRadius.radius3xl,
            child: DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                  alignment: Alignment.topCenter,
                  fit: BoxFit.cover,
                  scale: 1.5,
                  image: context.isDarkTheme ? UiKitAssets.images.bottomSheet.bottomSheetDark.provider() : UiKitAssets.images.bottomSheet.bottomSheetLight.provider(),
                ),
                color: context.appColors.background,
                borderRadius: AppRadius.radius3xl,
                border: Border.all(color: context.appColors.stroke),
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

abstract final class AppDialogContent {
  AppDialogContent._();

  static TextStyle titleStyle(BuildContext context) {
    final isTablet = AppTabletLayout.isTabletSized(MediaQuery.sizeOf(context));
    return context.textTheme.heading6.copyWith(color: context.appColors.text, fontSize: isTablet ? 24 : 21, height: 1.25);
  }

  static TextStyle bodyStyle(BuildContext context) {
    final isTablet = AppTabletLayout.isTabletSized(MediaQuery.sizeOf(context));
    return context.textTheme.bodyLargeRegular.copyWith(color: context.appColors.grey, fontSize: isTablet ? 17 : null, height: 1.4);
  }
}

class AppDialogMascot extends StatelessWidget {
  const AppDialogMascot({required this.asset, super.key, this.size = 104});

  final String asset;
  final double size;

  @override
  Widget build(BuildContext context) {
    final isTablet = AppTabletLayout.isTabletSized(MediaQuery.sizeOf(context));
    final effective = isTablet ? size * 1.35 : size;
    return SizedBox(
      width: effective,
      height: effective,
      child: Lottie.asset(asset, fit: BoxFit.contain),
    );
  }
}

abstract final class AppDialogActions {
  AppDialogActions._();

  static Widget rowCancelConfirm({required BuildContext context, required String cancelLabel, required VoidCallback onCancel, required String confirmLabel, required VoidCallback onConfirm}) {
    final cancelStyle = context.textTheme.heading6.copyWith(color: context.appColors.text);
    final confirmStyle = context.textTheme.heading6.copyWith(color: AppColors.white);
    const pad = EdgeInsets.symmetric(horizontal: 12, vertical: 14);
    return Row(
      children: [
        Expanded(
          child: PrimaryButton.outlined(label: cancelLabel, onPressed: onCancel, expand: true, applyTabletMaxWidth: false, height: 56, padding: pad, textStyle: cancelStyle),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: PrimaryButton.elevated(label: confirmLabel, onPressed: onConfirm, expand: true, applyTabletMaxWidth: false, height: 56, padding: pad, textStyle: confirmStyle),
        ),
      ],
    );
  }

  static Widget primaryFullWidth({required BuildContext context, required String label, required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity,
      child: PrimaryButton.elevated(
        label: label,
        onPressed: onPressed,
        expand: true,
        applyTabletMaxWidth: false,
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        textStyle: context.textTheme.heading6.copyWith(color: AppColors.white),
      ),
    );
  }
}
