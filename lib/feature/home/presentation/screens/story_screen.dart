import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/category_model.dart';
import 'package:story/story.dart';

class StoryScreen extends StatefulWidget {
  const StoryScreen({
    super.key,
    required this.categories,
    required this.initialIndex,
    required this.onView,
  });

  final List<StoryModel> categories;
  final int initialIndex;
  final ValueChanged<String> onView;

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  late final ValueNotifier<IndicatorAnimationCommand>
  indicatorAnimationController;

  double _dismissProgress = 0.0;
  bool _isPopped = false;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    indicatorAnimationController = ValueNotifier<IndicatorAnimationCommand>(
      IndicatorAnimationCommand.resume,
    );
  }

  @override
  void dispose() {
    indicatorAnimationController.dispose();
    super.dispose();
  }

  void _safePop() {
    if (!_isPopped) {
      _isPopped = true;
      if (mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Positioned.fill(
              child: ColoredBox(
                color: Colors.black.withValues(
                  alpha: (1 - _dismissProgress).clamp(0.0, 1.0),
                ),
              ),
            ),
            Dismissible(
              key: const Key('story_dismissible'),
              direction: DismissDirection.down,
              onUpdate: (details) {
                if (_isPopped) return;
                if (details.progress > 0.25) {
                  _safePop();
                } else {
                  setState(() {
                    _dismissProgress = details.progress;
                  });
                }
              },
              dismissThresholds: const {DismissDirection.down: 0.2},
              confirmDismiss: (direction) async {
                _safePop();
                return false;
              },
              onDismissed: (_) {},
              child: Transform.scale(
                scale: 1 - (_dismissProgress * 0.2),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    _dismissProgress > 0 ? 32 * _dismissProgress : 0,
                  ),
                  child: Hero(
                    tag:
                        'story_${widget.categories[_currentIndex].id}_$_currentIndex',
                    flightShuttleBuilder:
                        (
                          flightContext,
                          animation,
                          flightDirection,
                          fromHeroContext,
                          toHeroContext,
                        ) {
                          final Widget bigScreen =
                              flightDirection == HeroFlightDirection.push
                              ? (toHeroContext.widget as Hero).child
                              : (fromHeroContext.widget as Hero).child;
                          return AnimatedBuilder(
                            animation: animation,
                            builder: (context, child) {
                              final bool isPop =
                                  flightDirection == HeroFlightDirection.pop;
                              final double animValue =
                                  flightDirection == HeroFlightDirection.push
                                  ? animation.value
                                  : 1.0 - animation.value;
                              final double fadeOpacity = isPop
                                  ? animation.value.clamp(0.0, 1.0)
                                  : 1.0;
                              final double borderRadiusValue = isPop
                                  ? 50.0
                                  : 50 * (1 - animValue);
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  borderRadiusValue,
                                ),
                                child: Opacity(
                                  opacity: fadeOpacity,
                                  child: bigScreen,
                                ),
                              );
                            },
                          );
                        },
                    child: Material(
                      type: MaterialType.transparency,
                      child: StoryPageView(
                        initialPage: widget.initialIndex,
                        itemBuilder: (context, pageIndex, storyIndex) {
                          final category = widget.categories[pageIndex];
                          return Stack(
                            children: [
                              Positioned.fill(
                                child: CachedNetworkImage(
                                  imageUrl: category.imageUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned.fill(
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.black.withValues(alpha: 0.8),
                                        Colors.transparent,
                                        Colors.black.withValues(alpha: 0.8),
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      stops: const [0.0, 0.4, 0.8],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 60,
                                left: 16,
                                right: 16,
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    // Hero pop'ning oxirida konteyner juda torayadi.
                                    // Shu holatda row soddalashib overflow'ni oldini oladi.
                                    final isVeryTight =
                                        constraints.maxWidth < 56;
                                    final isTight = constraints.maxWidth < 96;

                                    if (isVeryTight) {
                                      return const SizedBox.shrink();
                                    }

                                    return Row(
                                      children: [
                                        Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 1.5,
                                            ),
                                            image: DecorationImage(
                                              image: CachedNetworkImageProvider(
                                                category.thumbnailUrl,
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        if (!isTight) const SizedBox(width: 8),
                                        if (!isTight)
                                          Expanded(
                                            child: Text(
                                              category.name,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: context
                                                  .textTheme
                                                  .bodyMediumBold
                                                  .copyWith(
                                                    color: Colors.white,
                                                  ),
                                            ),
                                          ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                        gestureItemBuilder: (context, pageIndex, storyIndex) {
                          return const SizedBox.shrink();
                        },
                        pageLength: widget.categories.length,
                        storyLength: (int pageIndex) {
                          return 1;
                        },
                        onPageLimitReached: () {
                          _safePop();
                        },
                        indicatorAnimationController:
                            indicatorAnimationController,
                        onPageChanged: (pageIndex) {
                          setState(() {
                            _currentIndex = pageIndex;
                          });
                          widget.onView(widget.categories[pageIndex].id);
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
