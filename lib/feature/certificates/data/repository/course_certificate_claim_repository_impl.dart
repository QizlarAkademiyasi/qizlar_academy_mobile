import 'package:qizlar_academy_mobile/feature/certificates/data/datasource/course_certificate_claim_datasource.dart';
import 'package:qizlar_academy_mobile/feature/certificates/domain/model/certificate_item_model.dart';
import 'package:qizlar_academy_mobile/feature/certificates/domain/repository/course_certificate_claim_repository.dart';

class CourseCertificateClaimRepositoryImpl implements CourseCertificateClaimRepository {
  CourseCertificateClaimRepositoryImpl(this._datasource);

  final CourseCertificateClaimDatasource _datasource;

  @override
  Future<CertificateItemModel> claimForCourse({
    required String courseId,
    required String courseDisplayName,
  }) {
    return _datasource.claimCertificateForCourse(courseId: courseId, courseDisplayName: courseDisplayName);
  }
}
