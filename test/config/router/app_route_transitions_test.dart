import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/router/app_route_transitions.dart';

void main() {
  testWidgets('bottom-up route slides from below to its final position', (
    tester,
  ) async {
    final controller = AnimationController(
      vsync: tester,
      duration: const Duration(milliseconds: 380),
    );
    addTearDown(controller.dispose);
    final page = buildBottomUpRoutePage(
      key: const ValueKey('bottom-up-page'),
      child: const SizedBox(key: ValueKey('route-child')),
    );
    late BuildContext buildContext;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            buildContext = context;
            return page.transitionsBuilder(
              context,
              controller,
              const AlwaysStoppedAnimation(0),
              page.child,
            );
          },
        ),
      ),
    );

    final routeTransition = find
        .ancestor(
          of: find.byKey(const ValueKey('route-child')),
          matching: find.byType(SlideTransition),
        )
        .first;
    var transition = tester.widget<SlideTransition>(routeTransition);
    expect(transition.position.value, const Offset(0, 1));

    controller.value = 1;
    await tester.pump();
    transition = tester.widget<SlideTransition>(routeTransition);
    expect(transition.position.value, Offset.zero);
    expect(page.transitionDuration, const Duration(milliseconds: 380));
    expect(page.reverseTransitionDuration, const Duration(milliseconds: 300));
    expect(buildContext.mounted, isTrue);
    expect(find.byKey(const ValueKey('route-child')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
