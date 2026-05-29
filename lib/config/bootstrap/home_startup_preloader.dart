import 'dart:async';

import 'package:qizlar_academy_mobile/config/constants/enum/user_type.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/config/logs/logs.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/bloc/auth_session_cubit.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/banner_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/category_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/course_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/home_stats_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/home_startup_snapshot.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/teacher_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/repository/home_repository.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/repository/profile_repository.dart';

abstract final class HomeStartupPreloader {
  HomeStartupPreloader._();

  static Future<void> preload() async {
    try {
      final auth = getIt<AuthSessionCubit>().state;
      if (!auth.isInitialized) return;

      final userType = auth.userType;
      final home = getIt<HomeRepository>();
      final profile = getIt<ProfileRepository>();

      final greetingFuture = _loadGreetingName(userType, profile);
      final results = await Future.wait<Object>([
        home.getStats(),
        home.getCategories(),
        home.getTeachers(),
        home.getCourses(),
        home.getBanners(),
        greetingFuture,
      ]);

      getIt<HomeStartupCache>().set(
        HomeStartupSnapshot(
          userType: userType,
          homeStats: results[0] as HomeStatsModel,
          categories: results[1] as List<StoryModel>,
          teachers: results[2] as List<TeacherModel>,
          courses: results[3] as List<CourseModel>,
          banners: results[4] as List<BannerModel>,
          userGreetingName: results[5] as String,
        ),
      );
    } catch (e, st) {
      // Preload muvaffaqiyatsiz bo'lsa ham app ishlashi kerak.
      AppLogger.w(
        'HomeStartupPreloader.preload failed',
        error: e,
        stackTrace: st,
      );
      getIt<HomeStartupCache>().clear();
    }
  }

  static Future<String> _loadGreetingName(
    UserType userType,
    ProfileRepository profile,
  ) async {
    if (userType != UserType.user) return '';
    try {
      final overview = await profile.getProfileOverview();
      final first = overview.user.firstName.trim();
      if (first.isNotEmpty) return first;
      final full = overview.user.fullName.trim();
      if (full.isNotEmpty) return full;
    } catch (_) {}
    return '';
  }
}
