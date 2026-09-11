import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/text_styles.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/app_options.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/components/home_header_component.dart';

void main() {
  for (final width in [320.0, 390.0]) {
    testWidgets('header actions and greeting fit at $width', (tester) async {
      tester.view.physicalSize = Size(width, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      var tasks = 0;
      var notifications = 0;
      await tester.pumpWidget(
        AppThemeProvider(
          builder: (context) => MaterialApp(
            theme: AppOptions.lightThemeData(context),
            home: Scaffold(
              body: HomeHeaderComponent(
                title: 'Salom, Rayhon',
                tasksTooltip: 'Tasks',
                notificationTooltip: 'Notifications',
                onTasksTap: () => tasks++,
                onNotificationTap: () => notifications++,
              ),
            ),
          ),
        ),
      );
      final left = find.byKey(const ValueKey('home-notification-button'));
      final right = find.byKey(const ValueKey('home-tasks-button'));
      expect(tester.getTopLeft(left).dx, 24);
      expect(tester.getRect(right).right, width - 24);
      expect(
        tester.getTopLeft(find.text('Salom, Rayhon')).dy,
        greaterThan(tester.getRect(left).bottom),
      );
      await tester.tap(left);
      await tester.pump(const Duration(milliseconds: 800));
      await tester.tap(right);
      await tester.pump(const Duration(milliseconds: 800));
      expect(tasks, 1);
      expect(notifications, 1);
      expect(tester.takeException(), isNull);
    });
  }
}
