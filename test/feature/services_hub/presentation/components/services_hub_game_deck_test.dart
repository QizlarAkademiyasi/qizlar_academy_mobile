import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/text_styles.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/app_options.dart';
import 'package:qizlar_academy_mobile/feature/services_hub/domain/model/services_hub_game_item.dart';
import 'package:qizlar_academy_mobile/feature/services_hub/presentation/components/services_hub_game_card.dart';
import 'package:qizlar_academy_mobile/feature/services_hub/presentation/components/services_hub_game_deck.dart';

void main() {
  const games = [
    ServicesHubGameItem(
      id: 'a',
      title: '2048',
      description: 'Desc A',
      playUrl: 'https://2048-game-7tp.pages.dev/',
      backgroundAsset:
          'packages/qizlar_academy_kit/assets/images/services_hub/game_card_2048_bg.svg',
      playButtonLabel: '2048',
    ),
    ServicesHubGameItem(
      id: 'b',
      title: 'Candy',
      description: 'Desc B',
      playUrl: 'https://candy-crash-2or.pages.dev/',
      backgroundAsset:
          'packages/qizlar_academy_kit/assets/images/services_hub/game_card_candy_bg.svg',
      playButtonLabel: 'Go',
    ),
  ];

  Finder cardWithId(String id) {
    return find.byWidgetPredicate(
      (widget) => widget is ServicesHubGameCard && widget.game.id == id,
    );
  }

  Future<void> tapCardPeek(WidgetTester tester, Finder card) async {
    final rect = tester.getRect(card);
    await tester.tapAt(Offset(rect.center.dx, rect.top + 24));
    await tester.pumpAndSettle(ServicesHubGameDeck.animationDuration);
  }

  Future<void> pumpDeck(WidgetTester tester) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      AppThemeProvider(
        builder: (context) => MaterialApp(
          theme: AppOptions.lightThemeData(context),
          home: Scaffold(
            body: SingleChildScrollView(
              child: ServicesHubGameDeck(
                games: games,
                onPlayGame: (_) {},
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('deck expands one card at a time on tap', (tester) async {
    await pumpDeck(tester);

    expect(find.byType(ServicesHubGameCard), findsNWidgets(2));

    final cardA = cardWithId('a');
    expect(tester.getSize(cardA).height, ServicesHubGameCard.collapsedHeight);
    expect(tester.widget<ServicesHubGameCard>(cardA).isExpanded, isFalse);

    await tapCardPeek(tester, cardA);

    expect(tester.getSize(cardA).height, ServicesHubGameCard.expandedHeight);
    expect(tester.widget<ServicesHubGameCard>(cardA).isExpanded, isTrue);

    await tapCardPeek(tester, cardA);

    expect(tester.getSize(cardA).height, ServicesHubGameCard.collapsedHeight);
    expect(tester.widget<ServicesHubGameCard>(cardA).isExpanded, isFalse);
  });

  testWidgets('collapsed stack uses peek step and total height', (tester) async {
    await pumpDeck(tester);

    final peek = ServicesHubGameDeck.stackPeek;
    final rect0 = tester.getRect(cardWithId('a'));
    final rect1 = tester.getRect(cardWithId('b'));

    expect(rect1.top, rect0.top + peek);

    final deck = find.byType(ServicesHubGameDeck);
    expect(
      tester.getSize(deck).height,
      peek + ServicesHubGameCard.collapsedHeight,
    );
  });

  testWidgets('expanded card keeps Figma overlap step to next card', (tester) async {
    await pumpDeck(tester);

    final cardA = cardWithId('a');
    await tapCardPeek(tester, cardA);

    final rect0 = tester.getRect(cardA);
    final rect1 = tester.getRect(cardWithId('b'));
    final expandedPeek = ServicesHubGameDeck.expandedStackPeek;

    expect(rect0.top, 0);
    expect(rect1.top, rect0.top + expandedPeek);
    expect(
      tester.getSize(find.byType(ServicesHubGameDeck)).height,
      expandedPeek + ServicesHubGameCard.collapsedHeight,
    );
  });

  testWidgets('deck height animates when a card expands', (tester) async {
    await pumpDeck(tester);

    final deck = find.byType(ServicesHubGameDeck);
    final collapsedHeight =
        ServicesHubGameDeck.stackPeek + ServicesHubGameCard.collapsedHeight;
    final expandedHeight =
        ServicesHubGameDeck.expandedStackPeek +
        ServicesHubGameCard.collapsedHeight;

    expect(tester.getSize(deck).height, collapsedHeight);

    final cardA = cardWithId('a');
    final rect = tester.getRect(cardA);
    await tester.tapAt(Offset(rect.center.dx, rect.top + 24));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));

    final midHeight = tester.getSize(deck).height;
    expect(midHeight, greaterThan(collapsedHeight));
    expect(midHeight, lessThan(expandedHeight));

    await tester.pumpAndSettle(ServicesHubGameDeck.animationDuration);
    expect(tester.getSize(deck).height, expandedHeight);
  });

  List<String> deckCardPaintOrder(WidgetTester tester) {
    final stack = tester.widget<Stack>(
      find
          .descendant(
            of: find.byType(ServicesHubGameDeck),
            matching: find.byType(Stack),
          )
          .first,
    );
    return stack.children
        .whereType<AnimatedPositioned>()
        .map((positioned) => (positioned.key! as ValueKey<String>).value)
        .toList(growable: false);
  }

  testWidgets('expanded card paints above cards below it in the stack', (
    tester,
  ) async {
    await pumpDeck(tester);

    expect(deckCardPaintOrder(tester), ['a', 'b']);

    await tapCardPeek(tester, cardWithId('a'));

    expect(deckCardPaintOrder(tester), ['b', 'a']);
  });

  testWidgets('collapsed play button is visible but not tappable', (tester) async {
    await pumpDeck(tester);

    final cardA = cardWithId('a');
    final playButton = find.descendant(
      of: cardA,
      matching: find.byWidgetPredicate(
        (widget) =>
            widget is SizedBox &&
            widget.width == 64 &&
            widget.height == 64,
      ),
    );
    expect(playButton, findsOneWidget);

    final ignorePointer = tester.widget<IgnorePointer>(
      find.ancestor(
        of: playButton,
        matching: find.byType(IgnorePointer),
      ).first,
    );
    expect(ignorePointer.ignoring, isTrue);
  });

  testWidgets('card content uses Figma top offsets', (tester) async {
    await pumpDeck(tester);

    void expectPositionedTop(
      double top, {
      double? left,
      double? right,
    }) {
      expect(
        find.descendant(
          of: cardWithId('a'),
          matching: find.byWidgetPredicate(
            (widget) {
              if (widget is! AnimatedPositioned || widget.top != top) {
                return false;
              }
              if (left != null && widget.left != left) return false;
              if (right != null && widget.right != right) return false;
              return true;
            },
          ),
        ),
        findsOneWidget,
      );
    }

    expectPositionedTop(
      ServicesHubGameCard.titleTopCollapsed,
      left: 0,
      right: 0,
    );
    expectPositionedTop(ServicesHubGameCard.descriptionTopCollapsed);
    expectPositionedTop(ServicesHubGameCard.playTopCollapsed);

    await tapCardPeek(tester, cardWithId('a'));

    expectPositionedTop(
      ServicesHubGameCard.titleTopExpanded,
      left: 0,
      right: 0,
    );
    expectPositionedTop(ServicesHubGameCard.descriptionTopExpanded);
    expectPositionedTop(ServicesHubGameCard.playTopExpanded);
  });

  testWidgets('expanded card background fills the full card height', (
    tester,
  ) async {
    await pumpDeck(tester);

    final cardA = cardWithId('a');
    final background = find.descendant(
      of: cardA,
      matching: find.byWidgetPredicate(
        (widget) =>
            widget is Positioned &&
            widget.left == 0 &&
            widget.top == 0 &&
            widget.right == 0 &&
            widget.bottom == 0 &&
            widget.child is SvgPicture,
      ),
    );
    expect(background, findsOneWidget);

    await tapCardPeek(tester, cardA);

    final bgBox = tester.renderObject<RenderBox>(background.first);
    expect(bgBox.size.height, ServicesHubGameCard.expandedHeight);
  });
}
