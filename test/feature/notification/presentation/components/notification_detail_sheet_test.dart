import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/text_styles.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/app_options.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_bottom_sheet.dart';
import 'package:qizlar_academy_mobile/feature/notification/domain/model/notification_item_model.dart';
import 'package:qizlar_academy_mobile/feature/notification/presentation/components/notification_detail_sheet.dart';

void main() {
  testWidgets('detail sheet uses the shared container and fires the CTA', (
    tester,
  ) async {
    var ctaTaps = 0;
    await tester.pumpWidget(_testApp(onCta: () => ctaTaps++));

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.byType(NotificationDetailSheet), findsOneWidget);
    expect(find.byType(AppBottomSheetContainer), findsOneWidget);
    expect(find.text('Darxol yangilang!'), findsOneWidget);
    expect(find.text('Ilovaning yangi versiyasi chiqarildi'), findsOneWidget);
    expect(find.text('Batafsil'), findsOneWidget);

    await tester.tap(find.text('Batafsil'));
    await tester.pump();

    expect(ctaTaps, 1);
  });
}

Widget _testApp({required VoidCallback onCta}) {
  final item = NotificationItemModel(
    id: 'n1',
    title: 'Darxol yangilang!',
    description: 'Ilovaning yangi versiyasi chiqarildi',
    createdAt: DateTime.utc(2026, 9, 27),
    channelType: NotificationChannelType.global,
    isRead: false,
  );

  return AppThemeProvider(
    builder: (context) => MaterialApp(
      locale: const Locale('uz'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppOptions.lightThemeData(context),
      home: Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () {
              showNotificationDetailSheet(context, item: item, onCta: onCta);
            },
            child: const Text('Open'),
          ),
        ),
      ),
    ),
  );
}
