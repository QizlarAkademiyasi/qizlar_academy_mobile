import 'dart:async';

import 'package:flutter/services.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/category_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/repository/home_repository.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/screens/story/story_screen.dart';

class StoryBarWidget extends StatefulWidget {
  const StoryBarWidget({
    super.key,
    required this.scrollController,
    required this.isLoading,
    required this.list,
    required this.headerBuilder,
  });

  final ScrollController scrollController;
  final bool isLoading;
  final List<StoryModel> list;
  final Widget Function(BuildContext context, double expandedProgress)
  headerBuilder;

  static const double expandedHeight = 162;
  static const double collapsedHeight = kToolbarHeight + 8;
  static const double emptyHeight = collapsedHeight;
  static const double expandedStoriesTop = 70;
  static const double collapsedStoriesTop = 6;
  static const double collapseExtent = expandedHeight - collapsedHeight;

  static double layoutExtent({
    required bool isLoading,
    required List<StoryModel> stories,
  }) {
    return isLoading || stories.isNotEmpty ? expandedHeight : emptyHeight;
  }

  @override
  State<StoryBarWidget> createState() => _StoryBarWidgetState();
}

class _StoryBarWidgetState extends State<StoryBarWidget> {
  double _progress = 1.0;
  bool _wasCollapsed = false;
  final Set<String> _viewedIds = {};

  void _onStoryViewed(String storyId) {
    setState(() => _viewedIds.add(storyId));
    unawaited(getIt<HomeRepository>().postStoryView(storyId));
  }

