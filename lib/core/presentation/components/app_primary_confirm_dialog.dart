import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/assets/assets.gen.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_modal_dialog.dart';

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
  return AppModalDialog.show<bool>(
    context,
    barrierDismissible: barrierDismissible,
    builder: (dialogContext) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppDialogMascot(
              asset: tgsAsset ?? UiKitAssets.lottie.rabbit.hmmmRabbit,
              size: tgsSize,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppDialogContent.titleStyle(dialogContext),
            ),
            const SizedBox(height: 14),
            Text(
              description,
              textAlign: TextAlign.center,
              style: AppDialogContent.bodyStyle(dialogContext),
            ),
            const SizedBox(height: 28),
            AppDialogActions.rowCancelConfirm(
              context: dialogContext,
              cancelLabel: cancelLabel,
              onCancel: () => Navigator.of(dialogContext).pop(false),
              confirmLabel: confirmLabel,
              onConfirm: () => Navigator.of(dialogContext).pop(true),
            ),
          ],
        ),
      );
    },
  );
}
