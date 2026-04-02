import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/courses_detail/domain/model/course_details_model.dart';

abstract interface class CoursesDatasource {
  Future<CourseDetailsModel> fetchCourseDetails({required String courseId});
}
