import 'package:qizlar_academy_mobile/config/flavor/app_remote_config.dart';

sealed class Apis {
  static String get baseUrl => AppRemoteConfig.instance.domain;

  /// Media (rasm, fayl) URL lari uchun asos — [resolveUrl] nisbiy yo‘llarni shu hostga bog‘laydi.
  static String get imageBaseUrl =>
      'https://pub-b6fcb2447c334506b2c5bc5f9b5e969f.r2.dev';

  /// Resolves remote media URLs into absolute URLs.
  /// - Absolute `http(s)://...` — o‘zgartirilmay qaytariladi.
  /// - `//host/...` — `https:` bilan to‘ldiriladi.
  /// - API yo‘llar (`/api/...`) [baseUrl] ga qarshi [Uri.resolve] qilinadi.
  /// - Nisbiy media yo‘llar (`/uploads/...` yoki `uploads/...`) [imageBaseUrl] ga qarshi [Uri.resolve] qilinadi.
  static String resolveUrl(String raw) {
    final value = raw.trim();
    if (value.isEmpty) return '';

    if (value.startsWith('//')) {
      final absolute = Uri.tryParse('https:$value');
      if (absolute != null && absolute.hasScheme && absolute.hasAuthority) {
        return absolute.toString();
      }
    }

    final parsed = Uri.tryParse(value);
    if (parsed != null && parsed.hasScheme && parsed.hasAuthority) {
      return value;
    }

    var path = value.replaceFirst(RegExp(r'^/+'), '/');
    if (!path.startsWith('/')) {
      path = '/$path';
    }

    // API fayllari (sertifikat PDF kabi) app backend domainida bo‘ladi.
    final baseCandidate = path.startsWith('/api/') ? baseUrl : imageBaseUrl;
    final base = Uri.tryParse(baseCandidate);
    if (base == null) return '$imageBaseUrl$path';
    return base.resolve(path).toString();
  }

  /// Sertifikat fayli uchun: allaqachon to‘liq `http(s)://...` (masalan R2) bo‘lsa qayta resolve qilinmaydi.
  static String certificateFileRequestUrl(String raw) {
    final t = raw.trim();
    if (t.isEmpty) return '';
    final u = Uri.tryParse(t);
    if (u != null && u.hasScheme && (u.isScheme('https') || u.isScheme('http'))) {
      return t;
    }
    return resolveUrl(t);
  }
}

sealed class AnonymousApis {
  static const String authOtpPhoneNumber = '/api/v1/auth/otp/phone-number';
  static const String authOtpBotPhoneNumber =
      '/api/v1/auth/otp/bot/phone-number';
  static const String authSignIn = '/api/v1/auth/signin';
  static const String authGoogle = '/api/v1/auth/google';
  static const String authRefresh = '/api/v1/auth/refresh';

  static const String storiesPublic = '/api/v1/story/public';

  static const String bannersPublic = '/api/v1/banner/public';
  static const String sponsorsPublic = '/api/v1/sponsor/public';

  static const String coursesFeatured = '/api/v1/course/featured';
  static const String coursesClientPublic = '/api/v1/course/client/public';
  static const String coursesLeaderboardPublic =
      '/api/v1/course/leaderboard/public';

  static String courseModulesByCourseIdPublic(String courseId) =>
      '/api/v1/course/$courseId/module/public';

  static String lessonByIdClientPublic(String lessonId) =>
      '/api/v1/lesson/$lessonId/client/public';
}

sealed class UserApis {
  static const String authLogout = '/api/v1/auth/logout';

  static const String userMe = '/api/v1/user/me';
  static String userProfileById(String id) => '/api/v1/user/profile/$id';
  static const String fileUpload = '/api/v1/file';
  static const String userLastProgress = '/api/v1/user/last-progress';
  static const String activityPing = '/api/v1/activity/ping';
  static const String profileNotifications = '/api/v1/profile/notifications';
  static const String notificationSubscribe = '/api/v1/notification/subscribe';
  static const String notificationUnsubscribe = '/api/v1/notification/unsubscribe';
  static const String profileLanguage = '/api/v1/profile/language';

  static const String stories = '/api/v1/story/client';
  static String storyViewById(String storyId) => '/api/v1/story/$storyId/view';

  static const String banners = '/api/v1/banner';

  static const String coursesClient = '/api/v1/course/client';
  static const String coursesMy = '/api/v1/course/my';
  static const String coursesLeaderboard = '/api/v1/course/leaderboard';

  static String courseDetails(String courseId) => '/api/v1/course/$courseId';

  static String courseModulesByCourseId(String courseId) =>
      '/api/v1/course/$courseId/module';
  static String courseModuleById({
    required String courseId,
    required String moduleId,
  }) => '/api/v1/course/$courseId/module/$moduleId';

  static String courseEnrollById(String courseId) =>
      '/api/v1/course/$courseId/enroll';
  static String courseProgressById(String courseId) =>
      '/api/v1/course/$courseId/progress';

  static const String courseRating = '/api/v1/course-rating';

  static String courseRatingsByCourseId(String courseId) =>
      '/api/v1/course-rating/course/$courseId';

  static String lessonByIdClient(String lessonId) =>
      '/api/v1/lesson/$lessonId/client';
  static String lessonCompleteById(String lessonId) =>
      '/api/v1/lesson/$lessonId/complete';

  static String quizQuestionsByLessonId(String lessonId) =>
      '/api/v1/quiz/lesson/$lessonId';
  static const String quizSubmit = '/api/v1/quiz/submit';

  static const String notifications = '/api/v1/notification';
  static const String notificationsReadAll = '/api/v1/notification/read-all';
  static String notificationsReadById(String id) =>
      '/api/v1/notification/${Uri.encodeComponent(id)}/read';

  static const String leaderboard = '/api/v1/leaderboard';
  static const String leaderboardCourses = '/api/v1/leaderboard/courses';

  static const String certificatesMy = '/api/v1/certificate/my';

  /// Kurs yakunlanganidan so‘ng sertifikat olish (ariza / ma’lumot).
  static String certificateCourseByCourseId(String courseId) =>
      '/api/v1/certificate/course/${Uri.encodeComponent(courseId)}';

  /// Rasm sertifikati (binary PNG, `application/png`).
  static String certificateImageByCourseId(String courseId) =>
      '/api/v1/certificate/image/${Uri.encodeComponent(courseId)}';

  static const String vacanciesClient = '/api/v1/vacancy/client';

  static String vacancyClientById(String id) =>
      '/api/v1/vacancy/client/${Uri.encodeComponent(id)}';
}
