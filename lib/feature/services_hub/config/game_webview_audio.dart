import 'dart:collection';

import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

/// Prewarm keepAlive WebView da musiqa ovozsiz qolishi uchun JS flag.
const String gameWebViewPrewarmMuteFlag = '__qaPrewarmMute';

/// [HTMLMediaElement.play] wrap + mavjud media/Howler ni mute qiladi.
///
/// Play davom etadi — o‘yin state buzilmasin, faqat ovoz o‘chadi.
const String gameWebViewMuteScript = '''
(function () {
  window.__qaPrewarmMute = true;
  if (!window.__qaPrewarmPlayWrapped) {
    window.__qaPrewarmPlayWrapped = true;
    var originalPlay = HTMLMediaElement.prototype.play;
    HTMLMediaElement.prototype.play = function () {
      if (window.__qaPrewarmMute) {
        this.muted = true;
        this.volume = 0;
      }
      return originalPlay.apply(this, arguments);
    };
  }
  var media = document.querySelectorAll('audio, video');
  for (var i = 0; i < media.length; i++) {
    media[i].muted = true;
    media[i].volume = 0;
    media[i].pause();
  }
  if (window.Howler && typeof window.Howler.mute === 'function') {
    window.Howler.mute(true);
  }
})();
''';

/// Play ekrani ochilganda ovozni qaytaradi. Volume ni 1 ga majburlamaydi.
const String gameWebViewUnmuteScript = '''
(function () {
  window.__qaPrewarmMute = false;
  var media = document.querySelectorAll('audio, video');
  for (var i = 0; i < media.length; i++) {
    media[i].muted = false;
  }
  if (window.Howler && typeof window.Howler.mute === 'function') {
    window.Howler.mute(false);
  }
})();
''';

/// Prewarm `InAppWebView` uchun DOCUMENT_START mute.
UnmodifiableListView<UserScript> gameWebViewMuteUserScripts() {
  return UnmodifiableListView<UserScript>([
    UserScript(
      source: gameWebViewMuteScript,
      injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START,
    ),
  ]);
}
