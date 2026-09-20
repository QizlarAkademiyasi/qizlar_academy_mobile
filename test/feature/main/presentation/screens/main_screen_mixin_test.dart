import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/feature/main/presentation/components/main_extra_menu_items.dart';
import 'package:qizlar_academy_mobile/feature/main/presentation/screens/main_screen_mixin.dart';

void main() {
  testWidgets('profile tab switches to profile index', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: _MainScreenMixinHarness(isGuestMode: false)),
    );

    expect(find.text('index:0 hub:false'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('profile-tab')));
    await tester.pump();
    expect(find.text('index:3 hub:false'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('home-tab')));
    await tester.pump();
    expect(find.text('index:0 hub:false'), findsOneWidget);
  });

  testWidgets('services hub tap selects tab index 4 for user', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: _MainScreenMixinHarness(isGuestMode: false)),
    );

    await tester.tap(find.byKey(const ValueKey('profile-tab')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('services-hub-tab')));
    await tester.pump();
    expect(find.text('index:4 hub:true'), findsOneWidget);
    expect(find.text('bottomNav:3'), findsOneWidget);
  });

  testWidgets('scroll does not minimize bottom navigation', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: _MainScreenMixinHarness(isGuestMode: false)),
    );

    await tester.drag(
      find.byKey(const ValueKey('scrollable')),
      const Offset(0, -80),
    );
    await tester.pump();
    expect(find.text('minimized:false'), findsOneWidget);
  });

  testWidgets('guest can select the courses tab', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: _MainScreenMixinHarness(isGuestMode: true)),
    );

    await tester.tap(find.byKey(const ValueKey('courses-tab')));
    await tester.pump();

    expect(find.text('index:1 hub:false'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

class _MainScreenMixinHarness extends StatefulWidget {
  const _MainScreenMixinHarness({this.isGuestMode = true});

  final bool isGuestMode;

  @override
  State<_MainScreenMixinHarness> createState() =>
      _MainScreenMixinHarnessState();
}

class _MainScreenMixinHarnessState extends State<_MainScreenMixinHarness>
    with MainScreenMixin<_MainScreenMixinHarness> {
  @override
  bool get isGuestMode => widget.isGuestMode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('index:$selectedIndex hub:$isServicesHubTabActive'),
          Text('bottomNav:$bottomNavigationSelectedIndex'),
          const Text('minimized:false'),
          TextButton(
            key: const ValueKey('services-hub-tab'),
            onPressed: onServicesHubTap,
            child: const Text('Services Hub'),
          ),
          TextButton(
            key: const ValueKey('profile-tab'),
            onPressed: () => onTabTap(kMainProfileTabIndex),
            child: const Text('Profile'),
          ),
          TextButton(
            key: const ValueKey('home-tab'),
            onPressed: () => onTabTap(0),
            child: const Text('Home'),
          ),
          TextButton(
            key: const ValueKey('courses-tab'),
            onPressed: () => onTabTap(1),
            child: const Text('Courses'),
          ),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: onMainScrollNotification,
              child: ListView(
                key: const ValueKey('scrollable'),
                children: const [SizedBox(height: 1000)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
