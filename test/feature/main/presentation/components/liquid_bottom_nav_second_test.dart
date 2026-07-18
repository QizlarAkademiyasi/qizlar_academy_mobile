import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/feature/main/presentation/components/liquid_bottom_nav_second.dart';

void main() {
  const items = <SecondLiquidBottomNavItem>[
    SecondLiquidBottomNavItem(icon: Icons.home_outlined, label: 'Home'),
    SecondLiquidBottomNavItem(icon: Icons.school_outlined, label: 'Courses'),
  ];

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
}
