// GitHub example: https://github.com/whynotmake-it/flutter_liquid_glass/tree/main/packages/liquid_glass_renderer/example/lib/widgets/bottom_bar.dart
// ignore_for_file: deprecated_member_use

import 'dart:math' as math;

import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/config/constants/colors.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/theme_extension.dart';
import 'package:qizlar_academy_mobile/feature/main/presentation/components/main_bottom_nav_kit_icons.dart';
import 'package:qizlar_academy_mobile/feature/main/presentation/components/main_bottom_nav_profile_tab_icon.dart';

/// Creates a jelly transform matrix based on velocity for organic squash and stretch effect
Matrix4 buildJellyTransform({required Offset velocity, double maxDistortion = 0.7, double velocityScale = 1000.0}) {
  final speed = velocity.distance;
  final direction = speed > 0 ? velocity / speed : Offset.zero;
  final distortionFactor = (speed / velocityScale).clamp(0.0, 1.0) * maxDistortion;

  if (distortionFactor == 0) {
    return Matrix4.identity();
  }

  final squashX = 1.0 - (direction.dx.abs() * distortionFactor * 0.5);
  final squashY = 1.0 - (direction.dy.abs() * distortionFactor * 0.5);
  final stretchX = 1.0 + (direction.dy.abs() * distortionFactor * 0.3);
  final stretchY = 1.0 + (direction.dx.abs() * distortionFactor * 0.3);

  final scaleX = squashX * stretchX;
  final scaleY = squashY * stretchY;

  final matrix = Matrix4.identity();
  matrix.scale(scaleX, scaleY);
  return matrix;
}

class LiquidGlassBottomBar extends StatefulWidget {
  const LiquidGlassBottomBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
    this.extraButton,
    this.spacing = 8,
    this.horizontalPadding = 20,
    this.bottomPadding = 20,
    this.barHeight = 64,
    this.glassSettings,
    this.showIndicator = true,
    this.indicatorColor,
    this.fake = false,
  });

  final List<LiquidGlassBottomBarTab> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final LiquidGlassBottomBarExtraButton? extraButton;
  final double spacing;
  final double horizontalPadding;
  final double bottomPadding;
  final double barHeight;
  final LiquidGlassSettings? glassSettings;
  final bool showIndicator;
  final Color? indicatorColor;
  final bool fake;

  @override
  State<LiquidGlassBottomBar> createState() => _LiquidGlassBottomBarState();
}

class _LiquidGlassBottomBarState extends State<LiquidGlassBottomBar> {
  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkTheme;
    final appColors = context.appColors;

    final glassSettings =
        widget.glassSettings ??
        LiquidGlassSettings(
          refractiveIndex: isDark ? 1.25 : 1.18,
          thickness: isDark ? 22 : 14,
          blur: 32,
          saturation: isDark ? 1.20 : 1.0,
          lightIntensity: isDark ? .85 : .9,
          ambientStrength: isDark ? .24 : .4,
          chromaticAberration: isDark ? 0.025 : 0.01,
          lightAngle: math.pi / 3,
          glassColor: appColors.bottomBarGlass,
        );

