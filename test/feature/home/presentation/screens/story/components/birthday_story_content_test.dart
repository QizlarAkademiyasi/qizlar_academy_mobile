import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
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
