import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_mobile/feature/services_hub/config/services_hub_game_keep_alive_store.dart';

void main() {
  group('ServicesHubGameKeepAliveStore', () {
    test('returns the same keepAlive instance for one gameId', () {
      final first = ServicesHubGameKeepAliveStore.of('2048');
      final second = ServicesHubGameKeepAliveStore.of('2048');

      expect(first, same(second));
    });

    test('returns different instances for different gameIds', () {
      final game2048 = ServicesHubGameKeepAliveStore.of('2048');
      final candy = ServicesHubGameKeepAliveStore.of('candy_crash');

      expect(game2048, isNot(same(candy)));
    });

    test('tracks warmed state per gameId', () {
      expect(ServicesHubGameKeepAliveStore.isWarmed('warm_game'), isFalse);

      ServicesHubGameKeepAliveStore.markWarmed('warm_game');
      expect(ServicesHubGameKeepAliveStore.isWarmed('warm_game'), isTrue);
      expect(ServicesHubGameKeepAliveStore.isWarmed('other_game'), isFalse);

      ServicesHubGameKeepAliveStore.clearWarmed('warm_game');
      expect(ServicesHubGameKeepAliveStore.isWarmed('warm_game'), isFalse);
    });

    test('tracks prewarming state per gameId', () {
      expect(ServicesHubGameKeepAliveStore.isPrewarming('busy_game'), isFalse);

      ServicesHubGameKeepAliveStore.beginPrewarm('busy_game');
      expect(ServicesHubGameKeepAliveStore.isPrewarming('busy_game'), isTrue);
      expect(ServicesHubGameKeepAliveStore.isPrewarming('free_game'), isFalse);

      ServicesHubGameKeepAliveStore.endPrewarm('busy_game');
      expect(ServicesHubGameKeepAliveStore.isPrewarming('busy_game'), isFalse);
    });
  });
}
