import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_padding.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/model/course_details_model.dart';

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
        boxShadow: [BoxShadow(color: context.appColors.shadow.withValues(alpha: 0.05), blurRadius: 2, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppStaggeredListItem(
            position: 0,
            duration: AppStaggeredListAnimation.duration,
            delay: AppStaggeredListAnimation.staggerDelay,
            verticalOffset: AppStaggeredListAnimation.verticalSlideOffset,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Kurs haqida', style: context.textTheme.heading6.copyWith(color: context.appColors.text)),
                const SizedBox(height: 10),
                Html(
                  data: course.description.trim().isEmpty ? '<p></p>' : course.description,
                  shrinkWrap: true,
                  style: {
                    'body': Style(
                      margin: Margins.zero,
                      padding: HtmlPaddings.zero,
                      fontSize: FontSize(context.textTheme.bodyLargeRegular.fontSize ?? 16),
                      color: context.appColors.grey,
                      lineHeight: const LineHeight(1.45),
                    ),
                    'p': Style(margin: Margins.only(bottom: 10), color: context.appColors.grey),
                    'a': Style(color: AppColors.primary),
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          AppStaggeredListItem(
            position: 1,
            duration: AppStaggeredListAnimation.duration,
            delay: AppStaggeredListAnimation.staggerDelay,
            verticalOffset: AppStaggeredListAnimation.verticalSlideOffset,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("O'qituvchi", style: context.textTheme.heading6.copyWith(color: context.appColors.text)),
                const SizedBox(height: 12),
                _TeacherCard(course: course),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TeacherCard extends StatelessWidget {
  const _TeacherCard({required this.course});

  final CourseDetailsModel course;

  /// Kurs kategoriyasi (fan) yoki API `teacherRole` / kurs nomi fallback.
  String get _teacherSubjectLine {
    final category = course.categoryName.trim();
    if (category.isNotEmpty) return category;
    return course.teacherRole.trim();
  }

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
            child: AppCachedNetworkImage(
              imageUrl: course.teacherAvatarUrl,
              width: 48,
              height: 48,
              fit: BoxFit.cover,
              fallback: const AppNetworkImageFallbackAvatar(iconSize: 18, placeholderShowsIcon: false),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(course.teacherName, style: context.textTheme.bodyXLargeSemibold.copyWith(color: context.appColors.text)),
                if (_teacherSubjectLine.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    _teacherSubjectLine,
                    style: context.textTheme.bodyMediumRegular.copyWith(color: context.appColors.grey),
                  ),
                ],
                if (course.teacherDescription.trim().isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    course.teacherDescription,
                    style: context.textTheme.bodyMediumRegular.copyWith(color: context.appColors.grey),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
