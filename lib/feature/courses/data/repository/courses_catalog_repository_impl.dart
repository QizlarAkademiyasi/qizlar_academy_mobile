import 'package:qizlar_academy_mobile/feature/auth/presentation/bloc/auth_session_cubit.dart';
import 'package:qizlar_academy_mobile/feature/courses/data/datasource/courses_catalog_api_datasource.dart';
import 'package:qizlar_academy_mobile/feature/courses/domain/model/courses_catalog_overview_model.dart';
import 'package:qizlar_academy_mobile/feature/courses/domain/repository/courses_catalog_repository.dart';

class CoursesCatalogRepositoryImpl implements CoursesCatalogRepository {
  CoursesCatalogRepositoryImpl({
    required CoursesCatalogApiDatasource apiDatasource,
    required AuthSessionCubit authSessionCubit,
  }) : _apiDatasource = apiDatasource,
       _authSessionCubit = authSessionCubit;

  final CoursesCatalogApiDatasource _apiDatasource;
  final AuthSessionCubit _authSessionCubit;

  @override
  Future<CoursesCatalogOverviewModel> fetchCatalog({required String query}) =>
      _apiDatasource.fetchCatalogByUserType(
        query: query,
        userType: _authSessionCubit.state.userType,
      );
}
