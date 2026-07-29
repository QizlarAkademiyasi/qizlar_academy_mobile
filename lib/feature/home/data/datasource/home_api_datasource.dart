import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/apis.dart';
import 'package:qizlar_academy_mobile/config/enum/user_type.dart';
import 'package:qizlar_academy_mobile/config/flavor/env_config.dart';
import 'package:qizlar_academy_mobile/feature/home/data/datasource/home_datasource.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/banner_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/category_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/course_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/home_stats_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/teacher_model.dart';

class HomeApiDatasource implements HomeDatasource {
  const HomeApiDatasource(this._dio);

  static const StoryModel _devBirthdayStory = StoryModel(
    id: 'dev-birthday-mock',
    name: '',
    imageUrl: 'https://randomuser.me/api/portraits/women/44.jpg',
    thumbnailUrl: 'https://randomuser.me/api/portraits/women/44.jpg',
    type: StoryItemType.birthday,
  );

  final Dio _dio;

  Future<List<BannerModel>> getBannersByUserType(UserType userType) async {
    final response = await _dio.get<dynamic>(AnonymousApis.bannersPublic);
    final rawList = _unwrapDataAsList(response.data);
    return rawList.map(_mapBanner).toList(growable: false);
  }

  Future<List<StoryModel>> getCategoriesByUserType(UserType userType) async {
    final response = await _dio.get<dynamic>(
      userType == UserType.guest
          ? AnonymousApis.storiesPublic
          : UserApis.stories,
      queryParameters: const {'pageNumber': 1, 'pageSize': 10},
    );
    final stories = parseStoriesPayload(response.data);
    if (!EnvConfig.instance.isDev) return stories;

    return [
      _devBirthdayStory,
      ...stories.where((story) => story.id != _devBirthdayStory.id),
    ];
  }

  List<StoryModel> parseStoriesPayload(dynamic payload) {
    final data = _unwrapDataAsMap(payload);
    final rawList = _asList(data['data']);
    return rawList
        .map((item) {
          final mediaUrl = Apis.resolveUrl((item['mediaUrl'] ?? '').toString());
          final thumbnail = Apis.resolveUrl(
            (item['thumbnail'] ?? '').toString(),
          );
          return StoryModel(
            id: (item['id'] ?? '').toString(),
            name: (item['title'] ?? '').toString(),
            imageUrl: mediaUrl,
            thumbnailUrl: thumbnail.isEmpty ? mediaUrl : thumbnail,
            isViewed: _parseBool(item['isViewed']),
            type: _parseStoryItemType(item['type']),
          );
        })
        .toList(growable: false);
  }

  Future<List<CourseModel>> getCoursesByUserType(UserType userType) async {
    final response = await _dio.get<dynamic>(AnonymousApis.coursesFeatured);
    final rawList = _unwrapDataAsList(response.data);
    return rawList.map(_mapCourse).toList(growable: false);
  }

  Future<HomeStatsModel> getStatsByUserType(UserType userType) async {
    if (userType == UserType.guest) {
      return const HomeStatsModel(
        coins: 0,
        grade: 0,
        rating: 0,
        lastLessonCategory: '',
        lastLessonProgress: 0,
      );
    }

    final response = await _dio.get<dynamic>(UserApis.userLastProgress);
    final progressData = _unwrapDataAsMap(response.data);
    final progressPercent = _parseDouble(progressData['progressPercent']);

    return HomeStatsModel(
      coins: _parseInt(progressData['coins']),
      // API: `last-progress` endpoint'dan "rating" ham keladi.
      // Home'dagi "Reyting" (oldin "Baho") shu qiymat bo'ladi.
      grade: _parseInt(progressData['rating']),
      rating: _parseInt(progressData['leaderboardRank']),
      lastLessonCategory: (progressData['lastLessonTitle'] ?? '').toString(),
      lastLessonProgress: (progressPercent / 100).clamp(0, 1),
    );
  }

  Future<List<TeacherModel>> getTeachersByUserType(UserType userType) async {
    return const [];
  }

  @override
  Future<List<BannerModel>> getBanners() => getBannersByUserType(UserType.user);

  @override
  Future<List<StoryModel>> getCategories() =>
      getCategoriesByUserType(UserType.user);

  @override
  Future<List<CourseModel>> getCourses() => getCoursesByUserType(UserType.user);

  @override
  Future<HomeStatsModel> getStats() => getStatsByUserType(UserType.user);

  @override
  Future<List<TeacherModel>> getTeachers() =>
      getTeachersByUserType(UserType.user);

  @override
  Future<void> postStoryView(String storyId) async {
    final trimmed = storyId.trim();
    if (trimmed.isEmpty) return;
    await _dio.post<dynamic>(UserApis.storyViewById(trimmed));
  }

  BannerModel _mapBanner(Map<String, dynamic> item) {
    return BannerModel(
      id: (item['id'] ?? '').toString(),
      title: (item['title'] ?? '').toString(),
      subtitle: (item['content'] ?? '').toString(),
      imageUrl: Apis.resolveUrl((item['photo'] ?? '').toString()),
      targetId: (item['targetId'] ?? item['target_id'] ?? '').toString().trim(),
      link: (item['link'] ?? item['url'] ?? '').toString().trim(),
    );
  }

  CourseModel _mapCourse(Map<String, dynamic> item) {
    return CourseModel(
      id: (item['id'] ?? '').toString(),
      title: (item['name'] ?? '').toString(),
      author: (item['teacherFullname'] ?? '').toString(),
      imageUrl: _resolveCourseImageUrl(item),
      durationSeconds: _parseInt(item['totalDuration']),
      studentCount: _parseInt(item['enrollmentCount']),
    );
  }

  String _resolveCourseImageUrl(Map<String, dynamic> item) {
    final icon = (item['icon'] ?? '').toString().trim();
    final banner = (item['bannerImage'] ?? '').toString().trim();
    final selected = icon.isNotEmpty ? icon : banner;
    return Apis.resolveUrl(selected);
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

  bool _parseBool(dynamic value) {
    if (value is bool) return value;
    if (value is String) {
      final lower = value.trim().toLowerCase();
      return lower == 'true' || lower == '1' || lower == 'yes';
    }
    if (value is num) return value != 0;
    return false;
  }

  StoryItemType _parseStoryItemType(dynamic value) {
    return value?.toString().trim().toLowerCase() == 'birthday'
        ? StoryItemType.birthday
        : StoryItemType.story;
  }
}
