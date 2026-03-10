import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/home_stats_model.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/components/home_last_lesson_card.dart';

class HomeStatsSection extends StatelessWidget {
  const HomeStatsSection({super.key, required this.stats});

  final HomeStatsModel stats;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _CoinsCard(coins: stats.coins)),
              const SizedBox(width: 12),
              Expanded(child: _GradeCard(grade: stats.grade)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: HomeLastLessonCard(
                  category: stats.lastLessonCategory,
                  progress: stats.lastLessonProgress,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: _RatingCard(rating: stats.rating),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CoinsCard extends StatelessWidget {
  const _CoinsCard({required this.coins});

  final int coins;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: AppRadius.radiusMd,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0),
              borderRadius: AppRadius.radiusXs,
            ),
            child: const Icon(LucideIcons.coins, color: Color(0xFFFF9800), size: 20),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$coins',
                style: context.textTheme.heading6.copyWith(
                  color: context.colorScheme.onSurface,
                ),
              ),
              Text(
                'Tangalar',
                style: context.textTheme.bodyXSmallRegular.copyWith(
                  color: AppColors.secondaryGrey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GradeCard extends StatelessWidget {
  const _GradeCard({required this.grade});

  final int grade;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: AppRadius.radiusMd,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: AppRadius.radiusXs,
            ),
            child: const Icon(LucideIcons.star, color: Color(0xFF4CAF50), size: 20),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$grade',
                style: context.textTheme.heading6.copyWith(
                  color: context.colorScheme.onSurface,
                ),
              ),
              Text(
                'Baho',
                style: context.textTheme.bodyXSmallRegular.copyWith(
                  color: AppColors.secondaryGrey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RatingCard extends StatelessWidget {
  const _RatingCard({required this.rating});

  final int rating;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: AppRadius.radiusMd,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(LucideIcons.trophy, color: AppColors.primary, size: 28),
          const SizedBox(height: 8),
          Text(
            '$rating',
            style: context.textTheme.heading6.copyWith(
              color: context.colorScheme.onSurface,
            ),
          ),
          Text(
            'Reyting',
            style: context.textTheme.bodyXSmallRegular.copyWith(
              color: AppColors.secondaryGrey,
            ),
          ),
        ],
      ),
    );
  }
}
