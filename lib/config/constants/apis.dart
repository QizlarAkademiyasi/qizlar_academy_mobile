import 'package:qizlar_academy_mobile/config/flavor/app_remote_config.dart';

sealed class Apis {
  static String get baseUrl => AppRemoteConfig.instance.domain;

  static const String authOtpPhoneNumber = '/api/v1/auth/otp/phone-number';
  static const String authSignIn = '/api/v1/auth/signin';
  static const String authGoogle = '/api/v1/auth/google';
  static const String authRefresh = '/api/v1/auth/refresh';
  static const String authLogout = '/api/v1/auth/logout';

  static const String userMe = '/api/v1/user/me';
  static const String userLastProgress = '/api/v1/user/last-progress';
  static const String profileNotifications = '/api/v1/profile/notifications';
  static const String profileLanguage = '/api/v1/profile/language';

  static const String stories = '/api/v1/story/client';
  static const String banners = '/api/v1/banner';
  static const String bannersPublic = '/api/v1/banner/public';
  static const String sponsorsPublic = '/api/v1/sponsor/public';
  static const String coursesFeatured = '/api/v1/course/featured';
  static const String coursesClient = '/api/v1/course/client';
  static const String coursesClientPublic = '/api/v1/course/client/public';

  static String courseDetails(String id) => '/api/courses/$id';
  static const String leaderboard = '/api/leaderboard';
  static const String notifications = '/api/v1/notification';
  static const String notificationsReadAll = '/api/v1/notification/read-all';
  static String notificationsReadById(String id) =>
      '/api/v1/notification/$id/read';
}
