import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/model/course_details_model.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/components/course_details_content.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/components/course_info_tab.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/components/course_lessons_tab.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/components/course_reviews_tab.dart';
import 'package:qizlar_academy_mobile/config/enum/courses_tab.dart';

mixin CourseDetailsContentMixin on State<CourseDetailsContent> {
  CourseDetailsModel get _course => widget.course;

  /// [PageView] sahifasi — bitta tab kontenti.
  Widget buildTabPage(
    BuildContext context,
    CoursesTab tab, {
    ValueChanged<String>? onLessonTap,
    void Function(String lessonId)? onOpenQuiz,
    bool lessonsLockedUntilEnroll = false,
    String? guestPreviewLessonId,
    VoidCallback? onGuestLessonAuthRequired,
    String? selectedCurriculumLessonId,
  }) {
    switch (tab) {
      case CoursesTab.lessons:
        return CourseLessonsTab(
          key: const ValueKey('lessons'),
          course: _course,
          selectedLessonId: selectedCurriculumLessonId,
          lessonsLockedUntilEnroll: lessonsLockedUntilEnroll,
          guestPreviewLessonId: guestPreviewLessonId,
          onGuestLessonAuthRequired: onGuestLessonAuthRequired,
          onLessonTap: onLessonTap,
          onOpenQuiz: onOpenQuiz,
        );
      case CoursesTab.info:
        return CourseInfoTab(key: const ValueKey('info'), course: _course);
      case CoursesTab.reviews:
        return CourseReviewsTab(key: const ValueKey('reviews'), course: _course);
    }
  }
}
