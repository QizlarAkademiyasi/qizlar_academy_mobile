import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_padding.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/format/review_relative_time.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/model/course_details_model.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/model/course_review_model.dart';

class CourseReviewsTab extends StatelessWidget {
  const CourseReviewsTab({super.key, required this.course});

  final CourseDetailsModel course;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      children: [
        _SummaryCard(course: course, l10n: l10n),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: AppPadding.paddingLg,
          decoration: BoxDecoration(
            color: context.appColors.onContainer,
            borderRadius: AppRadius.radius3xl,
            border: Border.all(color: context.appColors.stroke),
            boxShadow: [BoxShadow(color: context.appColors.shadow.withValues(alpha: 0.05), blurRadius: 2, offset: const Offset(0, 2))],
          ),
          child: course.reviews.isEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      Text(
                        l10n.courseReviewsEmptyTitle,
                        textAlign: TextAlign.center,
                        style: context.textTheme.bodyLargeSemibold.copyWith(color: context.appColors.text),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        l10n.courseReviewsEmptySubtitle,
                        textAlign: TextAlign.center,
                        style: context.textTheme.bodyMediumRegular.copyWith(color: context.appColors.grey, height: 1.4),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    for (var i = 0; i < course.reviews.length; i++) ...[
                      _ReviewItem(review: course.reviews[i], l10n: l10n),
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
  const _SummaryCard({required this.course, required this.l10n});

  final CourseDetailsModel course;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppPadding.paddingXl,
      decoration: BoxDecoration(
        color: context.appColors.onContainer,
        borderRadius: AppRadius.radius2xl,
        border: Border.all(color: context.appColors.stroke),
        boxShadow: [BoxShadow(color: context.appColors.shadow.withValues(alpha: 0.05), blurRadius: 2, offset: const Offset(0, 2))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 30,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.center,
                  child: Text(course.rating.toStringAsFixed(1), maxLines: 1, softWrap: false, style: context.textTheme.heading2.copyWith(color: context.appColors.text)),
                ),
                const SizedBox(height: 8),
                AppRatingStarsRow(rating: course.rating, iconSize: 13, spacing: 1, filledColor: AppColors.primary, emptyColor: context.appColors.grey, mainAxisAlignment: MainAxisAlignment.center),
                const SizedBox(height: 6),
                Text(l10n.courseReviewsSummaryCount(course.reviewsCount), style: context.textTheme.bodySmallRegular.copyWith(color: context.appColors.grey)),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 70,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: course.ratingBreakdown.map((item) => _RatingLine(item: item)).toList(),
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
          AppRatingStarsRow(rating: item.stars.toDouble(), showHalfStars: false, iconSize: 10, spacing: 1, filledColor: AppColors.primary, emptyColor: context.appColors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(value: value, minHeight: 4, backgroundColor: context.appColors.stroke, valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary)),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 34,
            child: Text(
              '${item.percent}%',
              textAlign: TextAlign.right,
              style: context.textTheme.bodySmallRegular.copyWith(color: context.appColors.grey),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewItem extends StatelessWidget {
  const _ReviewItem({required this.review, required this.l10n});

  final CourseReviewModel review;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final timeLabel = reviewRelativeTimeLabel(l10n, review.createdAt);
    final grey = context.appColors.grey;
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
          child: Text(review.userInitials, style: context.textTheme.bodyMediumSemibold.copyWith(color: grey)),
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
                        Text(review.userName, style: context.textTheme.bodyLargeSemibold.copyWith(color: context.appColors.text)),
                        if (timeLabel.isNotEmpty) ...[const SizedBox(height: 2), Text(timeLabel, style: context.textTheme.bodySmallRegular.copyWith(color: grey))],
                      ],
                    ),
                  ),
                  AppRatingStarsRow(rating: review.rating.toDouble(), filledColor: AppColors.primary, emptyColor: context.appColors.grey),
                ],
              ),
              const SizedBox(height: 8),
              Html(
                data: review.commentHtml.trim().isEmpty ? '<p></p>' : review.commentHtml,
                shrinkWrap: true,
                style: {
                  'body': Style(margin: Margins.zero, padding: HtmlPaddings.zero, fontSize: FontSize(context.textTheme.bodyMediumRegular.fontSize ?? 14), color: grey),
                  'p': Style(margin: Margins.only(bottom: 8), color: grey),
                  'li': Style(color: grey),
                  'span': Style(color: grey),
                  'a': Style(color: AppColors.primary),
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
