import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/feature/main/presentation/components/main_extra_menu_items.dart';
import 'package:qizlar_academy_mobile/feature/main/presentation/screens/main_screen_mixin.dart';

void main() {
  testWidgets('More opens the menu and Profile becomes the fourth tab', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: _MainScreenMixinHarness()));

    expect(find.text('index:0 expanded:false'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('fourth-tab')));
    await tester.pump();
    expect(find.text('index:0 expanded:true'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('profile-menu-item')));
    await tester.pump();
    expect(find.text('index:3 expanded:false'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('fourth-tab')));
    await tester.pump();
    expect(find.text('index:3 expanded:true'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('home-tab')));
    await tester.pump();
    expect(find.text('index:0 expanded:false'), findsOneWidget);
  });
}

class _MainScreenMixinHarness extends StatefulWidget {
  const _MainScreenMixinHarness();

  @override
  State<_MainScreenMixinHarness> createState() =>
      _MainScreenMixinHarnessState();
}

class _MainScreenMixinHarnessState extends State<_MainScreenMixinHarness>
    with MainScreenMixin<_MainScreenMixinHarness> {
  @override
  bool get isGuestMode => false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('index:$selectedIndex expanded:$isExtraMenuExpanded'),
          TextButton(
            key: const ValueKey('fourth-tab'),
            onPressed: () => onTabTap(kMainProfileTabIndex),
            child: const Text('More or Profile'),
          ),
          TextButton(
            key: const ValueKey('profile-menu-item'),
            onPressed: () => onExtraMenuItemTap(kMainExtraTabMenuItems.single),
            child: const Text('Select Profile'),
          ),
          TextButton(
            key: const ValueKey('home-tab'),
            onPressed: () => onTabTap(0),
            child: const Text('Home'),
          ),
        ],
      ),
    );
  }
}
