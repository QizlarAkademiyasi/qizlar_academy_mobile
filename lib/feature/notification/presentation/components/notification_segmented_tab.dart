import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

class NotificationSegmentedTab extends StatefulWidget {
  const NotificationSegmentedTab({
    super.key,
    required this.controller,
    required this.tabLabels,
    this.onTap,
  });

  final TabController controller;
  final List<String> tabLabels;
  final ValueChanged<int>? onTap;

  @override
  State<NotificationSegmentedTab> createState() =>
      _NotificationSegmentedTabState();
}

class _NotificationSegmentedTabState extends State<NotificationSegmentedTab> {
  late int _activeIndex;

  @override
  void initState() {
    super.initState();
    _activeIndex = widget.controller.index;
    widget.controller.addListener(_handleControllerChanged);
  }

  @override
  void didUpdateWidget(covariant NotificationSegmentedTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_handleControllerChanged);
      _activeIndex = widget.controller.index;
      widget.controller.addListener(_handleControllerChanged);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleControllerChanged);
    super.dispose();
  }

  void _handleControllerChanged() {
    final next = widget.controller.index;
    if (next == _activeIndex) return;
    setState(() => _activeIndex = next);
  }

  void _onSegmentTap(int index) {
    if (index == _activeIndex) return;
    Gaimon.light();
    setState(() => _activeIndex = index);
    widget.onTap?.call(index);
    widget.controller.animateTo(index);
  }

  @override
  Widget build(BuildContext context) {
    final tabCount = widget.tabLabels.length;
    return SizedBox(
      height: 40,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.appColors.onContainer,
          borderRadius: AppRadius.radiusXl,
          border: Border.all(color: context.appColors.stroke),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final tabWidth = constraints.maxWidth / tabCount;
            final maxX = constraints.maxWidth - tabWidth;
            return Stack(
              children: [
                AnimatedBuilder(
                  animation: widget.controller.animation!,
                  builder: (context, child) {
                    final progress = tabCount <= 1
                        ? 0.0
                        : (widget.controller.animation!.value / (tabCount - 1))
                              .clamp(0.0, 1.0);
                    return Transform.translate(
                      offset: Offset(maxX * progress, 0),
                      child: child,
                    );
                  },
                  child: SizedBox(
                    width: tabWidth,
                    height: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(3),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: AppRadius.radiusLg,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    for (var i = 0; i < tabCount; i++)
                      Expanded(
                        child: Semantics(
                          button: true,
                          selected: i == _activeIndex,
                          label: widget.tabLabels[i],
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              key: ValueKey('notification-tab-$i'),
                              onTap: () => _onSegmentTap(i),
                              borderRadius: AppRadius.radiusXl,
                              splashFactory: NoSplash.splashFactory,
                              overlayColor: WidgetStateProperty.all(
                                Colors.transparent,
                              ),
                              child: Center(
                                child: Text(
                                  widget.tabLabels[i],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      (i == _activeIndex
                                              ? context
                                                    .textTheme
                                                    .bodySmallBold
                                              : context
                                                    .textTheme
                                                    .bodySmallMedium)
                                          .copyWith(
                                            color: i == _activeIndex
                                                ? AppColors.white
                                                : context.appColors.grey,
                                          ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
