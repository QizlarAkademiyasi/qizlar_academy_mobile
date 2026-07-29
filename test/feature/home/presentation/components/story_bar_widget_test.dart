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
    expect(tester.getTopLeft(find.byType(BackdropFilter)).dy, 0);
    expect(
      tester.getSize(find.byType(BackdropFilter)).height,
      _topPadding + StoryBarWidget.expandedHeight,
    );
    expect(
      tester.getSize(find.byKey(const ValueKey('story-bar'))).height,
      _topPadding + StoryBarWidget.expandedHeight,
    );
    expect(
      tester.getTopLeft(find.byKey(const ValueKey('story-list-viewport'))).dy,
      _topPadding + StoryBarWidget.expandedStoriesTop,
    );
    expect(
      tester.getTopLeft(find.byKey(const ValueKey('first-content'))).dy,
      _topPadding + StoryBarWidget.expandedHeight,
    );
    expect(
      tester.getRect(find.byKey(const ValueKey('story-list-viewport'))).right,
      tester.getSize(find.byType(_StoryBarHarness)).width,
    );

    final storyScrollable = find.descendant(
      of: find.byKey(const ValueKey('story-list-viewport')),
      matching: find.byType(Scrollable),
    );
    final scrollPosition = tester
        .state<ScrollableState>(storyScrollable)
        .position;
    expect(scrollPosition.maxScrollExtent, greaterThan(0));

    await tester.drag(
      find.byKey(const ValueKey('story-list-viewport')),
      const Offset(-400, 0),
    );
    await tester.pump(const Duration(milliseconds: 500));

    expect(scrollPosition.pixels, greaterThan(0));

    final state = tester.state<_StoryBarHarnessState>(
      find.byType(_StoryBarHarness),
    );
    state.scrollController.jumpTo(StoryBarWidget.collapseExtent / 2);
    await tester.pump();

    expect(
      tester.getSize(find.byKey(const ValueKey('story-bar'))).height,
      closeTo(
        _topPadding +
            StoryBarWidget.collapsedHeight +
            StoryBarWidget.collapseExtent / 2,
        0.01,
      ),
    );

    state.scrollController.jumpTo(StoryBarWidget.collapseExtent);
    await tester.pump();

    expect(
      tester.getSize(find.byKey(const ValueKey('story-bar'))).height,
      _topPadding + StoryBarWidget.collapsedHeight,
    );
    expect(
      tester.getTopLeft(find.byKey(const ValueKey('first-content'))).dy,
      _topPadding + StoryBarWidget.collapsedHeight,
    );
    expect(
      tester.getRect(find.byKey(const ValueKey('story-list-viewport'))).right,
      tester.getSize(find.byType(_StoryBarHarness)).width -
          StoryBarWidget.collapsedActionsWidth,
    );
    expect(
      tester
          .getRect(find.byKey(const ValueKey('persistent-notification')))
          .bottom,
      lessThanOrEqualTo(_topPadding + StoryBarWidget.collapsedHeight),
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
        home: const MediaQuery(
          data: MediaQueryData(padding: EdgeInsets.only(top: _topPadding)),
          child: Scaffold(body: _StoryBarHarness()),
        ),
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
          padding: EdgeInsets.zero,
          children: const [
            SizedBox(height: _topPadding + StoryBarWidget.expandedHeight),
            SizedBox(key: ValueKey('first-content'), height: 1200),
          ],
        ),
        StoryBarWidget(
          key: const ValueKey('story-bar'),
          scrollController: scrollController,
          isLoading: false,
          list: _stories,
          topPadding: _topPadding,
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

const _topPadding = 24.0;

const _stories = [
  StoryModel(id: 'story-1', name: 'Birinchi', imageUrl: '', thumbnailUrl: ''),
  StoryModel(id: 'story-2', name: 'Ikkinchi', imageUrl: '', thumbnailUrl: ''),
  StoryModel(id: 'story-3', name: 'Uchinchi', imageUrl: '', thumbnailUrl: ''),
  StoryModel(id: 'story-4', name: 'To‘rtinchi', imageUrl: '', thumbnailUrl: ''),
  StoryModel(id: 'story-5', name: 'Beshinchi', imageUrl: '', thumbnailUrl: ''),
  StoryModel(id: 'story-6', name: 'Oltinchi', imageUrl: '', thumbnailUrl: ''),
  StoryModel(id: 'story-7', name: 'Yettinchi', imageUrl: '', thumbnailUrl: ''),
  StoryModel(
    id: 'story-8',
    name: 'Sakkizinchi',
    imageUrl: '',
    thumbnailUrl: '',
  ),
  StoryModel(
    id: 'story-9',
    name: 'To‘qqizinchi',
    imageUrl: '',
    thumbnailUrl: '',
  ),
  StoryModel(id: 'story-10', name: 'O‘ninchi', imageUrl: '', thumbnailUrl: ''),
  StoryModel(
    id: 'story-11',
    name: 'O‘n birinchi',
    imageUrl: '',
    thumbnailUrl: '',
  ),
  StoryModel(
    id: 'story-12',
    name: 'O‘n ikkinchi',
    imageUrl: '',
    thumbnailUrl: '',
  ),
];
