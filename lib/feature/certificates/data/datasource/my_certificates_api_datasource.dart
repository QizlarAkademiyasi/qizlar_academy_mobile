import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/apis.dart';
import 'package:qizlar_academy_mobile/config/logs/app_logger.dart';
import 'package:qizlar_academy_mobile/feature/certificates/data/datasource/my_certificates_datasource.dart';
import 'package:qizlar_academy_mobile/feature/certificates/domain/model/certificate_item_model.dart';
import 'package:qizlar_academy_mobile/feature/certificates/domain/model/certificate_tier.dart';

class MyCertificatesApiDatasource implements MyCertificatesDatasource {
  const MyCertificatesApiDatasource(this._dio);

  final Dio _dio;

  @override
  Future<List<CertificateItemModel>> fetchMyCertificates() async {
    final response = await _dio.get<dynamic>(UserApis.certificatesMy);
    final body = response.data;
    if (body is List) {
      return body.map((e) => _mapItem(_asMap(e))).where((c) => c.id.isNotEmpty).toList(growable: false);
    }
    final envelope = _asMap(body);
    final rawList = _extractListPayload(envelope['data']) ?? _extractListFromEnvelope(envelope);
    if (rawList == null) {
      AppLogger.w('MyCertificatesApiDatasource: could not find certificate list in response (data type: ${envelope['data']?.runtimeType})');
      return const [];
    }
    return rawList.map((e) => _mapItem(_asMap(e))).where((c) => c.id.isNotEmpty).toList(growable: false);
  }

  /// API `data` ba'zan to'g'ridan-to'g'ri massiv, ba'zan `{ "data": [...] }` yoki `items` / `certificates` ichida.
  List<dynamic>? _extractListPayload(dynamic dataField) {
    if (dataField is List) {
      return dataField;
    }
    if (dataField is! Map) {
      return null;
    }
    final m = _asMap(dataField);
    for (final key in const ['data', 'items', 'certificates', 'list', 'results', 'rows']) {
      final v = m[key];
      if (v is List) return v;
    }
    return null;
  }

  /// `data` kaliti bo'lmasa yoki noto'g'ri bo'lsa, envelope darajasidagi ro'yxat kalitlari.
  List<dynamic>? _extractListFromEnvelope(Map<String, dynamic> envelope) {
    for (final key in const ['items', 'certificates', 'data', 'list', 'results']) {
      final v = envelope[key];
      if (v is List) return v;
    }
    return null;
  }

  CertificateItemModel _mapItem(Map<String, dynamic> m) {
    final course = _asMap(m['course']);
    final type = (m['type'] ?? '').toString();
    final file = (m['file'] ?? '').toString().trim();
    return CertificateItemModel(
      id: (m['id'] ?? '').toString(),
      apiType: type,
      tier: certificateTierFromApiType(type),
      fileUrl: Apis.resolveUrl(file),
      courseId: (course['id'] ?? '').toString(),
      courseName: (course['name'] ?? '').toString(),
      createdAt: _parseDate(m['createdAt']),
    );
  }

  DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }

  Map<String, dynamic> _asMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) {
      return data.map((key, value) => MapEntry(key.toString(), value));
    }
    return <String, dynamic>{};
  }
}
