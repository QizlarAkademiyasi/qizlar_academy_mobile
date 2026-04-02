import 'package:qizlar_academy_mobile/config/logs/logs.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/bloc/auth_session_cubit.dart';
import 'package:qizlar_academy_mobile/feature/home/data/datasource/home_api_datasource.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/banner_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/category_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/course_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/home_stats_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/teacher_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/repository/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl({
    required HomeApiDatasource apiDatasource,
    required AuthSessionCubit authSessionCubit,
  }) : _apiDatasource = apiDatasource,
       _authSessionCubit = authSessionCubit;

  final HomeApiDatasource _apiDatasource;
  final AuthSessionCubit _authSessionCubit;

  @override
  Future<HomeStatsModel> getStats() =>
      _apiDatasource.getStatsByUserType(_authSessionCubit.state.userType);

  @override
  Future<List<StoryModel>> getCategories() =>
      _apiDatasource.getCategoriesByUserType(_authSessionCubit.state.userType);

  @override
  Future<List<TeacherModel>> getTeachers() =>
      _apiDatasource.getTeachersByUserType(_authSessionCubit.state.userType);

  @override
  Future<List<CourseModel>> getCourses() =>
      _apiDatasource.getCoursesByUserType(_authSessionCubit.state.userType);

  @override
  Future<List<BannerModel>> getBanners() =>
      _apiDatasource.getBannersByUserType(_authSessionCubit.state.userType);

  @override
  Future<void> postStoryView(String storyId) async {
    if (!_authSessionCubit.state.isRegistered) return;
    final id = storyId.trim();
    if (id.isEmpty) return;
    try {
      await _apiDatasource.postStoryView(id);
    } catch (error, stackTrace) {
      AppLogger.w(
        'Story view POST failed',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
