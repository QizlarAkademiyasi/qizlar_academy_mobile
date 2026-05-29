import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/courses/domain/model/course_in_progress_model.dart';

class CoursesInProgressCard extends StatelessWidget {
  const CoursesInProgressCard({super.key, required this.course, required this.onTap});

  final CourseInProgressModel course;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppLiquidStretch(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: AppRadius.radius3xl,
            border: Border.all(color: context.appColors.stroke),
            color: context.appColors.onContainer,
            gradient: LinearGradient(
              colors: [context.appColors.primary.withValues(alpha: 0.3), context.appColors.onContainer.withValues(alpha: 0.05), context.appColors.primary.withValues(alpha: 0.3)],
              stops: [0.0, 0.5, 1.0],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(context.l10n.coursesLastViewed, style: context.textTheme.bodyLargeSemibold.copyWith(color: context.appColors.text)),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.white.withValues(alpha: 0.09), borderRadius: BorderRadius.circular(14)),
                      child: Text(context.l10n.coursesInProgress, style: context.textTheme.bodySmallMedium.copyWith(color: AppColors.primary)),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    ClipRRect(borderRadius: AppRadius.radiusLg, child: _buildCourseImage(context)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            course.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.bodyLargeBold.copyWith(color: context.appColors.text),
                          ),
                          const SizedBox(height: 2),
                          Text(course.moduleTitle, style: context.textTheme.bodyMediumRegular.copyWith(color: context.appColors.secondaryGrey)),
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              minHeight: 7,
                              value: course.progressPercent / 100,
                              backgroundColor: AppColors.white.withValues(alpha: 0.14),
                              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(course.progressLabel, style: context.textTheme.bodySmallRegular.copyWith(color: context.appColors.secondaryGrey)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                PrimaryButton.elevated(
                  label: course.actionLabel,
                  onPressed: onTap,
                  expand: true,
                  height: 48,
                  shape: AppPrimaryButtonShape.roundedRectangle,
                  borderRadius: AppRadius.radius4xl,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCourseImage(BuildContext context) {
    final Widget image = !_hasValidImageUrl(course.imageUrl)
        ? _buildImageFallback(context)
        : AppCachedNetworkImage(imageUrl: course.imageUrl, width: 80, height: 80, fit: BoxFit.cover, fallback: const AppNetworkImageFallbackCourse(iconSize: 24, tintAlpha: 0.08));
    return image;
  }

  Widget _buildImageFallback(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      color: AppColors.primary.withValues(alpha: 0.08),
      child: const Icon(LucideIcons.bookOpen, color: AppColors.primary, size: 24),
    );
  }

  bool _hasValidImageUrl(String imageUrl) {
    final trimmed = imageUrl.trim();
    if (trimmed.isEmpty) return false;
    final parsed = Uri.tryParse(trimmed);
    return parsed != null && parsed.hasScheme && parsed.hasAuthority;
  }
}
