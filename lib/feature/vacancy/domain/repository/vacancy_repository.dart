import 'package:qizlar_academy_mobile/feature/vacancy/domain/model/vacancies_page_model.dart';
import 'package:qizlar_academy_mobile/feature/vacancy/domain/model/vacancy_detail_model.dart';

abstract class VacancyRepository {
  Future<VacanciesPageModel> fetchPage({required int pageNumber, int pageSize = 10, String currency = 'UZS'});

  Future<VacancyDetailModel> fetchById(String id);
}
