/// Meta (Facebook) App ID — yagona manba.
///
/// App ID manbai:
/// - `_appId` — yagona hard-lock qilingan production app ID.
///
/// Boshqa kodlarda Facebook App ID ga to‘g‘ridan-to‘g‘ri murojaat qilmang;
/// faqat shu klassdan o‘qing — bu ID iOS `Info.plist` (`FacebookAppID`),
/// Android `AndroidManifest.xml` (`com.facebook.sdk.ApplicationId`) va Meta
/// App Events SDK init bilan bir xilda saqlanishi kerak.
abstract final class FacebookConfig {
  /// Hozirgi Meta ilovasining App ID si. Native Info.plist / Manifest
  /// (`com.facebook.sdk.ApplicationId` / `FacebookAppID`) bilan sinxron
  /// bo‘lishi shart.
  static const String _appId = '1226563685979967';

  /// Yagona App ID (hard-lock).
  static String get appId => _appId;

  /// SDK ulanishi uchun App ID konfiguratsiyalanganmi?
  static bool get isConfigured => appId.isNotEmpty;
}
