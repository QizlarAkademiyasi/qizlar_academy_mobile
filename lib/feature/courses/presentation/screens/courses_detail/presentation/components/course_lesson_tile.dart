import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/model/course_lesson_model.dart';

class CourseLessonTile extends StatelessWidget {
  const CourseLessonTile({super.key, required this.lesson, required this.onTap, this.isActive = false, this.forceEnrollmentLock = false, this.guestPreviewLessonId, this.onGuestAuthRequired});

  final CourseLessonModel lesson;
  final VoidCallback? onTap;
  final bool isActive;

  /// Ro‘yxatdan o‘tgan, lekin kursga hali yozilmagan — barcha darslar qulflangan ko‘rinadi.
  final bool forceEnrollmentLock;

  /// Mehmon: faqat shu id dagi dars ochiq; boshqa darslarda qulf + [onGuestAuthRequired].
  final String? guestPreviewLessonId;
  final VoidCallback? onGuestAuthRequired;

  @override
  Widget build(BuildContext context) {
    final isGuestPreview = guestPreviewLessonId != null && lesson.id == guestPreviewLessonId;
    final enrollmentLocked = ((lesson.isLocked && !isGuestPreview) || forceEnrollmentLock);
    final guestRestricted = guestPreviewLessonId != null && !isGuestPreview && onGuestAuthRequired != null;
    final looksLocked = enrollmentLocked || guestRestricted;
    final badgeBg = looksLocked
        ? context.appColors.stroke
        : isActive
        ? AppColors.primary
        : context.appColors.background;
    final badgeFg = looksLocked
        ? context.appColors.grey
        : isActive
        ? AppColors.white
        : context.appColors.text;

    return Bounce(
      tilt: false,
      onTap: () {
        Gaimon.light();
        if (guestRestricted) {
          onGuestAuthRequired?.call();
          return;
        }
        if (enrollmentLocked) return;
        onTap?.call();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: context.appColors.onContainer,
          borderRadius: AppRadius.radiusXl,
          border: Border.all(color: isActive ? AppColors.primary : context.appColors.stroke),
        ),
        child: Row(
          children: [
            _OrderBadge(order: lesson.order, background: badgeBg, foreground: badgeFg),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.bodyMediumSemibold.copyWith(color: context.appColors.text, height: 1.25),
                  ),
                  const SizedBox(height: 6),
                  Text(lesson.duration, style: context.textTheme.bodyXSmallRegular.copyWith(color: context.appColors.grey)),
                ],
              ),
            ),
            const SizedBox(width: 10),
            if (looksLocked)
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.secondaryGrey),
                child: Icon(LucideIcons.lock, size: 18, color: AppColors.white),
              )
            else if (lesson.isCompleted)
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primary),
                child: const Icon(LucideIcons.play, color: AppColors.white, size: 18),
              )
            else
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primary),
                child: const Icon(LucideIcons.play, color: AppColors.white, size: 18),
              ),
          ],
        ),
      ),
    );
  }
}

class _OrderBadge extends StatelessWidget {
  const _OrderBadge({required this.order, required this.background, required this.foreground});

  final int order;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    final text = order.toString().padLeft(2, '0');

    return Container(
      width: 34,
      height: 34,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(12)),
      child: Text(text, style: context.textTheme.bodySmallBold.copyWith(color: foreground)),
    );
  }
}
