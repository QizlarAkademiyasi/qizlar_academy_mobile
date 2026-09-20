import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/app_options.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

void main() {
  const sheetKey = ValueKey('app-bottom-sheet-body');
  const pageKey = ValueKey('pushed-page');

  late BuildContext hostContext;

  Future<void> pumpHost(WidgetTester tester) async {
    await tester.pumpWidget(
      AppThemeProvider(
        builder: (themeContext) => MaterialApp(
          theme: AppOptions.lightThemeData(themeContext),
          home: Builder(
            builder: (context) {
              hostContext = context;
              return const Scaffold(body: SizedBox.expand());
            },
          ),
        ),
      ),
    );
  }

  testWidgets('modal sheet is popped and reported as handled', (tester) async {
    await pumpHost(tester);

    unawaited(
      showAppBottomSheet<void>(
        hostContext,
        child: const SizedBox(key: sheetKey, height: 200),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(sheetKey), findsOneWidget);

    expect(tryPopAppModalSheet(hostContext), isTrue);
    await tester.pumpAndSettle();

    expect(find.byKey(sheetKey), findsNothing);
  });

  testWidgets('a regular page route is left untouched', (tester) async {
    await pumpHost(tester);

    unawaited(
      Navigator.of(hostContext).push<void>(
        MaterialPageRoute<void>(
          builder: (_) => const Scaffold(body: SizedBox(key: pageKey)),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(pageKey), findsOneWidget);

    expect(tryPopAppModalSheet(hostContext), isFalse);
    await tester.pumpAndSettle();

    expect(find.byKey(pageKey), findsOneWidget);
  });

  testWidgets('nothing to pop reports as unhandled', (tester) async {
    await pumpHost(tester);

    expect(tryPopAppModalSheet(hostContext), isFalse);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a short drag down dismisses the sheet', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await pumpHost(tester);

    unawaited(
      showAppBottomSheet<void>(
        hostContext,
        child: const AppBottomSheetContainer(
          child: ColoredBox(
            key: sheetKey,
            color: Colors.white,
            child: SizedBox(height: 220, width: double.infinity),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(sheetKey), findsOneWidget);

    final gesture = await tester.startGesture(
      tester.getCenter(find.byKey(sheetKey)),
    );
    for (var i = 0; i < 6; i++) {
      await gesture.moveBy(const Offset(0, 20));
      await tester.pump(const Duration(milliseconds: 16));
    }
    await gesture.up();
    await tester.pumpAndSettle();

    expect(find.byKey(sheetKey), findsNothing);
  });

  testWidgets('appTopRoute reads the top route without popping it', (
    tester,
  ) async {
    await pumpHost(tester);

    unawaited(
      showAppBottomSheet<void>(
        hostContext,
        child: const SizedBox(key: sheetKey, height: 200),
      ),
    );
    await tester.pumpAndSettle();

    expect(appTopRoute(hostContext), isA<ModalSheetRoute<void>>());
    await tester.pumpAndSettle();

    expect(find.byKey(sheetKey), findsOneWidget);
  });
}
