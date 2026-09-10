import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/text_styles.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/app_options.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/feature/announcement/domain/model/announcement_model.dart';
import 'package:qizlar_academy_mobile/feature/announcement/presentation/components/announcement_bottom_sheet.dart';

void main() {
  testWidgets('shows the course name in the CTA and closes without an action', (
    tester,
  ) async {
    AnnouncementSheetAction? result;
    await tester.pumpWidget(_testApp(onResult: (value) => result = value));

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.text('Marketolog kursiga o‘tish'), findsOneWidget);
    expect(find.byKey(const ValueKey('announcement-close')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('announcement-close')));
    await tester.pumpAndSettle();

    expect(result, isNull);
    expect(find.byKey(const ValueKey('announcement-cta')), findsNothing);
  });

  testWidgets('returns open only when the CTA is pressed', (tester) async {
    AnnouncementSheetAction? result;
    await tester.pumpWidget(_testApp(onResult: (value) => result = value));

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('announcement-cta')));
    await tester.pumpAndSettle();

    expect(result, AnnouncementSheetAction.open);
  });
}

Widget _testApp({required ValueChanged<AnnouncementSheetAction?> onResult}) {
  const announcement = AnnouncementModel(
    viewId: 'view-1',
    type: AnnouncementType.course,
    photoUrl: '',
    courseId: 'course-1',
    courseName: 'Marketolog',
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
            onPressed: () async {
              onResult(
                await showAnnouncementBottomSheet(context, announcement),
              );
            },
            child: const Text('Open'),
          ),
        ),
      ),
    ),
  );
}
