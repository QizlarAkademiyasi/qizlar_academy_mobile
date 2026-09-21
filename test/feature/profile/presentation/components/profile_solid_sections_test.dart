import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/text_styles.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/app_color_scheme.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/app_options.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/feature/profile/presentation/components/profile_logout_tile.dart';
import 'package:qizlar_academy_mobile/feature/profile/presentation/components/profile_section_card.dart';

void main() {
  Future<void> pumpSections(
    WidgetTester tester, {
    required ThemeDataBuilder themeBuilder,
    required VoidCallback onLogoutTap,
  }) {
    return tester.pumpWidget(
      AppThemeProvider(
        builder: (context) => MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('uz'),
          theme: themeBuilder(context),
          home: Scaffold(
            body: Column(
              children: [
                const ProfileSectionCard(
                  title: 'Sozlamalar',
                  children: [SizedBox(height: 60)],
                ),
                ProfileLogoutTile(onTap: onLogoutTap),
              ],
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('section and logout use light solid surfaces', (tester) async {
    var logoutTaps = 0;
    await pumpSections(
      tester,
      themeBuilder: AppOptions.lightThemeData,
      onLogoutTap: () => logoutTaps++,
    );
    await tester.pump();

    _expectSolidSurface(
      tester,
      const ValueKey('profile-section-solid-surface'),
      AppColorScheme.light,
    );
    _expectSolidSurface(
      tester,
      const ValueKey('profile-logout-solid-surface'),
      AppColorScheme.light,
    );
    expect(find.byType(LiquidGlassLayer), findsNothing);
    expect(find.byType(LiquidGlass), findsNothing);

    await tester.tap(find.text('Chiqish'));
    await tester.pump();
    expect(logoutTaps, 1);
  });

  testWidgets('section and logout use dark solid surfaces', (tester) async {
    await pumpSections(
      tester,
      themeBuilder: AppOptions.darkThemeData,
      onLogoutTap: () {},
    );
    await tester.pump();

    _expectSolidSurface(
      tester,
      const ValueKey('profile-section-solid-surface'),
      AppColorScheme.dark,
    );
    _expectSolidSurface(
      tester,
      const ValueKey('profile-logout-solid-surface'),
      AppColorScheme.dark,
    );
    expect(find.byType(LiquidGlassLayer), findsNothing);
    expect(find.byType(LiquidGlass), findsNothing);
  });
}

void _expectSolidSurface(
  WidgetTester tester,
  Key key,
  AppColorScheme expectedColors,
) {
  final container = tester.widget<Container>(find.byKey(key));
  final decoration = container.decoration! as BoxDecoration;
  expect(decoration.color, expectedColors.onContainer);
  expect(decoration.border!.top.color, expectedColors.stroke);
}
