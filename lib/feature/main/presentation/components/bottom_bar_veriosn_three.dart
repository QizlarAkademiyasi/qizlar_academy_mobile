import 'dart:math' as math;

import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/theme_extension.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/feature/main/presentation/components/main_bottom_nav_kit_icons.dart';
import 'package:qizlar_academy_mobile/feature/main/presentation/components/main_more_menu_items.dart';

class GlassBottomNavigationVersionThree extends StatefulWidget {
  const GlassBottomNavigationVersionThree({super.key, required this.currentIndex, required this.onTap, this.onPlusTap, this.onMorePanelItemSelected});

  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback? onPlusTap;
  final ValueChanged<int>? onMorePanelItemSelected;

  @override
  State<GlassBottomNavigationVersionThree> createState() => _GlassBottomNavigationVersionThreeState();
}

class _GlassBottomNavigationVersionThreeState extends State<GlassBottomNavigationVersionThree> {
  static const Duration _animationDuration = Duration(milliseconds: 280);
  bool _isExpanded = false;
  bool _syncedInitialExpanded = false;

  /// «More» doim oxirgi tab — [_bottomTabs] uzunligi o‘zgarsa ham mos keladi.
  int _moreTabIndex() => _bottomTabs(context).length - 1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_syncedInitialExpanded) {
      return;
    }
    _syncedInitialExpanded = true;
    _isExpanded = widget.currentIndex == _moreTabIndex();
  }

  @override
  void didUpdateWidget(covariant GlassBottomNavigationVersionThree oldWidget) {
    super.didUpdateWidget(oldWidget);
    final more = _moreTabIndex();
    final leftMoreTab = oldWidget.currentIndex == more && widget.currentIndex != more;
    if (leftMoreTab && _isExpanded) {
      setState(() => _isExpanded = false);
    }
  }

  void _handleTabTap(int index) {
    if (index == _moreTabIndex()) {
      // Har doim toggle: boshqa tabdagi bo‘lsa ham yopish/ochish ishlaydi.
      setState(() => _isExpanded = !_isExpanded);
      return;
    }

    if (_isExpanded) {
      setState(() => _isExpanded = false);
    }
    if (widget.currentIndex != index) {
      widget.onTap(index);
    }
  }

  void _onMorePanelItemTapped(int itemIndex) {
    setState(() => _isExpanded = false);
    widget.onMorePanelItemSelected?.call(itemIndex);
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final isDark = context.isDarkTheme;
    final tabs = _bottomTabs(context);

    return SafeArea(
      top: false,
      bottom: false,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
          child: LiquidGlassLayer(
            settings: LiquidGlassSettings(
              refractiveIndex: 1.18,
              thickness: 14,
              blur: 8,
              saturation: 1,
              lightIntensity: isDark ? .45 : .95,
              ambientStrength: isDark ? .2 : .42,
              lightAngle: math.pi / 3,
              glassColor: appColors.bottomBarGlass,
            ),
            child: LiquidGlassBlendGroup(
              blend: 0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: _ResizableGlassContainer(currentIndex: widget.currentIndex, isExpanded: _isExpanded, tabs: tabs, onTabTap: _handleTabTap, onMorePanelItemSelected: _onMorePanelItemTapped),
                  ),
                  const SizedBox(width: 12),
                  _GlassPlusActionButton(onTap: widget.onPlusTap),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// «More» grid bilan bir xil o‘lchamlar — balandlik hisobi va [_MorePanelGrid] sinxron bo‘lsin.
class _MorePanelGridLayout {
  _MorePanelGridLayout._();

  static const int crossAxisCount = 4;
  static const double crossAxisSpacing = 12;
  static const double mainAxisSpacing = 0;
  static const double childAspectRatio = 1;
  static const EdgeInsets padding = EdgeInsets.fromLTRB(5, 14, 5, 20);

  static int rowCountForItemCount(int itemCount) {
    if (itemCount <= 0) {
      return 0;
    }
    return (itemCount + crossAxisCount - 1) ~/ crossAxisCount;
  }

  /// [maxWidth] — grid uchun mavjud kenglik (ichki konteyner kengligi).
  static double panelHeightForWidth(double maxWidth, int itemCount) {
    final rows = rowCountForItemCount(itemCount);
    if (rows == 0) {
      return padding.vertical;
    }
    final crossAxisExtent = math.max(0.0, maxWidth - padding.horizontal);
    final usableCrossAxis = math.max(0.0, crossAxisExtent - crossAxisSpacing * (crossAxisCount - 1));
    final childCrossAxisExtent = usableCrossAxis / crossAxisCount;
    final childMainAxisExtent = childCrossAxisExtent / childAspectRatio;
    return padding.vertical + rows * childMainAxisExtent + math.max(0, rows - 1) * mainAxisSpacing;
  }
}

class _ResizableGlassContainer extends StatelessWidget {
  const _ResizableGlassContainer({required this.currentIndex, required this.isExpanded, required this.tabs, required this.onTabTap, required this.onMorePanelItemSelected});

  final int currentIndex;
  final bool isExpanded;
  final List<_GlassBottomTabData> tabs;
  final ValueChanged<int> onTabTap;
  final ValueChanged<int> onMorePanelItemSelected;

  static const EdgeInsets _barContentPadding = EdgeInsets.fromLTRB(8, 2, 8, 2);
  static const double _expandedPanelToTabGap = 8;
  static const double _tabStripHeight = 70;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemCount = kMainMoreMenuItems.length;
        final gridViewportWidth = math.max(0.0, constraints.maxWidth - _barContentPadding.horizontal);
        final expandedPanelHeight = _MorePanelGridLayout.panelHeightForWidth(gridViewportWidth, itemCount);
        final expandedTotalHeight = _barContentPadding.vertical + expandedPanelHeight + _expandedPanelToTabGap + _tabStripHeight;
        // AnimatedContainer tashqarida: LiquidGlass layout balandlik o‘zgarishini barqaror qabul qiladi.
        return AnimatedContainer(
          duration: _GlassBottomNavigationVersionThreeState._animationDuration,
          curve: Curves.easeOutCubic,
          height: isExpanded ? expandedTotalHeight : 74,
          clipBehavior: Clip.none,
          padding: _barContentPadding,
          child: LiquidGlass.grouped(
            shape: const LiquidRoundedSuperellipse(borderRadius: 38),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: _GlassBottomNavigationVersionThreeState._animationDuration,
                  curve: Curves.easeOutCubic,
                  height: isExpanded ? expandedPanelHeight : 0,
                  child: ClipRect(
                    child: isExpanded
                        ? AnimatedOpacity(
                            duration: const Duration(milliseconds: 180),
                            opacity: 1,
                            child: _MorePanelGrid(onItemSelected: onMorePanelItemSelected),
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
                AnimatedContainer(duration: _GlassBottomNavigationVersionThreeState._animationDuration, curve: Curves.easeOutCubic, height: isExpanded ? _expandedPanelToTabGap : 0),
                _TabStrip(currentIndex: currentIndex, tabs: tabs, onTap: onTabTap),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TabStrip extends StatelessWidget {
  const _TabStrip({required this.currentIndex, required this.tabs, required this.onTap});

  static const double _indicatorRadius = 50;

  final int currentIndex;
  final List<_GlassBottomTabData> tabs;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final brightness = MediaQuery.platformBrightnessOf(context);
    final isDark = brightness == Brightness.dark;
    return SizedBox(
      height: 70,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tabCount = tabs.length;
          final safeCount = tabCount > 0 ? tabCount : 1;
          final tabWidth = constraints.maxWidth / safeCount;
          final indicatorLeft = tabWidth * currentIndex;
          final indicatorHorizontalInset = tabWidth * 0.007;
          return Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 240),
                curve: Curves.easeOutCubic,
                left: indicatorLeft + indicatorHorizontalInset,
                top: 4,
                bottom: 4,
                child: SizedBox(
                  width: tabWidth - (indicatorHorizontalInset * 2),
                  child: Bounce(
                    onTap: () => onTap(currentIndex),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(_indicatorRadius),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          DecoratedBox(
                            decoration: BoxDecoration(color: appColors.bottomBarIndicator, borderRadius: BorderRadius.circular(_indicatorRadius)),
                            child: const SizedBox.expand(),
                          ),
                          LiquidGlass.withOwnLayer(
                            fake: false,
                            settings: LiquidGlassSettings(
                              visibility: 1,
                              glassColor: isDark ? const Color.fromARGB(120, 54, 61, 77) : const Color.fromARGB(200, 213, 213, 213),
                              saturation: 1.05,
                              refractiveIndex: 1.1,
                              thickness: 0,
                              lightIntensity: isDark ? 0.85 : 1.15,
                              chromaticAberration: .2,
                              blur: 2,
                            ),
                            shape: const LiquidRoundedSuperellipse(borderRadius: _indicatorRadius),
                            child: const SizedBox.expand(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                children: List.generate(tabs.length, (index) {
                  final tab = tabs[index];
                  final selected = currentIndex == index;
                  return Expanded(
                    child: Bounce(
                      child: GestureDetector(
                        onTap: () => onTap(index),
                        behavior: HitTestBehavior.opaque,
                        child: _TabItem(selected: selected, label: tab.label, iconBuilder: tab.iconBuilder),
                      ),
                    ),
                  );
                }),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({required this.selected, required this.label, required this.iconBuilder});

  final bool selected;
  final String label;
  final Widget Function(Color color, double size, bool selected) iconBuilder;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final color = selected ? appColors.primary : appColors.bottomBarTabUnselected;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          iconBuilder(color, 22, selected),
          const SizedBox(height: 1),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: color, fontSize: 10, fontWeight: selected ? FontWeight.w700 : FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _MorePanelGrid extends StatelessWidget {
  const _MorePanelGrid({required this.onItemSelected});

  final ValueChanged<int> onItemSelected;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: appColors.stroke.withValues(alpha: 0.22)),
      ),
      child: GridView.builder(
        itemCount: kMainMoreMenuItems.length,
        physics: const NeverScrollableScrollPhysics(),
        padding: _MorePanelGridLayout.padding,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _MorePanelGridLayout.crossAxisCount,
          crossAxisSpacing: _MorePanelGridLayout.crossAxisSpacing,
          mainAxisSpacing: _MorePanelGridLayout.mainAxisSpacing,
          childAspectRatio: _MorePanelGridLayout.childAspectRatio,
        ),
        itemBuilder: (context, index) => _MoreGridTile(item: kMainMoreMenuItems[index], onTap: () => onItemSelected(index)),
      ),
    );
  }
}

class _MoreGridTile extends StatelessWidget {
  const _MoreGridTile({required this.item, required this.onTap});

  final MainMoreMenuItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LiquidGlass.grouped(
            shape: const LiquidRoundedSuperellipse(borderRadius: 22),
            child: SizedBox(width: 60, height: 60, child: Icon(item.icon, size: 26, color: item.tint)),
          ),
          Flexible(
            child: Text(
              item.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: appColors.text.withValues(alpha: 0.94), fontSize: 10.5, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassPlusActionButton extends StatelessWidget {
  const _GlassPlusActionButton({required this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: LiquidGlass.grouped(
        shape: const LiquidOval(),
        child: SizedBox(width: 74, height: 74, child: Icon(LucideIcons.plus, size: 30, color: appColors.bottomBarTabUnselected)),
      ),
    );
  }
}

class _GlassBottomTabData {
  const _GlassBottomTabData({required this.label, required this.iconBuilder});

  final String label;
  final Widget Function(Color color, double size, bool selected) iconBuilder;
}

List<_GlassBottomTabData> _bottomTabs(BuildContext context) {
  final l10n = context.l10n;
  return [
    _GlassBottomTabData(label: l10n.mainTabHome, iconBuilder: MainBottomNavKitIcons.home),
    // _GlassBottomTabData(label: l10n.mainTabCourses, iconBuilder: MainBottomNavKitIcons.courses),
    _GlassBottomTabData(label: l10n.mainTabLeaderboard, iconBuilder: MainBottomNavKitIcons.leaderboard),
    _GlassBottomTabData(label: l10n.mainTabProfile, iconBuilder: MainBottomNavKitIcons.user),
    _GlassBottomTabData(
      label: l10n.mainTabMore,
      iconBuilder: (color, size, selected) => Icon(LucideIcons.layoutGrid, size: size, color: color),
    ),
  ];
}
