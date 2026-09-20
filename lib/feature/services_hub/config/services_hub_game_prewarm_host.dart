import 'dart:async';

import 'package:qizlar_academy_mobile/feature/services_hub/config/services_hub_game_keep_alive_store.dart';
import 'package:qizlar_academy_mobile/feature/services_hub/config/services_hub_games_config.dart';

/// Logged-in [MainScreen] ochilganda o‘yinlarni ketma-ket headless prewarm qiladi.
class ServicesHubGamePrewarmHost {
  static const Duration startDelay = Duration(milliseconds: 300);

  Timer? _timer;

  void schedule() {
    _timer?.cancel();
    _timer = Timer(startDelay, () {
      unawaited(
        ServicesHubGameKeepAliveStore.startPrewarm(
          ServicesHubGamesConfig.games(
            game2048Description: '',
            candyCrashDescription: '',
          ),
        ),
      );
    });
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}
