import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform, kIsWeb;

/// Google Sign-In (Android CredentialManager) uchun **Web** turidagi OAuth 2.0 client ID.
///
/// - **To‘g‘ri manba:** Firebase Console → Project settings → Your apps → **Web** ilovasining
///   `client_id`, yoki Authentication → Sign-in method → Google → *Web SDK configuration*.
/// - **Build:** `--dart-define=GOOGLE_SIGN_IN_WEB_CLIENT_ID=xxxx.apps.googleusercontent.com`
///
/// `_fallbackServerClientId` — loyihadagi [GoogleService-Info.plist] dagi `CLIENT_ID` (iOS).
/// Ishonchli **Web** client bilan almashtirish tavsiya etiladi; Web client bo‘lmasa,
/// Firebase’da Web ilova qo‘shing va `google-services.json` ni yangilang.
abstract final class GoogleSignInConfig {
  static const String _envServerClientId = String.fromEnvironment(
    'GOOGLE_SIGN_IN_WEB_CLIENT_ID',
    defaultValue: '',
  );

  /// iOS `GoogleService-Info.plist` → `CLIENT_ID` (loyiha OAuth ro‘yxatida mavjud).
  static const String _fallbackServerClientId =
      '17451483765-igr4sughli1vjv54iltokl8ke6v2guhr.apps.googleusercontent.com';

  /// Android’da majburiy; iOS/Web’da `null` (tizim o‘z konfiguratsiyasi).
  static String? get serverClientIdForInitialize {
    if (kIsWeb) return null;
    if (defaultTargetPlatform == TargetPlatform.android) {
      final fromEnv = _envServerClientId.trim();
      if (fromEnv.isNotEmpty) return fromEnv;
      return _fallbackServerClientId;
    }
    return null;
  }
}
