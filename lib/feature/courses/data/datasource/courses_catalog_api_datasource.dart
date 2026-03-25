import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/apis.dart';
import 'package:qizlar_academy_mobile/config/constants/user_type.dart';
import 'package:qizlar_academy_mobile/feature/courses/data/datasource/courses_catalog_datasource.dart';
import 'package:qizlar_academy_mobile/feature/courses/domain/model/course_catalog_item_model.dart';
import 'package:qizlar_academy_mobile/feature/courses/domain/model/course_in_progress_model.dart';
import 'package:qizlar_academy_mobile/feature/courses/domain/model/courses_catalog_overview_model.dart';

class CoursesCatalogApiDatasource implements CoursesCatalogDatasource {
  const CoursesCatalogApiDatasource(this._dio);

  final Dio _dio;

  Future<CoursesCatalogOverviewModel> fetchCatalogByUserType({
    required String query,
    required UserType userType,
  }) async {
    final response = await _dio.get<dynamic>(
      userType == UserType.registered
          ? Apis.coursesClient
          : Apis.coursesClientPublic,
      queryParameters: const <String, dynamic>{'pageNumber': 1, 'pageSize': 100},
    );

    final envelope = _asMap(response.data);
    final data = _asMap(envelope['data']);
    final courses = _asList(data['data']).map(_mapCourse).where((item) {
      final normalizedQuery = query.trim().toLowerCase();
      if (normalizedQuery.isEmpty) return true;
      return item.title.toLowerCase().contains(normalizedQuery) ||
          item.mentorName.toLowerCase().contains(normalizedQuery);
    }).toList(growable: false);

    CourseInProgressModel? lastViewed;
    if (userType == UserType.registered) {
      final lastViewedRaw = _asMapOrNull(data['lastProgressedCourse']);
      if (lastViewedRaw != null) {
        final progress = _parseInt(lastViewedRaw['progressPercent']);
        lastViewed = CourseInProgressModel(
          courseId: (lastViewedRaw['courseId'] ?? '').toString(),
          title: (lastViewedRaw['name'] ?? '').toString(),
          moduleTitle: (lastViewedRaw['moduleName'] ?? '').toString(),
          imageUrl: (lastViewedRaw['bannerImage'] ?? '').toString(),
          progressPercent: progress,
          progressLabel: '$progress%',
          actionLabel: 'Davom qilish',
        );
      }
    }

    return CoursesCatalogOverviewModel(
      lastViewedCourse: lastViewed,
      courses: courses,
    );
  }

  @override
  Future<CoursesCatalogOverviewModel> fetchCatalog({
    required String query,
  }) => fetchCatalogByUserType(query: query, userType: UserType.registered);

  CourseCatalogItemModel _mapCourse(Map<String, dynamic> parsed) {
    return CourseCatalogItemModel(
      id: (parsed['id'] ?? '').toString(),
      title: (parsed['name'] ?? '').toString(),
      mentorName: (parsed['teacherFullname'] ?? '').toString(),
      imageUrl: (parsed['bannerImage'] ?? '').toString(),
      rating: _parseDouble(parsed['avgRating']),
      reviewsCount: _parseInt(parsed['totalRatings']),
      durationHours: _parseInt(parsed['totalDuration']),
      tagLabel: null,
    );
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

  List<Map<String, dynamic>> _asList(dynamic data) {
    if (data is! List) return const [];
    return data.whereType<Map>().map(_asMap).toList(growable: false);
  }

  int _parseInt(dynamic value) => int.tryParse('${value ?? 0}') ?? 0;

  double _parseDouble(dynamic value) => double.tryParse('${value ?? 0}') ?? 0;
}
