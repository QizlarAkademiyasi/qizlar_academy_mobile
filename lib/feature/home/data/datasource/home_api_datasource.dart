import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/apis.dart';
import 'package:qizlar_academy_mobile/config/constants/user_type.dart';
import 'package:qizlar_academy_mobile/feature/home/data/datasource/home_datasource.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/banner_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/category_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/course_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/home_stats_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/teacher_model.dart';

class HomeApiDatasource implements HomeDatasource {
  const HomeApiDatasource(this._dio);

  final Dio _dio;

  Future<List<BannerModel>> getBannersByUserType(UserType userType) async {
    final response = await _dio.get<dynamic>(Apis.bannersPublic);
    final banner = _unwrapDataAsMap(response.data);
    if (banner.isEmpty) return const [];
    return [_mapBanner(banner)];
  }

  Future<List<StoryModel>> getCategoriesByUserType(UserType userType) async {
    if (userType == UserType.anonymous) return const [];

    final response = await _dio.get<dynamic>(Apis.stories);
    final data = _unwrapDataAsMap(response.data);
    final rawList = _asList(data['data']);
    return rawList.map((item) {
      return StoryModel(
        id: (item['id'] ?? '').toString(),
        name: (item['title'] ?? '').toString(),
        imageUrl: (item['mediaUrl'] ?? '').toString(),
        thumbnailUrl: (item['mediaUrl'] ?? '').toString(),
      );
    }).toList(growable: false);
  }

  Future<List<CourseModel>> getCoursesByUserType(UserType userType) async {
    final response = await _dio.get<dynamic>(Apis.coursesFeatured);
    final rawList = _unwrapDataAsList(response.data);
    return rawList.map(_mapCourse).toList(growable: false);
  }

  Future<HomeStatsModel> getStatsByUserType(UserType userType) async {
    if (userType == UserType.anonymous) {
      return const HomeStatsModel(
        coins: 0,
        grade: 0,
        rating: 0,
        lastLessonCategory: '',
        lastLessonProgress: 0,
      );
    }

    final response = await _dio.get<dynamic>(Apis.userLastProgress);
    final progressData = _unwrapDataAsMap(response.data);
    final progressPercent = _parseDouble(progressData['progressPercent']);

    return HomeStatsModel(
      coins: _parseInt(progressData['coins']),
      grade: 0,
      rating: _parseInt(progressData['leaderboardRank']),
      lastLessonCategory: (progressData['lastLessonTitle'] ?? '').toString(),
      lastLessonProgress: (progressPercent / 100).clamp(0, 1),
    );
  }

  Future<List<TeacherModel>> getTeachersByUserType(UserType userType) async {
    return const [];
  }

  @override
  Future<List<BannerModel>> getBanners() => getBannersByUserType(UserType.registered);

  @override
  Future<List<StoryModel>> getCategories() =>
      getCategoriesByUserType(UserType.registered);

  @override
  Future<List<CourseModel>> getCourses() => getCoursesByUserType(UserType.registered);

  @override
  Future<HomeStatsModel> getStats() => getStatsByUserType(UserType.registered);

  @override
  Future<List<TeacherModel>> getTeachers() =>
      getTeachersByUserType(UserType.registered);

  BannerModel _mapBanner(Map<String, dynamic> item) {
    return BannerModel(
      id: (item['id'] ?? '').toString(),
      title: (item['title'] ?? '').toString(),
      subtitle: (item['content'] ?? '').toString(),
      imageUrl: (item['photo'] ?? '').toString(),
    );
  }

  CourseModel _mapCourse(Map<String, dynamic> item) {
    return CourseModel(
      id: (item['id'] ?? '').toString(),
      title: (item['name'] ?? '').toString(),
      author: (item['teacherFullname'] ?? '').toString(),
      imageUrl: (item['bannerImage'] ?? '').toString(),
      durationHours: _parseInt(item['totalDuration']),
      studentCount: _parseInt(item['enrollmentCount']),
    );
  }

  Map<String, dynamic> _unwrapDataAsMap(dynamic raw) {
    final envelope = _asMap(raw);
    return _asMap(envelope['data']);
  }

  List<Map<String, dynamic>> _unwrapDataAsList(dynamic raw) {
    final envelope = _asMap(raw);
    return _asList(envelope['data']);
  }

  Map<String, dynamic> _asMap(dynamic raw) {
    if (raw is Map<String, dynamic>) return raw;
    if (raw is Map) {
      return raw.map((key, value) => MapEntry(key.toString(), value));
    }
    return <String, dynamic>{};
  }

  List<Map<String, dynamic>> _asList(dynamic raw) {
    if (raw is! List) return const [];
    return raw.whereType<Map>().map(_asMap).toList(growable: false);
  }

  int _parseInt(dynamic value) => int.tryParse('${value ?? 0}') ?? 0;

  double _parseDouble(dynamic value) => double.tryParse('${value ?? 0}') ?? 0;
}
