import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/app_options.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

void main() {
  testWidgets('blur surface covers toolbar and status bar safe area', (
    tester,
  ) async {
    const topPadding = 24.0;

    await tester.pumpWidget(
      AppThemeProvider(
        builder: (context) => MaterialApp(
          theme: AppOptions.lightThemeData(context),
          home: const MediaQuery(
            data: MediaQueryData(padding: EdgeInsets.only(top: topPadding)),
            child: Scaffold(
              appBar: AppBlurredAppBar(title: Text('Sarlavha')),
              body: SizedBox.expand(),
            ),
          ),
        ),
      ),
    );

    final blurFilter = find.descendant(
      of: find.byType(AppBlurredAppBar),
      matching: find.byType(BackdropFilter),
    );

    expect(blurFilter, findsOneWidget);
    expect(tester.getTopLeft(blurFilter).dy, 0);
    expect(tester.getSize(blurFilter).height, topPadding + kToolbarHeight);
  });

  testWidgets('page content scrolls behind the pinned blur surface', (
    tester,
  ) async {
    const topPadding = 24.0;

    await tester.pumpWidget(
      AppThemeProvider(
        builder: (context) => MaterialApp(
          theme: AppOptions.lightThemeData(context),
          home: MediaQuery(
            data: const MediaQueryData(
              padding: EdgeInsets.only(top: topPadding),
            ),
            child: AppPageScaffold(
              title: 'Sarlavha',
              body: ListView(
                padding: EdgeInsets.zero,
                children: [
                  SizedBox(key: ValueKey('page-first-content'), height: 180),
                  SizedBox(height: 1200),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    final firstContent = find.byKey(const ValueKey('page-first-content'));
    final blurFilter = find.descendant(
      of: find.byType(AppPageScaffold),
      matching: find.byType(BackdropFilter),
    );
    final blurBottom = tester.getBottomLeft(blurFilter).dy;

    expect(tester.getTopLeft(firstContent).dy, blurBottom);

    await tester.drag(find.byType(ListView), const Offset(0, -140));
    await tester.pumpAndSettle();

    expect(tester.getTopLeft(firstContent).dy, lessThan(blurBottom));
  });
}
