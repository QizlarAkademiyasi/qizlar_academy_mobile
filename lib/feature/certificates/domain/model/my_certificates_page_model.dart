import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/feature/certificates/domain/model/certificate_item_model.dart';
import 'package:qizlar_academy_mobile/feature/certificates/domain/model/my_certificates_pagination_model.dart';

class MyCertificatesPageModel extends Equatable {
  const MyCertificatesPageModel({required this.items, required this.pagination});

  final List<CertificateItemModel> items;
  final MyCertificatesPaginationModel pagination;

  @override
  List<Object?> get props => [items, pagination];
}
