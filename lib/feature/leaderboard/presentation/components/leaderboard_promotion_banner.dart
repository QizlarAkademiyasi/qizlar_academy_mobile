import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

class LeaderboardPromotionBanner extends StatelessWidget {
  const LeaderboardPromotionBanner({
    super.key,
    required this.onStartTap,
  });

  final VoidCallback onStartTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.12),
        borderRadius: AppRadius.radius2xl,
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(
              LucideIcons.star,
              color: AppColors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  context.l10n.promotionTitle,
                  style: context.textTheme.bodyMediumBold.copyWith(
                    color: context.appColors.text,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  context.l10n.promotionSubtitle,
                  style: context.textTheme.bodyXSmallRegular.copyWith(
                    color: context.appColors.grey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Bounce(
            onTap: () {
              Gaimon.light();
              onStartTap();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                context.l10n.promotionStart,
                style: context.textTheme.bodySmallSemibold.copyWith(
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
