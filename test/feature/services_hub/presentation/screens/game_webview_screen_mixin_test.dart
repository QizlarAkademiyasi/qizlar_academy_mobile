import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_mobile/feature/services_hub/presentation/screens/game_webview/game_webview_screen_mixin.dart';

void main() {
  group('shouldCompleteGameLoad', () {
    test('completes when progress reaches 100', () {
      expect(shouldCompleteGameLoad(progress: 100), isTrue);
      expect(shouldCompleteGameLoad(progress: 99), isFalse);
    });

    test('completes on load stop even when progress is still zero', () {
      expect(shouldCompleteGameLoad(progress: 0, loadStop: true), isTrue);
    });

    test('does not complete without progress or load stop', () {
      expect(shouldCompleteGameLoad(), isFalse);
      expect(shouldCompleteGameLoad(progress: 0), isFalse);
    });
  });
}
