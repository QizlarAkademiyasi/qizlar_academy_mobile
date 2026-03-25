import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/courses/domain/model/course_in_progress_model.dart';

class CoursesInProgressCard extends StatelessWidget {
  const CoursesInProgressCard({
    super.key,
    required this.course,
    required this.onTap,
  });

  final CourseInProgressModel course;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: AppRadius.radius3xl,
        border: Border.all(color: context.appColors.stroke),
        color: context.appColors.onContainer,
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Oxirgi ko‘rilgan',
                    style: context.textTheme.bodyLargeSemibold.copyWith(
                      color: context.appColors.text,
                    ),
                  ),
                ),
                Text(
                  'Jarayonda',
                  style: context.textTheme.bodySmallMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                ClipRRect(
                  borderRadius: AppRadius.radiusLg,
                  child: CachedNetworkImage(
                    imageUrl: course.imageUrl,
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.bodyLargeBold.copyWith(
                          color: context.appColors.text,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        course.moduleTitle,
                        style: context.textTheme.bodySmallRegular.copyWith(
                          color: context.appColors.secondaryGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                minHeight: 7,
                value: course.progressPercent / 100,
                backgroundColor: AppColors.primary.withValues(alpha: 0.14),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              course.progressLabel,
              style: context.textTheme.bodyXSmallRegular.copyWith(
                color: context.appColors.secondaryGrey,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onTap,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(course.actionLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
