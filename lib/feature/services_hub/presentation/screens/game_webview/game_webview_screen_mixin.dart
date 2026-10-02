import 'dart:async';

import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/logs/app_logger.dart';
import 'package:qizlar_academy_mobile/feature/services_hub/config/services_hub_games_config.dart';
import 'package:qizlar_academy_mobile/feature/services_hub/domain/model/game_webview_args.dart';

mixin GameWebViewScreenMixin<T extends StatefulWidget> on State<T> {
  static const Duration gameLoadTimeout = Duration(seconds: 15);

  GameWebViewArgs get args;

  InAppWebViewController? webViewController;
  double loadProgress = 0;
  bool isLoading = true;
  bool hasError = false;

  Timer? _loadTimer;

  Uri? get validatedUri {
    final uri = Uri.tryParse(args.url);
    if (uri == null || !ServicesHubGamesConfig.isAllowedGameUrl(uri)) {
      return null;
    }
    return uri;
  }

  void initializeGameWebView() {
    _armLoadTimeout();
  }

  void disposeGameWebView() {
    _loadTimer?.cancel();
  }

  void _armLoadTimeout() {
    _loadTimer?.cancel();
    _loadTimer = Timer(gameLoadTimeout, () {
      if (!mounted || !isLoading) return;
      AppLogger.w('Game web load timeout: ${args.gameId}');
      _markFailed();
    });
  }

  void onWebViewCreated(InAppWebViewController controller) {
    webViewController = controller;
  }

  void onProgressChanged(int progress) {
    if (!mounted) return;
    if (shouldCompleteGameLoad(progress: progress)) {
      _completeLoading();
      return;
    }
    setState(() {
      loadProgress = progress / 100;
    });
  }

  void onWebViewLoadStop() {
    _completeLoading();
  }

  void _completeLoading() {
    _loadTimer?.cancel();
    if (!mounted) return;
    if (!isLoading && !hasError && loadProgress >= 1) return;
    setState(() {
      isLoading = false;
      hasError = false;
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
    _loadTimer?.cancel();
    if (!mounted) return;
    setState(() {
      isLoading = false;
      hasError = true;
    });
  }

  Future<void> reloadGame() async {
    final controller = webViewController;
    if (controller == null || validatedUri == null) return;
    if (mounted) {
      setState(() {
        hasError = false;
        isLoading = true;
        loadProgress = 0;
      });
    }
    _armLoadTimeout();
    await controller.reload();
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

/// Progress 100 yoki `onLoadStop` loader yopilishi kerakligini bildiradi.
bool shouldCompleteGameLoad({int? progress, bool loadStop = false}) {
  if (loadStop) return true;
  return progress != null && progress >= 100;
}
