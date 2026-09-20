import 'package:qizlar_academy_kit/gen/assets.gen.dart';
import 'package:qizlar_academy_mobile/feature/services_hub/domain/model/services_hub_game_item.dart';

/// O‘yin URL lari API Remote Config emas — alohida statik havolalar.
abstract final class ServicesHubGamesConfig {
  static const String game2048Url = 'https://2048-game-7tp.pages.dev/';
  static const String candyCrashUrl = 'https://candy-crash-2or.pages.dev/';

  static const Set<String> allowedGameHosts = {
    '2048-game-7tp.pages.dev',
    'candy-crash-2or.pages.dev',
  };

  static bool isAllowedGameUrl(Uri uri) {
    if (uri.scheme != 'https') return false;
    return allowedGameHosts.contains(uri.host);
  }

  static List<ServicesHubGameItem> games({
    required String game2048Description,
    required String candyCrashDescription,
  }) {
    return [
      ServicesHubGameItem(
        id: '2048',
        title: '2048',
        description: game2048Description,
        playUrl: game2048Url,
        backgroundAsset: UiKitAssets.images.servicesHub.gameCard2048Bg.path,
        playButtonLabel: '2048',
      ),
      ServicesHubGameItem(
        id: 'candy_crash',
        title: 'Candy Crash',
        description: candyCrashDescription,
        playUrl: candyCrashUrl,
        backgroundAsset: UiKitAssets.images.servicesHub.gameCardCandyBg.path,
        playButtonLabel: 'Go',
      ),
    ];
  }
}
