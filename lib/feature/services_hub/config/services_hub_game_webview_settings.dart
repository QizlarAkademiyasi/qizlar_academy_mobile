import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

/// Prewarm layer va o‘yin ekrani bitta sozlamadan foydalanadi — aks holda
/// cache mos kelmaydi va prewarm foydasi yo‘qoladi.
InAppWebViewSettings gameWebViewSettings() {
  return InAppWebViewSettings(
    javaScriptEnabled: true,
    mediaPlaybackRequiresUserGesture: false,
    transparentBackground: true,
    useShouldOverrideUrlLoading: true,
    cacheEnabled: true,
    clearCache: false,
    cacheMode: CacheMode.LOAD_DEFAULT,
    supportZoom: false,
    disableVerticalScroll: true,
    disableHorizontalScroll: true,
    disallowOverScroll: true,
    isTextInteractionEnabled: false,
    allowsInlineMediaPlayback: true,
    allowsBackForwardNavigationGestures: false,
  );
}
