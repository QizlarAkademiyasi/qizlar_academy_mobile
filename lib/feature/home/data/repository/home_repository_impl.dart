import 'package:qizlar_academy_mobile/feature/home/data/datasource/home_mock_datasource.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/category_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/course_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/home_stats_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/teacher_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/repository/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl(this._datasource);

  final HomeMockDatasource _datasource;

  @override
  Future<HomeStatsModel> getStats() => _datasource.getStats();

  @override
  Future<List<CategoryModel>> getCategories() => _datasource.getCategories();

  @override
  Future<List<TeacherModel>> getTeachers() => _datasource.getTeachers();

  @override
  Future<List<CourseModel>> getCourses() => _datasource.getCourses();
}
