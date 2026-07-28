import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/text_styles.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/app_options.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/category_model.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/components/story_bar_widget.dart';

void main() {
  testWidgets('collapses with custom geometry without a SliverAppBar', (
    tester,
  ) async {
    await tester.pumpWidget(const _TestApp());

    expect(find.byType(SliverAppBar), findsNothing);
    expect(find.byType(BackdropFilter), findsOneWidget);
    expect(
      tester.getSize(find.byKey(const ValueKey('story-bar'))).height,
      StoryBarWidget.expandedHeight,
    );
    expect(
      tester.getTopLeft(find.byKey(const ValueKey('story-list-viewport'))).dy,
      StoryBarWidget.expandedStoriesTop,
    );

    final state = tester.state<_StoryBarHarnessState>(
      find.byType(_StoryBarHarness),
    );
    state.scrollController.jumpTo(StoryBarWidget.collapseExtent / 2);
    await tester.pump();

    expect(
      tester.getSize(find.byKey(const ValueKey('story-bar'))).height,
      closeTo(
        StoryBarWidget.collapsedHeight + StoryBarWidget.collapseExtent / 2,
        0.01,
      ),
    );

    state.scrollController.jumpTo(StoryBarWidget.collapseExtent);
    await tester.pump();

    expect(
      tester.getSize(find.byKey(const ValueKey('story-bar'))).height,
      StoryBarWidget.collapsedHeight,
    );
    expect(
      tester
          .getRect(find.byKey(const ValueKey('persistent-notification')))
          .bottom,
      lessThanOrEqualTo(StoryBarWidget.collapsedHeight),
    );
    expect(
      tester
          .widget<Opacity>(find.byKey(const ValueKey('header-name-opacity')))
          .opacity,
      0,
    );
  });
}

class _TestApp extends StatelessWidget {
  const _TestApp();

  @override
  Widget build(BuildContext context) {
    return AppThemeProvider(
      builder: (context) => MaterialApp(
        theme: AppOptions.lightThemeData(context),
        home: const Scaffold(body: _StoryBarHarness()),
      ),
    );
  }
}

class _StoryBarHarness extends StatefulWidget {
  const _StoryBarHarness();

  @override
  State<_StoryBarHarness> createState() => _StoryBarHarnessState();
}

class _StoryBarHarnessState extends State<_StoryBarHarness> {
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          controller: scrollController,
          children: const [
            SizedBox(height: StoryBarWidget.expandedHeight),
            SizedBox(height: 1200),
          ],
        ),
        StoryBarWidget(
          key: const ValueKey('story-bar'),
          scrollController: scrollController,
          isLoading: false,
          list: _stories,
          headerBuilder: (context, expandedProgress) => SizedBox(
            height: kToolbarHeight,
            child: Stack(
              children: [
                Opacity(
                  key: const ValueKey('header-name-opacity'),
                  opacity: expandedProgress,
                  child: const Text('Header name'),
                ),
                const Positioned(
                  right: 8,
                  child: SizedBox(
                    key: ValueKey('persistent-notification'),
                    width: 48,
                    height: 48,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}

const _stories = [
  StoryModel(id: 'story-1', name: 'Birinchi', imageUrl: '', thumbnailUrl: ''),
  StoryModel(id: 'story-2', name: 'Ikkinchi', imageUrl: '', thumbnailUrl: ''),
  StoryModel(id: 'story-3', name: 'Uchinchi', imageUrl: '', thumbnailUrl: ''),
  StoryModel(id: 'story-4', name: 'To‘rtinchi', imageUrl: '', thumbnailUrl: ''),
];
