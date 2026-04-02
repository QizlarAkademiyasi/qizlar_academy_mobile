import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_radius.dart';
import 'package:qizlar_academy_mobile/config/constants/colors.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/theme_extension.dart';
import 'package:qizlar_academy_mobile/core/assets/assets.gen.dart';

/// Bottom sheet bilan bir xil fon rasmi + pill tugmalar; tasdiqlash dialoglari uchun.
///
/// Yuqorida doim `.tgs` animatsiya ([Lottie.asset]); boshqa holat uchun [tgsAsset].
Future<bool?> showAppPrimaryConfirmDialog(
  BuildContext context, {
  required String title,
  required String description,
  required String cancelLabel,
  required String confirmLabel,
  String? tgsAsset,
  double tgsSize = 104,
  bool barrierDismissible = true,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: Colors.black.withValues(alpha: 0.45),
    builder: (dialogContext) {
      return _AppPrimaryConfirmDialog(title: title, description: description, cancelLabel: cancelLabel, confirmLabel: confirmLabel, tgsAsset: tgsAsset, tgsSize: tgsSize);
    },
  );
}

class _AppPrimaryConfirmDialog extends StatelessWidget {
  const _AppPrimaryConfirmDialog({required this.title, required this.description, required this.cancelLabel, required this.confirmLabel, this.tgsAsset, this.tgsSize = 104});

  final String title;
  final String description;
  final String cancelLabel;
  final String confirmLabel;
  final String? tgsAsset;
  final double tgsSize;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkTheme;
    final sheetImage = isDark ? UiKitAssets.images.bottomSheet.bottomSheetDark.provider() : UiKitAssets.images.bottomSheet.bottomSheetLight.provider();

    return Dialog(
      backgroundColor: context.appColors.onContainer,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: ClipRRect(
        borderRadius: AppRadius.radius3xl,
        child: DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              scale: 1.5,
              image: context.isDarkTheme ? UiKitAssets.images.bottomSheet.bottomSheetDark.provider() : UiKitAssets.images.bottomSheet.bottomSheetLight.provider(),
            ),
            color: context.appColors.background,
            borderRadius: AppRadius.radius3xl,
            border: Border.all(color: context.appColors.stroke),
          ),
          child: Stack(
            children: [
              // Positioned.fill(
              //   child: DecoratedBox(
              //     decoration: BoxDecoration(
              //       image: DecorationImage(image: sheetImage, fit: BoxFit.cover, scale: 1.5),
              //     ),
              //   ),
              // ),
              // Positioned.fill(
              //   child: DecoratedBox(
              //     decoration: BoxDecoration(
              //       gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppColors.primary.withValues(alpha: 0.22), Colors.black.withValues(alpha: 0.72)]),
              //     ),
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: tgsSize,
                      height: tgsSize,
                      child: Lottie.asset(tgsAsset ?? UiKitAssets.lottie.rabbit.hmmmRabbit, fit: BoxFit.contain),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: context.textTheme.heading6.copyWith(color: context.appColors.text, fontSize: 21, height: 1.25),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      description,
                      textAlign: TextAlign.center,
                      style: context.textTheme.bodyLargeRegular.copyWith(color: context.appColors.grey, height: 1.4),
                    ),
                    const SizedBox(height: 28),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: context.appColors.text,
                              side: BorderSide(color: context.appColors.text),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: const StadiumBorder(),
                            ),
                            child: Text(cancelLabel, style: context.textTheme.heading6.copyWith(color: context.appColors.text)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: const StadiumBorder(),
                            ),
                            child: Text(confirmLabel, style: context.textTheme.heading6.copyWith(color: AppColors.white)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
