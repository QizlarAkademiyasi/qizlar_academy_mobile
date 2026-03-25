import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/home_stats_model.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/components/home_last_lesson_card.dart';

class HomeStatsSection extends StatelessWidget {
  const HomeStatsSection({super.key, required this.stats, this.isLoading = false});

  final HomeStatsModel stats;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _CoinsCard(coins: stats.coins, grade: stats.grade, isLoading: isLoading),
                const SizedBox(height: 12),
                _RatingCard(rating: stats.rating, onTap: () {}, isLoading: isLoading),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: HomeLastLessonCard(
              category: stats.lastLessonCategory,
              progress: stats.lastLessonProgress,
              onTap: () {},
              isLoading: isLoading,
            ),
          ),
        ],
      ),
    );
  }
}

class _CoinsCard extends StatelessWidget {
  const _CoinsCard({required this.coins, required this.grade, this.isLoading = false});

  final int coins;
  final int grade;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Bounce(
      onTap: () {},
      child: Container(
        height: 100,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: context.appColors.onContainer,
          borderRadius: AppRadius.radiusXl,
          border: Border.all(color: context.appColors.stroke, width: 1),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withValues(alpha: 0.05),
              blurRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    LucideIcons.circleStar,
                    color: AppColors.primary,
                    size: 24,
                  ),
                  const SizedBox(height: 8),
                  Skeletonizer(
                    enabled: isLoading,
                    child: Text(
                      '$coins',
                      style: context.textTheme.bodyMediumMedium.copyWith(
                        color: context.appColors.text,
                      ),
                    ),
                  ),
                  Text(
                    'Tangalar',
                    style: context.textTheme.bodySmallMedium.copyWith(
                      color: AppColors.secondaryGrey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    LucideIcons.flame,
                    color: AppColors.primary,
                    size: 24,
                  ),
                  const SizedBox(height: 8),
                  Skeletonizer(
                    enabled: isLoading,
                    child: Text(
                      '$grade',
                      style: context.textTheme.bodyMediumMedium.copyWith(
                        color: context.appColors.text,
                      ),
                    ),
                  ),
                  Text(
                    'Baho',
                    style: context.textTheme.bodySmallMedium.copyWith(
                      color: AppColors.secondaryGrey,
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
}

class _RatingCard extends StatelessWidget {
  const _RatingCard({required this.rating, required this.onTap, this.isLoading = false});

  final int rating;
  final VoidCallback? onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Bounce(
      onTap: () {},
      child: Container(
        height: 100,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: context.appColors.onContainer,
          borderRadius: AppRadius.radiusXl,
          border: Border.all(color: context.appColors.stroke, width: 1),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withValues(alpha: 0.05),
              blurRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(LucideIcons.crown, color: AppColors.primary, size: 24),
              const SizedBox(height: 8),
              Skeletonizer(
                enabled: isLoading,
                child: Text(
                  '$rating',
                  style: context.textTheme.bodyMediumMedium.copyWith(
                    color: context.appColors.text,
                  ),
                ),
              ),
              Text(
                'Reytingdagi o’riningiz',
                style: context.textTheme.bodySmallMedium.copyWith(
                  color: AppColors.secondaryGrey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
