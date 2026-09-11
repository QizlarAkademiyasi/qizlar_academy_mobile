import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/home_stats_model.dart';

class HomeStatsSection extends StatelessWidget {
  const HomeStatsSection({
    super.key,
    required this.stats,
    this.isLoading = false,
    this.onCoinsAndGradeTap,
    this.onRatingTap,
  });
  final HomeStatsModel stats;
  final bool isLoading;
  final VoidCallback? onCoinsAndGradeTap, onRatingTap;
  static const double stretchSlack = 12;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: stretchSlack),
    child: AppLiquidStretch(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
        decoration: BoxDecoration(
          color: context.appColors.onContainer.withValues(alpha: .35),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: context.appColors.onContainer.withValues(alpha: .9),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: _Metric(
                value: stats.coins,
                label: context.l10n.homeCoinsLabel,
                icon: LucideIcons.circleStar,
                isLoading: isLoading,
                onTap: onCoinsAndGradeTap,
              ),
            ),
            Expanded(
              child: _Metric(
                value: stats.grade,
                label: context.l10n.homeRatingLabel,
                icon: LucideIcons.flame,
                isLoading: isLoading,
                onTap: onCoinsAndGradeTap,
              ),
            ),
            Expanded(
              child: _Metric(
                value: stats.rating,
                label: context.l10n.homeRankLabel,
                icon: LucideIcons.crown,
                isLoading: isLoading,
                onTap: onRatingTap,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.value,
    required this.label,
    required this.icon,
    required this.isLoading,
    this.onTap,
  });
  final int value;
  final String label;
  final IconData icon;
  final bool isLoading;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          Icon(icon, size: 24, color: context.appColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Skeletonizer(
                  enabled: isLoading,
                  child: Text(
                    '$value',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.bodyMediumBold.copyWith(
                      fontSize: 16,
                      color: context.appColors.text,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: context.textTheme.bodySmallRegular.copyWith(
                    fontSize: 10,
                    color: context.appColors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
