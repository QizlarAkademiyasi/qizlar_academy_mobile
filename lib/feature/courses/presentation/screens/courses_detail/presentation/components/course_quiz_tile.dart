import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/model/course_lesson_model.dart';

/// Modul ro‘yxatidagi "Test" qatori (T badge, natija, qulf / qalam / check).
class CourseQuizTile extends StatelessWidget {
  const CourseQuizTile({super.key, required this.lesson, required this.questionCount, required this.onTap, this.forceEnrollmentLock = false, this.guestBlocked = false, this.onGuestAuthRequired});

  final CourseLessonModel lesson;
  final int questionCount;
  final VoidCallback? onTap;
  final bool forceEnrollmentLock;
  final bool guestBlocked;
  final VoidCallback? onGuestAuthRequired;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locked = lesson.isLocked || forceEnrollmentLock || !lesson.isCompleted || guestBlocked;
    final quizCompleted = lesson.hasCompletedLessonQuiz;
    final total = lesson.quizTotalCount ?? (questionCount > 0 ? questionCount : 0);
    final correct = lesson.quizCorrectCount ?? 0;
    final subtitle = total > 0 ? '$correct/$total' : '$questionCount';

    final badgeBorder = quizCompleted
        ? const Border.fromBorderSide(BorderSide(color: Color(0xFF22C55E), width: 2))
        : locked
        ? null
        : Border.fromBorderSide(BorderSide(color: AppColors.primary, width: 2));

    final tile = Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: context.appColors.onContainer,
        borderRadius: AppRadius.radiusXl,
        border: Border.all(color: context.appColors.stroke),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: quizCompleted ? const Color(0xFF22C55E) : context.appColors.background, shape: BoxShape.circle, border: badgeBorder),
            child: Text('T', style: context.textTheme.bodySmallBold.copyWith(color: quizCompleted ? AppColors.white : (locked ? context.appColors.grey : AppColors.primary))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.lessonQuizTestRowTitle, style: context.textTheme.bodyMediumSemibold.copyWith(color: locked ? context.appColors.grey : context.appColors.text, height: 1.25)),
                const SizedBox(height: 6),
                Text(subtitle, style: context.textTheme.bodyXSmallRegular.copyWith(color: context.appColors.grey)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          if (locked)
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.secondaryGrey),
              child: Icon(LucideIcons.lock, size: 18, color: AppColors.white),
            )
          else if (quizCompleted)
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF22C55E)),
              child: const Icon(LucideIcons.check, color: AppColors.white, size: 18),
            )
          else
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primary),
              child: const Icon(LucideIcons.squarePen, color: AppColors.white, size: 18),
            ),
        ],
      ),
    );

    if (quizCompleted) {
      return tile;
    }

    return Bounce(
      tilt: false,
      onTap: () {
        Gaimon.light();
        if (guestBlocked && onGuestAuthRequired != null) {
          onGuestAuthRequired!();
          return;
        }
        if (locked) return;
        onTap?.call();
      },
      child: tile,
    );
  }
}
