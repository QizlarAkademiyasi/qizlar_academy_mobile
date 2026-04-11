/// Instagram Story ([appinio_social_share]) Meta/Facebook ilovasi ID si.
///
/// Build: `--dart-define=FACEBOOK_APP_ID=your_meta_app_id`
/// ([Meta for Developers](https://developers.facebook.com/) → ilova → asosiy sozlamalar → App ID).
abstract final class MetaShareConstants {
  static const String facebookAppId = String.fromEnvironment('FACEBOOK_APP_ID', defaultValue: '1262098222769251');
}
