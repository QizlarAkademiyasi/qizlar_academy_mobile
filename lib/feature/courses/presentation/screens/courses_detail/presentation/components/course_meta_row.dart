import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_padding.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/model/course_details_model.dart';

class CourseMetaRow extends StatelessWidget {
  const CourseMetaRow({super.key, required this.course});

  final CourseDetailsModel course;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.paddingTopMd,
      child: Row(
        children: [
          Text(course.rating.toStringAsFixed(1), style: context.textTheme.bodyMediumBold.copyWith(color: AppColors.primary)),
          const SizedBox(width: 6),
          AppRatingStarsRow(
            rating: course.rating,
            iconSize: 14,
            spacing: 2,
            filledColor: AppColors.primary,
            emptyColor: context.appColors.grey,
          ),
          const SizedBox(width: 6),
          Text('(${course.reviewsCount})', style: context.textTheme.bodyMediumRegular.copyWith(color: context.appColors.grey)),
          SizedBox(width: 16),
          _MetaChip(icon: LucideIcons.users, text: _formatStudents(course.studentsCount)),
          const SizedBox(width: 16),
          _MetaChip(icon: LucideIcons.clock, text: course.totalDurationText),
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

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: context.appColors.grey),
        const SizedBox(width: 4),
        Text(text, style: context.textTheme.bodyMediumRegular.copyWith(color: context.appColors.grey)),
      ],
    );
  }
}
