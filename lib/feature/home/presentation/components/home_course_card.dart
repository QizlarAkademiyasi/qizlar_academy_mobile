import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/course_model.dart';

class HomeCourseCard extends StatelessWidget {
  const HomeCourseCard({
    super.key,
    required this.course,
    this.onTap,
    this.isLoading = false,
  });

  final CourseModel course;
  final VoidCallback? onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final dark = context.isDarkTheme;
    return AppLiquidStretch(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Gaimon.selection();
          onTap?.call();
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: dark
                ? context.appColors.onContainer
                : AppColors.lightBackground,
            borderRadius: AppRadius.radiusLg,
            boxShadow: homeCourseSoftShadows(context),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Skeletonizer(
                enabled: isLoading,
                child: ClipRRect(
                  borderRadius: AppRadius.radiusMd,
                  child: SizedBox(
                    height: 80,
                    width: double.infinity,
                    child: _cover(),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Skeletonizer(
                enabled: isLoading,
                child: Text(
                  course.title,
                  style: context.textTheme.bodyMediumBold.copyWith(
                    color: context.appColors.text,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 6),
              Skeletonizer(
                enabled: isLoading,
                child: Text(
                  course.author,
                  style: context.textTheme.bodySmallRegular.copyWith(
                    color: AppColors.grey,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(
                    LucideIcons.clock,
                    size: 12,
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
                        style: context.textTheme.bodySmallMedium.copyWith(
                          color: AppColors.secondaryGrey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cover() {
    final url = course.imageUrl.trim();
    if (url.isEmpty) {
      return ColoredBox(
        color: AppColors.primary.withValues(alpha: 0.1),
        child: const Center(
          child: Icon(LucideIcons.bookOpen, color: AppColors.primary, size: 28),
        ),
      );
    }
    return AppCachedNetworkImage(
      imageUrl: url,
      height: 80,
      fit: BoxFit.cover,
      alignment: Alignment.center,
      fallback: const AppNetworkImageFallbackCourse(
        iconSize: 28,
        tintAlpha: 0.1,
      ),
    );
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

List<BoxShadow> homeCourseSoftShadows(BuildContext context) {
  if (context.isDarkTheme) {
    return [
      BoxShadow(
        color: AppColors.shadow.withValues(alpha: 0.35),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ];
  }
  return const [
    BoxShadow(color: Color(0xFFEAEAEA), offset: Offset(3, 3), blurRadius: 8),
    BoxShadow(color: Colors.white, offset: Offset(-3, -3), blurRadius: 8),
  ];
}
