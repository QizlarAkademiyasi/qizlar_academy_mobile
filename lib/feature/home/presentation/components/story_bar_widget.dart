import 'package:flutter/services.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/category_model.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/screens/story_screen.dart';

class StoryBarWidget extends StatefulWidget {
  const StoryBarWidget({
    super.key,
    required this.scrollController,
    required this.isLoading,
    required this.list,
    this.appBar,
  });

  final ScrollController scrollController;
  final bool isLoading;
  final List<StoryModel> list;
  final Widget? appBar;

  @override
  State<StoryBarWidget> createState() => _StoryBarWidgetState();
}

class _StoryBarWidgetState extends State<StoryBarWidget> {
  double _progress = 1.0;
  final double _expandedHeight = 150;
  bool _wasCollapsed = false;
  final Set<String> _viewedIds = {};

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
    final int itemCount = (widget.isLoading || widget.list.isEmpty)
        ? 6
        : (_progress < 0.5 ? 3 : widget.list.length);

    final double spacing = 10 * _progress + (-14) * (1 - _progress);
    final double avatarOuterSize = 36 + (24 * _progress);
    final double avatarInnerSize = avatarOuterSize - 2;
    final double textWidth = 36 + (16 * _progress);
    final double textFontSize = 12 + (2 * _progress);

    return SliverAppBar(
      backgroundColor: context.appColors.background,
      title: Opacity(
        opacity: _progress,
        child:
            widget.appBar ??
            const Text(
              'Qizlar akademiyasi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
      ),
      centerTitle: false,
      pinned: true,
      expandedHeight: _expandedHeight,
      flexibleSpace: SafeArea(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: spacing,
                children: List.generate(itemCount, (index) {
                  final isSkeleton = widget.isLoading || widget.list.isEmpty;
                  final story = widget.list.isNotEmpty
                      ? widget.list[index % widget.list.length]
                      : const StoryModel(
                          id: '',
                          name: 'Kategoriya',
                          imageUrl: '',
                          thumbnailUrl: '',
                        );

                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 2,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (_progress < 0.5) {
                              widget.scrollController.animateTo(
                                0,
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeInOut,
                              );
                            } else {
                              if (isSkeleton) return;
                              setState(() => _viewedIds.add(story.id));
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  opaque: false,
                                  transitionDuration: const Duration(
                                    milliseconds: 300,
                                  ),
                                  reverseTransitionDuration: const Duration(
                                    milliseconds: 300,
                                  ),
                                  pageBuilder:
                                      (context, animation, secondaryAnimation) {
                                        return FadeTransition(
                                          opacity: animation,
                                          child: StoryScreen(
                                            categories: widget.list,
                                            initialIndex:
                                                index % widget.list.length,
                                            onView: (id) {
                                              setState(
                                                () => _viewedIds.add(id),
                                              );
                                            },
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
                              color: context.appColors.background,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _viewedIds.contains(story.id)
                                    ? AppColors.secondaryGrey
                                    : AppColors.primary,
                                width: 1.5,
                              ),
                            ),
                            child: Container(
                              height: avatarInnerSize,
                              width: avatarInnerSize,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                // border: Border.all(color: AppColors.white),
                              ),
                              child: Skeletonizer(
                                enabled: isSkeleton,
                                child: Hero(
                                  tag: 'story_${story.id}_$index',
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: CachedNetworkImage(
                                      imageUrl: story.thumbnailUrl,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (_progress >= 0.5)
                          SizedBox(
                            width: textWidth,
                            child: Skeletonizer(
                              enabled: isSkeleton,
                              child: Text(
                                story.name,
                                style: context.textTheme.bodySmallMedium
                                    .copyWith(
                                      fontSize: textFontSize,
                                      color: context.appColors.text,
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
