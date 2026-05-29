import 'package:qizlar_academy_mobile/feature/courses/domain/model/courses_catalog_overview_model.dart';

abstract interface class CoursesCatalogDatasource {
  Future<CoursesCatalogOverviewModel> fetchCatalog({required String query});
}
