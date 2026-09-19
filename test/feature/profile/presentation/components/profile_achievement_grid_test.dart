import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/text_styles.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/app_options.dart';
import 'package:qizlar_academy_mobile/feature/profile/presentation/components/profile_achievement_grid.dart';

void main() {
  testWidgets('ProfileAchievementGrid invokes tap callbacks', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      AppThemeProvider(
        builder: (context) => MaterialApp(
          theme: AppOptions.lightThemeData(context),
          home: Scaffold(
            body: ProfileAchievementGrid(
              sectionTitle: 'HISOB',
              items: [
                ProfileAchievementGridItem(
                  icon: LucideIcons.file,
                  title: 'Sertifikatlarim',
                  badgeCount: 4,
                  onTap: () => taps++,
                ),
                ProfileAchievementGridItem(
                  icon: LucideIcons.bookmark,
                  title: 'Kurslarim',
                  onTap: () {},
                ),
                ProfileAchievementGridItem(
                  icon: LucideIcons.trendingUp,
                  title: 'Faolligim',
                  onTap: () {},
                ),
                ProfileAchievementGridItem(
                  icon: LucideIcons.briefcase,
                  title: 'Vakansiyalar',
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    expect(
      find.byKey(const ValueKey('profile-achievement-liquid-layer')),
      findsOneWidget,
    );
    expect(find.byType(LiquidGlass), findsNWidgets(4));
    expect(find.text('Sertifikatlarim'), findsOneWidget);
    await tester.tap(find.text('Sertifikatlarim'));
    await tester.pump();
    expect(taps, 1);
  });
}
