import 'package:qizlar_academy_mobile/feature/auth/presentation/bloc/auth_session_cubit.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/my_courses/data/datasource/my_courses_api_datasource.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/my_courses/domain/model/my_courses_page_model.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/my_courses/domain/repository/my_courses_repository.dart';

class MyCoursesRepositoryImpl implements MyCoursesRepository {
  MyCoursesRepositoryImpl({required MyCoursesApiDatasource apiDatasource, required AuthSessionCubit authSessionCubit}) : _apiDatasource = apiDatasource, _authSessionCubit = authSessionCubit;

  final MyCoursesApiDatasource _apiDatasource;
  final AuthSessionCubit _authSessionCubit;

  void _ensureRegistered() {
    if (_authSessionCubit.state.isAnonymous) {
      throw StateError('My courses is only available for registered users.');
    }
  }

  @override
  Future<MyCoursesPageModel> fetchPage({required int pageNumber, int pageSize = 10}) {
    _ensureRegistered();
    return _apiDatasource.fetchPage(pageNumber: pageNumber, pageSize: pageSize);
  }
}
