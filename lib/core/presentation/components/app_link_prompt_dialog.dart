import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_primary_confirm_dialog.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_toast.dart';

/// Tashqi havolaga o‘tishdan oldin [showAppPrimaryConfirmDialog] orqali so‘raydi, “Ha” bo‘lsa [launchUrl] chaqiradi.
Future<void> showAppLinkPromptDialog(
  BuildContext context, {
  required String title,
  required String description,
  required String negativeLabel,
  required String positiveLabel,
  required Uri uri,
  String? tgsAsset,
  double tgsSize = 104,
  LaunchMode launchMode = LaunchMode.externalApplication,
  bool barrierDismissible = true,
}) async {
  final confirmed = await showAppPrimaryConfirmDialog(
    context,
    title: title,
    description: description,
    cancelLabel: negativeLabel,
    confirmLabel: positiveLabel,
    tgsAsset: tgsAsset,
    tgsSize: tgsSize,
    barrierDismissible: barrierDismissible,
  );

  if (confirmed != true || !context.mounted) return;

  final launched = await launchUrl(uri, mode: launchMode);
  if (!context.mounted) return;
  if (!launched) {
    AppToast.error(context, message: context.l10n.aboutUsLinkOpenError);
  }
}
