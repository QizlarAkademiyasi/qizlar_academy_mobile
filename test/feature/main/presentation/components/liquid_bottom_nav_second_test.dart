import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/router/app_routes.dart';
import 'package:qizlar_academy_mobile/feature/main/presentation/components/liquid_bottom_nav_second.dart';
import 'package:qizlar_academy_mobile/feature/main/presentation/components/main_extra_menu_items.dart';

void main() {
  const items = <SecondLiquidBottomNavItem>[
    SecondLiquidBottomNavItem(icon: Icons.home_outlined, label: 'Home'),
    SecondLiquidBottomNavItem(icon: Icons.school_outlined, label: 'Courses'),
  ];

  test('courses replaces store in the expanded menu', () {
    expect(kMainExtraMenuItems.first.label, 'Kurslar');
    expect(kMainExtraMenuItems.first.route, Routes.courses);
    expect(kMainExtraMenuItems.any((item) => item.route == Routes.store), isFalse);
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

    await tester.tap(find.text('Courses'));
    await tester.pump();

    expect(selectedIndex, 1);
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

  testWidgets('selected tab shows its retap indicator next to the label', (tester) async {
    const retapItems = <SecondLiquidBottomNavItem>[
      SecondLiquidBottomNavItem(icon: Icons.home_outlined, label: 'Home'),
      SecondLiquidBottomNavItem(
        icon: Icons.person_outline,
        label: 'Profile',
        selectedLabelTrailingIcon: Icons.keyboard_arrow_up_rounded,
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
