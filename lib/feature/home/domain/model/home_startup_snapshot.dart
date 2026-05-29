import 'package:qizlar_academy_mobile/config/constants/enum/user_type.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/banner_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/category_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/course_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/home_stats_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/teacher_model.dart';

final class HomeStartupSnapshot {
  const HomeStartupSnapshot({
    required this.userType,
    required this.homeStats,
    required this.categories,
    required this.teachers,
    required this.courses,
    required this.banners,
    required this.userGreetingName,
  });

  final UserType userType;
  final HomeStatsModel homeStats;
  final List<StoryModel> categories;
  final List<TeacherModel> teachers;
  final List<CourseModel> courses;
  final List<BannerModel> banners;
  final String userGreetingName;
}

/// Splash paytida preload qilingan Home datalari uchun in-memory cache.
///
/// Maqsad: native splash (first frame) turib turganida HomeScreen ma'lumotlarini
/// oldindan olib qo'yish va HomeBloc birinchi ochilganda ikki marta fetch bo'lmasin.
final class HomeStartupCache {
  HomeStartupSnapshot? _snapshot;

  void set(HomeStartupSnapshot snapshot) => _snapshot = snapshot;

  HomeStartupSnapshot? consumeIfMatches(UserType userType) {
    final snapshot = _snapshot;
    if (snapshot == null) return null;
    if (snapshot.userType != userType) return null;
    _snapshot = null;
    return snapshot;
  }

  void clear() => _snapshot = null;
}
