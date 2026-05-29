import 'package:qizlar_academy_mobile/config/logs/app_logger.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/bloc/auth_session_cubit.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/data/datasource/courses_api_datasource.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/course_details_review_merge.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/model/course_details_model.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/model/course_lesson_model.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/repository/courses_repository.dart';

class CoursesRepositoryImpl implements CoursesRepository {
  CoursesRepositoryImpl({required CoursesApiDatasource apiDatasource, required AuthSessionCubit authSessionCubit}) : _apiDatasource = apiDatasource, _authSessionCubit = authSessionCubit;

  final CoursesApiDatasource _apiDatasource;
  final AuthSessionCubit _authSessionCubit;

  @override
  Future<CourseDetailsModel> fetchCourseDetails({required String courseId}) async {
    final base = await _apiDatasource.fetchCourseDetailsByUserType(
      courseId: courseId,
      userType: _authSessionCubit.state.userType,
    );
    if (_authSessionCubit.state.isAnonymous) return base;
    try {
      final ratings = await _apiDatasource.fetchCourseRatingsForCourse(courseId: courseId);
      return applyReviewsToCourseDetails(base, ratings);
    } catch (e, st) {
      AppLogger.w('CoursesRepository: course ratings list failed, using module reviews', error: e, stackTrace: st);
      return base;
    }
  }

  @override
  Future<CourseLessonModel> fetchLessonDetails({required String lessonId, String? courseId}) {
    return _apiDatasource.fetchLessonDetailsByUserType(
      lessonId: lessonId,
      userType: _authSessionCubit.state.userType,
      courseId: courseId,
    );
  }

  @override
  Future<void> completeLesson({required String lessonId}) async {
    if (_authSessionCubit.state.isAnonymous) return;
    await _apiDatasource.completeLesson(lessonId: lessonId);
  }

  @override
  Future<void> enrollInCourse({required String courseId}) async {
    if (_authSessionCubit.state.isAnonymous) {
      throw StateError('enrollInCourse requires a registered user.');
    }
    await _apiDatasource.enrollInCourse(courseId: courseId);
  }

  @override
  Future<void> submitCourseRating({required String courseId, required double rating, required String comment}) async {
    if (_authSessionCubit.state.isAnonymous) {
      throw StateError('submitCourseRating requires a registered user.');
    }
    await _apiDatasource.submitCourseRating(courseId: courseId, rating: rating, comment: comment);
  }
}
