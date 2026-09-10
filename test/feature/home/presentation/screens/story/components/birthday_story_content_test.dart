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

  testWidgets('plays confetti when congratulate button is tapped', (
    tester,
  ) async {
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

    final button = find.byKey(const ValueKey('birthday-congratulate-button'));
    expect(button, findsOneWidget);
    expect(
      find.byKey(const ValueKey('birthday-confetti-animation')),
      findsNothing,
    );

    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pump();

    expect(
      find.byKey(const ValueKey('birthday-confetti-animation')),
      findsOneWidget,
    );
  });

  testWidgets('congratulate button is tappable inside the story viewer', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

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
                name: 'Rayhon',
                imageUrl: '',
                thumbnailUrl: '',
                type: StoryItemType.birthday,
              ),
            ],
            initialIndex: 0,
            onView: (_) {},
          ),
        ),
      ),
    );

    final button = find.byKey(const ValueKey('birthday-congratulate-button'));
    expect(button, findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);

    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pump();

    expect(
      find.byKey(const ValueKey('birthday-confetti-animation')),
      findsOneWidget,
    );
    expect(find.byType(LinearProgressIndicator), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('birthday story keeps right-side navigation working', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

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
                name: 'Rayhon',
                imageUrl: '',
                thumbnailUrl: '',
                type: StoryItemType.birthday,
              ),
              StoryModel(
                id: 'regular-story-id',
                name: 'Oddiy story',
                imageUrl: '',
                thumbnailUrl: '',
              ),
            ],
            initialIndex: 0,
            onView: viewedIds.add,
          ),
        ),
      ),
    );
    await tester.pump();

    final storyRect = tester.getRect(find.byType(StoryPageView));
    await tester.tapAt(Offset(storyRect.right - 20, storyRect.center.dy));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pump(const Duration(milliseconds: 600));

    expect(viewedIds, contains('regular-story-id'));
    expect(find.byType(LinearProgressIndicator), findsWidgets);

    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('birthday story closes when its indicator completes', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final navigatorObserver = _RecordingNavigatorObserver();
    await tester.pumpWidget(
      AppThemeProvider(
        builder: (context) => MaterialApp(
          navigatorObservers: [navigatorObserver],
          theme: AppOptions.lightThemeData(context),
          locale: L10n.uz,
          supportedLocales: L10n.supportedLocales,
          localizationsDelegates: L10n.localizationsDelegates,
          home: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                key: const ValueKey('open-birthday-story'),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => StoryScreen(
                      categories: const [
                        StoryModel(
                          id: 'birthday-user-id',
                          name: 'Rayhon',
                          imageUrl: '',
                          thumbnailUrl: '',
                          type: StoryItemType.birthday,
                        ),
                      ],
                      initialIndex: 0,
                      onView: (_) {},
                    ),
                  ),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('open-birthday-story')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));
    expect(
      find.byKey(const ValueKey('birthday-story-content')),
      findsOneWidget,
    );

    for (var i = 0; i < 51; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(
      tester
          .widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator))
          .value,
      1,
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));
    await tester.pump(const Duration(milliseconds: 350));

    expect(navigatorObserver.popCount, 1);
    expect(find.byKey(const ValueKey('birthday-story-content')), findsNothing);
  });

  testWidgets('birthday indicator advances to the next story automatically', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

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
                name: 'Rayhon',
                imageUrl: '',
                thumbnailUrl: '',
                type: StoryItemType.birthday,
              ),
              StoryModel(
                id: 'regular-story-id',
                name: 'Oddiy story',
                imageUrl: '',
                thumbnailUrl: '',
              ),
            ],
            initialIndex: 0,
            onView: viewedIds.add,
          ),
        ),
      ),
    );
    await tester.pump();

    for (var i = 0; i < 51; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    for (var i = 0; i < 6; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    expect(viewedIds, contains('regular-story-id'));

    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('birthday story emits a view event when opened', (tester) async {
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
    expect(viewedIds, ['birthday-user-id']);

    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('untrackable birthday mock does not emit a view event', (
    tester,
  ) async {
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
                id: 'dev-birthday-mock',
                name: '',
                imageUrl: '',
                thumbnailUrl: '',
                type: StoryItemType.birthday,
                canTrackView: false,
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

class _RecordingNavigatorObserver extends NavigatorObserver {
  int popCount = 0;

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    popCount++;
    super.didPop(route, previousRoute);
  }
}
