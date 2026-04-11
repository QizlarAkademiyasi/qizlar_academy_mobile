import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_radius.dart';
import 'package:qizlar_academy_mobile/config/constants/colors.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/theme_extension.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/assets/assets.gen.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/primary_button.dart';

/// Chiqishdan oldin saqlanmagan tahrirlar bo‘lsa — saqlash / saqlamaslik / davom etish.
enum EditInformationUnsavedResult {
  cancelled,
  discard,
  save,
}

Future<EditInformationUnsavedResult?> showEditInformationUnsavedDialog(BuildContext context) {
  final l10n = context.l10n;
  return showDialog<EditInformationUnsavedResult>(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withValues(alpha: 0.45),
    builder: (dialogContext) {
      return Dialog(
        backgroundColor: dialogContext.appColors.onContainer,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: ClipRRect(
          borderRadius: AppRadius.radius3xl,
          child: DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                scale: 1.5,
                image: dialogContext.isDarkTheme ? UiKitAssets.images.bottomSheet.bottomSheetDark.provider() : UiKitAssets.images.bottomSheet.bottomSheetLight.provider(),
              ),
              color: dialogContext.appColors.background,
              borderRadius: AppRadius.radius3xl,
              border: Border.all(color: dialogContext.appColors.stroke),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 104,
                    height: 104,
                    child: Lottie.asset(UiKitAssets.lottie.rabbit.hmmmRabbit, fit: BoxFit.contain),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.editProfileUnsavedTitle,
                    textAlign: TextAlign.center,
                    style: dialogContext.textTheme.heading6.copyWith(color: dialogContext.appColors.text, fontSize: 21, height: 1.25),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    l10n.editProfileUnsavedMessage,
                    textAlign: TextAlign.center,
                    style: dialogContext.textTheme.bodyLargeRegular.copyWith(color: dialogContext.appColors.grey, height: 1.4),
                  ),
                  const SizedBox(height: 28),
                  PrimaryButton.elevated(
                    label: l10n.editProfileUnsavedSave,
                    onPressed: () => Navigator.of(dialogContext).pop(EditInformationUnsavedResult.save),
                    expand: true,
                    applyTabletMaxWidth: false,
                    height: 52,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: dialogContext.textTheme.heading6.copyWith(color: AppColors.white),
                  ),
                  const SizedBox(height: 10),
                  PrimaryButton.outlined(
                    label: l10n.editProfileUnsavedDiscard,
                    onPressed: () => Navigator.of(dialogContext).pop(EditInformationUnsavedResult.discard),
                    expand: true,
                    applyTabletMaxWidth: false,
                    height: 52,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    foregroundColor: dialogContext.appColors.text,
                    borderColor: dialogContext.appColors.stroke,
                    textStyle: dialogContext.textTheme.heading6.copyWith(color: dialogContext.appColors.text),
                  ),
                  const SizedBox(height: 8),
                  PrimaryButton.text(
                    label: l10n.editProfileUnsavedContinue,
                    onPressed: () => Navigator.of(dialogContext).pop(EditInformationUnsavedResult.cancelled),
                    expand: true,
                    applyTabletMaxWidth: false,
                    foregroundColor: dialogContext.appColors.secondaryGrey,
                    textStyle: dialogContext.textTheme.bodyMediumSemibold.copyWith(color: dialogContext.appColors.secondaryGrey),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
