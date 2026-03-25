import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_padding.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/courses_detail/domain/model/course_details_model.dart';
import 'package:qizlar_academy_mobile/feature/courses_detail/domain/model/course_review_model.dart';

class CourseReviewsTab extends StatelessWidget {
  const CourseReviewsTab({super.key, required this.course});

  final CourseDetailsModel course;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SummaryCard(course: course),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: AppPadding.paddingLg,
          decoration: BoxDecoration(
            color: context.appColors.onContainer,
            borderRadius: AppRadius.radius3xl,
            border: Border.all(color: context.appColors.stroke),
            boxShadow: [
              BoxShadow(
                color: context.appColors.shadow.withValues(alpha: 0.05),
                blurRadius: 2,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              for (var i = 0; i < course.reviews.length; i++) ...[
                _ReviewItem(review: course.reviews[i]),
                if (i != course.reviews.length - 1)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Divider(height: 1, color: context.appColors.stroke),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.course});

  final CourseDetailsModel course;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppPadding.paddingLg,
      decoration: BoxDecoration(
        color: context.appColors.onContainer,
        borderRadius: AppRadius.radius3xl,
        border: Border.all(color: context.appColors.stroke),
        boxShadow: [
          BoxShadow(
            color: context.appColors.shadow.withValues(alpha: 0.05),
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 78,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.rating.toStringAsFixed(1),
                  style: context.textTheme.heading2.copyWith(
                    color: context.appColors.text,
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 8),
                _Stars(rating: course.rating, iconSize: 13, spacing: 1),
                const SizedBox(height: 6),
                Text(
                  '${course.reviewsCount} ta sharh',
                  style: context.textTheme.bodySmallRegular.copyWith(
                    color: context.appColors.grey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              children: course.ratingBreakdown
                  .map((item) => _RatingLine(item: item))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _RatingLine extends StatelessWidget {
  const _RatingLine({required this.item});

  final CourseRatingBreakdownModel item;

  @override
  Widget build(BuildContext context) {
    final value = item.percent.clamp(0, 100) / 100;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: Row(
        children: [
          SizedBox(
            width: 10,
            child: Text(
              '${item.stars}',
              style: context.textTheme.bodySmallRegular.copyWith(
                color: context.appColors.grey,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: value,
                minHeight: 4,
                backgroundColor: context.appColors.stroke,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 34,
            child: Text(
              '${item.percent}%',
              textAlign: TextAlign.right,
              style: context.textTheme.bodySmallRegular.copyWith(
                color: context.appColors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewItem extends StatelessWidget {
  const _ReviewItem({required this.review});

  final CourseReviewModel review;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: context.appColors.background,
            border: Border.all(color: context.appColors.stroke),
          ),
          child: Text(
            review.userInitials,
            style: context.textTheme.bodyMediumSemibold.copyWith(
              color: context.appColors.grey,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          review.userName,
                          style: context.textTheme.bodyLargeSemibold.copyWith(
                            color: context.appColors.text,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          review.timeAgo,
                          style: context.textTheme.bodySmallRegular.copyWith(
                            color: context.appColors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _Stars(rating: review.rating.toDouble()),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                review.comment,
                style: context.textTheme.bodyMediumRegular.copyWith(
                  color: context.appColors.grey,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Stars extends StatelessWidget {
  const _Stars({required this.rating, this.iconSize = 14, this.spacing = 2});

  final double rating;
  final double iconSize;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final full = rating.floor().clamp(0, 5);
    final hasHalf = (rating - full) >= 0.5 && full < 5;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final isFull = index < full;
        final isHalf = index == full && hasHalf;
        final color = isFull || isHalf
            ? AppColors.primary
            : context.appColors.stroke;

        return Padding(
          padding: EdgeInsets.only(right: index == 4 ? 0 : spacing),
          child: Icon(
            isHalf ? LucideIcons.starHalf : LucideIcons.star,
            size: iconSize,
            color: color,
          ),
        );
      }),
    );
  }
}
