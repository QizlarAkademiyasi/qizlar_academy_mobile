import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_padding.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/screens/course_submit_review/course_submit_review_args.dart';

class CourseSubmitReviewCourseCard extends StatelessWidget {
  const CourseSubmitReviewCourseCard({super.key, required this.args});

  final CourseSubmitReviewArgs args;

  @override
  Widget build(BuildContext context) {
    final category = args.categoryName.trim().toUpperCase();
    return Container(
      width: double.infinity,
      padding: AppPadding.paddingMd,
      decoration: BoxDecoration(
        color: context.appColors.onContainer,
        borderRadius: AppRadius.radius2xl,
        border: Border.all(color: context.appColors.stroke),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: AppRadius.radiusLg,
            child: SizedBox(
              width: 72,
              height: 72,
              child: AppCachedNetworkImage(
                imageUrl: args.thumbnailUrl,
                fit: BoxFit.cover,
                fallback: const AppNetworkImageFallbackAvatar(iconSize: 28, placeholderShowsIcon: false),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (category.isNotEmpty)
                  Text(
                    category,
                    style: context.textTheme.bodySmallSemibold.copyWith(
                      color: AppColors.primary,
                      letterSpacing: 0.6,
                    ),
                  ),
                if (category.isNotEmpty) const SizedBox(height: 4),
                Text(
                  args.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodyLargeSemibold.copyWith(color: context.appColors.text),
                ),
                const SizedBox(height: 4),
                Text(
                  args.teacherName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodyMediumRegular.copyWith(color: context.appColors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
