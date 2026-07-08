import 'package:qizlar_academy_mobile/feature/certificates/domain/model/my_certificates_page_model.dart';

abstract class MyCertificatesDatasource {
  Future<MyCertificatesPageModel> fetchPage({required int pageNumber, required int pageSize});
}
