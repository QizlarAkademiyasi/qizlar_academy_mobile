import 'package:qizlar_academy_mobile/feature/courses_detail/domain/model/course_details_model.dart';

abstract class CoursesRepository {
  Future<CourseDetailsModel> fetchCourseDetails({required String courseId});
}
