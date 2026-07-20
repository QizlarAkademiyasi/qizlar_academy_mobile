/// Ilovani ulashish va tashqi havolalar.
abstract final class AppShareLinks {
  AppShareLinks._();

  /// App Store / Google Play uchun yagona havola (OneLink).
  static const String storeOneLink = 'https://onelink.to/4h9hr9';

  /// Rasmiy Telegram jamoat kanali ([AboutUsLocalDatasource] bilan mos).
  static const String telegramCommunityChannel = 'https://t.me/qizlarakademiyasi';

  static const String instagramProfile = 'https://www.instagram.com/qizlarakademiyasi/';

  static const String telegramChannel = 'https://t.me/qizlarakademiyasi';

  static const String telegramGroup = 'https://t.me/+FzaaFCLH7GY4MDVi';

  static const String youtubeChannel = 'https://www.youtube.com/@qizlar_akademiyasi';

  /// Universal link host (App Links / Universal Links bilan bir xil).
  static const String universalLinkBase = 'https://www.qizlarakademiyasi.uz';

  /// Kursni ulashish:
  /// `https://www.qizlarakademiyasi.uz/courses/{courseId}`
  ///
  /// Bu format app killed holatda ham universal link orqali deep link routeni
  /// to'g'ri tiklashga xizmat qiladi.
  static String courseDetailsHttpsUrl(String courseId) {
    final id = courseId.trim();
    if (id.isEmpty) return universalLinkBase;
    return Uri.parse(universalLinkBase)
        .resolve('/courses/${Uri.encodeComponent(id)}')
        .toString();
  }

  /// Portfolio postini ulashish:
  /// `https://www.qizlarakademiyasi.uz/portfolio/{postId}`
  static String portfolioPostHttpsUrl(String postId) {
    final id = postId.trim();
    if (id.isEmpty) return universalLinkBase;
    return Uri.parse(universalLinkBase)
        .resolve('/portfolio/${Uri.encodeComponent(id)}')
        .toString();
  }

  /// App Store 5.1.1(v) — hisobni o‘chirish so‘rovi uchun veb sahifa.
  static const String accountDeletionWebUrl = 'https://qizlarakademiyasi.uz/account-deletion';
}
