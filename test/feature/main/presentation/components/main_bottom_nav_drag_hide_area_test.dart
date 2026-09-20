import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/text_styles.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/app_options.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/feature/main/presentation/components/liquid_bottom_nav_second.dart';
import 'package:qizlar_academy_mobile/feature/main/presentation/components/main_ai_chat_floating_pill.dart';
import 'package:qizlar_academy_mobile/feature/main/presentation/components/main_bottom_nav_drag_hide_area.dart';

void main() {
  const items = <SecondLiquidBottomNavItem>[
    SecondLiquidBottomNavItem(icon: Icons.home_outlined, label: 'Home'),
    SecondLiquidBottomNavItem(icon: Icons.school_outlined, label: 'Courses'),
    SecondLiquidBottomNavItem(icon: Icons.leaderboard_outlined, label: 'Top'),
    SecondLiquidBottomNavItem(icon: Icons.person_outline, label: 'Profile'),
  ];

  const handleKey = ValueKey('main-bottom-nav-restore-handle');
  const pillKey = ValueKey('main-ai-chat-floating-pill');
  final navFinder = find.byType(SecondLiquidBottomNav);

  Future<void> pumpArea(
    WidgetTester tester, {
    int currentIndex = 0,
    ValueChanged<int>? onChanged,
    VoidCallback? onPillTap,
    MainBottomNavDragDismissHandler? onDismissIntent,
  }) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      AppThemeProvider(
        builder: (context) => MaterialApp(
          locale: const Locale('uz'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppOptions.lightThemeData(context),
          home: Scaffold(
            body: Stack(
              children: [
                const Positioned.fill(child: ColoredBox(color: Colors.white)),
                MainBottomNavDragHideArea(
                  onDismissIntent: onDismissIntent,
                  floatingPill: MainAiChatFloatingPillOverlay(
                    bottomNavigationOffset: Offset.zero,
                    onTap: onPillTap ?? () {},
                  ),
                  navigation: SecondLiquidBottomNav(
                    items: items,
                    currentIndex: currentIndex,
                    backgroundBlurSigma: 0,
                    onChanged: onChanged,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('dragging the bar down hides it and reveals the handle', (
    tester,
  ) async {
    await pumpArea(tester);

    final double visibleTop = tester.getTopLeft(navFinder).dy;
    expect(find.byKey(handleKey), findsNothing);

    await tester.drag(navFinder, const Offset(0, 120));
    await tester.pumpAndSettle();

    final double screenHeight = tester.getSize(find.byType(Scaffold)).height;
    expect(tester.getTopLeft(navFinder).dy, greaterThanOrEqualTo(screenHeight));
    expect(tester.getTopLeft(navFinder).dy, greaterThan(visibleTop));
    expect(find.byKey(handleKey), findsOneWidget);
  });

  testWidgets('one short drag down is enough to dismiss the bar', (
    tester,
  ) async {
    await pumpArea(tester);

    await tester.drag(navFinder, const Offset(0, 30));
    await tester.pumpAndSettle();

    final double screenHeight = tester.getSize(find.byType(Scaffold)).height;
    expect(tester.getTopLeft(navFinder).dy, greaterThanOrEqualTo(screenHeight));
    expect(find.byKey(handleKey), findsOneWidget);
  });

  testWidgets('a short drag up on the handle is enough to restore the bar', (
    tester,
  ) async {
    await pumpArea(tester);

    final double visibleTop = tester.getTopLeft(navFinder).dy;

    await tester.drag(navFinder, const Offset(0, 120));
    await tester.pumpAndSettle();

    await tester.drag(find.byKey(handleKey), const Offset(0, -30));
    await tester.pumpAndSettle();

    expect(tester.getTopLeft(navFinder).dy, closeTo(visibleTop, 0.5));
    expect(find.byKey(handleKey), findsNothing);
  });

  testWidgets('a tiny drag keeps the bar in its current state', (tester) async {
    await pumpArea(tester);

    final double visibleTop = tester.getTopLeft(navFinder).dy;

    await tester.drag(navFinder, const Offset(0, 8));
    await tester.pumpAndSettle();

    expect(tester.getTopLeft(navFinder).dy, closeTo(visibleTop, 0.5));
    expect(find.byKey(handleKey), findsNothing);
  });

  testWidgets('dragging the bar margin below the tabs hides it', (
    tester,
  ) async {
    await pumpArea(tester);

    final Rect navRect = tester.getRect(navFinder);
    final Offset marginPoint = Offset(
      navRect.center.dx,
      navRect.bottom - 6,
    );

    await tester.dragFrom(marginPoint, const Offset(0, 40));
    await tester.pumpAndSettle();

    final double screenHeight = tester.getSize(find.byType(Scaffold)).height;
    expect(tester.getTopLeft(navFinder).dy, greaterThanOrEqualTo(screenHeight));
    expect(find.byKey(handleKey), findsOneWidget);
  });

  testWidgets('dragging the AI chat pill hides the bar but keeps its tap', (
    tester,
  ) async {
    var pillTaps = 0;
    await pumpArea(tester, onPillTap: () => pillTaps++);

    await tester.tap(find.byKey(pillKey));
    await tester.pumpAndSettle();
    expect(pillTaps, 1);

    await tester.drag(find.byKey(pillKey), const Offset(0, 40));
    await tester.pumpAndSettle();

    final double screenHeight = tester.getSize(find.byType(Scaffold)).height;
    expect(tester.getTopLeft(navFinder).dy, greaterThanOrEqualTo(screenHeight));
    expect(find.byKey(handleKey), findsOneWidget);
    expect(pillTaps, 1);
  });

  testWidgets('tapping the handle restores the bar', (tester) async {
    await pumpArea(tester);

    final double visibleTop = tester.getTopLeft(navFinder).dy;

    await tester.drag(navFinder, const Offset(0, 120));
    await tester.pumpAndSettle();
    expect(find.byKey(handleKey), findsOneWidget);

    await tester.tap(find.byKey(handleKey));
    await tester.pumpAndSettle();

    expect(tester.getTopLeft(navFinder).dy, closeTo(visibleTop, 0.5));
    expect(find.byKey(handleKey), findsNothing);
  });

  testWidgets('dragging the handle up restores the bar', (tester) async {
    await pumpArea(tester);

    final double visibleTop = tester.getTopLeft(navFinder).dy;

    await tester.drag(navFinder, const Offset(0, 120));
    await tester.pumpAndSettle();

    await tester.drag(find.byKey(handleKey), const Offset(0, -120));
    await tester.pumpAndSettle();

    expect(tester.getTopLeft(navFinder).dy, closeTo(visibleTop, 0.5));
    expect(find.byKey(handleKey), findsNothing);
  });

  testWidgets('a handled dismiss keeps the bar in place', (tester) async {
    final dismissals = <MainBottomNavDragDismissDetails>[];
    await pumpArea(
      tester,
      onDismissIntent: (details) {
        dismissals.add(details);
        return true;
      },
    );

    final double visibleTop = tester.getTopLeft(navFinder).dy;

    await tester.drag(navFinder, const Offset(0, 120));
    await tester.pumpAndSettle();

    expect(dismissals, hasLength(1));
    expect(dismissals.single.travel, greaterThan(0));
    expect(tester.getTopLeft(navFinder).dy, closeTo(visibleTop, 0.5));
    expect(find.byKey(handleKey), findsNothing);
  });

  testWidgets('an unhandled dismiss still hides the bar', (tester) async {
    var calls = 0;
    await pumpArea(
      tester,
      onDismissIntent: (_) {
        calls++;
        return false;
      },
    );

    await tester.drag(navFinder, const Offset(0, 120));
    await tester.pumpAndSettle();

    final double screenHeight = tester.getSize(find.byType(Scaffold)).height;
    expect(calls, 1);
    expect(tester.getTopLeft(navFinder).dy, greaterThanOrEqualTo(screenHeight));
    expect(find.byKey(handleKey), findsOneWidget);
  });

  testWidgets('dragging up does not report a dismiss intent', (tester) async {
    var calls = 0;
    await pumpArea(tester, onDismissIntent: (_) => (calls++) >= 0);

    await tester.drag(navFinder, const Offset(0, -40));
    await tester.pumpAndSettle();

    expect(calls, 0);
    expect(find.byKey(handleKey), findsNothing);
  });

  testWidgets('vertical drag layer keeps tab taps and horizontal drag working', (
    tester,
  ) async {
    final selected = <int>[];
    await pumpArea(tester, onChanged: selected.add);

    await tester.tap(find.text('Courses'));
    await tester.pumpAndSettle();
    expect(selected, [1]);

    await tester.drag(find.text('Home'), const Offset(240, 0));
    await tester.pumpAndSettle();
    expect(selected.length, greaterThan(1));
    expect(selected.last, greaterThan(0));
    expect(tester.takeException(), isNull);
  });
}
