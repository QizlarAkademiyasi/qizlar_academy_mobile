import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/my_courses/domain/model/my_courses_page_model.dart';

abstract class MyCoursesDatasource {
  Future<MyCoursesPageModel> fetchPage({required int pageNumber, required int pageSize});
}
