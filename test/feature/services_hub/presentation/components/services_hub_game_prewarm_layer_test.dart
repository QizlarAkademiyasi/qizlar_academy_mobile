import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/feature/services_hub/config/game_webview_audio.dart';
import 'package:qizlar_academy_mobile/feature/services_hub/presentation/components/services_hub_game_prewarm_layer.dart';

void main() {
  test('prewarm mute UserScript is injected at document start', () {
    final scripts = ServicesHubGamePrewarmLayer.muteUserScripts();

    expect(scripts, hasLength(1));
    expect(
      scripts.single.injectionTime,
      UserScriptInjectionTime.AT_DOCUMENT_START,
    );
    expect(scripts.single.source, gameWebViewMuteScript);
    expect(scripts.single.source, contains('window.__qaPrewarmMute = true'));
  });
}
