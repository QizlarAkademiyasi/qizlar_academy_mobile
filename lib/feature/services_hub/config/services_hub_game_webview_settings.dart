import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

/// User ochgan game session WebView sozlamalari.
InAppWebViewSettings gameWebViewSettings() {
  return InAppWebViewSettings(
    javaScriptEnabled: true,
    mediaPlaybackRequiresUserGesture: false,
    transparentBackground: false,
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
