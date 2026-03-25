import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_padding.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/courses/domain/model/course_catalog_item_model.dart';

class CoursesListItemCard extends StatelessWidget {
  const CoursesListItemCard({
    super.key,
    required this.course,
    required this.onTap,
  });

  final CourseCatalogItemModel course;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Bounce(
      tilt: false,
      onTap: () {
        Gaimon.selection();
        onTap();
      },
      child: Container(
        padding: AppPadding.paddingSm,
        decoration: BoxDecoration(
          borderRadius: AppRadius.radius3xl,
          border: Border.all(color: context.appColors.stroke),
          color: context.appColors.onContainer,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: course.imageUrl,
                    width: double.infinity,
                    height: 156,
                    fit: BoxFit.cover,
                  ),
                ),
                if (course.tagLabel != null)
                  Positioned(
                    left: 10,
                    bottom: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        course.tagLabel!,
                        style: context.textTheme.bodyXSmallMedium.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.bodyXLargeSemibold.copyWith(
                      color: context.appColors.text,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    course.mentorName,
                    style: context.textTheme.bodySmallRegular.copyWith(
                      color: context.appColors.secondaryGrey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        LucideIcons.star,
                        size: 14,
                        color: Color(0xFFF6C344),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${course.rating.toStringAsFixed(1)} (${_formatReviews(course.reviewsCount)} izohlar)',
                        style: context.textTheme.bodyXSmallRegular.copyWith(
                          color: context.appColors.secondaryGrey,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Icon(
                        LucideIcons.clock3,
                        size: 14,
                        color: context.appColors.secondaryGrey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${course.durationHours} soat',
                        style: context.textTheme.bodyXSmallRegular.copyWith(
                          color: context.appColors.secondaryGrey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatReviews(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return '$count';
  }
}
