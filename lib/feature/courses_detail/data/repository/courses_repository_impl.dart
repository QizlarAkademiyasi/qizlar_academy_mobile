import 'package:qizlar_academy_mobile/feature/courses_detail/data/datasource/courses_api_datasource.dart';
import 'package:qizlar_academy_mobile/feature/courses_detail/domain/model/course_details_model.dart';
import 'package:qizlar_academy_mobile/feature/courses_detail/domain/repository/courses_repository.dart';

class CoursesRepositoryImpl implements CoursesRepository {
  CoursesRepositoryImpl({
    required CoursesApiDatasource apiDatasource,
  }) : _apiDatasource = apiDatasource;

  final CoursesApiDatasource _apiDatasource;

  @override
  Future<CourseDetailsModel> fetchCourseDetails({required String courseId}) =>
      _apiDatasource.fetchCourseDetails(courseId: courseId);
}
