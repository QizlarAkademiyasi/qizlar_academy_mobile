import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/feature/certificates/domain/model/certificate_tier.dart';

class CertificateItemModel extends Equatable {
  const CertificateItemModel({
    required this.id,
    required this.apiType,
    required this.tier,
    required this.fileUrl,
    required this.courseId,
    required this.courseName,
    this.createdAt,
  });

  final String id;
  final String apiType;
  final CertificateTier tier;
  final String fileUrl;
  final String courseId;
  final String courseName;
  final DateTime? createdAt;

  @override
  List<Object?> get props => [id, apiType, tier, fileUrl, courseId, courseName, createdAt];
}
