import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/logs/app_logger.dart';
import 'package:qizlar_academy_mobile/feature/services_hub/config/services_hub_game_keep_alive_store.dart';
import 'package:qizlar_academy_mobile/feature/services_hub/config/services_hub_games_config.dart';
import 'package:qizlar_academy_mobile/feature/services_hub/domain/model/game_webview_args.dart';

mixin GameWebViewScreenMixin<T extends StatefulWidget> on State<T> {
  late final GameWebViewArgs args;

  InAppWebViewController? webViewController;
  double loadProgress = 0;
  bool isLoading = true;
  bool hasError = false;

  Uri? get validatedUri {
    final uri = Uri.tryParse(args.url);
    if (uri == null || !ServicesHubGamesConfig.isAllowedGameUrl(uri)) {
      return null;
    }
    return uri;
  }

  /// Prewarm keepAlive ni band qilgan bo‘lsa, ekran o‘z WebView'ini ochadi
  /// (HTTP cache baribir umumiy). Qaror bir marta — build davomida
  /// o‘zgarmasligi uchun.
  late final bool usesKeepAlive = !ServicesHubGameKeepAliveStore.isPrewarming(
    args.gameId,
  );

  late final bool startsWarmed =
      usesKeepAlive && ServicesHubGameKeepAliveStore.isWarmed(args.gameId);

  InAppWebViewKeepAlive? get gameKeepAlive =>
      usesKeepAlive ? ServicesHubGameKeepAliveStore.of(args.gameId) : null;

  void onWebViewCreated(InAppWebViewController controller) {
    webViewController = controller;
    if (!startsWarmed) return;
    if (!mounted) return;
    setState(() {
      isLoading = false;
      loadProgress = 1;
    });
  }

  void onProgressChanged(int progress) {
    if (!mounted) return;
    setState(() {
      loadProgress = progress / 100;
      if (progress >= 100) isLoading = false;
    });
  }

  void onWebViewLoadStop() {
    if (usesKeepAlive) {
      ServicesHubGameKeepAliveStore.markWarmed(args.gameId);
    }
    if (!mounted) return;
    setState(() {
      isLoading = false;
      loadProgress = 1;
    });
  }

  void onWebViewLoadError(WebResourceRequest request, WebResourceError error) {
    if (request.isForMainFrame == false) return;
    AppLogger.w('Game web load error: ${error.type} ${error.description}');
    _markFailed();
  }

  void onWebViewHttpError(
    WebResourceRequest request,
    WebResourceResponse response,
  ) {
    if (request.isForMainFrame == false) return;
    final statusCode = response.statusCode ?? 0;
    if (statusCode < 400) return;
    AppLogger.w('Game web http error: $statusCode');
    _markFailed();
  }

  void _markFailed() {
    ServicesHubGameKeepAliveStore.clearWarmed(args.gameId);
    if (!mounted) return;
    setState(() {
      isLoading = false;
      hasError = true;
    });
  }

  Future<void> reloadGame() async {
    final uri = validatedUri;
    if (uri == null) return;
    if (mounted) {
      setState(() {
        hasError = false;
        isLoading = true;
        loadProgress = 0;
      });
    }
    await webViewController?.loadUrl(
      urlRequest: URLRequest(url: WebUri(uri.toString())),
    );
  }

  Future<void> handleSystemBack() async {
    final controller = webViewController;
    if (controller != null && await controller.canGoBack()) {
      await controller.goBack();
      return;
    }
    if (!mounted) return;
    context.pop();
  }

  Future<NavigationActionPolicy> onShouldOverrideUrlLoading(
    InAppWebViewController controller,
    NavigationAction action,
  ) async {
    final uri = action.request.url;
    if (uri == null) return NavigationActionPolicy.CANCEL;
    if (ServicesHubGamesConfig.isAllowedGameUrl(uri)) {
      return NavigationActionPolicy.ALLOW;
    }
    AppLogger.w('Game web navigation blocked: $uri');
    return NavigationActionPolicy.CANCEL;
  }
}
