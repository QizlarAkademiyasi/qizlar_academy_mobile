import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/text_styles.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/app_options.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/feature/daily_coin/presentation/components/daily_coin_streak_row.dart';

void main() {
  testWidgets('shows exactly seven relative day labels', (tester) async {
    await tester.pumpWidget(
      AppThemeProvider(
        builder: (context) => MaterialApp(
          locale: const Locale('uz'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppOptions.lightThemeData(context),
          home: const Scaffold(body: DailyCoinStreakRow(streakCount: 2)),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Bugun'), findsOneWidget);
    expect(find.text('Ertaga'), findsOneWidget);
    for (var day = 3; day <= 7; day++) {
      expect(find.text('$day kun'), findsOneWidget);
    }
    for (var day = 8; day <= 10; day++) {
      expect(find.text('$day kun'), findsNothing);
    }
  });
}
