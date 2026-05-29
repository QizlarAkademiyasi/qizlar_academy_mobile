import 'package:qizlar_academy_mobile/feature/about_us/data/datasource/about_us_local_datasource.dart';
import 'package:qizlar_academy_mobile/feature/about_us/domain/model/about_us_page_model.dart';
import 'package:qizlar_academy_mobile/feature/about_us/domain/repository/about_us_repository.dart';

class AboutUsRepositoryImpl implements AboutUsRepository {
  AboutUsRepositoryImpl({AboutUsLocalDatasource? localDatasource}) : _local = localDatasource ?? const AboutUsLocalDatasource();

  final AboutUsLocalDatasource _local;

  @override
  Future<AboutUsPageModel> loadAboutUs() async {
    return _local.fetch();
  }
}
