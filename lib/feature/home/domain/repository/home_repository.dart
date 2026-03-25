import 'package:qizlar_academy_mobile/feature/home/domain/model/category_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/course_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/home_stats_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/teacher_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/banner_model.dart';

abstract interface class HomeRepository {
  Future<HomeStatsModel> getStats();
  Future<List<StoryModel>> getCategories();
  Future<List<TeacherModel>> getTeachers();
  Future<List<CourseModel>> getCourses();
  Future<List<BannerModel>> getBanners();
}
