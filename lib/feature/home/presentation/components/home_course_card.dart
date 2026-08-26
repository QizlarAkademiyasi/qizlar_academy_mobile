import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_padding.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/course_model.dart';

class HomeCourseCard extends StatelessWidget {
  const HomeCourseCard({
    super.key,
    required this.course,
    this.onTap,
    this.isLoading = false,
    this.rating,
    this.reviewsCount,
    this.margin = const EdgeInsets.only(bottom: 12),
  });

  final CourseModel course;

  /// Bosilganda kurs detallariga o‘tish (masalan context.push).
  final VoidCallback? onTap;
  final bool isLoading;

  /// Berilsa Home’dagi student count o‘rniga reyting qatori chiqadi (AI chat).
  final double? rating;
  final int? reviewsCount;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppLiquidStretch(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Gaimon.selection();
          onTap?.call();
        },
        child: Container(
          margin: margin,
          decoration: BoxDecoration(
            color: context.appColors.onContainer,
            border: Border.all(color: context.appColors.stroke),
            borderRadius: AppRadius.radius3xl,
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow.withValues(alpha: 0.05),
                blurRadius: 2,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Padding(
                padding: AppPadding.paddingMd,
                child: Skeletonizer(
                  enabled: isLoading,
                  child: ClipRRect(
                    borderRadius: AppRadius.radiusXl,
                    child: _homeCourseThumbnail(),
                  ),
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 4,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Skeletonizer(
                        enabled: isLoading,
                        child: Text(
                          course.title,
                          style: context.textTheme.bodyLargeBold.copyWith(
                            color: context.appColors.text,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Skeletonizer(
                        enabled: isLoading,
                        child: Text(
                          course.author,
                          style: context.textTheme.bodySmallRegular.copyWith(
                            color: AppColors.secondaryGrey,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          if (rating != null) ...[
                            const Icon(
                              LucideIcons.star,
                              size: 13,
                              color: AppColors.secondaryGrey,
                            ),
                            const SizedBox(width: 4),
                            Skeletonizer(
                              enabled: isLoading,
                              child: Text(
                                _ratingLabel(rating!, reviewsCount),
                                style: context.textTheme.bodySmallRegular
                                    .copyWith(color: AppColors.secondaryGrey),
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                          const Icon(
                            LucideIcons.clock,
                            size: 13,
                            color: AppColors.secondaryGrey,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Skeletonizer(
                              enabled: isLoading,
                              child: Text(
                                _durationText(l10n, course.durationSeconds),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: context.textTheme.bodySmallRegular
                                    .copyWith(color: AppColors.secondaryGrey),
                              ),
                            ),
                          ),
                          if (rating == null) ...[
                            const SizedBox(width: 8),
                            const Icon(
                              LucideIcons.users,
                              size: 13,
                              color: AppColors.secondaryGrey,
                            ),
                            const SizedBox(width: 4),
                            Skeletonizer(
                              enabled: isLoading,
                              child: Text(
                                _formatStudents(course.studentCount),
                                style: context.textTheme.bodySmallRegular
                                    .copyWith(color: AppColors.secondaryGrey),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _homeCourseThumbnail() {
    final Widget image = course.imageUrl.trim().isEmpty
        ? Container(
            width: 90,
            height: 90,
            color: AppColors.primary.withValues(alpha: 0.1),
            child: const Icon(
              LucideIcons.bookOpen,
              color: AppColors.primary,
              size: 32,
            ),
          )
        : AppCachedNetworkImage(
            imageUrl: course.imageUrl.trim(),
            width: 90,
            height: 90,
            fit: BoxFit.cover,
            alignment: Alignment.centerRight,
            fallback: const AppNetworkImageFallbackCourse(
              iconSize: 32,
              tintAlpha: 0.1,
            ),
          );
    return image;
  }

  static String _ratingLabel(double rating, int? reviewsCount) {
    final value = rating.toStringAsFixed(1);
    if (reviewsCount == null || reviewsCount <= 0) return value;
    return '$value ($reviewsCount)';
  }

  static String _formatStudents(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return '$count';
  }

  String _durationText(AppLocalizations l10n, int totalSeconds) {
    if (totalSeconds <= 0) return l10n.courseDurationMinutes(0);
    final safeSeconds = totalSeconds < 0 ? 0 : totalSeconds;
    final hours = safeSeconds ~/ 3600;
    final minutes = (safeSeconds % 3600) ~/ 60;
    if (hours <= 0) return l10n.courseDurationMinutes(minutes);
    if (minutes == 0) return l10n.myCoursesDurationHours(hours);
    return l10n.courseDurationHoursMinutes(hours, minutes);
  }
}
