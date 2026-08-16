import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/category_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/repository/home_repository.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/components/story_avatar_ring_painter.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/screens/story/story_screen.dart';

enum _StoryHeaderState { expanded, transition, collapsed }

class StoryBarWidget extends StatefulWidget {
  const StoryBarWidget({
    super.key,
    required this.scrollController,
    required this.isLoading,
    required this.list,
    required this.headerBuilder,
    this.topPadding = 0,
  });

  final ScrollController scrollController;
  final bool isLoading;
  final List<StoryModel> list;
  final Widget Function(BuildContext context, double expandedProgress)
  headerBuilder;
  final double topPadding;

  static const double expandedHeight = 162;
  static const double collapsedHeight = kToolbarHeight + 8;
  static const double emptyHeight = collapsedHeight;
  static const double expandedStoriesTop = 70;
  static const double collapsedActionsWidth = 120;
  static const int collapsedVisibleStoryCount = 3;
  static const double expandedAvatarSize = 48;
  static const double collapsedAvatarSize = 26.33;
  static const double collapsedStoryStep = 16;
  static const double expandedStoryStep = 70;
  static const double collapseThreshold = 0.3;
  static const double collapseExtent = expandedHeight - collapsedHeight;

  static double layoutExtent({
    required bool isLoading,
    required List<StoryModel> stories,
    double topPadding = 0,
  }) {
    final headerHeight = isLoading || stories.isNotEmpty
        ? expandedHeight
        : emptyHeight;
    return topPadding + headerHeight;
  }

  @override
  State<StoryBarWidget> createState() => _StoryBarWidgetState();
}

