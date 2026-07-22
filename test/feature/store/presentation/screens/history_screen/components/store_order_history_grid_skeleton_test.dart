import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/text_styles.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/app_options.dart';
import 'package:qizlar_academy_mobile/feature/store/presentation/screens/history_screen/components/store_order_history_grid_skeleton.dart';

void main() {
  testWidgets('history skeleton card fits a narrow two-column grid', (
    tester,
  ) async {
    await tester.pumpWidget(
      AppThemeProvider(
        builder: (context) => MaterialApp(
          theme: AppOptions.lightThemeData(context),
          home: const Scaffold(
            body: Align(
              alignment: Alignment.topLeft,
              child: Skeletonizer.zone(
                child: SizedBox(
                  width: 172,
                  height: 260,
                  child: StoreOrderHistorySkeletonCard(),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pump();

    expect(tester.takeException(), isNull);
  });
}
