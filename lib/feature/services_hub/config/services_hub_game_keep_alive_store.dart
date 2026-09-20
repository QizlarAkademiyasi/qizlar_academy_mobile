import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

/// O‘yin WebView instancelarini tirik saqlash: bir marta yuklangan o‘yin
/// keyingi ochilishda darhol chiqadi va holati saqlanadi.
///
/// Bitta [InAppWebViewKeepAlive] bir vaqtda faqat bitta `InAppWebView` ga
/// ulanadi — prewarm layer yuklab bo‘lgach o‘zini unmount qilishi shart.
abstract final class ServicesHubGameKeepAliveStore {
  static final Map<String, InAppWebViewKeepAlive> _instances = {};
  static final Set<String> _warmed = {};
  static final Set<String> _prewarming = {};

  static InAppWebViewKeepAlive of(String gameId) {
    return _instances.putIfAbsent(gameId, InAppWebViewKeepAlive.new);
  }

  static bool isWarmed(String gameId) => _warmed.contains(gameId);

  static void markWarmed(String gameId) => _warmed.add(gameId);

  static void clearWarmed(String gameId) => _warmed.remove(gameId);

  /// Prewarm layer keepAlive ni band qilib turgan payt — bu vaqtda o‘yin
  /// ekrani keepAlive ga ulanmaydi, aks holda bitta instance ikki
  /// `InAppWebView` ga ulanib qoladi.
  static bool isPrewarming(String gameId) => _prewarming.contains(gameId);

  static void beginPrewarm(String gameId) => _prewarming.add(gameId);

  static void endPrewarm(String gameId) => _prewarming.remove(gameId);

  static Future<void> disposeAll() async {
    for (final keepAlive in _instances.values) {
      await InAppWebViewController.disposeKeepAlive(keepAlive);
    }
    _instances.clear();
    _warmed.clear();
    _prewarming.clear();
  }
}
