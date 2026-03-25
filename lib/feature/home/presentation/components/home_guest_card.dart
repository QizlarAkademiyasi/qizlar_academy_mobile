import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_gap.dart';
import 'package:qizlar_academy_mobile/config/constants/app_margin.dart';
import 'package:qizlar_academy_mobile/config/constants/app_padding.dart';
import 'package:qizlar_academy_mobile/config/constants/app_radius.dart';
import 'package:qizlar_academy_mobile/config/constants/colors.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/theme_extension.dart';

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
      padding: AppPadding.paddingMd,
      decoration: BoxDecoration(
        borderRadius: AppRadius.radius2xl,
        color: context.appColors.onContainer,
        border: Border.all(color: context.appColors.stroke),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.005),
            blurRadius: 2,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Mehmon rejimi',
            style: context.textTheme.bodyLargeBold.copyWith(
              color: context.appColors.text,
            ),
          ),
          const SizedBox(height: AppGap.gapSm),
          Text(
            "Barcha imkoniyatlardan foydalanish uchun akkaunt\nyarating yoki tizimga kiring.",
            style: context.textTheme.bodySmallRegular.copyWith(
              color: AppColors.secondaryGrey.withValues(alpha: 0.9),
              height: 1.35,
            ),
          ),
          const SizedBox(height: AppGap.gapXs),
          const SizedBox(height: AppGap.gapSm),
          Bounce(
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(85, 26),
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.radius5xl,
                ),
              ),
              child: Text(
                'Kirish',
                style: context.textTheme.bodyMediumSemibold.copyWith(
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
