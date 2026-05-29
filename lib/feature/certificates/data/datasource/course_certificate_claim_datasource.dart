import 'package:qizlar_academy_mobile/feature/certificates/domain/model/certificate_item_model.dart';

abstract class CourseCertificateClaimDatasource {
  Future<CertificateItemModel> claimCertificateForCourse({
    required String courseId,
    required String courseDisplayName,
  });
}
