import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/app_options.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/services_hub/config/services_hub_games_config.dart';
import 'package:qizlar_academy_mobile/feature/services_hub/domain/model/game_webview_args.dart';
import 'package:qizlar_academy_mobile/feature/services_hub/presentation/screens/game_webview/components/game_webview_loading_skeleton.dart';
import 'package:qizlar_academy_mobile/feature/services_hub/presentation/screens/game_webview/game_webview_screen.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('2048 leaves the loading skeleton', (tester) async {
    await _pumpGame(
      tester,
      gameId: '2048',
      title: '2048',
      url: ServicesHubGamesConfig.game2048Url,
    );
    await _expectGameReady(tester);
  });

  testWidgets('Candy Crash leaves the loading skeleton', (tester) async {
    await _pumpGame(
      tester,
      gameId: 'candy_crash',
      title: 'Candy Crash',
      url: ServicesHubGamesConfig.candyCrashUrl,
    );
    await _expectGameReady(tester);
  });
}

Future<void> _pumpGame(
  WidgetTester tester, {
  required String gameId,
  required String title,
  required String url,
}) async {
  await tester.pumpWidget(
    AppThemeProvider(
      builder: (context) => MaterialApp(
        locale: const Locale('uz'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppOptions.lightThemeData(context),
        home: GameWebViewScreen(
          args: GameWebViewArgs(gameId: gameId, title: title, url: url),
        ),
      ),
    ),
  );
  await tester.pump();
}

Future<void> _expectGameReady(WidgetTester tester) async {
  final deadline = DateTime.now().add(const Duration(seconds: 20));
  while (DateTime.now().isBefore(deadline)) {
    await tester.pump(const Duration(milliseconds: 200));
    if (find.byType(AppFailureState).evaluate().isNotEmpty) {
      fail('Game WebView reported a connection error');
    }
    if (find.byType(GameWebViewLoadingSkeleton).evaluate().isEmpty &&
        find.byType(InAppWebView).evaluate().isNotEmpty) {
      return;
    }
  }
  fail('Game WebView stayed on the loading skeleton');
}
