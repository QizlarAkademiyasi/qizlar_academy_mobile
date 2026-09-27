import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/feature/services_hub/config/game_webview_audio.dart';

void main() {
  group('gameWebViewMuteScript', () {
    test('sets the prewarm mute flag and wraps HTMLMediaElement.play', () {
      expect(gameWebViewMuteScript, contains(gameWebViewPrewarmMuteFlag));
      expect(gameWebViewMuteScript, contains('window.__qaPrewarmMute = true'));
      expect(
        gameWebViewMuteScript,
        contains('HTMLMediaElement.prototype.play'),
      );
      expect(gameWebViewMuteScript, contains('this.muted = true'));
      expect(gameWebViewMuteScript, contains('this.volume = 0'));
    });

    test('mutes Howler and existing audio/video', () {
      expect(gameWebViewMuteScript, contains('Howler.mute(true)'));
      expect(gameWebViewMuteScript, contains("querySelectorAll('audio, video')"));
      expect(gameWebViewMuteScript, contains('media[i].pause()'));
    });
  });

  group('gameWebViewUnmuteScript', () {
    test('clears the mute flag and restores Howler without forcing volume', () {
      expect(gameWebViewUnmuteScript, contains('window.__qaPrewarmMute = false'));
      expect(gameWebViewUnmuteScript, contains('Howler.mute(false)'));
      expect(gameWebViewUnmuteScript, contains('media[i].muted = false'));
      expect(gameWebViewUnmuteScript, isNot(contains('volume = 1')));
    });
  });

  group('gameWebViewMuteUserScripts', () {
    test('injects mute script at document start', () {
      final scripts = gameWebViewMuteUserScripts();

      expect(scripts, hasLength(1));
      expect(
        scripts.single.injectionTime,
        UserScriptInjectionTime.AT_DOCUMENT_START,
      );
      expect(scripts.single.source, gameWebViewMuteScript);
    });
  });
}
