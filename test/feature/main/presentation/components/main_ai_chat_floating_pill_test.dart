import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/text_styles.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/app_options.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/feature/main/presentation/components/main_ai_chat_floating_pill.dart';

void main() {
  test('pill follows bottom navigation geometry', () {
    expect(MainAiChatFloatingPillOverlay.pillHeight, 54);
    final offset = MainAiChatFloatingPillOverlay.resolveBottomOffset(
      safeAreaBottom: 24,
      navigationTranslateY: -12,
    );

    expect(offset, 126);
  });

  testWidgets('pill is centered and tappable', (tester) async {
    tester.view.physicalSize = const Size(320, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    var taps = 0;

    await tester.pumpWidget(
      AppThemeProvider(
        builder: (context) => MaterialApp(
          locale: const Locale('uz'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppOptions.darkThemeData(context),
          home: Scaffold(
            body: Stack(
              children: [
                MainAiChatFloatingPillOverlay(
                  bottomNavigationOffset: const Offset(0, -12),
                  onTap: () => taps++,
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final pill = find.byKey(const ValueKey('main-ai-chat-floating-pill'));
    expect(pill, findsOneWidget);
    expect(find.text('AI bilan chat'), findsOneWidget);
    expect(
      tester.getSize(pill).height,
      MainAiChatFloatingPillOverlay.pillHeight,
    );
    expect(tester.getCenter(pill).dx, closeTo(160, 0.5));
    await tester.tap(pill);
    expect(taps, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('pill shadow is visible only in light mode', (tester) async {
    Future<void> pumpPill({required bool isDark}) async {
      await tester.pumpWidget(
        AppThemeProvider(
          builder: (context) => MaterialApp(
            locale: const Locale('uz'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: isDark
                ? AppOptions.darkThemeData(context)
                : AppOptions.lightThemeData(context),
            home: Scaffold(
              body: Stack(
                children: [
                  MainAiChatFloatingPillOverlay(
                    bottomNavigationOffset: Offset.zero,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    const shadowKey = ValueKey('main-ai-chat-pill-shadow');
    await pumpPill(isDark: false);
    final lightDecoration =
        tester.widget<DecoratedBox>(find.byKey(shadowKey)).decoration
            as BoxDecoration;
    expect(lightDecoration.boxShadow, hasLength(2));

    await pumpPill(isDark: true);
    final darkDecoration =
        tester.widget<DecoratedBox>(find.byKey(shadowKey)).decoration
            as BoxDecoration;
    expect(darkDecoration.boxShadow, isEmpty);
    expect(tester.takeException(), isNull);
  });
}
