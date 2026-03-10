import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/course_model.dart';

class HomeCourseCard extends StatelessWidget {
  const HomeCourseCard({super.key, required this.course});

  final CourseModel course;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
            child: CachedNetworkImage(
              imageUrl: course.imageUrl,
              width: 90,
              height: 90,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                width: 90,
                height: 90,
                color: AppColors.primary.withValues(alpha: 0.1),
                child: const Icon(LucideIcons.bookOpen, color: AppColors.primary, size: 32),
              ),
              errorWidget: (context, url, error) => Container(
                width: 90,
                height: 90,
                color: AppColors.primary.withValues(alpha: 0.1),
                child: const Icon(LucideIcons.bookOpen, color: AppColors.primary, size: 32),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    style: context.textTheme.bodyMediumSemibold.copyWith(
                      color: context.colorScheme.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    course.author,
                    style: context.textTheme.bodySmallRegular.copyWith(
                      color: AppColors.secondaryGrey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(LucideIcons.clock, size: 12, color: AppColors.secondaryGrey),
                      const SizedBox(width: 4),
                      Text(
                        '${course.durationHours} soat',
                        style: context.textTheme.bodyXSmallRegular.copyWith(
                          color: AppColors.secondaryGrey,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(LucideIcons.users, size: 12, color: AppColors.secondaryGrey),
                      const SizedBox(width: 4),
                      Text(
                        _formatStudents(course.studentCount),
                        style: context.textTheme.bodyXSmallRegular.copyWith(
                          color: AppColors.secondaryGrey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }

  String _formatStudents(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return '$count';
  }
}
