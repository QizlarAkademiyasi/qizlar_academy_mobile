import 'dart:async';

import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/feature/services_hub/config/services_hub_game_keep_alive_store.dart';
import 'package:qizlar_academy_mobile/feature/services_hub/config/services_hub_game_webview_settings.dart';
import 'package:qizlar_academy_mobile/feature/services_hub/domain/model/services_hub_game_item.dart';

/// O‘yinlarni ekran tashqarisida oldindan yuklaydi, shunda o‘yin ekrani
/// darhol ochiladi. Yuklab bo‘lgach widget o‘zini olib tashlaydi — native
/// instance [ServicesHubGameKeepAliveStore] orqali tirik qoladi.
///
/// `Stack` ning bevosita bolasi bo‘lishi kerak (`Positioned` qaytaradi).
class ServicesHubGamePrewarmLayer extends StatefulWidget {
  const ServicesHubGamePrewarmLayer({
    super.key,
    required this.games,
  });

  static const Duration startDelay = Duration(milliseconds: 300);
  static const double prewarmWidth = 360;
  static const double prewarmHeight = 640;

  final List<ServicesHubGameItem> games;

  @override
  State<ServicesHubGamePrewarmLayer> createState() =>
      _ServicesHubGamePrewarmLayerState();
}

class _ServicesHubGamePrewarmLayerState
    extends State<ServicesHubGamePrewarmLayer> {
  final List<ServicesHubGameItem> _pending = [];
  Timer? _startTimer;

  @override
  void initState() {
    super.initState();
    _startTimer = Timer(ServicesHubGamePrewarmLayer.startDelay, _startPrewarm);
  }

  @override
  void dispose() {
    _startTimer?.cancel();
    for (final game in _pending) {
      ServicesHubGameKeepAliveStore.endPrewarm(game.id);
    }
    super.dispose();
  }

  void _startPrewarm() {
    if (!mounted) return;
    final games = widget.games
        .where(
          (game) =>
              !ServicesHubGameKeepAliveStore.isWarmed(game.id) &&
              !ServicesHubGameKeepAliveStore.isPrewarming(game.id),
        )
        .toList();
    if (games.isEmpty) return;
    for (final game in games) {
      ServicesHubGameKeepAliveStore.beginPrewarm(game.id);
    }
    setState(() => _pending.addAll(games));
  }

  void _finishPrewarm(String gameId, {required bool warmed}) {
    if (!mounted) {
      ServicesHubGameKeepAliveStore.endPrewarm(gameId);
      if (warmed) ServicesHubGameKeepAliveStore.markWarmed(gameId);
      return;
    }
    setState(() => _pending.removeWhere((game) => game.id == gameId));
    // keepAlive bo‘shashi shu kadrdagi unmount tugagandan keyin — aks holda
    // o‘yin ekrani bir vaqtda o‘sha instance ga ulanib qolishi mumkin.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ServicesHubGameKeepAliveStore.endPrewarm(gameId);
      if (warmed) ServicesHubGameKeepAliveStore.markWarmed(gameId);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_pending.isEmpty) {
      return const Positioned(
        top: 0,
        left: 0,
        child: SizedBox.shrink(),
      );
    }

    return Positioned(
      top: -(ServicesHubGamePrewarmLayer.prewarmHeight + 100),
      left: 0,
      width: ServicesHubGamePrewarmLayer.prewarmWidth,
      height: ServicesHubGamePrewarmLayer.prewarmHeight,
      child: IgnorePointer(
        child: Stack(
          children: [
            for (final game in _pending)
              Positioned.fill(
                child: InAppWebView(
                  key: ValueKey('prewarm_${game.id}'),
                  keepAlive: ServicesHubGameKeepAliveStore.of(game.id),
                  initialUrlRequest: URLRequest(url: WebUri(game.playUrl)),
                  initialSettings: gameWebViewSettings(),
                  onLoadStop: (_, _) =>
                      _finishPrewarm(game.id, warmed: true),
                  onReceivedError: (_, _, _) =>
                      _finishPrewarm(game.id, warmed: false),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