    return LiquidGlassLayer(
      settings: glassSettings,
      fake: widget.fake,
      child: LiquidGlassBlendGroup(
        blend: 5,
        child: Padding(
          padding: EdgeInsets.only(right: widget.horizontalPadding, left: widget.horizontalPadding, bottom: widget.bottomPadding, top: widget.bottomPadding),
          child: Row(
            children: [
              Expanded(
                child: _TabIndicator(
                  // fake: widget.fake,
                  visible: widget.showIndicator,
                  tabIndex: widget.selectedIndex,
                  tabCount: widget.tabs.length,
                  indicatorColor: widget.indicatorColor,
                  onTabChanged: widget.onTabSelected,
                  child: LiquidGlass.grouped(
                    clipBehavior: Clip.none,
                    shape: const LiquidRoundedSuperellipse(borderRadius: 32),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      height: widget.barHeight,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          for (var i = 0; i < widget.tabs.length; i++)
                            Expanded(
                              child: _BottomBarTab(tab: widget.tabs[i], selected: widget.selectedIndex == i, onTap: () => widget.onTabSelected(i)),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (widget.extraButton != null) ...[SizedBox(width: widget.spacing), _ExtraButton(config: widget.extraButton!, fake: widget.fake)],
            ],
          ),
        ),
      ),
    );
  }
}

class LiquidGlassBottomBarTab {
  const LiquidGlassBottomBarTab({required this.label, this.icon, this.selectedIcon, this.iconBuilder, this.glowColor})
    : assert(icon != null || iconBuilder != null, 'LiquidGlassBottomBarTab requires icon or iconBuilder');

  final String label;
  final IconData? icon;
  final IconData? selectedIcon;
  final Widget Function(BuildContext context, Color color, double size, bool selected)? iconBuilder;
  final Color? glowColor;
}

class LiquidGlassBottomBarExtraButton {
  const LiquidGlassBottomBarExtraButton({required this.icon, required this.onTap, required this.label, this.size = 64});

  final IconData icon;
  final VoidCallback onTap;
  final String label;
  final double size;
}

class _BottomBarTab extends StatelessWidget {
  const _BottomBarTab({required this.tab, required this.selected, required this.onTap});

  final LiquidGlassBottomBarTab tab;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final iconColor = selected ? appColors.primary : appColors.bottomBarTabUnselected;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Semantics(
        button: true,
        label: tab.label,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              ExcludeSemantics(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    if (tab.glowColor != null)
                      Positioned(
                        top: -24,
                        right: -24,
                        left: -24,
                        bottom: -24,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          transformAlignment: Alignment.center,
                          curve: Curves.easeOutCirc,
                          transform: selected
                              ? Matrix4.identity()
                              : (Matrix4.identity()
                                  ..scale(0.4)
                                  ..rotateZ(-math.pi)),
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 150),
                            opacity: selected ? 1 : 0,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [BoxShadow(color: tab.glowColor!.withValues(alpha: selected ? 0.6 : 0), blurRadius: 32, spreadRadius: 8)],
                              ),
                            ),
                          ),
                        ),
                      ),
                    AnimatedScale(
                      scale: 1,
                      duration: const Duration(milliseconds: 150),
                      child: tab.iconBuilder != null ? tab.iconBuilder!(context, iconColor, 24, selected) : Icon(selected ? (tab.selectedIcon ?? tab.icon!) : tab.icon!, color: iconColor, size: 24),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                tab.label,
                maxLines: 1,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: iconColor, fontSize: 11, fontWeight: selected ? FontWeight.w600 : FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExtraButton extends StatefulWidget {
  const _ExtraButton({required this.config, this.fake = false});

  final LiquidGlassBottomBarExtraButton config;
  final bool fake;

  @override
  State<_ExtraButton> createState() => _ExtraButtonState();
}

class _ExtraButtonState extends State<_ExtraButton> {
  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return GestureDetector(
      onTap: widget.config.onTap,
      child: LiquidStretch(
        child: Semantics(
          button: true,
          label: widget.config.label,
          child: LiquidGlass.grouped(
            shape: const LiquidOval(),
            child: GlassGlow(
              child: SizedBox(
                height: widget.config.size,
                width: widget.config.size,
                child: Center(child: Icon(widget.config.icon, size: 24, color: appColors.bottomBarTabUnselected)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TabIndicator extends StatefulWidget {
  const _TabIndicator({required this.child, required this.tabIndex, required this.tabCount, required this.onTabChanged, this.visible = true, this.indicatorColor});

  final int tabIndex;
  final int tabCount;
  final bool visible;
  final Widget child;
  final Color? indicatorColor;
  final ValueChanged<int> onTabChanged;

  @override
  State<_TabIndicator> createState() => _TabIndicatorState();
}

class _TabIndicatorState extends State<_TabIndicator> with SingleTickerProviderStateMixin {
  bool _isDown = false;
  bool _isDragging = false;

  late double xAlign = _computeXAlignmentForTab(widget.tabIndex);

  double _computeXAlignmentForTab(int tabIndex) {
    if (widget.tabCount <= 1) return 0;
    final relativeTabIndex = (tabIndex / (widget.tabCount - 1)).clamp(0.0, 1.0);
    return (relativeTabIndex * 2) - 1; // -1 to 1
  }

  @override
  void didUpdateWidget(covariant _TabIndicator oldWidget) {
    if (oldWidget.tabIndex != widget.tabIndex || oldWidget.tabCount != widget.tabCount) {
      setState(() {
        xAlign = _computeXAlignmentForTab(widget.tabIndex);
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  double _getAlignmentFromGlobalPosition(Offset globalPosition) {
    final box = context.findRenderObject() as RenderBox;
    final localPosition = box.globalToLocal(globalPosition);

    final indicatorWidth = 1.0 / widget.tabCount;
    final draggableRange = 1.0 - indicatorWidth;
    final padding = indicatorWidth / 2;

    final rawRelativeX = (localPosition.dx / box.size.width).clamp(0.0, 1.0);
    final normalizedX = (rawRelativeX - padding) / draggableRange;

    final adjustedRelativeX = _applyRubberBandResistance(normalizedX);
    return (adjustedRelativeX * 2) - 1;
  }

  void _onDragDown(DragDownDetails details) {
    setState(() {
      _isDown = true;
      xAlign = _getAlignmentFromGlobalPosition(details.globalPosition);
    });
  }

  void _onDragUpdate(DragUpdateDetails details) {
    setState(() {
      _isDragging = true;
      xAlign = _getAlignmentFromGlobalPosition(details.globalPosition);
    });
  }

  double _applyRubberBandResistance(double value) {
    const double resistance = 0.4;
    const double maxOverdrag = 0.3;

    if (value < 0) {
      final overdrag = -value;
      final resistedOverdrag = overdrag * resistance;
      return -resistedOverdrag.clamp(0.0, maxOverdrag);
    } else if (value > 1) {
      final overdrag = value - 1;
      final resistedOverdrag = overdrag * resistance;
      return 1 + resistedOverdrag.clamp(0.0, maxOverdrag);
    } else {
      return value;
    }
  }

  void _onDragEnd(DragEndDetails details) {
    setState(() {
      _isDragging = false;
      _isDown = false;
    });

    final box = context.findRenderObject() as RenderBox;
    final currentRelativeX = (xAlign + 1) / 2;
    final tabWidth = 1.0 / widget.tabCount;

    final indicatorWidth = 1.0 / widget.tabCount;
    final draggableRange = 1.0 - indicatorWidth;
    final velocityX = (details.velocity.pixelsPerSecond.dx / box.size.width) / draggableRange;

    int targetTabIndex;

    if (currentRelativeX < 0) {
      targetTabIndex = 0;
    } else if (currentRelativeX > 1) {
      targetTabIndex = widget.tabCount - 1;
    } else {
      const velocityThreshold = 0.5;
      if (velocityX.abs() > velocityThreshold) {
        final projectedX = (currentRelativeX + velocityX * 0.3).clamp(0.0, 1.0);
        targetTabIndex = (projectedX / tabWidth).round().clamp(0, widget.tabCount - 1);

        final currentTabIndex = (currentRelativeX / tabWidth).round().clamp(0, widget.tabCount - 1);
        if (velocityX > velocityThreshold && targetTabIndex <= currentTabIndex && currentTabIndex < widget.tabCount - 1) {
          targetTabIndex = currentTabIndex + 1;
        } else if (velocityX < -velocityThreshold && targetTabIndex >= currentTabIndex && currentTabIndex > 0) {
          targetTabIndex = currentTabIndex - 1;
        }
      } else {
        targetTabIndex = (currentRelativeX / tabWidth).round().clamp(0, widget.tabCount - 1);
      }
    }
    xAlign = _computeXAlignmentForTab(targetTabIndex);

    if (targetTabIndex != widget.tabIndex) {
      widget.onTabChanged(targetTabIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final isDark = context.isDarkTheme;
    final indicatorColor = widget.indicatorColor ?? appColors.bottomBarIndicator;
    final targetAlignment = _computeXAlignmentForTab(widget.tabIndex);

    return GestureDetector(
      onHorizontalDragDown: _onDragDown,
      onHorizontalDragUpdate: _onDragUpdate,
      onHorizontalDragEnd: _onDragEnd,
      onHorizontalDragCancel: () => setState(() {
        _isDragging = false;
        _isDown = false;
      }),
      child: VelocityMotionBuilder(
        converter: SingleMotionConverter(),
        value: xAlign,
        motion: _isDragging ? const Motion.interactiveSpring(snapToEnd: true) : const Motion.snappySpring(snapToEnd: true),
        builder: (context, value, velocity, child) {
          final alignment = Alignment(value, 0);
          return SingleMotionBuilder(
            motion: const Motion.snappySpring(snapToEnd: true, duration: Duration(milliseconds: 150)),
            value: widget.visible && (_isDown || (alignment.x - targetAlignment).abs() > 0.30) ? 1.0 : 0.0,
            builder: (context, thickness, child) {
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  if (thickness < 1)
                    _IndicatorTransform(
                      velocity: velocity,
                      tabCount: widget.tabCount,
                      alignment: alignment,
                      thickness: thickness,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 120),
                        opacity: widget.visible && thickness <= .2 ? 1 : 0,
                        child: DecoratedBox(
                          decoration: BoxDecoration(color: indicatorColor, borderRadius: BorderRadius.circular(64)),
                          child: const SizedBox.expand(),
                        ),
                      ),
                    ),
                  child!,
                  if (thickness > 0)
                    _IndicatorTransform(
                      velocity: velocity,
                      tabCount: widget.tabCount,
                      alignment: alignment,
                      thickness: thickness,
                      child: LiquidGlass.withOwnLayer(
                        // Indicator doim o'z layerida real render qilinadi,
                        // aks holda fake mode'da u blur bilan yo'qolib ketadi.
                        fake: false,
                        settings: LiquidGlassSettings(
                          visibility: thickness,
                          glassColor: isDark ? AppColors.darkBottomBarIndicatorGlass : AppColors.lightBottomBarIndicatorGlass,
                          saturation: 1.05,
                          refractiveIndex: 1.1,
                          thickness: 10,
                          lightIntensity: isDark ? 0.8 : 1.2,
                          chromaticAberration: .2,
                          blur: 1,
                        ),
                        shape: const LiquidRoundedSuperellipse(borderRadius: 64),
                        child: GlassGlow(child: const SizedBox.expand()),
                      ),
                    ),
                ],
              );
            },
            child: widget.child,
          );
        },
        child: widget.child,
      ),
    );
  }
}

class _IndicatorTransform extends StatelessWidget {
  const _IndicatorTransform({required this.velocity, required this.tabCount, required this.alignment, required this.thickness, required this.child});

  final double velocity;
  final int tabCount;
  final Alignment alignment;
  final double thickness;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final rect = RelativeRect.lerp(RelativeRect.fill, const RelativeRect.fromLTRB(-8, -8, -8, -8), thickness);
    return Positioned.fill(
      left: 4,
      right: 4,
      top: 4,
      bottom: 4,
      child: FractionallySizedBox(
        widthFactor: 1 / tabCount,
        alignment: alignment,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fromRelativeRect(
              rect: rect ?? RelativeRect.fill,
              child: SingleMotionBuilder(
                motion: Motion.bouncySpring(duration: const Duration(milliseconds: 150)),
                value: velocity,
                builder: (context, velocityValue, child) {
                  return Transform(
                    alignment: Alignment.center,
                    transform: buildJellyTransform(velocity: Offset(velocityValue, 0), maxDistortion: .8, velocityScale: 10),
                    child: child,
                  );
                },
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Simple fractionally sized box for indicator (no motor dependency in this path)
class FractionallySizedBox extends StatelessWidget {
  const FractionallySizedBox({super.key, required this.widthFactor, required this.child, this.alignment = Alignment.center});

  final double widthFactor;
  final Widget child;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth * widthFactor;
        return Align(
          alignment: alignment,
          child: SizedBox(width: width, child: child),
        );
      },
    );
  }
}

/// MainBottomBar — loyiha ekranlari uchun wrapper: GitHub'dagi LiquidGlassBottomBar
/// xuddi shu iOS uslubida, faqat bizning tablarimiz bilan.
class GlassBottomNavigationVersionOne extends StatelessWidget {
  const GlassBottomNavigationVersionOne({super.key, required this.currentIndex, required this.onTap, this.fake = false});

  final int currentIndex;
  final ValueChanged<int> onTap;
  final bool fake;

  static List<LiquidGlassBottomBarTab> _tabs(BuildContext context) {
    final l10n = context.l10n;
    return [
      LiquidGlassBottomBarTab(label: l10n.mainTabHome, iconBuilder: (_, color, size, selected) => MainBottomNavKitIcons.home(color, size, selected)),
      LiquidGlassBottomBarTab(label: l10n.mainTabCourses, iconBuilder: (_, color, size, selected) => MainBottomNavKitIcons.courses(color, size, selected)),
      LiquidGlassBottomBarTab(label: l10n.mainTabLeaderboard, iconBuilder: (_, color, size, selected) => MainBottomNavKitIcons.leaderboard(color, size, selected)),
      LiquidGlassBottomBarTab(
        label: l10n.mainTabProfile,
        iconBuilder: (ctx, color, size, selected) =>
            MainBottomNavProfileTabIcon(isGuestMode: false, selected: selected, selectedColor: ctx.appColors.primary, unselectedColor: ctx.appColors.bottomBarTabUnselected),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: LiquidGlassBottomBar(tabs: _tabs(context), selectedIndex: currentIndex, onTabSelected: onTap, fake: fake),
      ),
    );
  }
}
