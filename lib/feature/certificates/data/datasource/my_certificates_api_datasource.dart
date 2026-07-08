import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/apis.dart';
import 'package:qizlar_academy_mobile/config/logs/app_logger.dart';
import 'package:qizlar_academy_mobile/feature/certificates/data/datasource/my_certificates_datasource.dart';
import 'package:qizlar_academy_mobile/feature/certificates/domain/model/certificate_item_model.dart';
import 'package:qizlar_academy_mobile/feature/certificates/domain/model/certificate_tier.dart';
import 'package:qizlar_academy_mobile/feature/certificates/domain/model/my_certificates_page_model.dart';
import 'package:qizlar_academy_mobile/feature/certificates/domain/model/my_certificates_pagination_model.dart';

class MyCertificatesApiDatasource implements MyCertificatesDatasource {
  const MyCertificatesApiDatasource(this._dio);

  final Dio _dio;

  @override
  Future<MyCertificatesPageModel> fetchPage({required int pageNumber, required int pageSize}) async {
    final response = await _dio.get<dynamic>(
      UserApis.certificatesMy,
      queryParameters: <String, dynamic>{'pageNumber': pageNumber, 'pageSize': pageSize},
    );
    final body = response.data;

    if (body is List) {
      final items = body.map((e) => _mapItem(_asMap(e))).where((c) => c.id.isNotEmpty).toList(growable: false);
      return MyCertificatesPageModel(
        items: items,
        pagination: _inferPagination(
          pageNumber: pageNumber,
          pageSize: pageSize,
          itemCount: items.length,
        ),
      );
    }

    final envelope = _asMap(body);
    final data = _asMap(envelope['data']);
    final paginatedList = data['data'];
    if (paginatedList is List) {
      final items = paginatedList.map((e) => _mapItem(_asMap(e))).where((c) => c.id.isNotEmpty).toList(growable: false);
      final meta = _asMapOrNull(data['meta']);
      final paginationRaw = _asMapOrNull(meta?['pagination']);
      final pagination = _mapPagination(
        paginationRaw,
        fallbackPageNumber: pageNumber,
        fallbackPageSize: pageSize,
        itemCount: items.length,
      );
      return MyCertificatesPageModel(items: items, pagination: pagination);
    }

    final rawList = _extractListPayload(envelope['data']) ?? _extractListFromEnvelope(envelope);
    if (rawList == null) {
      AppLogger.w('MyCertificatesApiDatasource: could not find certificate list in response (data type: ${envelope['data']?.runtimeType})');
      return MyCertificatesPageModel(
        items: const [],
        pagination: _inferPagination(pageNumber: pageNumber, pageSize: pageSize, itemCount: 0),
      );
    }
    final items = rawList.map((e) => _mapItem(_asMap(e))).where((c) => c.id.isNotEmpty).toList(growable: false);
    return MyCertificatesPageModel(
      items: items,
      pagination: _inferPagination(pageNumber: pageNumber, pageSize: pageSize, itemCount: items.length),
    );
  }

  MyCertificatesPaginationModel _mapPagination(
    Map<String, dynamic>? p, {
    required int fallbackPageNumber,
    required int fallbackPageSize,
    required int itemCount,
  }) {
    if (p == null || p.isEmpty) {
      return _inferPagination(pageNumber: fallbackPageNumber, pageSize: fallbackPageSize, itemCount: itemCount);
    }
    final rawPageCount = _parseInt(p['pageCount']);
    final safePageCount = rawPageCount <= 0 ? 1 : rawPageCount;
    return MyCertificatesPaginationModel(
      totalCount: _parseInt(p['count']),
      pageCount: safePageCount,
      pageNumber: _parseInt(p['pageNumber']).clamp(1, 1 << 30),
      pageSize: _parseInt(p['pageSize']).clamp(1, 500),
    );
  }

  MyCertificatesPaginationModel _inferPagination({
    required int pageNumber,
    required int pageSize,
    required int itemCount,
  }) {
    final pageCount = itemCount >= pageSize ? pageNumber + 1 : pageNumber;
    return MyCertificatesPaginationModel(
      totalCount: itemCount,
      pageCount: pageCount,
      pageNumber: pageNumber,
      pageSize: pageSize,
    );
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

  Map<String, dynamic>? _asMapOrNull(dynamic data) {
    final map = _asMap(data);
    return map.isEmpty ? null : map;
  }

  int _parseInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse('${value ?? 0}') ?? 0;
  }
}
