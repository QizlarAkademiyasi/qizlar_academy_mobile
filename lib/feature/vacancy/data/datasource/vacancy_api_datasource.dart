import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/apis.dart';
import 'package:qizlar_academy_mobile/config/logs/app_logger.dart';
import 'package:qizlar_academy_mobile/feature/vacancy/data/datasource/vacancy_datasource.dart';
import 'package:qizlar_academy_mobile/feature/vacancy/domain/model/vacancies_page_model.dart';
import 'package:qizlar_academy_mobile/feature/vacancy/domain/model/vacancies_pagination_model.dart';
import 'package:qizlar_academy_mobile/feature/vacancy/domain/model/vacancy_detail_model.dart';
import 'package:qizlar_academy_mobile/feature/vacancy/domain/model/vacancy_item_model.dart';
import 'package:qizlar_academy_mobile/feature/vacancy/domain/model/vacancy_skill_model.dart';

class VacancyApiDatasource implements VacancyDatasource {
  const VacancyApiDatasource(this._dio);

  final Dio _dio;

  @override
  Future<VacanciesPageModel> fetchPage({required int pageNumber, required int pageSize, required String currency}) async {
    final response = await _dio.get<dynamic>(
      UserApis.vacanciesClient,
      queryParameters: <String, dynamic>{
        'pageNumber': pageNumber,
        'pageSize': pageSize,
        'currency': currency,
      },
    );

    final envelope = _asMap(response.data);
    final data = _asMap(envelope['data']);
    final rawList = data['data'];
    final list = _asList(rawList);
    final items = list.map(_mapItem).toList(growable: false);

    final meta = _asMapOrNull(data['meta']);
    final paginationRaw = _asMapOrNull(meta?['pagination']);
    final pagination = _mapPagination(paginationRaw, fallbackPageSize: pageSize);

    return VacanciesPageModel(items: items, pagination: pagination);
  }

  @override
  Future<VacancyDetailModel> fetchById(String id) async {
    final response = await _dio.get<dynamic>(UserApis.vacancyClientById(id));
    final envelope = _asMap(response.data);
    final data = _asMap(envelope['data']);
    return _mapDetail(data);
  }

  VacancyDetailModel _mapDetail(Map<String, dynamic> m) {
    final rawSkills = m['skills'];
    final skills = rawSkills is List
        ? rawSkills
            .map((e) => _asMap(e))
            .where((s) => s.isNotEmpty)
            .map((s) => VacancySkillModel(id: (s['id'] ?? '').toString(), name: (s['name'] ?? '').toString()))
            .where((s) => s.name.isNotEmpty || s.id.isNotEmpty)
            .toList(growable: false)
        : const <VacancySkillModel>[];

    return VacancyDetailModel(
      id: (m['id'] ?? '').toString(),
      title: (m['title'] ?? '').toString(),
      companyName: (m['companyName'] ?? '').toString(),
      description: (m['description'] ?? '').toString(),
      requirements: (m['requirements'] ?? '').toString(),
      salaryFrom: _parseInt(m['salaryFrom']),
      salaryTo: _parseInt(m['salaryTo']),
      category: (m['category'] ?? '').toString(),
      currency: (m['currency'] ?? 'UZS').toString(),
      location: (m['location'] ?? '').toString(),
      type: (m['type'] ?? '').toString(),
      skills: skills,
      createdAt: _parseDate(m['createdAt']),
    );
  }

  VacancyItemModel _mapItem(Map<String, dynamic> m) {
    return VacancyItemModel(
      id: (m['id'] ?? '').toString(),
      title: (m['title'] ?? '').toString(),
      companyName: (m['companyName'] ?? '').toString(),
      salaryFrom: _parseInt(m['salaryFrom']),
      salaryTo: _parseInt(m['salaryTo']),
      currency: (m['currency'] ?? 'UZS').toString(),
      category: (m['category'] ?? '').toString(),
      location: (m['location'] ?? '').toString(),
      type: (m['type'] ?? '').toString(),
      createdAt: _parseDate(m['createdAt']),
    );
  }

  DateTime _parseDate(dynamic value) {
    if (value == null) return DateTime.fromMillisecondsSinceEpoch(0, isUtc: true).toLocal();
    final s = value.toString().trim();
    if (s.isEmpty) return DateTime.fromMillisecondsSinceEpoch(0, isUtc: true).toLocal();
    try {
      return DateTime.parse(s).toLocal();
    } catch (_) {
      return DateTime.fromMillisecondsSinceEpoch(0, isUtc: true).toLocal();
    }
  }

  VacanciesPaginationModel _mapPagination(Map<String, dynamic>? p, {required int fallbackPageSize}) {
    if (p == null || p.isEmpty) {
      return VacanciesPaginationModel(totalCount: 0, pageCount: 1, pageNumber: 1, pageSize: fallbackPageSize);
    }
    final rawPageCount = _parseInt(p['pageCount']);
    final safePageCount = rawPageCount <= 0 ? 1 : rawPageCount;
    return VacanciesPaginationModel(
      totalCount: _parseInt(p['count']),
      pageCount: safePageCount,
      pageNumber: _parseInt(p['pageNumber']).clamp(1, 1 << 30),
      pageSize: _parseInt(p['pageSize']).clamp(1, 500),
    );
  }

  Map<String, dynamic> _asMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) {
      return data.map((key, value) => MapEntry(key.toString(), value));
    }
    AppLogger.w('VacancyApiDatasource: expected map envelope, got ${data.runtimeType}');
    return <String, dynamic>{};
  }

  Map<String, dynamic>? _asMapOrNull(dynamic data) {
    final map = _asMap(data);
    return map.isEmpty ? null : map;
  }

  List<Map<String, dynamic>> _asList(dynamic data) {
    if (data is! List) return const [];
    return data.map((e) => _asMap(e)).where((m) => m.isNotEmpty).toList(growable: false);
  }

  int _parseInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse('${value ?? 0}') ?? 0;
  }
}
