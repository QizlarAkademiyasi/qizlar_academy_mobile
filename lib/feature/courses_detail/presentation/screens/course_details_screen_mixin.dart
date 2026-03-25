import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/config/router/app_routes.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/services/guest_tap_gate_service.dart';
import 'package:qizlar_academy_mobile/feature/courses_detail/domain/model/course_details_model.dart';
import 'package:qizlar_academy_mobile/feature/courses_detail/presentation/components/course_details_content.dart';
import 'package:qizlar_academy_mobile/feature/courses_detail/presentation/screens/course_lesson_player_args.dart';
import 'package:qizlar_academy_mobile/feature/courses_detail/presentation/bloc/course_details_bloc.dart';
import 'package:qizlar_academy_mobile/config/enum/courses_tab.dart';

/// Kurs detallari ekrani uchun mixin: tab holati, Bloc listener, retry, va kontentni mixin orqali qaytarish.
/// Reference §5.1: ekran faqat layout va lifecycle; katta UI blok komponentda (CourseDetailsContent).
mixin CourseDetailsScreenMixin<T extends StatefulWidget> on State<T> {
  CoursesTab get selectedTab => _selectedTab;
  CoursesTab _selectedTab = CoursesTab.lessons;

  void onTabChanged(CoursesTab tab) {
    if (_selectedTab == tab) return;
    Gaimon.light();
    setState(() => _selectedTab = tab);
  }

  void coursesBlocListener(BuildContext context, CourseDetailsState state) {}

  void retryLoad(BuildContext context) {
    context.read<CourseDetailsBloc>().add(const CoursesRetryRequested());
  }

  /// Kurs detallari kontenti — komponent orqali (SOLID: mixin faqat holat va ulash).
  Widget buildCourseDetails(
    BuildContext context, {
    required CourseDetailsModel course,
  }) {
    return CourseDetailsContent(
      course: course,
      selectedTab: _selectedTab,
      onTabChanged: onTabChanged,
      onContinueTap: _selectedTab == CoursesTab.info
          ? () => Gaimon.light()
          : () => openLessonPlayer(context, course: course),
      onLessonTap: (lessonId) =>
          openLessonPlayer(context, course: course, lessonId: lessonId),
    );
  }

  Future<void> openLessonPlayer(
    BuildContext context, {
    required CourseDetailsModel course,
    String? lessonId,
  }) async {
    final canOpen = await getIt<GuestTapGateService>().allowAction(
      context,
      key: 'course_lesson_player_${course.id}_${lessonId ?? 'continue'}',
    );
    if (!canOpen || !context.mounted) return;

    final initialLessonId = lessonId ?? _resolveContinueLessonId(course);
    context.push(
      Routes.coursePlayer(course.id),
      extra: CourseLessonPlayerArgs(
        course: course,
        initialLessonId: initialLessonId,
      ),
    );
  }

  String _resolveContinueLessonId(CourseDetailsModel course) {
    final allLessons = course.modules.expand((m) => m.lessons).toList();
    if (allLessons.isEmpty) return '';

    final firstUnlockedIncomplete = allLessons.firstWhere(
      (lesson) => !lesson.isLocked && !lesson.isCompleted,
      orElse: () => allLessons.firstWhere(
        (lesson) => !lesson.isLocked,
        orElse: () => allLessons.first,
      ),
    );
    return firstUnlockedIncomplete.id;
  }
}
