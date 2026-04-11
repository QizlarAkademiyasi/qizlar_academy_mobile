import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_padding.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/model/course_lesson_model.dart';

/// Modul ro‘yxatidagi "Test" qatori (T squircle, natija, qulf / qalam / check).
class CourseQuizTile extends StatelessWidget {
  const CourseQuizTile({
    super.key,
    required this.lesson,
    required this.questionCount,
    required this.onTap,
    this.forceEnrollmentLock = false,
    this.guestBlocked = false,
    this.onGuestAuthRequired,
    this.modulePrerequisiteLocked = false,
    this.onModulePrerequisiteBlocked,
  });

  final CourseLessonModel lesson;
  final int questionCount;
  final VoidCallback? onTap;
  final bool forceEnrollmentLock;
  final bool guestBlocked;
  final VoidCallback? onGuestAuthRequired;
  final bool modulePrerequisiteLocked;
  final VoidCallback? onModulePrerequisiteBlocked;

  static const double _leadingSize = 40;
  static const double _leadingRadius = 12;
  static const double _trailingActionSize = 24;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final quizCompleted = lesson.hasCompletedLessonQuiz;
    final locked = modulePrerequisiteLocked || guestBlocked || lesson.isLocked || forceEnrollmentLock || (!quizCompleted && !lesson.isCompleted);
    final total = lesson.quizTotalCount ?? (questionCount > 0 ? questionCount : 0);
    final correct = lesson.quizCorrectCount ?? 0;
    final subtitle = total > 0 ? '$correct/$total' : '$questionCount';

    final titleColor = (locked && !quizCompleted) ? context.appColors.grey : context.appColors.text;

    final row = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _QuizLeadingBadge(quizCompleted: quizCompleted, locked: locked && !quizCompleted, isDark: isDark),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.lessonQuizTestRowTitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.bodyMediumSemibold.copyWith(color: titleColor, height: 1.25),
              ),
              const SizedBox(height: 4),
              Text(subtitle, style: context.textTheme.bodySmallRegular.copyWith(color: context.appColors.grey)),
            ],
          ),
        ),
        const SizedBox(width: 10),
        if (quizCompleted)
          Container(
            width: _trailingActionSize,
            height: _trailingActionSize,
            decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.quizSuccess),
            child: const Icon(LucideIcons.check, color: AppColors.white, size: 12),
          )
        else if (locked)
          Container(
            width: _trailingActionSize,
            height: _trailingActionSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark ? AppColors.curriculumLessonLockedSurfaceDark : AppColors.curriculumLessonLockedSurfaceLight,
            ),
            child: Icon(
              LucideIcons.lock,
              size: 12,
              color: isDark ? AppColors.curriculumLessonLockedFgDark : AppColors.curriculumLessonLockedFgLight,
            ),
          )
        else
          Container(
            width: _trailingActionSize,
            height: _trailingActionSize,
            decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primary),
            child: const Icon(LucideIcons.squarePen, color: AppColors.white, size: 12),
          ),
      ],
    );

    final tile = Padding(
      padding: AppPadding.paddingLg.copyWith(top: 14, bottom: 14),
      child: row,
    );

    if (quizCompleted) {
      return tile;
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Gaimon.light();
        if (modulePrerequisiteLocked) {
          onModulePrerequisiteBlocked?.call();
          return;
        }
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

class _QuizLeadingBadge extends StatelessWidget {
  const _QuizLeadingBadge({required this.quizCompleted, required this.locked, required this.isDark});

  final bool quizCompleted;
  final bool locked;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    if (quizCompleted) {
      return Container(
        width: CourseQuizTile._leadingSize,
        height: CourseQuizTile._leadingSize,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: AppColors.quizSuccess, borderRadius: BorderRadius.circular(CourseQuizTile._leadingRadius)),
        child: Text('T', style: context.textTheme.bodySmallBold.copyWith(color: AppColors.white)),
      );
    }

    if (locked) {
      return Container(
        width: CourseQuizTile._leadingSize,
        height: CourseQuizTile._leadingSize,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isDark ? AppColors.curriculumLessonLockedSurfaceDark : AppColors.curriculumLessonLockedSurfaceLight,
          borderRadius: BorderRadius.circular(CourseQuizTile._leadingRadius),
        ),
        child: Text(
          'T',
          style: context.textTheme.bodySmallBold.copyWith(
            color: isDark ? AppColors.curriculumLessonLockedFgDark : AppColors.curriculumLessonLockedFgLight,
          ),
        ),
      );
    }

    return Container(
      width: CourseQuizTile._leadingSize,
      height: CourseQuizTile._leadingSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: context.appColors.onContainer,
        borderRadius: BorderRadius.circular(CourseQuizTile._leadingRadius),
        border: Border.all(color: AppColors.primary, width: 2),
      ),
      child: Text('T', style: context.textTheme.bodySmallBold.copyWith(color: AppColors.primary)),
    );
  }
}
