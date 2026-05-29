import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/model/course_details_model.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/components/course_module_section.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/components/course_progress_card.dart';

class CourseLessonsTab extends StatelessWidget {
  const CourseLessonsTab({
    super.key,
    required this.course,
    this.selectedLessonId,
    this.lessonsLockedUntilEnroll = false,
    this.guestPreviewLessonId,
    this.onGuestLessonAuthRequired,
    this.onLessonTap,
    this.onOpenQuiz,
  });

  final CourseDetailsModel course;
  /// Hozir ko‘rilayotgan / «davom etish» darsi — modul ro‘yxatida ajratiladi.
  final String? selectedLessonId;
  final bool lessonsLockedUntilEnroll;
  final String? guestPreviewLessonId;
  final VoidCallback? onGuestLessonAuthRequired;
  final ValueChanged<String>? onLessonTap;
  final void Function(String lessonId)? onOpenQuiz;

  @override
  Widget build(BuildContext context) {
    final modules = course.modules;
    return Column(
      children: [
        AppStaggeredListItem(
          position: 0,
          duration: AppStaggeredListAnimation.duration,
          delay: AppStaggeredListAnimation.staggerDelay,
          verticalOffset: AppStaggeredListAnimation.verticalSlideOffset,
          child: CourseProgressCard(
            progressLabel: course.progressLessonsText,
            progressSeenText: course.progressSeenText,
            progressTotalText: course.progressDurationText,
            progressRatio: course.progressRatio,
          ),
        ),
        const SizedBox(height: 14),
        for (var i = 0; i < modules.length; i++)
          AppStaggeredListItem(
            position: 1 + i,
            duration: AppStaggeredListAnimation.duration,
            delay: AppStaggeredListAnimation.staggerDelay,
            verticalOffset: AppStaggeredListAnimation.verticalSlideOffset,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: CourseModuleSection(
                module: modules[i],
                allModules: modules,
                sequentialCurriculumEnabled: course.isEnrolled && !lessonsLockedUntilEnroll,
                selectedLessonId: selectedLessonId,
                lessonsLockedUntilEnroll: lessonsLockedUntilEnroll,
                guestPreviewLessonId: guestPreviewLessonId,
                onGuestLessonAuthRequired: onGuestLessonAuthRequired,
                onOpenQuiz: onOpenQuiz,
                onLessonTap: (_, id) {
                  if (onLessonTap != null) {
                    onLessonTap!(id);
                    return;
                  }
                  Gaimon.light();
                },
              ),
            ),
          ),
      ],
    );
  }
}
