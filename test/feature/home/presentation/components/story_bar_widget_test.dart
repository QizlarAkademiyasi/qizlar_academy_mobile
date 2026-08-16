import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/text_styles.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/app_options.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/category_model.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/components/story_avatar_ring_painter.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/components/story_bar_widget.dart';

void main() {
  testWidgets('ports Telegram threshold, wave, state, and collapsed stack', (
    tester,
  ) async {
    await tester.pumpWidget(const _TestApp());

    expect(find.byType(SliverAppBar), findsNothing);
    expect(find.byType(BackdropFilter), findsOneWidget);
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
    expect(find.byKey(const ValueKey('story-state-expanded')), findsOneWidget);
    expect(
      _avatarDiameter(tester, 'story-avatar-image-0'),
      StoryBarWidget.expandedAvatarSize,
    );

    final storyScrollable = find.descendant(
      of: find.byKey(const ValueKey('story-list-viewport')),
      matching: find.byType(Scrollable),
    );
    final storyPosition = tester
        .state<ScrollableState>(storyScrollable)
        .position;
    expect(storyPosition.maxScrollExtent, greaterThan(0));

    await tester.drag(
      find.byKey(const ValueKey('story-list-viewport')),
      const Offset(-400, 0),
    );
    await tester.pump(const Duration(milliseconds: 500));
    expect(storyPosition.pixels, greaterThan(0));

    final state = tester.state<_StoryBarHarnessState>(
      find.byType(_StoryBarHarness),
    );
    state.scrollController.jumpTo(
      StoryBarWidget.collapseExtent * (StoryBarWidget.collapseThreshold - 0.01),
    );
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.byKey(const ValueKey('story-state-expanded')), findsOneWidget);

    state.scrollController.jumpTo(
      StoryBarWidget.collapseExtent * (StoryBarWidget.collapseThreshold + 0.02),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 180));

    expect(
      find.byKey(const ValueKey('story-state-transition')),
      findsOneWidget,
    );
    final firstSize = _avatarDiameter(tester, 'collapsed-story-avatar-image-0');
    final secondSize = _avatarDiameter(
      tester,
      'collapsed-story-avatar-image-1',
    );
    final thirdSize = _avatarDiameter(tester, 'collapsed-story-avatar-image-2');
    expect(firstSize, lessThan(secondSize));
    expect(secondSize, lessThan(thirdSize));

    state.scrollController.jumpTo(StoryBarWidget.collapseExtent);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1100));

    expect(find.byKey(const ValueKey('story-state-collapsed')), findsOneWidget);
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
      _avatarDiameter(tester, 'collapsed-story-avatar-image-0'),
      closeTo(StoryBarWidget.collapsedAvatarSize, 0.01),
    );
    expect(
      tester
              .getTopLeft(find.byKey(const ValueKey('collapsed-story-item-1')))
              .dx -
          tester
              .getTopLeft(find.byKey(const ValueKey('collapsed-story-item-0')))
              .dx,
      closeTo(StoryBarWidget.collapsedStoryStep - 0.5, 0.01),
    );
    expect(
      tester
              .getTopLeft(find.byKey(const ValueKey('collapsed-story-item-2')))
              .dx -
          tester
              .getTopLeft(find.byKey(const ValueKey('collapsed-story-item-1')))
              .dx,
      closeTo(StoryBarWidget.collapsedStoryStep, 0.01),
    );
    for (var index = 0; index < _stories.length; index++) {
      expect(
        tester
            .widget<Opacity>(find.byKey(ValueKey('story-item-$index')))
            .opacity,
        0,
      );
    }
    for (var index = 0; index < 3; index++) {
      expect(
        tester
            .widget<Opacity>(
              find.byKey(ValueKey('collapsed-story-item-$index')),
            )
            .opacity,
        1,
      );
    }
    expect(
      tester
          .widget<Align>(find.byKey(const ValueKey('collapsed-story-label-0')))
          .heightFactor,
      0,
    );
    expect(
      tester
          .widget<Opacity>(find.byKey(const ValueKey('header-name-opacity')))
          .opacity,
      0,
    );

    final secondAvatar = find.byKey(const ValueKey('collapsed-story-avatar-1'));
    final ringPaint = tester.widget<CustomPaint>(
      find
          .descendant(of: secondAvatar, matching: find.byType(CustomPaint))
          .first,
    );
    final painter = ringPaint.painter! as StoryAvatarRingPainter;
    expect(painter.exclusions, isNotEmpty);

    state.scrollController.jumpTo(0);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1100));
    expect(find.byKey(const ValueKey('story-state-expanded')), findsOneWidget);
    expect(
      tester.getTopLeft(find.byKey(const ValueKey('story-item-5'))).dx -
          tester.getTopLeft(find.byKey(const ValueKey('story-item-4'))).dx,
      StoryBarWidget.expandedStoryStep,
    );
  });

  testWidgets('keeps long stories scrollable and reserves collapsed actions', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const _TestApp());

    final viewport = find.byKey(const ValueKey('story-list-viewport'));
    expect(tester.getSize(viewport).width, 320);

    final storyScrollable = find.descendant(
      of: viewport,
      matching: find.byType(Scrollable),
    );
    final storyPosition = tester
        .state<ScrollableState>(storyScrollable)
        .position;
    expect(storyPosition.maxScrollExtent, greaterThan(0));

    await tester.drag(viewport, const Offset(-180, 0));
    await tester.pump(const Duration(milliseconds: 300));
    expect(storyPosition.pixels, greaterThan(0));

    final state = tester.state<_StoryBarHarnessState>(
      find.byType(_StoryBarHarness),
    );
    state.scrollController.jumpTo(StoryBarWidget.collapseExtent);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1100));

    expect(
      tester.getSize(viewport).width,
      320 - StoryBarWidget.collapsedActionsWidth,
    );
    for (var index = 3; index < _stories.length; index++) {
      expect(
        tester
            .widget<Opacity>(find.byKey(ValueKey('story-item-$index')))
            .opacity,
        0,
      );
    }
  });
}

double _avatarDiameter(WidgetTester tester, String key) {
  return tester.getSize(find.byKey(ValueKey(key))).width -
      StoryAvatarRingPainter.ringInset * 2;
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
