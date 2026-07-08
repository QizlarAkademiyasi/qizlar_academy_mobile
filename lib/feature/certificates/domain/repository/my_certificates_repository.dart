import 'package:qizlar_academy_mobile/feature/certificates/domain/model/my_certificates_page_model.dart';

abstract class MyCertificatesRepository {
  Future<MyCertificatesPageModel> fetchPage({required int pageNumber, int pageSize});
}
