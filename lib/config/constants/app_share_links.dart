import 'package:qizlar_academy_mobile/config/constants/app_deep_link_config.dart';

/// Ilovani ulashish va tashqi havolalar.
abstract final class AppShareLinks {
  AppShareLinks._();

  /// App Store / Google Play uchun yagona havola (OneLink).
  static const String storeOneLink = 'https://onelink.to/4h9hr9';

  /// Universal Link / App Links — kurs detali sahifasi (ilova ochiladi).
  static String courseDetailsHttpsUrl(String courseId) {
    final id = courseId.trim();
    if (id.isEmpty) {
      return storeOneLink;
    }
    return 'https://${AppDeepLinkConfig.defaultUniversalLinkHost}/courses/$id';
  }

  /// Rasmiy Telegram jamoat kanali ([AboutUsLocalDatasource] bilan mos).
  static const String telegramCommunityChannel = 'https://t.me/qizlarakademiyasi';

  static const String instagramProfile = 'https://www.instagram.com/qizlarakademiyasi/';

  static const String telegramChannel = 'https://t.me/qizlarakademiyasi';

  static const String telegramGroup = 'https://t.me/+FzaaFCLH7GY4MDVi';

  static const String youtubeChannel = 'https://www.youtube.com/@qizlar_akademiyasi';
}
