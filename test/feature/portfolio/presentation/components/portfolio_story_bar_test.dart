import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/text_styles.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/app_options.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/category_model.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/presentation/components/portfolio_story_bar.dart';

void main() {
  for (final width in [320.0, 390.0]) {
    testWidgets('all stories scroll and select at $width', (tester) async {
      tester.view.physicalSize = Size(width, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      var selected = -1;
      await tester.pumpWidget(
        AppThemeProvider(
          builder: (context) => MaterialApp(
            theme: AppOptions.lightThemeData(context),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: PortfolioStoryBar(
                items: List.generate(
                  12,
                  (i) => StoryModel(
                    id: '$i',
                    name: 'Story $i',
                    imageUrl: '',
                    thumbnailUrl: '',
                  ),
                ),
                onTap: (i) => selected = i,
              ),
            ),
          ),
        ),
      );
      final list = find.byKey(const ValueKey('portfolio-story-list'));
      final scroll = find.descendant(
        of: list,
        matching: find.byType(Scrollable),
      );
      final position = tester.state<ScrollableState>(scroll).position;
      expect(tester.getSize(list).width, width);
      expect(position.maxScrollExtent, greaterThan(0));
      await tester.drag(list, const Offset(-280, 0));
      await tester.pump(const Duration(milliseconds: 500));
      expect(position.pixels, greaterThan(0));
      position.jumpTo(position.maxScrollExtent);
      await tester.pump();
      await tester.tap(find.text('Story 11'));
      expect(selected, 11);
      expect(tester.takeException(), isNull);
    });
  }
}
