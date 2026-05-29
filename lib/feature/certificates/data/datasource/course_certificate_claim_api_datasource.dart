import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/apis.dart';
import 'package:qizlar_academy_mobile/config/logs/app_logger.dart';
import 'package:qizlar_academy_mobile/feature/certificates/data/datasource/course_certificate_claim_datasource.dart';
import 'package:qizlar_academy_mobile/feature/certificates/domain/model/certificate_item_model.dart';
import 'package:qizlar_academy_mobile/feature/certificates/domain/model/certificate_tier.dart';

class CourseCertificateClaimApiDatasource implements CourseCertificateClaimDatasource {
  const CourseCertificateClaimApiDatasource(this._dio);

  final Dio _dio;

  @override
  Future<CertificateItemModel> claimCertificateForCourse({
    required String courseId,
    required String courseDisplayName,
  }) async {
    final id = courseId.trim();
    if (id.isEmpty) {
      throw StateError('courseId empty');
    }
    final response = await _dio.get<dynamic>(UserApis.certificateCourseByCourseId(id));
    final envelope = _asMap(response.data);
    final data = _asMap(envelope['data']);
    final file = (data['file'] ?? '').toString().trim();
    final type = (data['type'] ?? '').toString().trim();
    if (file.isEmpty) {
      AppLogger.w('CourseCertificateClaimApiDatasource: empty file in response (courseId=$id)');
    }
    return CertificateItemModel(
      id: '${id}_$type',
      apiType: type.isEmpty ? 'UNKNOWN' : type,
      tier: certificateTierFromApiType(type),
      fileUrl: Apis.resolveUrl(file),
      courseId: id,
      courseName: courseDisplayName.trim().isNotEmpty ? courseDisplayName.trim() : id,
      createdAt: DateTime.now(),
    );
  }

  Map<String, dynamic> _asMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) {
      return data.map((key, value) => MapEntry(key.toString(), value));
    }
    return <String, dynamic>{};
  }
}
