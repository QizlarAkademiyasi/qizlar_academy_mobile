import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/services_hub/config/services_hub_game_webview_settings.dart';
import 'package:qizlar_academy_mobile/feature/services_hub/domain/model/game_webview_args.dart';
import 'package:qizlar_academy_mobile/feature/services_hub/presentation/screens/game_webview/game_webview_screen_mixin.dart';

class GameWebViewScreen extends StatefulWidget {
  const GameWebViewScreen({super.key, required this.args});

  final GameWebViewArgs args;

  @override
  State<GameWebViewScreen> createState() => _GameWebViewScreenState();
}

class _GameWebViewScreenState extends State<GameWebViewScreen>
    with GameWebViewScreenMixin<GameWebViewScreen> {
  @override
  void initState() {
    super.initState();
    args = widget.args;
  }

  @override
  Widget build(BuildContext context) {
    final uri = validatedUri;
    if (uri == null) {
      return AppPageScaffold(
        title: args.title,
        body: Center(
          child: Text(
            context.l10n.connectionErrorMessage,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        handleSystemBack();
      },
      child: Scaffold(
        backgroundColor: context.appColors.background,
        resizeToAvoidBottomInset: false,
        appBar: AppPageAppBar(
          title: args.title,
          onBackTap: handleSystemBack,
          actions: [
            IconButton(
              onPressed: reloadGame,
              tooltip: context.l10n.refresh,
              icon: const Icon(LucideIcons.rotateCw, size: 20),
            ),
          ],
        ),
        body: Stack(
          children: [
            InAppWebView(
              keepAlive: gameKeepAlive,
              initialUrlRequest: URLRequest(url: WebUri(uri.toString())),
              initialSettings: gameWebViewSettings(),
              onWebViewCreated: onWebViewCreated,
              onProgressChanged: (_, progress) => onProgressChanged(progress),
              onLoadStop: (_, _) => onWebViewLoadStop(),
              onReceivedError: (_, request, error) =>
                  onWebViewLoadError(request, error),
              onReceivedHttpError: (_, request, response) =>
                  onWebViewHttpError(request, response),
              shouldOverrideUrlLoading: onShouldOverrideUrlLoading,
            ),
            if (loadProgress < 1 && !hasError)
              Align(
                alignment: Alignment.topCenter,
                child: LinearProgressIndicator(
                  value: loadProgress == 0 ? null : loadProgress,
                  minHeight: 2,
                ),
              ),
            if (isLoading && !hasError)
              const Center(child: CircularProgressIndicator.adaptive()),
            if (hasError)
              Positioned.fill(
                child: ColoredBox(
                  color: context.appColors.background,
                  child: AppFailureState(
                    message: context.l10n.connectionErrorMessage,
                    onRetry: reloadGame,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
