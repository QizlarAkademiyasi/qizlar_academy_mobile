import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/feature/courses_detail/domain/model/course_details_model.dart';
import 'package:qizlar_academy_mobile/feature/courses_detail/domain/repository/courses_repository.dart';

part 'course_details_event.dart';
part 'course_details_state.dart';

class CourseDetailsBloc extends Bloc<CourseDetailsEvent, CourseDetailsState> {
  CourseDetailsBloc(this._repository) : super(const CourseDetailsState()) {
    on<CoursesCourseDetailsRequested>(_onCourseDetailsRequested);
    on<CoursesRetryRequested>(_onRetryRequested);
  }

  final CoursesRepository _repository;

  Future<void> _onCourseDetailsRequested(
    CoursesCourseDetailsRequested event,
    Emitter<CourseDetailsState> emit,
  ) async {
    emit(state.copyWith(status: CoursesStatus.loading, message: null));
    try {
      final course = await _repository.fetchCourseDetails(
        courseId: event.courseId,
      );
      emit(state.copyWith(status: CoursesStatus.success, course: course));
    } catch (e) {
      emit(
        state.copyWith(
          status: CoursesStatus.failure,
          message: 'Kurs ma’lumotlarini olishda xatolik.',
        ),
      );
    }
  }

  Future<void> _onRetryRequested(
    CoursesRetryRequested event,
    Emitter<CourseDetailsState> emit,
  ) async {
    final lastId = state.course?.id;
    if (lastId == null) {
      emit(
        state.copyWith(
          status: CoursesStatus.failure,
          message: 'Qayta urinish uchun courseId topilmadi.',
        ),
      );
      return;
    }
    add(CoursesCourseDetailsRequested(courseId: lastId));
  }
}
