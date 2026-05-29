import 'package:qizlar_academy_mobile/feature/certificates/domain/model/certificate_item_model.dart';

abstract class MyCertificatesDatasource {
  Future<List<CertificateItemModel>> fetchMyCertificates();
}
