import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/config/router/app_routes.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/bloc/auth_session_cubit.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/services/guest_tap_gate_service.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/model/course_details_model.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/model/course_lesson_model.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/components/course_details_content.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/screens/course_lesson_player_args.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/screens/course_submit_review/course_submit_review_args.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/presentation/bloc/course_details_bloc.dart';
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

  void coursesBlocListener(BuildContext context, CourseDetailsState state) {
    final err = state.enrollError;
    if (err == null || !context.mounted) return;
    AppToast.error(context, message: err);
    context.read<CourseDetailsBloc>().add(const CoursesEnrollErrorCleared());
  }

  void retryLoad(BuildContext context) {
    context.read<CourseDetailsBloc>().add(const CoursesRetryRequested());
  }

  /// Kurs detallari kontenti — komponent orqali (SOLID: mixin faqat holat va ulash).
  Widget buildCourseDetails(BuildContext context, {required CourseDetailsModel course, required CourseDetailsState courseDetailsState}) {
    return CourseDetailsContent(
      course: course,
      selectedTab: _selectedTab,
      onTabChanged: onTabChanged,
      isEnrolling: courseDetailsState.isEnrolling,
      onPrimaryCtaTap: () => onCoursePrimaryCtaTap(context, course: course),
      onLeaveReviewTap: () => openCourseSubmitReview(context, course: course),
      onLessonTap: (lessonId) => openLessonPlayer(context, course: course, lessonId: lessonId),
      onOpenQuiz: (lessonId) => openLessonQuiz(context, course: course, lessonId: lessonId),
    );
  }

  Future<void> openCourseSubmitReview(BuildContext context, {required CourseDetailsModel course}) async {
    final canOpen = await getIt<GuestTapGateService>().allowAction(context, key: 'course_submit_review_${course.id}');
    if (!canOpen || !context.mounted) return;
    final thumb = course.teacherAvatarUrl.trim().isNotEmpty ? course.teacherAvatarUrl : course.coverImageUrl;
    final bloc = context.read<CourseDetailsBloc>();
    final args = CourseSubmitReviewArgs(
      courseId: course.id,
      title: course.title,
      categoryName: course.categoryName,
      teacherName: course.teacherName,
      thumbnailUrl: thumb,
      onSubmitted: (rating, comment) {
        if (!context.mounted) return;
        bloc.add(CoursesReviewSubmitSucceeded(courseId: course.id, rating: rating, comment: comment));
      },
    );
    await context.push(Routes.courseSubmitReview(course.id), extra: args);
  }

  Future<void> openLessonQuiz(
    BuildContext context, {
    required CourseDetailsModel course,
    required String lessonId,
  }) async {
    CourseLessonModel? lesson;
    for (final module in course.modules) {
      for (final l in module.lessons) {
        if (l.id == lessonId) {
          lesson = l;
          break;
        }
      }
      if (lesson != null) break;
    }
    if (lesson != null && lesson.hasCompletedLessonQuiz) {
      if (context.mounted) {
        AppToast.info(context, message: context.l10n.lessonQuizAlreadyTaken);
      }
      return;
    }
    final canOpen = await getIt<GuestTapGateService>().allowAction(context, key: 'lesson_quiz_$lessonId');
    if (!canOpen || !context.mounted) return;
    await context.push(Routes.lessonQuiz(lessonId));
    if (!context.mounted) return;
    context.read<CourseDetailsBloc>().add(
          CoursesCourseDetailsBackgroundRefreshRequested(courseId: course.id),
        );
  }

  Future<void> onCoursePrimaryCtaTap(BuildContext context, {required CourseDetailsModel course}) async {
    final session = getIt<AuthSessionCubit>().state;
    if (session.isAnonymous) {
      final previewId = course.firstGuestPreviewLessonId;
      if (previewId == null || !context.mounted) return;
      Gaimon.light();
      onTabChanged(CoursesTab.lessons);
      await navigateToCourseLessonPlayer(context, course: course, lessonId: previewId);
      return;
    }
    if (!course.isEnrolled) {
      if (!context.mounted) return;
      final enroll = await _confirmCourseEnroll(context);
      if (!enroll || !context.mounted) return;
      context.read<CourseDetailsBloc>().add(CoursesEnrollRequested(courseId: course.id, openLessonPlayerAfterSuccess: true));
      return;
    }
    if (_selectedTab == CoursesTab.info) {
      onTabChanged(CoursesTab.lessons);
      return;
    }
    navigateToCourseLessonPlayer(context, course: course);
  }

  Future<void> onEnrolledNavigateToLessonPlayer(BuildContext context, CourseDetailsState state) async {
    final course = state.course!;
    final pinnedLessonId = state.openLessonPlayerLessonId;
    if (!context.mounted) return;
    context.read<CourseDetailsBloc>().add(const CoursesEnrollOpenPlayerConsumed());
    if (!context.mounted) return;
    Gaimon.light();
    onTabChanged(CoursesTab.lessons);
    await navigateToCourseLessonPlayer(context, course: course, lessonId: pinnedLessonId);
  }

  Future<void> openLessonPlayer(BuildContext context, {required CourseDetailsModel course, String? lessonId}) async {
    final session = getIt<AuthSessionCubit>().state;
    if (session.isRegistered && !course.isEnrolled) {
      if (!context.mounted) return;
      final enroll = await _confirmCourseEnroll(context);
      if (!enroll || !context.mounted) return;
      context.read<CourseDetailsBloc>().add(CoursesEnrollRequested(courseId: course.id, openLessonPlayerAfterSuccess: true, lessonIdAfterSuccess: lessonId));
      return;
    }

    await navigateToCourseLessonPlayer(context, course: course, lessonId: lessonId);
  }

  Future<void> navigateToCourseLessonPlayer(BuildContext context, {required CourseDetailsModel course, String? lessonId}) async {
    final session = getIt<AuthSessionCubit>().state;
    final previewId = course.firstGuestPreviewLessonId;

    if (session.isAnonymous) {
      if (previewId == null || !context.mounted) return;
      final target = lessonId ?? previewId;
      if (target != previewId) {
        await showAuthRequiredBottomSheet(context, title: context.l10n.courseGuestMoreLessonsTitle, description: context.l10n.courseGuestMoreLessonsBody);
        return;
      }
      if (!context.mounted) return;
      context.push(
        Routes.coursePlayer(course.id),
        extra: CourseLessonPlayerArgs(course: course, initialLessonId: previewId),
      );
      return;
    }

    final canOpen = await getIt<GuestTapGateService>().allowAction(context, key: 'course_lesson_player_${course.id}_${lessonId ?? 'continue'}');
    if (!canOpen || !context.mounted) return;

    final initialLessonId = lessonId ?? _resolveContinueLessonId(course);
    context.push(
      Routes.coursePlayer(course.id),
      extra: CourseLessonPlayerArgs(course: course, initialLessonId: initialLessonId),
    );
  }

  Future<bool> _confirmCourseEnroll(BuildContext context) async {
    final l10n = context.l10n;
    final result = await showAppPrimaryConfirmDialog(
      context,
      title: l10n.courseEnrollConfirmTitle,
      description: l10n.courseEnrollConfirmBody,
      cancelLabel: l10n.courseEnrollConfirmCancel,
      confirmLabel: l10n.courseEnrollConfirmPrimary,
    );
    return result == true;
  }

  String _resolveContinueLessonId(CourseDetailsModel course) {
    final session = getIt<AuthSessionCubit>().state;
    if (session.isAnonymous) {
      return course.firstGuestPreviewLessonId ?? '';
    }

    final allLessons = course.modules.expand((m) => m.lessons).toList();
    if (allLessons.isEmpty) return '';

    final firstUnlockedIncomplete = allLessons.firstWhere(
      (lesson) => !lesson.isLocked && !lesson.isCompleted,
      orElse: () => allLessons.firstWhere((lesson) => !lesson.isLocked, orElse: () => allLessons.first),
    );
    return firstUnlockedIncomplete.id;
  }
}
