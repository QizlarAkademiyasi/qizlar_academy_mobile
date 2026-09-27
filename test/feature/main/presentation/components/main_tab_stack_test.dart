import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/feature/main/presentation/components/main_tab_stack.dart';

void main() {
  Widget host({required int selectedIndex, required int fadeNonce}) {
    return MaterialApp(
      home: Scaffold(
        body: MainTabStack(
          selectedIndex: selectedIndex,
          fadeNonce: fadeNonce,
          pages: const [
            Text('home-tab-page'),
            Text('courses-tab-page'),
            Text('profile-tab-page'),
          ],
        ),
      ),
    );
  }

  testWidgets('warms inactive tabs after the first frame', (tester) async {
    await tester.pumpWidget(host(selectedIndex: 0, fadeNonce: 0));

    expect(find.text('home-tab-page'), findsOneWidget);
    expect(find.text('courses-tab-page', skipOffstage: false), findsNothing);
    expect(find.text('profile-tab-page', skipOffstage: false), findsNothing);

    await tester.pump();

    expect(find.text('courses-tab-page', skipOffstage: false), findsOneWidget);
    expect(find.text('profile-tab-page', skipOffstage: false), findsOneWidget);
    expect(find.text('courses-tab-page'), findsNothing);
  });

  testWidgets('shows the new tab immediately without waiting for fade', (
    tester,
  ) async {
    await tester.pumpWidget(host(selectedIndex: 0, fadeNonce: 0));
    await tester.pump();

    await tester.pumpWidget(host(selectedIndex: 1, fadeNonce: 1));
    await tester.pump();

    expect(
      find.text('courses-tab-page', skipOffstage: true),
      findsOneWidget,
    );
  });

  testWidgets('crossfades outgoing and incoming tabs during switch', (
    tester,
  ) async {
    await tester.pumpWidget(host(selectedIndex: 0, fadeNonce: 0));
    await tester.pump();

    await tester.pumpWidget(host(selectedIndex: 1, fadeNonce: 1));
    await tester.pump();

    expect(
      find.text('home-tab-page', skipOffstage: false),
      findsOneWidget,
    );
    expect(
      find.text('courses-tab-page', skipOffstage: false),
      findsOneWidget,
    );

    await tester.pumpAndSettle(MainTabStack.fadeDuration);

    expect(find.text('home-tab-page', skipOffstage: true), findsNothing);
    expect(
      find.text('courses-tab-page', skipOffstage: true),
      findsOneWidget,
    );
  });
}
