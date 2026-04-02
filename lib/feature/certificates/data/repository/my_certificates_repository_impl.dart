import 'package:qizlar_academy_mobile/feature/certificates/data/datasource/my_certificates_datasource.dart';
import 'package:qizlar_academy_mobile/feature/certificates/domain/model/certificate_item_model.dart';
import 'package:qizlar_academy_mobile/feature/certificates/domain/repository/my_certificates_repository.dart';

class MyCertificatesRepositoryImpl implements MyCertificatesRepository {
  MyCertificatesRepositoryImpl({required MyCertificatesDatasource datasource}) : _datasource = datasource;

  final MyCertificatesDatasource _datasource;

  @override
  Future<List<CertificateItemModel>> fetchMyCertificates() {
    return _datasource.fetchMyCertificates();
  }
}
