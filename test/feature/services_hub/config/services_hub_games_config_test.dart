import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_mobile/feature/services_hub/config/services_hub_games_config.dart';

void main() {
  group('ServicesHubGamesConfig.isAllowedGameUrl', () {
    test('allows whitelisted https hosts', () {
      for (final host in ServicesHubGamesConfig.allowedGameHosts) {
        expect(
          ServicesHubGamesConfig.isAllowedGameUrl(Uri.parse('https://$host/')),
          isTrue,
        );
      }
    });

    test('rejects http scheme for a whitelisted host', () {
      final host = ServicesHubGamesConfig.allowedGameHosts.first;
      expect(
        ServicesHubGamesConfig.isAllowedGameUrl(Uri.parse('http://$host/')),
        isFalse,
      );
    });

    test('rejects hosts outside the whitelist', () {
      expect(
        ServicesHubGamesConfig.isAllowedGameUrl(
          Uri.parse('https://example.com/game'),
        ),
        isFalse,
      );
    });

    test('game items expose whitelisted play urls', () {
      final games = ServicesHubGamesConfig.games(
        game2048Description: '2048',
        candyCrashDescription: 'candy',
      );

      expect(games, hasLength(2));
      for (final game in games) {
        expect(
          ServicesHubGamesConfig.isAllowedGameUrl(Uri.parse(game.playUrl)),
          isTrue,
        );
      }
    });
  });
}
