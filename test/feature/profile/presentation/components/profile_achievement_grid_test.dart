import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/text_styles.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/app_color_scheme.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/app_options.dart';
import 'package:qizlar_academy_mobile/feature/profile/presentation/components/profile_achievement_grid.dart';

void main() {
  Future<void> pumpGrid(
    WidgetTester tester, {
    required ThemeDataBuilder themeBuilder,
    required VoidCallback onFirstTap,
    bool showSurface = true,
  }) {
    return tester.pumpWidget(
      AppThemeProvider(
        builder: (context) => MaterialApp(
          theme: themeBuilder(context),
          home: Scaffold(
            body: ProfileAchievementGrid(
              sectionTitle: 'HISOB',
              showSurface: showSurface,
              items: [
                ProfileAchievementGridItem(
                  icon: LucideIcons.file,
                  title: 'Sertifikatlarim',
                  badgeCount: 4,
                  onTap: onFirstTap,
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
  }

  testWidgets('renders a solid 2x2 grid and invokes tap callbacks', (
    tester,
  ) async {
    var taps = 0;
    await pumpGrid(
      tester,
      themeBuilder: AppOptions.lightThemeData,
      onFirstTap: () => taps++,
    );
    await tester.pump();
    expect(find.byType(LiquidGlassLayer), findsNothing);
    expect(find.byType(LiquidGlass), findsNothing);

    final surface = tester.widget<Container>(
      find.byKey(const ValueKey('profile-achievement-solid-surface')),
    );
    final decoration = surface.decoration! as BoxDecoration;
    expect(decoration.color, isNull);
    expect(decoration.border!.top.color, AppColorScheme.light.stroke);
    expect(surface.padding, ProfileAchievementGrid.surfacePadding);

    final cards = tester.widgetList<Container>(
      find.byKey(const ValueKey('profile-achievement-card')),
    );
    expect(cards, hasLength(4));
    for (final card in cards) {
      final cardDecoration = card.decoration! as BoxDecoration;
      expect(cardDecoration.color, AppColorScheme.light.onContainer);
    }

    final firstTopLeft = tester.getTopLeft(find.text('Sertifikatlarim'));
    final secondTopLeft = tester.getTopLeft(find.text('Kurslarim'));
    final thirdTopLeft = tester.getTopLeft(find.text('Faolligim'));
    final fourthTopLeft = tester.getTopLeft(find.text('Vakansiyalar'));
    expect(firstTopLeft.dy, secondTopLeft.dy);
    expect(thirdTopLeft.dy, fourthTopLeft.dy);
    expect(thirdTopLeft.dy, greaterThan(firstTopLeft.dy));

    expect(find.text('Sertifikatlarim'), findsOneWidget);
    await tester.tap(find.text('Sertifikatlarim'));
    await tester.pump();
    expect(taps, 1);
  });

  testWidgets('uses the dark theme solid surface colors', (tester) async {
    await pumpGrid(
      tester,
      themeBuilder: AppOptions.darkThemeData,
      onFirstTap: () {},
    );
    await tester.pump();

    final surface = tester.widget<Container>(
      find.byKey(const ValueKey('profile-achievement-solid-surface')),
    );
    final decoration = surface.decoration! as BoxDecoration;
    expect(decoration.color, isNull);
    expect(decoration.border!.top.color, AppColorScheme.dark.stroke);

    final cards = tester.widgetList<Container>(
      find.byKey(const ValueKey('profile-achievement-card')),
    );
    expect(cards, hasLength(4));
    for (final card in cards) {
      final cardDecoration = card.decoration! as BoxDecoration;
      expect(cardDecoration.color, AppColorScheme.dark.onContainer);
    }
    expect(find.byType(LiquidGlassLayer), findsNothing);
    expect(find.byType(LiquidGlass), findsNothing);
  });

  testWidgets('hides the outer surface and its padding when showSurface is false', (
    tester,
  ) async {
    var taps = 0;
    await pumpGrid(
      tester,
      themeBuilder: AppOptions.lightThemeData,
      onFirstTap: () => taps++,
      showSurface: false,
    );
    await tester.pump();

    expect(
      find.byKey(const ValueKey('profile-achievement-solid-surface')),
      findsNothing,
    );

    final cards = tester.widgetList<Container>(
      find.byKey(const ValueKey('profile-achievement-card')),
    );
    expect(cards, hasLength(4));
    for (final card in cards) {
      final cardDecoration = card.decoration! as BoxDecoration;
      expect(cardDecoration.color, AppColorScheme.light.onContainer);
    }

    final titleLeft = tester.getTopLeft(find.text('HISOB')).dx;
    final firstCardLeft = tester
        .getTopLeft(find.byKey(const ValueKey('profile-achievement-card')).first)
        .dx;
    expect(firstCardLeft, titleLeft);

    final firstTopLeft = tester.getTopLeft(find.text('Sertifikatlarim'));
    final secondTopLeft = tester.getTopLeft(find.text('Kurslarim'));
    final thirdTopLeft = tester.getTopLeft(find.text('Faolligim'));
    final fourthTopLeft = tester.getTopLeft(find.text('Vakansiyalar'));
    expect(firstTopLeft.dy, secondTopLeft.dy);
    expect(thirdTopLeft.dy, fourthTopLeft.dy);
    expect(thirdTopLeft.dy, greaterThan(firstTopLeft.dy));

    await tester.tap(find.text('Sertifikatlarim'));
    await tester.pump();
    expect(taps, 1);
  });
}
