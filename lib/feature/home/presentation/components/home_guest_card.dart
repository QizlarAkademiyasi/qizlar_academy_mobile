import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_gap.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/config/constants/app_margin.dart';
import 'package:qizlar_academy_mobile/config/constants/app_padding.dart';
import 'package:qizlar_academy_mobile/config/constants/app_radius.dart';
import 'package:qizlar_academy_mobile/config/constants/colors.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/theme_extension.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/primary_button.dart';

class HomeGuestCard extends StatelessWidget {
  const HomeGuestCard({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      // Heightni qat'iy cheklamaslik uchun, kartani balandligi kontentga moslashadi,
      // shu bilan birga kichik constraintlarda pastga overflow bo'lmaydi.
      width: double.infinity,
      margin: AppMargin.marginMd,
      padding: AppPadding.paddingXl,
      decoration: BoxDecoration(
        borderRadius: AppRadius.radius2xl,
        color: context.appColors.onContainer,
        border: Border.all(color: context.appColors.stroke),
        boxShadow: [BoxShadow(color: AppColors.shadow.withValues(alpha: 0.005), blurRadius: 2, offset: const Offset(0, 10))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(context.l10n.guestModeTitle, style: context.textTheme.bodyLargeBold.copyWith(color: context.appColors.text)),
          const SizedBox(height: AppGap.gapSm),
          Text(context.l10n.guestModeDescription, style: context.textTheme.bodySmallRegular.copyWith(color: AppColors.secondaryGrey.withValues(alpha: 0.9), height: 1.35)),
          const SizedBox(height: AppGap.gapXs),
          const SizedBox(height: AppGap.gapSm),
          Row(
            children: [
              PrimaryButton.elevated(
                label: context.l10n.homeGuestCardSignIn,
                onPressed: onPressed,
                expand: false,
                height: 24,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
                shape: AppPrimaryButtonShape.roundedRectangle,
                borderRadius: AppRadius.radius5xl,
                textStyle: context.textTheme.bodyMediumSemibold.copyWith(color: AppColors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
