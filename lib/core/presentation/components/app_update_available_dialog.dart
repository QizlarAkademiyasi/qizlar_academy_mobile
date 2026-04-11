import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart' show AppLocalizationsX;
import 'package:qizlar_academy_mobile/core/assets/assets.gen.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_modal_dialog.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_toast.dart';

/// Yangilanish haqidagi modal — global [AppModalDialog] shell + mascot + stadium tugmalar.
Future<void> showAppUpdateAvailableDialog(BuildContext context, {required Uri storeUri, required bool forceUpdate, String tgsAsset = '', double tgsSize = 120}) async {
  final asset = tgsAsset.isEmpty ? UiKitAssets.lottie.rabbit.loveAndSmileRabbit : tgsAsset;
  await AppModalDialog.show<void>(
    context,
    barrierDismissible: !forceUpdate,
    builder: (dialogContext) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppDialogMascot(asset: asset, size: tgsSize),
            const SizedBox(height: 16),
            Text(dialogContext.l10n.appUpdateAvailableTitle, textAlign: TextAlign.center, style: AppDialogContent.titleStyle(dialogContext)),
            const SizedBox(height: 14),
            Text(dialogContext.l10n.appUpdateAvailableBody, textAlign: TextAlign.center, style: AppDialogContent.bodyStyle(dialogContext)),
            const SizedBox(height: 28),
            AppDialogActions.rowCancelConfirm(
              context: dialogContext,
              cancelLabel: dialogContext.l10n.appUpdateLater,
              onCancel: () => Navigator.of(dialogContext).pop(),
              confirmLabel: dialogContext.l10n.appUpdateCta,
              onConfirm: () => _launchStoreAndMaybeClose(dialogContext, storeUri),
            ),
          ],
        ),
      );
    },
  );
}

Future<void> _launchStoreAndMaybeClose(BuildContext dialogContext, Uri storeUri) async {
  final launched = await launchUrl(storeUri, mode: LaunchMode.externalApplication);
  if (!dialogContext.mounted) return;
  if (launched) {
    Navigator.of(dialogContext).pop();
  } else {
    AppToast.error(dialogContext, message: dialogContext.l10n.aboutUsLinkOpenError);
  }
}
