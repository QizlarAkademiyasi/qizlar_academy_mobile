import 'package:qizlar_academy_mobile/feature/auth/presentation/bloc/auth_session_cubit.dart';
import 'package:qizlar_academy_mobile/feature/vacancy/data/datasource/vacancy_api_datasource.dart';
import 'package:qizlar_academy_mobile/feature/vacancy/domain/model/vacancies_page_model.dart';
import 'package:qizlar_academy_mobile/feature/vacancy/domain/model/vacancy_detail_model.dart';
import 'package:qizlar_academy_mobile/feature/vacancy/domain/repository/vacancy_repository.dart';

class VacancyRepositoryImpl implements VacancyRepository {
  VacancyRepositoryImpl({required VacancyApiDatasource apiDatasource, required AuthSessionCubit authSessionCubit})
    : _apiDatasource = apiDatasource,
      _authSessionCubit = authSessionCubit;

  final VacancyApiDatasource _apiDatasource;
  final AuthSessionCubit _authSessionCubit;

  void _ensureRegistered() {
    if (_authSessionCubit.state.isAnonymous) {
      throw StateError('Vacancies are only available for registered users.');
    }
  }

  @override
  Future<VacanciesPageModel> fetchPage({required int pageNumber, int pageSize = 10, String currency = 'UZS'}) {
    _ensureRegistered();
    return _apiDatasource.fetchPage(pageNumber: pageNumber, pageSize: pageSize, currency: currency);
  }

  @override
  Future<VacancyDetailModel> fetchById(String id) {
    _ensureRegistered();
    return _apiDatasource.fetchById(id);
  }
}