class _StoryBarWidgetState extends State<StoryBarWidget>
    with TickerProviderStateMixin {
  static const _easeOutQuint = Cubic(0.23, 1, 0.32, 1);
  static const _collapseSpring = _TelegramOvershootCurve(0.95);
  static const _expandSpring = _TelegramOvershootCurve(0.9);
  static const _storyPadding = 24.0;
  static const _ringInset = StoryAvatarRingPainter.ringInset;

  late final AnimationController _collapseFactorController;
  late final AnimationController _xMotionController;
  late final AnimationController _yStoriesController;
  Animation<double> _xMotionAnimation = const AlwaysStoppedAnimation(0);
  Animation<double> _yStoriesAnimation = const AlwaysStoppedAnimation(0);

  final ScrollController _storiesScrollController = ScrollController();
  final Set<String> _viewedIds = {};
  double _rawCollapseProgress = 0;
  double _xMotion = 0;
  double _yStoriesProgress = 0;
  bool _collapseTarget = false;
  _StoryHeaderState _state = _StoryHeaderState.expanded;

  double get _collapseFactor => _collapseFactorController.value;
  double get _collapsedProgress =>
      (_rawCollapseProgress * _collapseFactor).clamp(0, 1);

  @override
  void initState() {
    super.initState();
    _collapseFactorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..addListener(_onAnimationTick);
    _xMotionController = AnimationController(vsync: this)
      ..addListener(() {
        _xMotion = _xMotionAnimation.value;
        _onAnimationTick();
      });
    _yStoriesController = AnimationController(vsync: this)
      ..addListener(() {
        _yStoriesProgress = _yStoriesAnimation.value;
        _onAnimationTick();
      });
    widget.scrollController.addListener(_updateProgressFromScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _updateProgressFromScroll();
    });
  }

  void _onAnimationTick() {
    if (!mounted) return;
    setState(_syncState);
  }

  void _syncState() {
    final progress = _collapsedProgress;
    _state = switch (progress) {
      <= 0.0001 => _StoryHeaderState.expanded,
      >= 0.9999 => _StoryHeaderState.collapsed,
      _ => _StoryHeaderState.transition,
    };
  }

  void _updateProgressFromScroll() {
    if (!widget.scrollController.hasClients) return;
    final nextProgress =
        (widget.scrollController.offset / StoryBarWidget.collapseExtent).clamp(
          0.0,
          1.0,
        );
    final nextTarget = nextProgress > StoryBarWidget.collapseThreshold;

    if (nextTarget != _collapseTarget) {
      _collapseTarget = nextTarget;
      _animateThresholdTransition(nextTarget, nextProgress);
      unawaited(HapticFeedback.lightImpact());
    }

    if ((_rawCollapseProgress - nextProgress).abs() > 0.0001 && mounted) {
      setState(() {
        _rawCollapseProgress = nextProgress;
        _syncState();
      });
    }
  }

  void _animateThresholdTransition(bool collapse, double scrollProgress) {
    _collapseFactorController.animateTo(
      collapse ? 1 : 0,
      duration: const Duration(milliseconds: 1000),
      curve: _easeOutQuint,
    );

    _xMotionController
      ..stop()
      ..reset();
    _xMotionAnimation = Tween<double>(begin: _xMotion, end: collapse ? 1 : 0)
        .animate(
          CurvedAnimation(
            parent: _xMotionController,
            curve: collapse ? _collapseSpring : _expandSpring,
          ),
        );
    _xMotionController.duration = Duration(milliseconds: collapse ? 750 : 350);
    unawaited(_xMotionController.forward());

    _yStoriesController
      ..stop()
      ..reset();
    _yStoriesAnimation =
        Tween<double>(
          begin: _yStoriesProgress,
          end: collapse ? scrollProgress : 0,
        ).animate(
          CurvedAnimation(parent: _yStoriesController, curve: Curves.easeInOut),
        );
    _yStoriesController.duration = const Duration(milliseconds: 100);
    unawaited(_yStoriesController.forward());
  }

  void _onStoryViewed(String storyId) {
    StoryModel? matchedStory;
    for (final story in widget.list) {
      if (story.id == storyId) {
        matchedStory = story;
        break;
      }
    }
    if (matchedStory == null || !matchedStory.canTrackView) return;
    setState(() => _viewedIds.add(storyId));
    unawaited(getIt<HomeRepository>().postStoryView(storyId));
  }

  bool _isStoryViewedBorder(StoryModel story) =>
      story.canTrackView && (story.isViewed || _viewedIds.contains(story.id));

  @override
  void didUpdateWidget(covariant StoryBarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scrollController == widget.scrollController) return;
    oldWidget.scrollController.removeListener(_updateProgressFromScroll);
    widget.scrollController.addListener(_updateProgressFromScroll);
    _updateProgressFromScroll();
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_updateProgressFromScroll);
    _storiesScrollController.dispose();
    _collapseFactorController.dispose();
    _xMotionController.dispose();
    _yStoriesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showStories = widget.isLoading || widget.list.isNotEmpty;
    final rawCollapse = showStories ? _rawCollapseProgress : 0.0;
    final collapsedProgress = showStories ? _collapsedProgress : 0.0;
    final expandedProgress = _smoothStep(1 - rawCollapse);
    final headerHeight = showStories
        ? StoryBarWidget.expandedHeight -
              StoryBarWidget.collapseExtent * rawCollapse
        : StoryBarWidget.emptyHeight;
    final storiesTop = StoryBarWidget.expandedStoriesTop * (1 - rawCollapse);
    final storiesRightInset =
        StoryBarWidget.collapsedActionsWidth * collapsedProgress;
    final itemCount = widget.isLoading ? 6 : widget.list.length;
    final geometries = _buildGeometries(itemCount, collapsedProgress);
    final exclusions = _buildRingExclusions(geometries);
    final promotedGeometries = geometries.take(3).toList();
    final promotedExclusions = _buildRingExclusions(promotedGeometries);
    final promotedAlpha = (collapsedProgress / StoryBarWidget.collapseThreshold)
        .clamp(0.0, 1.0);
    final listAlpha = 1 - promotedAlpha;
    final labelAlpha =
        1 -
        (collapsedProgress / StoryBarWidget.collapseThreshold).clamp(0.0, 1.0);
    final contentWidth = itemCount * StoryBarWidget.expandedStoryStep;
    final horizontalScrollEnabled =
        _state == _StoryHeaderState.expanded && rawCollapse <= 0.2;

    return SizedBox(
      height: widget.topPadding + headerHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: AppBlurredHeaderSurface(
              child: Padding(
                padding: EdgeInsets.only(top: widget.topPadding),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: widget.headerBuilder(context, expandedProgress),
                ),
              ),
            ),
          ),
          if (showStories)
            Positioned(
              key: ValueKey('story-state-${_state.name}'),
              top: widget.topPadding + storiesTop,
              left: 0,
              right: storiesRightInset,
              height: StoryBarWidget.expandedHeight,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  SingleChildScrollView(
                    key: const ValueKey('story-list-viewport'),
                    controller: _storiesScrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: _storyPadding,
                    ),
                    scrollDirection: Axis.horizontal,
                    clipBehavior: Clip.none,
                    physics: horizontalScrollEnabled
                        ? const BouncingScrollPhysics()
                        : const NeverScrollableScrollPhysics(),
                    child: SizedBox(
                      width: contentWidth,
                      height: StoryBarWidget.expandedHeight,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: _buildStoryItems(
                          context,
                          geometries: geometries,
                          exclusions: exclusions,
                          opacity: listAlpha,
                          labelAlpha: labelAlpha,
                          keyPrefix: 'story',
                          includeHero: true,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: _storyPadding,
                    width: contentWidth,
                    height: StoryBarWidget.expandedHeight,
                    child: IgnorePointer(
                      ignoring: promotedAlpha <= 0.001,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: _buildStoryItems(
                          context,
                          geometries: promotedGeometries,
                          exclusions: promotedExclusions,
                          opacity: promotedAlpha,
                          labelAlpha: labelAlpha,
                          keyPrefix: 'collapsed-story',
                          includeHero: false,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _buildStoryItems(
    BuildContext context, {
    required List<_StoryGeometry> geometries,
    required List<List<StoryRingArcExclusion>> exclusions,
    required double opacity,
    required double labelAlpha,
    required String keyPrefix,
    required bool includeHero,
  }) {
    return List.generate(geometries.length, (drawIndex) {
      final index = geometries.length - 1 - drawIndex;
      final geometry = geometries[index];
      final isSkeleton = widget.isLoading;
      final story = widget.list.isNotEmpty
          ? widget.list[index % widget.list.length]
          : const StoryModel(
              id: 'skeleton',
              name: 'Story',
              imageUrl: '',
              thumbnailUrl: '',
            );
      final text = story.isBirthday && story.name.trim().isEmpty
          ? context.l10n.birthdayStoryLabel
          : story.name;

      return Positioned(
        left: geometry.left,
        top: geometry.top,
        child: Opacity(
          key: ValueKey('$keyPrefix-item-$index'),
          opacity: opacity,
          child: IgnorePointer(
            ignoring: opacity <= 0.001,
            child: SizedBox(
              width: geometry.paintSize,
              height: geometry.paintSize + 25,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  GestureDetector(
                    key: ValueKey('$keyPrefix-avatar-$index'),
                    behavior: HitTestBehavior.opaque,
                    onTap: () => _onAvatarTap(index, isSkeleton),
                    child: _StoryAvatar(
                      key: ValueKey('$keyPrefix-avatar-image-$index'),
                      avatarSize: geometry.avatarSize,
                      story: story,
                      isLoading: isSkeleton,
                      isViewed: _isStoryViewedBorder(story),
                      collapsedProgress: geometry.cellProgress,
                      collapseFactor: _collapseFactor,
                      exclusions: exclusions[index],
                      heroTag: includeHero ? 'story_${story.id}_$index' : null,
                    ),
                  ),
                  Positioned(
                    top: geometry.paintSize + 7 * (1 - geometry.cellProgress),
                    left: (geometry.paintSize - 52) / 2,
                    width: 52,
                    child: Opacity(
                      opacity: labelAlpha,
                      child: Align(
                        key: ValueKey('$keyPrefix-label-$index'),
                        alignment: Alignment.topCenter,
                        heightFactor: labelAlpha,
                        child: Skeletonizer(
                          enabled: isSkeleton,
                          child: Text(
                            text,
                            style: context.textTheme.bodySmallMedium.copyWith(
                              fontSize: 10,
                              color: context.appColors.text,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  void _onAvatarTap(int index, bool isSkeleton) {
    if (_state != _StoryHeaderState.expanded || _rawCollapseProgress > 0.001) {
      widget.scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 350),
        curve: _easeOutQuint,
      );
      return;
    }
    if (isSkeleton || widget.list.isEmpty) return;
    Navigator.of(context).push(
      PageRouteBuilder<void>(
        opaque: false,
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, animation, secondaryAnimation) => StoryScreen(
          categories: widget.list,
          initialIndex: index % widget.list.length,
          onView: _onStoryViewed,
        ),
      ),
    );
  }

  List<_StoryGeometry> _buildGeometries(int count, double progress) {
    return List.generate(count, (index) {
      final cellProgress = switch (index) {
        0 => math.pow(progress, 0.25).toDouble(),
        1 => math.pow(progress, 0.5).toDouble(),
        _ => progress,
      };
      final avatarSize = _lerp(
        StoryBarWidget.expandedAvatarSize,
        StoryBarWidget.collapsedAvatarSize,
        cellProgress,
      );
      final cellLeft = index * StoryBarWidget.expandedStoryStep;
      final expandedLocalX =
          StoryBarWidget.expandedStoryStep / 2 - avatarSize / 2;
      final localX = _lerp(expandedLocalX, 0, cellProgress);
      final targetX = switch (index) {
        0 => 0.0,
        1 =>
          StoryBarWidget.collapsedStoryStep * cellProgress -
              0.5 +
              StoryBarWidget.collapsedStoryStep * (1 - progress),
        _ =>
          StoryBarWidget.collapsedStoryStep +
              StoryBarWidget.collapsedStoryStep * cellProgress -
              0.5 +
              StoryBarWidget.collapsedStoryStep * 2 * (1 - progress),
      };
      final translationX = (targetX - cellLeft) * _xMotion;
      final collapsedY =
          (StoryBarWidget.collapsedHeight -
              StoryBarWidget.collapsedAvatarSize) /
          2;
      final localY =
          _lerp(5, collapsedY, cellProgress) + _telegramWaveY(index, progress);

      return _StoryGeometry(
        left: cellLeft + translationX + localX - _ringInset,
        top: localY - _ringInset,
        avatarSize: avatarSize,
        cellProgress: cellProgress,
      );
    });
  }

  double _telegramWaveY(int index, double progress) {
    if (index > 1) return 0;
    final collapsedFactor = ((_rawCollapseProgress - 0.2) / 0.1).clamp(
      0.0,
      1.0,
    );
    final maxY =
        StoryBarWidget.expandedStoriesTop -
        (StoryBarWidget.collapsedHeight - StoryBarWidget.collapsedAvatarSize) /
            2;
    final delta = -maxY * (1 - _rawCollapseProgress);
    final multiplier = index == 0 ? 1.0 : 0.65;
    final y1 = delta * multiplier * _easeOutQuint.transform(progress);
    final y2 = delta * multiplier * _yStoriesProgress;
    return _lerp(y2, y1, collapsedFactor);
  }

  List<List<StoryRingArcExclusion>> _buildRingExclusions(
    List<_StoryGeometry> geometries,
  ) {
    final result = List.generate(
      geometries.length,
      (_) => <StoryRingArcExclusion>[],
    );
    for (var index = 1; index < geometries.length; index++) {
      final previous = geometries[index - 1];
      final current = geometries[index];
      final dx = current.center.dx - previous.center.dx;
      final dy = current.center.dy - previous.center.dy;
      final distance = math.sqrt(dx * dx + dy * dy);
      final radiusSum = previous.ringRadius + current.ringRadius;
      if (distance <= 0 || distance >= radiusSum) continue;

      final halfSweep = math.acos((distance / radiusSum).clamp(-1.0, 1.0));
      result[index - 1].add(
        StoryRingArcExclusion(
          centerAngle: math.atan2(dy, dx),
          halfSweep: halfSweep,
        ),
      );
      result[index].add(
        StoryRingArcExclusion(
          centerAngle: math.atan2(-dy, -dx),
          halfSweep: halfSweep,
        ),
      );
    }
    return result;
  }

  double _smoothStep(double value) => value * value * (3 - 2 * value);

  double _lerp(double from, double to, double progress) =>
      from + (to - from) * progress;
}

class _StoryGeometry {
  const _StoryGeometry({
    required this.left,
    required this.top,
    required this.avatarSize,
    required this.cellProgress,
  });

  final double left;
  final double top;
  final double avatarSize;
  final double cellProgress;

  double get paintSize => avatarSize + StoryAvatarRingPainter.ringInset * 2;
  double get ringRadius => avatarSize / 2 + StoryAvatarRingPainter.ringInset;
  Offset get center => Offset(left + paintSize / 2, top + paintSize / 2);
}

class _StoryAvatar extends StatelessWidget {
  const _StoryAvatar({
    super.key,
    required this.avatarSize,
    required this.story,
    required this.isLoading,
    required this.isViewed,
    required this.collapsedProgress,
    required this.collapseFactor,
    required this.exclusions,
    this.heroTag,
  });

  final double avatarSize;
  final StoryModel story;
  final bool isLoading;
  final bool isViewed;
  final double collapsedProgress;
  final double collapseFactor;
  final List<StoryRingArcExclusion> exclusions;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    final image = Padding(
      padding: const EdgeInsets.all(StoryAvatarRingPainter.ringInset),
      child: ClipOval(
        child: SizedBox(
          width: avatarSize,
          height: avatarSize,
          child: Skeletonizer(
            enabled: isLoading,
            child: story.thumbnailUrl.trim().isEmpty
                ? const _StoryThumbnailSkeleton()
                : AppCachedNetworkImage(
                    imageUrl: story.thumbnailUrl.trim(),
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const _StoryThumbnailSkeleton(),
                    errorWidget: (context, url, error) =>
                        const _StoryThumbnailSkeleton(),
                  ),
          ),
        ),
      ),
    );

    return CustomPaint(
      painter: StoryAvatarRingPainter(
        ringColor: isViewed ? AppColors.secondaryGrey : AppColors.primary,
        separatorColor: context.appColors.background,
        avatarSize: avatarSize,
        collapsedProgress: collapsedProgress,
        collapseFactor: collapseFactor,
        exclusions: exclusions,
      ),
      child: heroTag == null ? image : Hero(tag: heroTag!, child: image),
    );
  }
}

class _StoryThumbnailSkeleton extends StatelessWidget {
  const _StoryThumbnailSkeleton();

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ColoredBox(color: context.appColors.onContainer),
    );
  }
}

class _TelegramOvershootCurve extends Curve {
  const _TelegramOvershootCurve(this.tension);

  final double tension;

  @override
  double transformInternal(double t) {
    final shifted = t - 1;
    return shifted * shifted * ((tension + 1) * shifted + tension) + 1;
  }
}
