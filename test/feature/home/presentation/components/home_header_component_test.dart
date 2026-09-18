import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/text_styles.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/app_options.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/components/home_app_bar_background.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/components/home_header_component.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/components/home_liquid_action_button.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/components/home_pinned_app_bar.dart';

void main() {
  for (final width in [320.0, 390.0, 430.0]) {
    testWidgets('large greeting fits at $width', (tester) async {
      tester.view.physicalSize = Size(width, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        AppThemeProvider(
          builder: (context) => MaterialApp(
            theme: AppOptions.lightThemeData(context),
            home: const Scaffold(
              body: HomeHeaderComponent(title: 'Salom, Rayhon'),
            ),
          ),
        ),
      );
      expect(find.byKey(const ValueKey('home-large-greeting')), findsOneWidget);
      expect(find.text('Salom, Rayhon'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('pinned app bar keeps actions and collapses name at $width', (
      tester,
    ) async {
      tester.view.physicalSize = Size(width, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final controller = ScrollController();
      addTearDown(controller.dispose);
      final collapse = ValueNotifier<double>(0);
      addTearDown(collapse.dispose);
      controller.addListener(() {
        collapse.value = (controller.offset / 56).clamp(0.0, 1.0);
      });
      var tasks = 0;
      var notifications = 0;
      await tester.pumpWidget(
        AppThemeProvider(
          builder: (context) => MaterialApp(
            theme: AppOptions.lightThemeData(context),
            home: MediaQuery(
              data: MediaQueryData(
                size: Size(width, 800),
                padding: const EdgeInsets.only(top: 47),
              ),
              child: Scaffold(
                body: ValueListenableBuilder<double>(
                  valueListenable: collapse,
                  builder: (context, progress, _) {
                    return Stack(
                      children: [
                        CustomScrollView(
                          controller: controller,
                          slivers: [
                            SliverToBoxAdapter(
                              child: SizedBox(
                                height: HomePinnedAppBar.contentInset(context),
                              ),
                            ),
                            const SliverToBoxAdapter(
                              child: HomeHeaderComponent(
                                title: 'Salom, Rayhon',
                              ),
                            ),
                            const SliverToBoxAdapter(
                              child: SizedBox(height: 1200),
                            ),
                          ],
                        ),
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: HomePinnedAppBar(
                            title: 'Salom, Rayhon',
                            collapseProgress: progress,
                            tasksTooltip: 'Tasks',
                            notificationTooltip: 'Notifications',
                            onTasksTap: () => tasks++,
                            onNotificationTap: () => notifications++,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      final left = find.byKey(const ValueKey('home-notification-button'));
      final right = find.byKey(const ValueKey('home-tasks-button'));
      expect(tester.getSize(left), const Size.square(44));
      expect(tester.getSize(right), const Size.square(44));
      expect(tester.getTopLeft(left).dx, HomePinnedAppBar.horizontalInset);
      expect(
        tester.getRect(right).right,
        width - HomePinnedAppBar.horizontalInset,
      );
      final overlay = tester.getRect(
        find.byKey(const ValueKey('home-pinned-app-bar')),
      );
      expect(
        HomePinnedAppBar.contentInset(
          tester.element(find.byType(HomePinnedAppBar)),
        ),
        47 + HomePinnedAppBar.toolbarHeight,
      );
      const toolbarBottom = 47 + HomePinnedAppBar.toolbarHeight;
      expect(
        overlay.height,
        toolbarBottom + HomePinnedAppBar.fadePocket,
      );
      expect(tester.getRect(left).bottom, closeTo(toolbarBottom, 2));
      expect(
        tester.getTopLeft(find.byKey(const ValueKey('home-large-greeting'))).dy,
        greaterThan(tester.getRect(left).bottom),
      );
      final opacityFinder = find.ancestor(
        of: find.byKey(const ValueKey('home-compact-title')),
        matching: find.byType(Opacity),
      );
      expect(tester.widget<Opacity>(opacityFinder).opacity, 0);
      expect(
        find.byKey(const ValueKey('home-liquid-action-layer')),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byKey(const ValueKey('home-liquid-action-layer')),
          matching: find.byType(LiquidGlass),
        ),
        findsNWidgets(2),
      );
      expect(find.byType(HomeLiquidActionButton), findsNWidgets(2));
      expect(find.byIcon(CupertinoIcons.bell), findsOneWidget);
      expect(find.byIcon(CupertinoIcons.doc_checkmark), findsOneWidget);
      expect(
        find.byKey(const ValueKey('home-notification-indicator')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('home-app-bar-background-inactive')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('home-app-bar-background')),
        findsNothing,
      );
      final yBefore = tester.getTopLeft(left).dy;
      await tester.tap(left);
      await tester.pump(const Duration(milliseconds: 800));
      await tester.tap(right);
      await tester.pump(const Duration(milliseconds: 800));
      expect(tasks, 1);
      expect(notifications, 1);
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -120));
      await tester.pumpAndSettle();
      expect(tester.getTopLeft(left).dy, yBefore);
      expect(tester.widget<Opacity>(opacityFinder).opacity, greaterThan(0.9));
      expect(find.byKey(const ValueKey('home-compact-title')), findsOneWidget);
      final compactTitle = tester.getRect(
        find.byKey(const ValueKey('home-compact-title')),
      );
      expect(toolbarBottom - compactTitle.bottom, inInclusiveRange(8, 16));
      expect(find.byType(HomeAppBarBackground), findsOneWidget);
      expect(
        find.byKey(const ValueKey('home-app-bar-background')),
        findsOneWidget,
      );
      expect(find.byType(BackdropFilter), findsNothing);
      final offsetBeforeFadeDrag = controller.offset;
      await tester.dragFrom(
        Offset(width / 2, overlay.bottom - 8),
        const Offset(0, -80),
      );
      await tester.pumpAndSettle();
      expect(controller.offset, greaterThan(offsetBeforeFadeDrag));
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('pinned app bar survives main tab fade and page jump', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final pageController = PageController();
    final fadeController = AnimationController(
      vsync: tester,
      duration: const Duration(milliseconds: 160),
    );
    addTearDown(pageController.dispose);
    addTearDown(fadeController.dispose);

    await tester.pumpWidget(
      AppThemeProvider(
        builder: (context) => MaterialApp(
          theme: AppOptions.lightThemeData(context),
          home: MediaQuery(
            data: const MediaQueryData(
              size: Size(390, 800),
              padding: EdgeInsets.only(top: 47),
            ),
            child: FadeTransition(
              opacity: Tween<double>(begin: 1, end: 0).animate(fadeController),
              child: PageView(
                controller: pageController,
                children: [
                  Scaffold(
                    body: Stack(
                      children: [
                        const SizedBox.expand(),
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: HomePinnedAppBar(
                            title: 'Salom, Rayhon',
                            collapseProgress: 0,
                            tasksTooltip: 'Tasks',
                            notificationTooltip: 'Notifications',
                            onTasksTap: () {},
                            onNotificationTap: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Scaffold(body: Center(child: Text('other-tab'))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    expect(find.byType(HomeLiquidActionButton), findsNWidgets(2));

    fadeController.forward();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 160));
    pageController.jumpToPage(1);
    await tester.pump();
    fadeController.reverse();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 160));

    pageController.jumpToPage(0);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(tester.takeException(), isNull);
    expect(find.byType(HomeLiquidActionButton), findsNWidgets(2));
    expect(
      find.byKey(const ValueKey('home-liquid-action-layer')),
      findsOneWidget,
    );
  });
}
