import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_padding.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/courses_detail/domain/model/course_details_model.dart';

class CourseMetaRow extends StatelessWidget {
  const CourseMetaRow({super.key, required this.course});

  final CourseDetailsModel course;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.paddingTopMd,
      child: Row(
        children: [
          Text(
            course.rating.toStringAsFixed(1),
            style: context.textTheme.bodyMediumBold.copyWith(
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 6),
          _Stars(rating: course.rating),
          const SizedBox(width: 6),
          Text(
            '(${course.reviewsCount})',
            style: context.textTheme.bodyMediumRegular.copyWith(
              color: context.appColors.grey,
            ),
          ),
          SizedBox(width: 16),
          _MetaChip(
            icon: LucideIcons.users,
            text: _formatStudents(course.studentsCount),
          ),
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
        Text(
          text,
          style: context.textTheme.bodyMediumRegular.copyWith(
            color: context.appColors.grey,
          ),
        ),
      ],
    );
  }
}

class _Stars extends StatelessWidget {
  const _Stars({required this.rating});

  final double rating;

  @override
  Widget build(BuildContext context) {
    final full = rating.floor().clamp(0, 5);
    final hasHalf = (rating - full) >= 0.5 && full < 5;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final isFull = i < full;
        final isHalf = i == full && hasHalf;

        if (isFull) {
          return const Padding(
            padding: EdgeInsets.only(right: 2),
            child: Icon(LucideIcons.star, size: 14, color: AppColors.primary),
          );
        }
        if (isHalf) {
          return Padding(
            padding: const EdgeInsets.only(right: 2),
            child: Icon(
              LucideIcons.starHalf,
              size: 14,
              color: AppColors.primary,
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.only(right: 2),
          child: Icon(
            LucideIcons.star,
            size: 14,
            color: context.appColors.stroke,
          ),
        );
      }),
    );
  }
}
