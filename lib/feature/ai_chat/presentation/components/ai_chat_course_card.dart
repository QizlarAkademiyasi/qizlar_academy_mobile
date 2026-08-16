import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/theme_extension.dart';
import 'package:qizlar_academy_mobile/core/format/course_duration_format.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_cached_network_image.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/model/ai_chat_course_model.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/presentation/components/ai_chat_glass_surface.dart';

class AiChatCourseCard extends StatelessWidget {
  const AiChatCourseCard({
    super.key,
    required this.course,
    required this.onTap,
  });

  final AiChatCourseModel course;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AiChatGlassSurface(
      radius: 26,
      padding: const EdgeInsets.all(12),
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: AppCachedNetworkImage(
              imageUrl: course.imageUrl,
              width: 82,
              height: 82,
              fit: BoxFit.cover,
              fallback: const AppNetworkImageFallbackCourse(iconSize: 28),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  course.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodyLargeSemibold.copyWith(
                    color: context.appColors.text,
                    height: 1.25,
                  ),
                ),
                if (course.mentorName.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    course.mentorName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.bodySmallRegular.copyWith(
                      color: context.appColors.secondaryGrey,
                    ),
                  ),
                ],
                if (course.reason case final reason?) ...[
                  const SizedBox(height: 5),
                  Text(
                    reason,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.bodyXSmallRegular.copyWith(
                      color: context.appColors.primary,
                      height: 1.25,
                    ),
                  ),
                ],
                if (course.rating != null ||
                    course.durationSeconds != null) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 12,
                    runSpacing: 5,
                    children: [
                      if (course.rating case final rating?)
                        _Meta(
                          icon: LucideIcons.star,
                          label: rating.toStringAsFixed(1),
                        ),
                      if (course.durationSeconds case final duration?)
                        _Meta(
                          icon: LucideIcons.clock3,
                          label: CourseDurationFormat.compactFromTotalSeconds(
                            duration,
                          ),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 6),
          Icon(
            LucideIcons.chevronRight,
            size: 19,
            color: context.appColors.secondaryGrey,
          ),
        ],
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: context.appColors.secondaryGrey),
        const SizedBox(width: 4),
        Text(
          label,
          style: context.textTheme.bodyXSmallMedium.copyWith(
            color: context.appColors.secondaryGrey,
          ),
        ),
      ],
    );
  }
}
