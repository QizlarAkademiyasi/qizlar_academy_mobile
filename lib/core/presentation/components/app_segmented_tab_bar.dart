import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

/// Global segmentli tab bar — pill ko‘rinishida, primary indikator.
/// Leaderboard, filtrlarda va boshqa ekranlarda qayta ishlatish uchun.
class AppSegmentedTabBar extends StatefulWidget {
  const AppSegmentedTabBar({
    super.key,
    required this.controller,
    required this.tabLabels,
    this.onTap,
    this.animate = true,
  }) : assert(tabLabels.length > 0, 'tabLabels must not be empty');

  final TabController controller;
  final List<String> tabLabels;
  final ValueChanged<int>? onTap;
  final bool animate;

  @override
  State<AppSegmentedTabBar> createState() => _AppSegmentedTabBarState();
}

class _AppSegmentedTabBarState extends State<AppSegmentedTabBar> {
  late int _activeIndex;

  @override
  void initState() {
    super.initState();
    _activeIndex = widget.controller.index;
    widget.controller.addListener(_handleControllerChanged);
  }

  @override
  void didUpdateWidget(covariant AppSegmentedTabBar oldWidget) {
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
    // Swipe tugaganda ham, tap/animateTo bo‘lganda ham index yangilanadi.
    final next = widget.controller.index;
    if (next == _activeIndex) return;
    setState(() => _activeIndex = next);
  }

  void _onSegmentTap(int index) {
    if (index == _activeIndex) return;
    Gaimon.light();
    // TabController index'i (animateTo paytida) ba'zan kechroq yangilanadi,
    // shuning uchun indikator "kutib" qolmasligi uchun darhol local state'ni yangilaymiz.
    setState(() => _activeIndex = index);
    widget.onTap?.call(index);
    if (widget.animate) {
      widget.controller.animateTo(index);
    } else {
      widget.controller.index = index;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tabCount = widget.tabLabels.length;

    return AppTabletMaxWidth(
      child: Container(
        height: 56,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: context.appColors.onContainer,
          borderRadius: AppRadius.radius5xl,
          border: Border.all(color: context.appColors.stroke),
          boxShadow: [
            BoxShadow(
              color: context.appColors.shadow.withValues(alpha: 0.05),
              blurRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
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
                    final position = widget.animate
                        ? widget.controller.animation!.value
                        : _activeIndex.toDouble();
                    final progress = tabCount <= 1
                        ? 0.0
                        : (position / (tabCount - 1)).clamp(0.0, 1.0);
                    return Transform.translate(
                      offset: Offset(maxX * progress, 0),
                      child: child,
                    );
                  },
                  child: SizedBox(
                    width: tabWidth,
                    height: double.infinity,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: AppRadius.radius5xl,
                        color: AppColors.primary,
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
                              onTap: () => _onSegmentTap(i),
                              borderRadius: AppRadius.radius5xl,
                              splashFactory: NoSplash.splashFactory,
                              overlayColor: WidgetStateProperty.all(
                                Colors.transparent,
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: Text(
                                    widget.tabLabels[i],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        (i == _activeIndex
                                                ? context
                                                      .textTheme
                                                      .bodyMediumSemibold
                                                : context
                                                      .textTheme
                                                      .bodyMediumRegular)
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
