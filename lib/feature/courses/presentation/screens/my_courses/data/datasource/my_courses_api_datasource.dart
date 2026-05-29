import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/apis.dart';
import 'package:qizlar_academy_mobile/config/logs/app_logger.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/my_courses/data/datasource/my_courses_datasource.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/my_courses/domain/model/my_course_item_model.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/my_courses/domain/model/my_courses_page_model.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/my_courses/domain/model/my_courses_pagination_model.dart';

class MyCoursesApiDatasource implements MyCoursesDatasource {
  const MyCoursesApiDatasource(this._dio);

  final Dio _dio;

  @override
  Future<MyCoursesPageModel> fetchPage({required int pageNumber, required int pageSize}) async {
    final response = await _dio.get<dynamic>(UserApis.coursesMy, queryParameters: <String, dynamic>{'pageNumber': pageNumber, 'pageSize': pageSize});

    final envelope = _asMap(response.data);
    final data = _asMap(envelope['data']);
    final rawList = data['data'];
    final list = _asList(rawList);
    final items = list.map(_mapItem).toList(growable: false);

    final meta = _asMapOrNull(data['meta']);
    final paginationRaw = _asMapOrNull(meta?['pagination']);
    final pagination = _mapPagination(paginationRaw, fallbackPageSize: pageSize);

    return MyCoursesPageModel(items: items, pagination: pagination);
  }

  MyCourseItemModel _mapItem(Map<String, dynamic> m) {
    final banner = (m['icon'] ?? '').toString().trim();
    return MyCourseItemModel(
      id: (m['id'] ?? '').toString(),
      name: (m['name'] ?? '').toString(),
      bannerImageUrl: Apis.resolveUrl(banner),
      teacherFullname: (m['teacherFullname'] ?? '').toString(),
      enrollmentCount: _parseInt(m['enrollmentCount']),
      totalDurationSeconds: _parseInt(m['totalDuration']),
      avgRating: _parseDouble(m['avgRating']),
      totalRatings: _parseInt(m['totalRatings']),
    );
  }

  MyCoursesPaginationModel _mapPagination(Map<String, dynamic>? p, {required int fallbackPageSize}) {
    if (p == null || p.isEmpty) {
      return MyCoursesPaginationModel(totalCount: 0, pageCount: 1, pageNumber: 1, pageSize: fallbackPageSize);
    }
    final rawPageCount = _parseInt(p['pageCount']);
    final safePageCount = rawPageCount <= 0 ? 1 : rawPageCount;
    return MyCoursesPaginationModel(
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
    AppLogger.w('MyCoursesApiDatasource: expected map envelope, got ${data.runtimeType}');
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

  double _parseDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse('${value ?? 0}') ?? 0;
  }
}
