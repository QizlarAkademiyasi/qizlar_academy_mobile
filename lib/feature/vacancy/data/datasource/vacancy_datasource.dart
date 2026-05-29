import 'package:qizlar_academy_mobile/feature/vacancy/domain/model/vacancies_page_model.dart';
import 'package:qizlar_academy_mobile/feature/vacancy/domain/model/vacancy_detail_model.dart';

abstract class VacancyDatasource {
  Future<VacanciesPageModel> fetchPage({required int pageNumber, required int pageSize, required String currency});

  Future<VacancyDetailModel> fetchById(String id);
}
