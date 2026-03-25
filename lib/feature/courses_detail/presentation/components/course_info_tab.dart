import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_padding.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/courses_detail/domain/model/course_details_model.dart';

class CourseInfoTab extends StatelessWidget {
  const CourseInfoTab({super.key, required this.course});

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kurs haqida',
            style: context.textTheme.heading6.copyWith(
              color: context.appColors.text,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            course.description,
            style: context.textTheme.bodyLargeRegular.copyWith(
              color: context.appColors.grey,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 22),
          Text(
            "O'qituvchi",
            style: context.textTheme.heading6.copyWith(
              color: context.appColors.text,
            ),
          ),
          const SizedBox(height: 12),
          _TeacherCard(course: course),
        ],
      ),
    );
  }
}

class _TeacherCard extends StatelessWidget {
  const _TeacherCard({required this.course});

  final CourseDetailsModel course;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: context.appColors.background,
        borderRadius: AppRadius.radiusXl,
        border: Border.all(color: context.appColors.stroke),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: CachedNetworkImage(
              imageUrl: course.teacherAvatarUrl,
              width: 48,
              height: 48,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                width: 48,
                height: 48,
                color: context.appColors.stroke,
              ),
              errorWidget: (context, url, error) => Container(
                width: 48,
                height: 48,
                color: context.appColors.stroke,
                child: Icon(
                  LucideIcons.user,
                  color: context.appColors.grey,
                  size: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.teacherName,
                  style: context.textTheme.bodyXLargeSemibold.copyWith(
                    color: context.appColors.text,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  course.teacherDescription,
                  style: context.textTheme.bodyMediumRegular.copyWith(
                    color: context.appColors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
