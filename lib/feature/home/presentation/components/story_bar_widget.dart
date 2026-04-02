import 'dart:async';

import 'package:flutter/services.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/category_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/repository/home_repository.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/screens/story_screen.dart';

class StoryBarWidget extends StatefulWidget {
  const StoryBarWidget({
    super.key,
    required this.scrollController,
    required this.isLoading,
    required this.list,
    this.appBar,
    this.onNotificationTap,
  });

  final ScrollController scrollController;
  final bool isLoading;
  final List<StoryModel> list;
  final Widget? appBar;
  final VoidCallback? onNotificationTap;

  @override
  State<StoryBarWidget> createState() => _StoryBarWidgetState();
}

class _StoryBarWidgetState extends State<StoryBarWidget> {
  double _progress = 1.0;
  final double _expandedHeight = 150;
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
    final offset = widget.scrollController.offset;
    final value = 1 - (offset / (_expandedHeight - kToolbarHeight * 1.8));
    final nextProgress = value.clamp(0.0, 1.0);
    final isCollapsed = nextProgress < 0.5;

    if (isCollapsed != _wasCollapsed) {
      _wasCollapsed = isCollapsed;
      HapticFeedback.lightImpact();
    }

    setState(() {
      _progress = nextProgress;
    });
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
    final effectiveProgress = showStories ? _progress : 1.0;

    final double avatarOuterSize = 36 + (24 * effectiveProgress);
    final double avatarInnerSize = avatarOuterSize - 2;
    final double textWidth = 36 + (16 * effectiveProgress);
    final double textFontSize = 8 + (2 * effectiveProgress);

    return SliverAppBar(
      backgroundColor: context.appColors.background,
      title: Stack(
        alignment: Alignment.centerRight,
        children: [
          IgnorePointer(
            ignoring: effectiveProgress < 0.95,
            child: Opacity(
              opacity: effectiveProgress,
              child: widget.appBar ??
                  const Text(
                    'Qizlar akademiyasi',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
            ),
          ),
          if (widget.onNotificationTap != null)
            Opacity(
              opacity: 1 - effectiveProgress,
              child: IgnorePointer(
                ignoring: (1 - effectiveProgress) <= 0.01,
                child: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Bounce(
                    tilt: false,
                    onTap: () {
                      Gaimon.selection();
                      widget.onNotificationTap!();
                    },
                    child: Stack(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: context.appColors.onContainer,
                            boxShadow: [
                              BoxShadow(
                                color: context.appColors.shadow.withValues(
                                  alpha: 0.005,
                                ),
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                              ),
                            ],
                            border: Border.all(color: context.appColors.stroke),
                          ),
                          child: Icon(
                            LucideIcons.bell,
                            size: 22,
                            color: context.appColors.text,
                          ),
                        ),
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      centerTitle: false,
      pinned: true,
      expandedHeight: showStories ? _expandedHeight : (kToolbarHeight + 8),
      flexibleSpace: SafeArea(
        child: Align(
          alignment: AlignmentDirectional.bottomStart,
          child: showStories
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    scrollDirection: Axis.horizontal,
                    child: Builder(
                      builder: (context) {
                        final int itemLength = widget.isLoading
                            ? 6
                            : widget.list.length;

                        double getX(int index, double p) {
                          double x = 0;
                          for (int j = 0; j < index; j++) {
                            if (j < 2) {
                              x +=
                                  22 +
                                  48 *
                                      p; // From 22 (collapsed) to 70 (expanded)
                            } else {
                              x +=
                                  70 * p; // From 0 (collapsed) to 70 (expanded)
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
                          height: 85, // Fixed height to prevent jumps
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: List.generate(itemLength, (i) {
                              // Render in reverse so index 0 is on top
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

                              // Items >= 3 should fade out as they collapse
                              double opacity = 1.0;
                              double scale = 1.0;
                              if (index >= 3) {
                                opacity = effectiveProgress;
                                scale = 0.5 + 0.5 * effectiveProgress;
                              }

                              if (opacity <= 0.01) {
                                return const SizedBox.shrink();
                              }

                              return Positioned(
                                left: x,
                                top: 8,
                                child: Opacity(
                                  opacity: opacity,
                                  child: Transform.scale(
                                    scale: scale,
                                    alignment: Alignment
                                        .centerLeft, // Shrink towards left
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      // spacing property in Column might cause issues if not supported in all flutter versions, but since user used it, we keep it or use SizedBox. User used `spacing: 2`
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
                                                curve: Curves.easeInOut,
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
                                                        return FadeTransition(
                                                          opacity: animation,
                                                          child: StoryScreen(
                                                            categories:
                                                                widget.list,
                                                            initialIndex:
                                                                index %
                                                                widget
                                                                    .list
                                                                    .length,
                                                            onView:
                                                                _onStoryViewed,
                                                          ),
                                                        );
                                                      },
                                                ),
                                              );
                                            }
                                          },
                                          child: Container(
                                            height: avatarOuterSize,
                                            width: avatarOuterSize,
                                            padding: const EdgeInsets.all(2),
                                            clipBehavior: Clip.antiAlias,
                                            decoration: BoxDecoration(
                                              color:
                                                  context.appColors.background,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color:
                                                    _isStoryViewedBorder(story)
                                                    ? AppColors.secondaryGrey
                                                    : AppColors.primary,
                                                width: 1.5,
                                              ),
                                            ),
                                            child: Container(
                                              height: avatarInnerSize,
                                              width: avatarInnerSize,
                                              clipBehavior: Clip.antiAlias,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                              ),
                                              child: Skeletonizer(
                                                enabled: isSkeleton,
                                                child: Hero(
                                                  tag:
                                                      'story_${story.id}_$index',
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          50,
                                                        ),
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
                                                            placeholder:
                                                                (
                                                                  context,
                                                                  url,
                                                                ) =>
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
                                        ),
                                        if (effectiveProgress >= 0.5)
                                          SizedBox(
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
                                                      color: context
                                                          .appColors
                                                          .text,
                                                    ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        );
                      },
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
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
