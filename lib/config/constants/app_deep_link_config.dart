import 'package:qizlar_academy_mobile/config/flavor/app_remote_config.dart';

/// Universal / App Links, push va `app_links` uchun yagona sozlamalar.
///
/// **FCM `data` kontrakti (backend):**
/// - `link` — to‘liq HTTPS yoki `qizlaracademy:` custom scheme havolasi (tavsiya).
/// - `route` — ilova ichidagi path, `/` bilan boshlanishi kerak (masalan `/courses/abc`).
///
/// **Serverda joylashtirish (App Links / Universal Links):**
/// - Android: repodagi `android/app/deeplink_assetlinks.json` ni nusxalab
///   `https://<defaultUniversalLinkHost>/.well-known/assetlinks.json` ga qo‘ying (Content-Type: `application/json`).
///   Prod: `uz.globalmove.girls_academy` + **release** keystore SHA256. Play App Signing bo‘lsa,
///   Play Console → App signing → **App signing key certificate** SHA256 (upload emas).
///   Bir xil `package_name` ichida bir nechta SHA256 qo‘shish mumkin (masalan release + debug).
///   Dev flavor (`uz.globalmove.girls_academy_dev`) uchun alohida `target` yoki shu massivga qo‘shing;
///   debug SHA: `keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android`.
/// - Android: `https://<deepLinkHost>/.well-known/assetlinks.json` — `package_name`
///   (`uz.globalmove.girls_academy` / dev: `uz.globalmove.girls_academy_dev`) va signing SHA256.
/// - iOS: repodagi `ios/apple-app-site-association.json` — hostingda
///   `/.well-known/apple-app-site-association` (ko‘pincha **kengaytmasiz**), `appID` = `TeamID.BundleID`
///   (masalan `C8ASSFN5K9.uz.qizlar.akademiyasi` — Xcode `DEVELOPMENT_TEAM` + `PRODUCT_BUNDLE_IDENTIFIER`).
///
/// **Qo‘llab-quvvatlanadigan marshrutlar** ([Routes] bilan mos, `extra` talab qilinmaydiganlar):
/// `/courses/:id`, `/courses/:id/player`, `/courses/:id/review`,
/// `/lesson-quiz/:lessonId`,
/// `/notification`, `/my-courses`, `/my-certificates`,
/// `/vacancies`, `/vacancies/:vacancyId`,
/// `/portfolio/:postId`,
/// `/about-us`, `/privacy-policy`,
/// `/sign-in`, `/register`, `/main`, `/main/guest`, `/main/user`.
///
/// **Hozircha qo‘llab-quvvatlanmaydi** (Bloc yoki `extra` majburiy): `/courses-search`,
/// `/lesson-quiz-result`, `/verification`, `/profile/information`.
abstract final class AppDeepLinkConfig {
  AppDeepLinkConfig._();

  /// FCM va boshqa payload kalitlari.
  static const String fcmDataKeyLink = 'link';
  static const String fcmDataKeyRoute = 'route';

  /// [AndroidManifest] / [Info.plist] bilan mos custom scheme.
  static const String customUrlScheme = 'qizlaracademy';

  /// Android `manifestPlaceholders["deepLinkHost"]` va iOS Associated Domains bilan bir xil host.
  /// `android/local.properties` da `deeplink.host=sizning.host` orqali almashtiriladi (ixtiyoriy).
  static const String defaultUniversalLinkHost = 'www.qizlarakademiyasi.uz';

  /// Remote Config API domenidan tashqari ruxsat etilgan HTTPS hostlar.
  static const Set<String> additionalAllowedHosts = {'qizlarakademiyasi.uz'};

  /// HTTPS havolalar uchun ruxsat etilgan hostlar to‘plami.
  static Set<String> resolvedHttpsHosts() {
    final hosts = <String>{defaultUniversalLinkHost, ...additionalAllowedHosts};
    final raw = AppRemoteConfig.instance.domain.trim();
    if (raw.isEmpty) {
      return hosts;
    }
    final base = Uri.tryParse(raw);
    if (base != null && base.hasAuthority && base.host.isNotEmpty) {
      hosts.add(base.host);
    }
    return hosts;
  }
}