  bool _isStoryViewedBorder(StoryModel story) =>
      story.isViewed || _viewedIds.contains(story.id);

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_updateProgress);
  }

  void _updateProgress() {
    if (!widget.scrollController.hasClients) return;
    final offset = widget.scrollController.offset;
    final value = 1 - (offset / StoryBarWidget.collapseExtent);
    final nextProgress = value.clamp(0.0, 1.0);
    final isCollapsed = nextProgress < 0.5;

    if (isCollapsed != _wasCollapsed) {
      _wasCollapsed = isCollapsed;
      HapticFeedback.lightImpact();
    }

    if ((_progress - nextProgress).abs() > 0.001 && mounted) {
      setState(() => _progress = nextProgress);
    }
  }

  @override
  void didUpdateWidget(covariant StoryBarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scrollController == widget.scrollController) return;
    oldWidget.scrollController.removeListener(_updateProgress);
    widget.scrollController.addListener(_updateProgress);
    _updateProgress();
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_updateProgress);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasStories = widget.list.isNotEmpty;
    final showStories = widget.isLoading || hasStories;
    final rawProgress = showStories ? _progress : 1.0;
    final effectiveProgress = _smoothStep(rawProgress);

    final double avatarOuterSize = 36 + (24 * effectiveProgress);
    final double textWidth = 36 + (16 * effectiveProgress);
    final double textFontSize = 8 + (2 * effectiveProgress);
    final headerHeight = showStories
        ? StoryBarWidget.collapsedHeight +
              StoryBarWidget.collapseExtent * rawProgress
        : StoryBarWidget.emptyHeight;
    final storiesTop =
        StoryBarWidget.collapsedStoriesTop +
        (StoryBarWidget.expandedStoriesTop -
                StoryBarWidget.collapsedStoriesTop) *
            effectiveProgress;

    return SizedBox(
      height: headerHeight,
      child: AppBlurredHeaderSurface(
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: widget.headerBuilder(context, effectiveProgress),
            ),
            if (showStories)
              Positioned(
                top: storiesTop,
                left: 0,
                right: 120,
                height: 85,
                child: SingleChildScrollView(
                  key: const ValueKey('story-list-viewport'),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  scrollDirection: Axis.horizontal,
                  physics: effectiveProgress < 0.95
                      ? const NeverScrollableScrollPhysics()
                      : const BouncingScrollPhysics(),
                  child: Builder(
                    builder: (context) {
                      final int itemLength = widget.isLoading
                          ? 6
                          : widget.list.length;

                      double getX(int index, double p) {
                        double x = 0;
                        for (int j = 0; j < index; j++) {
                          if (j < 2) {
                            x += 22 + 48 * p;
                          } else {
                            x += 70 * p;
                          }
                        }
                        return x;
                      }

                      double totalWidth = 0;
                      if (itemLength > 0) {
                        totalWidth =
                            getX(itemLength - 1, effectiveProgress) +
                            avatarOuterSize;
                      }

                      return SizedBox(
                        width: totalWidth,
                        height: 85,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            ...List.generate(itemLength, (i) {
                              final index = itemLength - 1 - i;
                              final isSkeleton = widget.isLoading;
                              final story = widget.list.isNotEmpty
                                  ? widget.list[index % widget.list.length]
                                  : const StoryModel(
                                      id: 'skeleton',
                                      name: 'Story',
                                      imageUrl: '',
                                      thumbnailUrl: '',
                                    );

                              final double x = getX(index, effectiveProgress);

                              return Positioned(
                                left: x,
                                top: 8,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  spacing: 2,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        if (effectiveProgress < 0.95) {
                                          widget.scrollController.animateTo(
                                            0,
                                            duration: const Duration(
                                              milliseconds: 300,
                                            ),
                                            curve: Curves.easeOutCubic,
                                          );
                                        } else {
                                          if (isSkeleton) return;
                                          setState(
                                            () => _viewedIds.add(story.id),
                                          );
                                          Navigator.of(context).push(
                                            PageRouteBuilder(
                                              opaque: false,
                                              transitionDuration:
                                                  const Duration(
                                                    milliseconds: 300,
                                                  ),
                                              reverseTransitionDuration:
                                                  const Duration(
                                                    milliseconds: 300,
                                                  ),
                                              pageBuilder:
                                                  (
                                                    context,
                                                    animation,
                                                    secondaryAnimation,
                                                  ) {
                                                    return StoryScreen(
                                                      categories: widget.list,
                                                      initialIndex:
                                                          index %
                                                          widget.list.length,
                                                      onView: _onStoryViewed,
                                                    );
                                                  },
                                            ),
                                          );
                                        }
                                      },
                                      child: Container(
                                        height: avatarOuterSize,
                                        width: avatarOuterSize,
                                        clipBehavior: Clip.antiAlias,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                        foregroundDecoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: _isStoryViewedBorder(story)
                                                ? AppColors.secondaryGrey
                                                : AppColors.primary,
                                            width: 1.5,
                                          ),
                                        ),
                                        child: Skeletonizer(
                                          enabled: isSkeleton,
                                          child: Hero(
                                            tag: 'story_${story.id}_$index',
                                            child: ClipOval(
                                              child:
                                                  story.thumbnailUrl
                                                      .trim()
                                                      .isEmpty
                                                  ? const _StoryThumbnailSkeleton()
                                                  : AppCachedNetworkImage(
                                                      imageUrl: story
                                                          .thumbnailUrl
                                                          .trim(),
                                                      fit: BoxFit.cover,
                                                      placeholder: (context, url) =>
                                                          const _StoryThumbnailSkeleton(),
                                                      errorWidget:
                                                          (
                                                            context,
                                                            url,
                                                            error,
                                                          ) =>
                                                              const _StoryThumbnailSkeleton(),
                                                    ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    ClipRect(
                                      child: Align(
                                        alignment: Alignment.topCenter,
                                        heightFactor: effectiveProgress,
                                        child: SizedBox(
                                          width: textWidth,
                                          child: Skeletonizer(
                                            enabled: isSkeleton,
                                            child: Text(
                                              story.name,
                                              style: context
                                                  .textTheme
                                                  .bodySmallMedium
                                                  .copyWith(
                                                    fontSize: textFontSize,
                                                    color:
                                                        context.appColors.text,
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
                              );
                            }),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  double _smoothStep(double value) => value * value * (3 - 2 * value);
}

class _StoryThumbnailSkeleton extends StatelessWidget {
  const _StoryThumbnailSkeleton();

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Container(
        decoration: BoxDecoration(
          color: context.appColors.onContainer,
          shape: BoxShape.circle,
        ),
        child: const SizedBox.expand(),
      ),
    );
  }
}
