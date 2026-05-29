import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/feature/vacancy/domain/model/vacancies_pagination_model.dart';
import 'package:qizlar_academy_mobile/feature/vacancy/domain/model/vacancy_item_model.dart';

class VacanciesPageModel extends Equatable {
  const VacanciesPageModel({required this.items, required this.pagination});

  final List<VacancyItemModel> items;
  final VacanciesPaginationModel pagination;

  @override
  List<Object?> get props => [items, pagination];
}
