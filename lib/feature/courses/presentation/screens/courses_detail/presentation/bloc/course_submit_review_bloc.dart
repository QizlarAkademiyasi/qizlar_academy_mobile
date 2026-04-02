import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/logs/app_logger.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/repository/courses_repository.dart';

part 'course_submit_review_event.dart';
part 'course_submit_review_state.dart';

class CourseSubmitReviewBloc extends Bloc<CourseSubmitReviewEvent, CourseSubmitReviewState> {
  CourseSubmitReviewBloc(this._repository, {required this.courseId}) : super(const CourseSubmitReviewState()) {
    on<CourseSubmitReviewSubmitted>(_onSubmitted);
  }

  final CoursesRepository _repository;
  final String courseId;

  Future<void> _onSubmitted(CourseSubmitReviewSubmitted event, Emitter<CourseSubmitReviewState> emit) async {
    emit(state.copyWith(status: CourseSubmitReviewStatus.submitting, clearMessage: true));
    try {
      await _repository.submitCourseRating(courseId: courseId, rating: event.rating, comment: event.comment);
      emit(state.copyWith(status: CourseSubmitReviewStatus.success));
    } catch (e, st) {
      AppLogger.e('CourseSubmitReviewBloc: submit failed', error: e, stackTrace: st);
      emit(state.copyWith(status: CourseSubmitReviewStatus.failure, message: 'submit_failed'));
    }
  }
}
