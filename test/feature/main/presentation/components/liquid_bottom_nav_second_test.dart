import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/config/router/app_routes.dart';
import 'package:qizlar_academy_mobile/feature/main/presentation/components/liquid_bottom_nav_second.dart';
import 'package:qizlar_academy_mobile/feature/main/presentation/components/main_extra_menu_items.dart';

void main() {
  const items = <SecondLiquidBottomNavItem>[
    SecondLiquidBottomNavItem(icon: Icons.home_outlined, label: 'Home'),
    SecondLiquidBottomNavItem(icon: Icons.school_outlined, label: 'Courses'),
  ];

  test('tab selections and route screens use separate menu lists', () {
    expect(kMainExtraTabMenuItems.single.label, 'Profil');
    expect(kMainExtraTabMenuItems.single.tabIndex, kMainProfileTabIndex);
    expect(kMainExtraRouteMenuItems.first.label, 'Kurslar');
    expect(kMainExtraRouteMenuItems.first.screenRoute, Routes.courses);
    expect(
      kMainExtraRouteMenuItems.any((item) => item.screenRoute == Routes.store),
      isFalse,
    );
    expect(
      kMainExtraMenuItems.length,
      kMainExtraTabMenuItems.length +
          kMainExtraRouteMenuItems.length +
          kMainExtraActionMenuItems.length,
    );
  });

  testWidgets('fourth tab changes from More to Profile with an arrow', (
    tester,
  ) async {
    MainExtraMenuItem? selectedExtraMenuItem;
    var profileMenuIsExpanded = false;
    late StateSetter setHarnessState;

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: StatefulBuilder(
          builder: (context, setState) {
            setHarnessState = setState;
            final navItems = mainAppSecondLiquidBottomNavItems(
              context,
              isGuestMode: true,
              selectedExtraMenuItem: selectedExtraMenuItem,
              isProfileMenuExpanded: profileMenuIsExpanded,
            );
            final fourthItem = navItems[kMainProfileTabIndex];
            return Column(
              children: [
                Text(fourthItem.label),
                if (fourthItem.labelTrailingIcon != null)
                  Icon(fourthItem.labelTrailingIcon),
              ],
            );
          },
        ),
      ),
    );

    expect(find.text('More'), findsOneWidget);
    expect(find.byIcon(Icons.keyboard_arrow_up_rounded), findsNothing);
    expect(find.byIcon(Icons.keyboard_arrow_down_rounded), findsNothing);

    setHarnessState(
      () => selectedExtraMenuItem = kMainExtraTabMenuItems.single,
    );
    await tester.pump();
    expect(find.text('Profile'), findsOneWidget);
    expect(find.byIcon(Icons.keyboard_arrow_up_rounded), findsOneWidget);

    setHarnessState(() => profileMenuIsExpanded = true);
    await tester.pump();
    expect(find.byIcon(Icons.keyboard_arrow_down_rounded), findsOneWidget);

    setHarnessState(
      () => selectedExtraMenuItem = kMainExtraRouteMenuItems.first,
    );
    await tester.pump();
    expect(find.text('Kurslar'), findsOneWidget);
    expect(find.byIcon(Icons.keyboard_arrow_down_rounded), findsOneWidget);
  });

  testWidgets('tab tap uses no splash and reports the selected index', (
    tester,
  ) async {
    int? selectedIndex;

    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: SecondLiquidBottomNav(
            items: items,
            margin: EdgeInsets.zero,
            backgroundBlurSigma: 0,
            onChanged: (index) => selectedIndex = index,
          ),
        ),
      ),
    );

    final coursesInkWell = tester.widget<InkWell>(
      find.ancestor(of: find.text('Courses'), matching: find.byType(InkWell)),
    );
    expect(coursesInkWell.splashFactory, same(NoSplash.splashFactory));
    expect(
      find.descendant(
        of: find.byType(SecondLiquidBottomNav),
        matching: find.byType(LiquidStretch),
      ),
      findsOneWidget,
    );

    await tester.tap(find.text('Courses'));
    await tester.pump();

    expect(selectedIndex, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('minimized mode compacts tabs and restores their labels', (
    tester,
  ) async {
    var minimized = false;
    late StateSetter setHarnessState;

    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: StatefulBuilder(
            builder: (context, setState) {
              setHarnessState = setState;
              return SecondLiquidBottomNav(
                items: items,
                margin: EdgeInsets.zero,
                backgroundBlurSigma: 0,
                isMinimized: minimized,
              );
            },
          ),
        ),
      ),
    );

    final fullTabHeight = tester.getSize(find.byType(InkWell).first).height;

    setHarnessState(() => minimized = true);
    await tester.pumpAndSettle();
    final compactTabHeight = tester.getSize(find.byType(InkWell).first).height;
    final labelOpacity = tester.widget<Opacity>(
      find
          .ancestor(of: find.text('Home'), matching: find.byType(Opacity))
          .first,
    );

    expect(compactTabHeight, lessThan(fullTabHeight));
    expect(labelOpacity.opacity, 0);

    setHarnessState(() => minimized = false);
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byType(InkWell).first).height, fullTabHeight);
    expect(tester.takeException(), isNull);
  });

  testWidgets('extra action expansion and icon transition settle smoothly', (
    tester,
  ) async {
    var expanded = false;
    late StateSetter setHarnessState;

    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: StatefulBuilder(
            builder: (context, setState) {
              setHarnessState = setState;
              return SecondLiquidBottomNav(
                items: items,
                margin: EdgeInsets.zero,
                backgroundBlurSigma: 0,
                extraActionIcon: Icons.add,
                onExtraActionTap: () =>
                    setHarnessState(() => expanded = !expanded),
                isExpanded: expanded,
                expandedContentHeight: 96,
                expandedContent: const SizedBox(
                  key: ValueKey('expanded-content'),
                  height: 96,
                  child: Text('Extra actions'),
                ),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    expect(find.byIcon(Icons.close), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 180));
    expect(find.byKey(const ValueKey('expanded-content')), findsOneWidget);
    expect(tester.binding.hasScheduledFrame, isTrue);

    await tester.pumpAndSettle();
    expect(find.text('Extra actions'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('selected tab shows its retap indicator next to the label', (
    tester,
  ) async {
    const retapItems = <SecondLiquidBottomNavItem>[
      SecondLiquidBottomNavItem(icon: Icons.home_outlined, label: 'Home'),
      SecondLiquidBottomNavItem(
        icon: Icons.person_outline,
        label: 'Profile',
        labelTrailingIcon: Icons.keyboard_arrow_up_rounded,
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: SecondLiquidBottomNav(
            items: retapItems,
            currentIndex: 1,
            margin: EdgeInsets.zero,
            backgroundBlurSigma: 0,
          ),
        ),
      ),
    );

    expect(find.text('Profile'), findsOneWidget);
    expect(find.byIcon(Icons.keyboard_arrow_up_rounded), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
