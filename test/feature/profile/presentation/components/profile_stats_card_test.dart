import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/text_styles.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/app_options.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/model/profile_overview_model.dart';
import 'package:qizlar_academy_mobile/feature/profile/presentation/components/profile_stats_card.dart';

void main() {
  testWidgets('ProfileStatsCard renders liquid glass layer and primary values', (
    tester,
  ) async {
    await tester.pumpWidget(
      AppThemeProvider(
        builder: (context) => MaterialApp(
          theme: AppOptions.lightThemeData(context),
          home: const Scaffold(
            body: ProfileStatsCard(
              stats: [
                ProfileStatModel(value: '12', label: 'Kurslar'),
                ProfileStatModel(value: '12', label: 'Sertifikatlar'),
                ProfileStatModel(value: '5', label: 'Rating'),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    expect(
      find.byKey(const ValueKey('profile-stats-liquid-layer')),
      findsOneWidget,
    );
    expect(find.text('12'), findsNWidgets(2));
    expect(find.text('5'), findsOneWidget);
    expect(find.byType(LiquidGlass), findsNWidgets(3));
  });
}
