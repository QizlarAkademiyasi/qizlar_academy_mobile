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

  testWidgets('expanded card pushes card below without overlap', (tester) async {
    await pumpDeck(tester);

    final cardA = cardWithId('a');
    await tapCardPeek(tester, cardA);

    final rect0 = tester.getRect(cardA);
    final rect1 = tester.getRect(cardWithId('b'));

    expect(rect0.top, 0);
    expect(rect1.top, rect0.top + ServicesHubGameCard.expandedHeight);
    expect(
      tester.getSize(find.byType(ServicesHubGameDeck)).height,
      ServicesHubGameCard.expandedHeight + ServicesHubGameCard.collapsedHeight,
    );
  });

  testWidgets('deck height animates when a card expands', (tester) async {
    await pumpDeck(tester);

    final deck = find.byType(ServicesHubGameDeck);
    final collapsedHeight =
        ServicesHubGameDeck.stackPeek + ServicesHubGameCard.collapsedHeight;
    final expandedHeight =
        ServicesHubGameCard.expandedHeight + ServicesHubGameCard.collapsedHeight;

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

  testWidgets('unselected cards use perspective tilt when collapsed', (tester) async {
    await pumpDeck(tester);

    Transform cardTransform(Finder card) {
      return tester.widget<Transform>(
        find.ancestor(
          of: card,
          matching: find.byType(Transform),
        ).first,
      );
    }

    expect(
      cardTransform(cardWithId('a')).transform.entry(1, 1),
      lessThan(1.0),
    );

    await tapCardPeek(tester, cardWithId('a'));

    expect(
      cardTransform(cardWithId('a')).transform.entry(1, 1),
      closeTo(1.0, 0.001),
    );
    expect(
      cardTransform(cardWithId('b')).transform.entry(1, 1),
      lessThan(1.0),
    );
  });

  testWidgets('play button is hidden when card is collapsed', (tester) async {
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

    final opacity = tester.widget<AnimatedOpacity>(
      find.ancestor(
        of: playButton,
        matching: find.byType(AnimatedOpacity),
      ).first,
    );
    expect(opacity.opacity, 0);

    final ignorePointer = tester.widget<IgnorePointer>(
      find.ancestor(
        of: playButton,
        matching: find.byType(IgnorePointer),
      ).first,
    );
    expect(ignorePointer.ignoring, isTrue);
  });
}
