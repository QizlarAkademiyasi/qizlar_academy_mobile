import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/text_styles.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/app_options.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/components/home_header_component.dart';

void main() {
  const collapsedHeaderHeight = kToolbarHeight + 8;

  testWidgets('keeps tasks and notification actions visible and tappable', (
    tester,
  ) async {
    var tasksTapCount = 0;
    var notificationTapCount = 0;

    await tester.pumpWidget(
      AppThemeProvider(
        builder: (context) => MaterialApp(
          theme: AppOptions.lightThemeData(context),
          home: Scaffold(
            body: Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                height: collapsedHeaderHeight,
                child: HomeHeaderComponent(
                  title: 'Abubakr',
                  subtitle: 'Xush kelibsiz!',
                  expandedProgress: 0,
                  tasksTooltip: 'Vazifalar',
                  notificationTooltip: 'Bildirishnoma',
                  onTasksTap: () => tasksTapCount++,
                  onNotificationTap: () => notificationTapCount++,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    final tasksButton = find.byKey(const ValueKey('home-tasks-button'));
    final notificationButton = find.byKey(
      const ValueKey('home-notification-button'),
    );

    expect(tasksButton, findsOneWidget);
    expect(notificationButton, findsOneWidget);
    final tasksRect = tester.getRect(tasksButton);
    final notificationRect = tester.getRect(notificationButton);
    expect(tasksRect.top, 8);
    expect(collapsedHeaderHeight - tasksRect.bottom, 8);
    expect(notificationRect.top, 8);
    expect(collapsedHeaderHeight - notificationRect.bottom, 8);

    await tester.tap(tasksButton);
    await tester.pump(const Duration(milliseconds: 800));
    expect(tasksTapCount, 1);

    await tester.tap(notificationButton);
    await tester.pump(const Duration(milliseconds: 800));

    expect(notificationTapCount, 1);
  });
}
