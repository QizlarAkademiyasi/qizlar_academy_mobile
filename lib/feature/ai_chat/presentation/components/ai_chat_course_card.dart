import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_padding.dart';
import 'package:qizlar_academy_mobile/config/constants/app_radius.dart';
import 'package:qizlar_academy_mobile/config/constants/colors.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/theme_extension.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_cached_network_image.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/model/ai_chat_course_model.dart';

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
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.appColors.onContainer,
          border: Border.all(color: context.appColors.stroke),
          borderRadius: AppRadius.radius3xl,
        ),
        child: Row(
          children: [
            Padding(
              padding: AppPadding.paddingMd,
              child: ClipRRect(
                borderRadius: AppRadius.radiusXl,
                child: _thumbnail(),
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
                    Text(
                      course.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.bodyLargeBold.copyWith(
                        color: context.appColors.text,
                      ),
                    ),
                    if (course.mentorName.trim().isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        course.mentorName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.bodySmallRegular.copyWith(
                          color: AppColors.secondaryGrey,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }

  Widget _thumbnail() {
    final url = course.imageUrl.trim();
    if (url.isEmpty) {
      return Container(
        width: 72,
        height: 72,
        color: AppColors.primary.withValues(alpha: 0.1),
        child: const Icon(
          LucideIcons.bookOpen,
          color: AppColors.primary,
          size: 28,
        ),
      );
    }
    return AppCachedNetworkImage(
      imageUrl: url,
      width: 72,
      height: 72,
      fit: BoxFit.cover,
      fallback: const AppNetworkImageFallbackCourse(
        iconSize: 28,
        tintAlpha: 0.1,
      ),
    );
  }
}
