import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/colors.dart';
import 'package:qizlar_academy_mobile/config/constants/text_styles.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/app_options.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/category_model.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/screens/story/components/birthday_story_content.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/screens/story/story_screen.dart';

void main() {
  testWidgets('shows the birthday avatar and centered greeting', (
    tester,
  ) async {
    await tester.pumpWidget(
      AppThemeProvider(
        builder: (context) => MaterialApp(
          theme: AppOptions.lightThemeData(context),
          home: const BirthdayStoryContent(
            imageUrl: '',
            title: 'Tabriklaymiz!',
            message:
                '“Qizlar Akademiyasi” jamoasi sizni chin qalbdan tabriklaydi!',
          ),
        ),
      ),
    );

    expect(
      find.byKey(const ValueKey('birthday-story-content')),
      findsOneWidget,
    );
    expect(find.text('Tabriklaymiz!'), findsOneWidget);
    expect(
      find.text('“Qizlar Akademiyasi” jamoasi sizni chin qalbdan tabriklaydi!'),
      findsOneWidget,
    );
    expect(find.byType(ClipOval), findsOneWidget);
  });

  testWidgets('uses semantic dark theme colors', (tester) async {
    await tester.pumpWidget(
      AppThemeProvider(
        builder: (context) => MaterialApp(
          theme: AppOptions.lightThemeData(context),
          darkTheme: AppOptions.darkThemeData(context),
          themeMode: ThemeMode.dark,
          home: const BirthdayStoryContent(
            imageUrl: '',
            title: 'Tabriklaymiz!',
            message:
                '“Qizlar Akademiyasi” jamoasi sizni chin qalbdan tabriklaydi!',
          ),
        ),
      ),
    );

    final surface = tester.widget<ColoredBox>(
      find.byKey(const ValueKey('birthday-story-content')),
    );
    final title = tester.widget<Text>(find.text('Tabriklaymiz!'));

    expect(surface.color, AppColors.darkBackground);
    expect(title.style?.color, AppColors.darkText);
  });

  testWidgets('animates the birthday avatar glow pulse', (tester) async {
    await tester.pumpWidget(
      AppThemeProvider(
        builder: (context) => MaterialApp(
          theme: AppOptions.lightThemeData(context),
          home: const BirthdayStoryContent(
            imageUrl: '',
            title: 'Tabriklaymiz!',
            message: 'Tug‘ilgan kuningiz bilan!',
          ),
        ),
      ),
    );

    final pulseFinder = find.byKey(
      const ValueKey('birthday-avatar-glow-pulse'),
    );
    final initialScale = tester
        .widget<Transform>(pulseFinder)
        .transform
        .storage[0];

    await tester.pump(const Duration(milliseconds: 700));

    final animatedScale = tester
        .widget<Transform>(pulseFinder)
        .transform
        .storage[0];
    expect(animatedScale, greaterThan(initialScale));
  });

  testWidgets('birthday story does not emit a view event', (tester) async {
    final viewedIds = <String>[];

    await tester.pumpWidget(
      AppThemeProvider(
        builder: (context) => MaterialApp(
          theme: AppOptions.lightThemeData(context),
          locale: L10n.uz,
          supportedLocales: L10n.supportedLocales,
          localizationsDelegates: L10n.localizationsDelegates,
          home: StoryScreen(
            categories: const [
              StoryModel(
                id: 'birthday-user-id',
                name: '',
                imageUrl: '',
                thumbnailUrl: '',
                type: StoryItemType.birthday,
              ),
            ],
            initialIndex: 0,
            onView: viewedIds.add,
          ),
        ),
      ),
    );
    await tester.pump();

    expect(
      find.byKey(const ValueKey('birthday-story-content')),
      findsOneWidget,
    );
    expect(viewedIds, isEmpty);

    await tester.pumpWidget(const SizedBox.shrink());
  });
}
