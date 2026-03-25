import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/feature/courses_detail/domain/model/course_details_model.dart';
import 'package:qizlar_academy_mobile/feature/courses_detail/presentation/components/course_info_tab.dart';
import 'package:qizlar_academy_mobile/feature/courses_detail/presentation/components/course_lessons_tab.dart';
import 'package:qizlar_academy_mobile/feature/courses_detail/presentation/components/course_reviews_tab.dart';
import 'package:qizlar_academy_mobile/config/enum/courses_tab.dart';

mixin CourseDetailsContentMixin on StatelessWidget {
  Widget buildTabContent(
    BuildContext context, {
    required CourseDetailsModel course,
    required CoursesTab selectedTab,
    ValueChanged<String>? onLessonTap,
  }) {
    switch (selectedTab) {
      case CoursesTab.lessons:
        return CourseLessonsTab(
          key: const ValueKey('lessons'),
          course: course,
          onLessonTap: onLessonTap,
        );
      case CoursesTab.info:
        return CourseInfoTab(key: const ValueKey('info'), course: course);
      case CoursesTab.reviews:
        return CourseReviewsTab(key: const ValueKey('reviews'), course: course);
    }
  }
}
