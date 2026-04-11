import 'package:qizlar_academy_mobile/config/constants/app_deep_link_config.dart';
import 'package:qizlar_academy_mobile/config/logs/app_logger.dart';

/// Havola yoki FCM `data` dan [GoRouter] `location` qatori.
final class AppDeepLinkParser {
  static final RegExp _coursePath = RegExp(r'^/courses/[^/]+(/player|/review)?$');
  static final RegExp _lessonQuizPath = RegExp(r'^/lesson-quiz/[^/]+$');
  static final RegExp _vacancyDetailPath = RegExp(r'^/vacancies/[^/]+$');

  static const Set<String> _exactPaths = {
    '/notification',
    '/my-courses',
    '/my-certificates',
    '/vacancies',
    '/about-us',
    '/privacy-policy',
    '/sign-in',
    '/register',
    '/main',
    '/main/guest',
    '/main/user',
  };

  /// FCM `data` (qiymatlar string) — [AppDeepLinkConfig] dagi kalitlar.
  String? parseFromFcmData(Map<String, dynamic> data) {
    final link = _stringFromData(data, AppDeepLinkConfig.fcmDataKeyLink);
    if (link != null && link.isNotEmpty) {
      final uri = Uri.tryParse(link);
      if (uri != null) {
        final loc = parseUriToLocation(uri);
        if (loc != null) {
          return loc;
        }
      }
    }
    final route = _stringFromData(data, AppDeepLinkConfig.fcmDataKeyRoute);
    if (route != null && route.isNotEmpty) {
      return parsePathOnly(route);
    }
    return null;
  }

  String? _stringFromData(Map<String, dynamic> data, String key) {
    final direct = data[key];
    if (direct != null) {
      return direct.toString().trim();
    }
    for (final e in data.entries) {
      if (e.key.toLowerCase() == key.toLowerCase()) {
        return e.value?.toString().trim();
      }
    }
    return null;
  }

  String? parsePathOnly(String rawPath) {
    final normalized = _normalizePath(rawPath);
    if (normalized == null) {
      return null;
    }
    return _isAllowedPath(normalized) ? normalized : null;
  }

  String? parseUriToLocation(Uri uri) {
    if (uri.scheme == AppDeepLinkConfig.customUrlScheme) {
      final path = _pathFromCustomSchemeUri(uri);
      if (path == null) {
        return null;
      }
      return _isAllowedPath(path) ? path : null;
    }

    if (uri.scheme == 'https' || uri.scheme == 'http') {
      if (!uri.hasAuthority) {
        return null;
      }
      final allowed = AppDeepLinkConfig.resolvedHttpsHosts();
      if (!allowed.contains(uri.host)) {
        AppLogger.d('Deep link: host rad etildi: ${uri.host}');
        return null;
      }
      final path = _normalizePath(uri.path);
      if (path == null) {
        return null;
      }
      return _isAllowedPath(path) ? path : null;
    }

    return null;
  }

  String? _pathFromCustomSchemeUri(Uri uri) {
    if (uri.host.isNotEmpty) {
      final p = uri.path;
      final suffix = (p.isEmpty || p == '/') ? '' : p;
      return _normalizePath('/${uri.host}$suffix');
    }
    var p = uri.path;
    if (p.isEmpty) {
      return null;
    }
    if (!p.startsWith('/')) {
      p = '/$p';
    }
    return _normalizePath(p);
  }

  String? _normalizePath(String raw) {
    var p = raw.trim();
    if (p.isEmpty) {
      return null;
    }
    if (!p.startsWith('/')) {
      p = '/$p';
    }
    final q = p.indexOf('?');
    if (q >= 0) {
      p = p.substring(0, q);
    }
    if (p.contains('..')) {
      return null;
    }
    if (p.length > 512) {
      return null;
    }
    while (p.length > 1 && p.endsWith('/')) {
      p = p.substring(0, p.length - 1);
    }
    return p;
  }

  bool _isAllowedPath(String path) {
    if (_exactPaths.contains(path)) {
      return true;
    }
    if (_coursePath.hasMatch(path)) {
      return true;
    }
    if (_lessonQuizPath.hasMatch(path)) {
      return true;
    }
    if (_vacancyDetailPath.hasMatch(path)) {
      return true;
    }
    return false;
  }
}
