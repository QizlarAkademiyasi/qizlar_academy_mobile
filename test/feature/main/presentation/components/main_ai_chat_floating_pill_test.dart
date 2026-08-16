import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/text_styles.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/app_options.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/feature/main/presentation/components/main_ai_chat_floating_pill.dart';

void main() {
  test('pill follows full and compact bottom navigation geometry', () {
    expect(MainAiChatFloatingPillOverlay.pillHeight, 40);
    final full = MainAiChatFloatingPillOverlay.resolveBottomOffset(
      safeAreaBottom: 24,
      isBottomNavMinimized: false,
      navigationTranslateY: -12,
    );
    final compact = MainAiChatFloatingPillOverlay.resolveBottomOffset(
      safeAreaBottom: 24,
      isBottomNavMinimized: true,
      navigationTranslateY: -12,
    );

    expect(full, 126);
    expect(compact, 104);
    expect(compact, lessThan(full));
  });

  testWidgets('pill is centered, tappable and hides for expanded menu', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    var expanded = false;
    var taps = 0;
    late StateSetter setHarnessState;

    await tester.pumpWidget(
      AppThemeProvider(
        builder: (context) => MaterialApp(
          locale: const Locale('uz'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppOptions.darkThemeData(context),
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                setHarnessState = setState;
                return Stack(
                  children: [
                    MainAiChatFloatingPillOverlay(
                      isBottomNavMinimized: false,
                      isExtraMenuExpanded: expanded,
                      bottomNavigationOffset: const Offset(0, -12),
                      onTap: () => taps++,
                    ),
                  ],
                );
              },
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

    setHarnessState(() => expanded = true);
    await tester.pumpAndSettle();
    final opacity = tester.widget<AnimatedOpacity>(
      find.byType(AnimatedOpacity),
    );
    expect(opacity.opacity, 0);
    final ignorePointer = tester.widget<IgnorePointer>(
      find.ancestor(of: pill, matching: find.byType(IgnorePointer)).first,
    );
    expect(ignorePointer.ignoring, isTrue);
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
                    isBottomNavMinimized: false,
                    isExtraMenuExpanded: false,
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
