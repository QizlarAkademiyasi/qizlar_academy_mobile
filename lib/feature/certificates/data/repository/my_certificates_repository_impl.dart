import 'package:qizlar_academy_mobile/feature/certificates/data/datasource/my_certificates_datasource.dart';
import 'package:qizlar_academy_mobile/feature/certificates/domain/model/my_certificates_page_model.dart';
import 'package:qizlar_academy_mobile/feature/certificates/domain/repository/my_certificates_repository.dart';

class MyCertificatesRepositoryImpl implements MyCertificatesRepository {
  MyCertificatesRepositoryImpl({required MyCertificatesDatasource datasource}) : _datasource = datasource;

  final MyCertificatesDatasource _datasource;

  @override
  Future<MyCertificatesPageModel> fetchPage({required int pageNumber, int pageSize = 10}) {
    return _datasource.fetchPage(pageNumber: pageNumber, pageSize: pageSize);
  }
}
