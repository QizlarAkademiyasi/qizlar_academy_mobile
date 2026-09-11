import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/text_styles.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/app_options.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_segmented_tab_bar.dart';

void main() {
  double x(WidgetTester tester) => tester
      .widget<Transform>(find.byKey(const ValueKey('segmented-tab-indicator')))
      .transform
      .storage[12];
  Widget app({bool animate = true, bool reduced = false}) => AppThemeProvider(
    builder: (context) => MaterialApp(
      theme: AppOptions.lightThemeData(context),
      home: MediaQuery(
        data: MediaQueryData(disableAnimations: reduced),
        child: _Harness(animate: animate),
      ),
    ),
  );
  testWidgets('motor moves continuously and retargets without jumping', (
    tester,
  ) async {
    await tester.pumpWidget(app());
    final start = x(tester);
    await tester.tap(find.text('Two'));
    await tester.pump();
    expect(x(tester), closeTo(start, .01));
    await tester.pump(const Duration(milliseconds: 80));
    final middle = x(tester);
    expect(middle, greaterThan(start));
    await tester.tap(find.text('One'));
    await tester.pump();
    expect(x(tester), closeTo(middle, .01));
    await tester.pumpAndSettle();
    expect(x(tester), closeTo(start, .01));
    final state = tester.state<_HarnessState>(find.byType(_Harness));
    expect(state.taps, 2);
    expect(state.controller.index, 0);
  });
  testWidgets('external controller selection and replacement stay in sync', (
    tester,
  ) async {
    await tester.pumpWidget(app());
    final state = tester.state<_HarnessState>(find.byType(_Harness));
    state.controller.animateTo(1);
    await tester.pumpAndSettle();
    final end = x(tester);
    expect(end, greaterThan(0));
    expect(state.taps, 0);
    state.replaceController();
    await tester.pumpAndSettle();
    expect(x(tester), closeTo(0, .01));
    state.controller.index = 1;
    await tester.pumpAndSettle();
    expect(x(tester), closeTo(end, .01));
    await tester.pumpWidget(const SizedBox.shrink());
    expect(tester.takeException(), isNull);
  });
  testWidgets('fractional swipe tracks directly and returns on cancellation', (
    tester,
  ) async {
    await tester.pumpWidget(app());
    final state = tester.state<_HarnessState>(find.byType(_Harness));
    state.controller.offset = .4;
    await tester.pump();
    final partial = x(tester);
    expect(partial, greaterThan(0));
    state.controller.offset = 0;
    await tester.pump();
    await tester.pumpAndSettle();
    expect(x(tester), closeTo(0, .01));
  });
  for (final reduced in [false, true]) {
    testWidgets('disabled animation is immediate reduced=$reduced', (
      tester,
    ) async {
      await tester.pumpWidget(app(animate: reduced, reduced: reduced));
      await tester.tap(find.text('Two'));
      await tester.pump();
      expect(x(tester), greaterThan(0));
      final end = x(tester);
      await tester.pumpAndSettle();
      expect(x(tester), end);
    });
  }
}

class _Harness extends StatefulWidget {
  const _Harness({required this.animate});
  final bool animate;
  @override
  State<_Harness> createState() => _HarnessState();
}

class _HarnessState extends State<_Harness> with TickerProviderStateMixin {
  late TabController controller;
  int taps = 0;
  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
  }

  void replaceController() {
    final previous = controller;
    setState(() => controller = TabController(length: 2, vsync: this));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      previous.dispose();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Align(
      alignment: Alignment.topLeft,
      child: SizedBox(
        width: 360,
        child: AppSegmentedTabBar(
          controller: controller,
          tabLabels: const ['One', 'Two'],
          animate: widget.animate,
          onTap: (_) => taps++,
        ),
      ),
    ),
  );
}
