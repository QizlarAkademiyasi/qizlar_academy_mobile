import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/config/router/app_routes.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

/// Oxirgi modul tugagach: confetti + sertifikatga yo‘naltirish.
Future<void> showCourseCompleteCongratsDialog(BuildContext context) {
  final rootContext = context;
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withValues(alpha: 0.55),
    builder: (dialogContext) {
      final l10n = dialogContext.l10n;
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: -40,
              right: -40,
              top: -24,
              height: 220,
              child: IgnorePointer(
                child: Lottie.asset(
                  UiKitAssets.lottie.confetti,
                  fit: BoxFit.cover,
                  repeat: true,
                ),
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                color: dialogContext.appColors.onContainer,
                borderRadius: AppRadius.radius3xl,
                border: Border.all(color: dialogContext.appColors.stroke),
                boxShadow: [
                  BoxShadow(
                    color: dialogContext.appColors.shadow.withValues(alpha: 0.12),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.courseCompleteCongratsTitle,
                      textAlign: TextAlign.center,
                      style: dialogContext.textTheme.heading6.copyWith(
                        color: dialogContext.appColors.text,
                        fontSize: 22,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.courseCompleteCongratsDescription,
                      textAlign: TextAlign.center,
                      style: dialogContext.textTheme.bodyLargeRegular.copyWith(
                        color: dialogContext.appColors.grey,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),
                    PrimaryButton.elevated(
                      label: l10n.courseCompleteGetCertificate,
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        Future.microtask(() {
                          if (!rootContext.mounted) return;
                          rootContext.push(Routes.myCertificates);
                        });
                      },
                      expand: true,
                      applyTabletMaxWidth: false,
                      height: 52,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      textStyle: dialogContext.textTheme.heading6.copyWith(color: AppColors.white),
                    ),
                    const SizedBox(height: 10),
                    PrimaryButton.text(
                      label: l10n.courseCompleteClose,
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      expand: true,
                      applyTabletMaxWidth: false,
                      foregroundColor: dialogContext.appColors.grey,
                      textStyle: dialogContext.textTheme.bodyLargeSemibold.copyWith(color: dialogContext.appColors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
