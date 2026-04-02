import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/model/course_details_model.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/components/course_module_section.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/components/course_progress_card.dart';

class CourseLessonsTab extends StatelessWidget {
  const CourseLessonsTab({
    super.key,
    required this.course,
    this.lessonsLockedUntilEnroll = false,
    this.guestPreviewLessonId,
    this.onGuestLessonAuthRequired,
    this.onLessonTap,
    this.onOpenQuiz,
  });

  final CourseDetailsModel course;
  final bool lessonsLockedUntilEnroll;
  final String? guestPreviewLessonId;
  final VoidCallback? onGuestLessonAuthRequired;
  final ValueChanged<String>? onLessonTap;
  final void Function(String lessonId)? onOpenQuiz;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CourseProgressCard(progressLabel: course.progressLessonsText, progressSeenText: course.progressSeenText, progressTotalText: course.progressDurationText, progressRatio: course.progressRatio),
        const SizedBox(height: 14),
        ...course.modules.map(
          (m) => Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: CourseModuleSection(
              module: m,
              lessonsLockedUntilEnroll: lessonsLockedUntilEnroll,
              guestPreviewLessonId: guestPreviewLessonId,
              onGuestLessonAuthRequired: onGuestLessonAuthRequired,
              onOpenQuiz: onOpenQuiz,
              onLessonTap: (id) {
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
