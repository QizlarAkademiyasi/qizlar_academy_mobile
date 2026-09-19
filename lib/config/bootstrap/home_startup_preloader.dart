import 'dart:async';

import 'package:qizlar_academy_mobile/config/constants/enum/user_type.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/config/logs/logs.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/bloc/auth_session_cubit.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/banner_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/course_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/home_stats_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/home_startup_snapshot.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/home_user_profile_snippet.dart';
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

      final profileSnippetFuture = _loadProfileSnippet(userType, profile);
      final results = await Future.wait<Object>([
        home.getStats(),
        home.getTeachers(),
        home.getCourses(),
        home.getBanners(),
        profileSnippetFuture,
      ]);
      final snippet = results[4] as HomeUserProfileSnippet;

      getIt<HomeStartupCache>().set(
        HomeStartupSnapshot(
          userType: userType,
          homeStats: results[0] as HomeStatsModel,
          teachers: results[1] as List<TeacherModel>,
          courses: results[2] as List<CourseModel>,
          banners: results[3] as List<BannerModel>,
          userGreetingName: snippet.greetingName,
          userBadgeId: snippet.badgeId,
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

  static Future<HomeUserProfileSnippet> _loadProfileSnippet(
    UserType userType,
    ProfileRepository profile,
  ) async {
    if (userType != UserType.user) return HomeUserProfileSnippet.empty;
    try {
      final overview = await profile.getProfileOverview();
      final user = overview.user;
      final first = user.firstName.trim();
      final name = first.isNotEmpty
          ? first
          : (user.fullName.trim().isNotEmpty ? user.fullName.trim() : '');
      return HomeUserProfileSnippet(
        greetingName: name,
        badgeId: user.badgeId,
      );
    } catch (_) {}
    return HomeUserProfileSnippet.empty;
  }
}
