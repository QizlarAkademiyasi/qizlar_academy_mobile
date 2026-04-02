import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/logs/app_logger.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/course_details_review_merge.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/model/course_details_model.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/model/course_review_model.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/repository/courses_repository.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/repository/profile_repository.dart';

part 'course_details_event.dart';
part 'course_details_state.dart';

class CourseDetailsBloc extends Bloc<CourseDetailsEvent, CourseDetailsState> {
  CourseDetailsBloc(this._repository, this._profileRepository) : super(const CourseDetailsState()) {
    on<CoursesCourseDetailsRequested>(_onCourseDetailsRequested);
    on<CoursesCourseDetailsBackgroundRefreshRequested>(_onCourseDetailsBackgroundRefreshRequested);
    on<CoursesReviewSubmitSucceeded>(_onReviewSubmitSucceeded);
    on<CoursesRetryRequested>(_onRetryRequested);
    on<CoursesEnrollRequested>(_onEnrollRequested);
    on<CoursesEnrollErrorCleared>(_onEnrollErrorCleared);
    on<CoursesEnrollOpenPlayerConsumed>(_onEnrollOpenPlayerConsumed);
  }

  final CoursesRepository _repository;
  final ProfileRepository _profileRepository;

  Future<void> _onCourseDetailsRequested(CoursesCourseDetailsRequested event, Emitter<CourseDetailsState> emit) async {
    emit(state.copyWith(status: CoursesStatus.loading, clearMessage: true, clearEnrollError: true, isEnrolling: false, clearOpenLessonPlayerPending: true));
    try {
      final course = await _repository.fetchCourseDetails(courseId: event.courseId);
      emit(state.copyWith(status: CoursesStatus.success, course: course, isEnrolling: false));
    } catch (e, st) {
      AppLogger.e('CourseDetailsBloc: load course failed', error: e, stackTrace: st);
      emit(state.copyWith(status: CoursesStatus.failure, message: 'Kurs ma’lumotlarini olishda xatolik.', isEnrolling: false));
    }
  }

  Future<void> _onCourseDetailsBackgroundRefreshRequested(
    CoursesCourseDetailsBackgroundRefreshRequested event,
    Emitter<CourseDetailsState> emit,
  ) async {
    if (state.course?.id != event.courseId) return;
    try {
      final course = await _repository.fetchCourseDetails(courseId: event.courseId);
      emit(state.copyWith(course: course, clearMessage: true));
    } catch (e, st) {
      AppLogger.e('CourseDetailsBloc: background refresh failed', error: e, stackTrace: st);
    }
  }

  Future<void> _onReviewSubmitSucceeded(CoursesReviewSubmitSucceeded event, Emitter<CourseDetailsState> emit) async {
    final course = state.course;
    if (course == null || course.id != event.courseId) return;

    var userName = 'Siz';
    var initials = 'S';
    try {
      final overview = await _profileRepository.getProfileOverview();
      final fn = overview.user.fullName.trim();
      if (fn.isNotEmpty) {
        userName = fn;
        initials = _initialsFromReviewerName(fn);
      }
    } catch (_) {}

    final stars = event.rating.round().clamp(1, 5);
    final review = CourseReviewModel(
      id: 'local_${DateTime.now().millisecondsSinceEpoch}',
      userName: userName,
      userInitials: initials,
      createdAt: DateTime.now(),
      rating: stars,
      commentHtml: _plainCommentToHtmlParagraph(event.comment),
    );
    final merged = applyReviewsToCourseDetails(course, [review, ...course.reviews]);
    emit(state.copyWith(course: merged));
  }

  Future<void> _onRetryRequested(CoursesRetryRequested event, Emitter<CourseDetailsState> emit) async {
    final lastId = state.course?.id;
    if (lastId == null) {
      emit(state.copyWith(status: CoursesStatus.failure, message: 'Qayta urinish uchun courseId topilmadi.'));
      return;
    }
    add(CoursesCourseDetailsRequested(courseId: lastId));
  }

  Future<void> _onEnrollRequested(CoursesEnrollRequested event, Emitter<CourseDetailsState> emit) async {
    emit(state.copyWith(isEnrolling: true, clearEnrollError: true));
    try {
      await _repository.enrollInCourse(courseId: event.courseId);
      final course = await _repository.fetchCourseDetails(courseId: event.courseId);
      emit(
        state.copyWith(
          status: CoursesStatus.success,
          course: course,
          isEnrolling: false,
          openLessonPlayerPending: event.openLessonPlayerAfterSuccess,
          openLessonPlayerLessonId: event.lessonIdAfterSuccess,
        ),
      );
    } catch (e, st) {
      AppLogger.e('CourseDetailsBloc: enroll failed', error: e, stackTrace: st);
      emit(state.copyWith(isEnrolling: false, clearOpenLessonPlayerPending: true, enrollError: 'Kursga yozilishda xatolik. Iltimos, qayta urinib ko‘ring.'));
    }
  }

  void _onEnrollOpenPlayerConsumed(CoursesEnrollOpenPlayerConsumed event, Emitter<CourseDetailsState> emit) {
    emit(state.copyWith(clearOpenLessonPlayerPending: true));
  }

  void _onEnrollErrorCleared(CoursesEnrollErrorCleared event, Emitter<CourseDetailsState> emit) {
    emit(state.copyWith(clearEnrollError: true));
  }
}

String _initialsFromReviewerName(String name) {
  final parts = name.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
  if (parts.isEmpty) return '?';
  if (parts.length == 1) {
    final p = parts[0];
    return (p.length >= 2 ? p.substring(0, 2) : p).toUpperCase();
  }
  return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
}

String _plainCommentToHtmlParagraph(String plain) {
  final t = plain.trim();
  if (t.isEmpty) return '<p></p>';
  final esc = t.replaceAll('&', '&amp;').replaceAll('<', '&lt;').replaceAll('>', '&gt;').replaceAll('"', '&quot;');
  return '<p>$esc</p>';
}
