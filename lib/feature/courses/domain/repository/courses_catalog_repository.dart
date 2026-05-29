import 'package:qizlar_academy_mobile/feature/courses/domain/model/courses_catalog_overview_model.dart';

abstract interface class CoursesCatalogRepository {
  Future<CoursesCatalogOverviewModel> fetchCatalog({required String query});
}
