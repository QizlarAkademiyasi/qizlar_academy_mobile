import 'package:flutter/rendering.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/feature/services_hub/domain/model/services_hub_game_item.dart';
import 'package:qizlar_academy_mobile/feature/services_hub/presentation/components/services_hub_game_card.dart';

class ServicesHubGameDeck extends StatefulWidget {
  const ServicesHubGameDeck({
    super.key,
    required this.games,
    required this.onPlayGame,
    this.revealBottomInset = 0,
  });

  static const double cardOverlap = 44;
  static const double cardTiltRadians = 0.1;
  static const double cardPerspective = 0.001;
  static const Duration animationDuration = Duration(milliseconds: 450);
  static const Curve animationCurve = Curves.easeOutCubic;

  /// Yopiq stackda har bir kartaning ko‘rinadigan vertikal qadam (Figma overlap).
  static double get stackPeek =>
      ServicesHubGameCard.collapsedHeight - cardOverlap;

  final List<ServicesHubGameItem> games;
  final ValueChanged<ServicesHubGameItem> onPlayGame;
  final double revealBottomInset;

  @override
  State<ServicesHubGameDeck> createState() => _ServicesHubGameDeckState();
}

class _ServicesHubGameDeckState extends State<ServicesHubGameDeck> {
  int? _expandedIndex;
  final Map<String, GlobalKey> _cardKeys = {};

  @override
  void initState() {
    super.initState();
    _ensureCardKeys();
  }

  @override
  void didUpdateWidget(ServicesHubGameDeck oldWidget) {
    super.didUpdateWidget(oldWidget);
    _ensureCardKeys();
  }

  void _ensureCardKeys() {
    for (final game in widget.games) {
      _cardKeys.putIfAbsent(game.id, GlobalKey.new);
    }
  }

  double _cardHeight(int index) {
    return _expandedIndex == index
        ? ServicesHubGameCard.expandedHeight
        : ServicesHubGameCard.collapsedHeight;
  }

  /// Karta bilan keyingi karta orasidagi vertikal qadam.
  double _stepAfter(int index) {
    return _expandedIndex == index
        ? ServicesHubGameCard.expandedHeight
        : ServicesHubGameDeck.stackPeek;
  }

  List<double> _tops() {
    final tops = <double>[0];
    for (var i = 1; i < widget.games.length; i++) {
      tops.add(tops[i - 1] + _stepAfter(i - 1));
    }
    return tops;
  }

  double _totalHeight(List<double> tops) {
    return tops.last + _cardHeight(widget.games.length - 1);
  }

  void _onCardTap(int index) {
    final expanding = _expandedIndex != index;
    setState(() {
      if (_expandedIndex == index) {
        _expandedIndex = null;
      } else {
        _expandedIndex = index;
      }
    });
    if (expanding && _expandedIndex == index) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _revealExpandedCard(widget.games[index]);
      });
    }
  }

  void _revealExpandedCard(ServicesHubGameItem game) {
    if (!mounted) {
      return;
    }
    final scrollable = Scrollable.maybeOf(context);
    if (scrollable == null) {
      return;
    }
    final key = _cardKeys[game.id];
    final cardContext = key?.currentContext;
    if (cardContext == null) {
      return;
    }
    final box = cardContext.findRenderObject();
    if (box is! RenderBox || !box.hasSize) {
      return;
    }
    final position = scrollable.position;
    final target = RenderAbstractViewport.of(box).getOffsetToReveal(box, 1).offset +
        widget.revealBottomInset;
    if (target > position.pixels) {
      position.animateTo(
        target.clamp(position.minScrollExtent, position.maxScrollExtent),
        duration: ServicesHubGameDeck.animationDuration,
        curve: ServicesHubGameDeck.animationCurve,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.games.isEmpty) {
      return const SizedBox.shrink();
    }

    final count = widget.games.length;
    final tops = _tops();
    final totalHeight = _totalHeight(tops);

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: totalHeight, end: totalHeight),
      duration: ServicesHubGameDeck.animationDuration,
      curve: ServicesHubGameDeck.animationCurve,
      builder: (context, height, child) {
        return SizedBox(
          height: height,
          width: double.infinity,
          child: child,
        );
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          for (var i = 0; i < count; i++)
            AnimatedPositioned(
              key: ValueKey(widget.games[i].id),
              duration: ServicesHubGameDeck.animationDuration,
              curve: ServicesHubGameDeck.animationCurve,
              left: 0,
              right: 0,
              top: tops[i],
              height: _cardHeight(i),
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(
                  end: _expandedIndex == i ? 0.0 : ServicesHubGameDeck.cardTiltRadians,
                ),
                duration: ServicesHubGameDeck.animationDuration,
                curve: ServicesHubGameDeck.animationCurve,
                builder: (context, angle, child) {
                  return Transform(
                    alignment: Alignment.topCenter,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, ServicesHubGameDeck.cardPerspective)
                      ..rotateX(angle),
                    child: child,
                  );
                },
                child: ServicesHubGameCard(
                  key: _cardKeys[widget.games[i].id],
                  game: widget.games[i],
                  isExpanded: _expandedIndex == i,
                  onCardTap: () => _onCardTap(i),
                  onPlayTap: () => widget.onPlayGame(widget.games[i]),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
