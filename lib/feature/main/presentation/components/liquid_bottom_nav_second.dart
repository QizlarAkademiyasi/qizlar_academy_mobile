import 'dart:ui' show ImageFilter, lerpDouble;

import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:motor/motor.dart';
import 'package:qizlar_academy_mobile/config/constants/colors.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/theme_extension.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_liquid_stretch.dart';
import 'package:qizlar_academy_mobile/feature/main/presentation/components/main_bottom_nav_kit_icons.dart';
import 'package:qizlar_academy_mobile/feature/main/presentation/components/main_bottom_nav_profile_tab_icon.dart';

Color _secondLiquidBottomNavWhiten(Color base, {required bool lightBar}) {
  return Color.lerp(base, const Color(0xFFFFFFFF), lightBar ? 0.38 : 0.72)!;
}

/// Dark truba: biroz yoritilgan qora/kulrang sirt (oq emas).
Color _secondLiquidBottomNavDarkSurface(Color base) {
  return Color.lerp(base, const Color(0xFF3A3A3C), 0.28)!;
}

/// Kengaygan grid va tashqi komponentlar uchun truba sirt rangi.
Color secondLiquidBottomNavSurfaceTint(BuildContext context, {Color? backgroundColor}) {
  final Color base = backgroundColor ?? secondLiquidBottomNavThemePalette(context).backgroundColor;
  final bool lightBar = base.computeLuminance() > 0.5;
  return lightBar ? _secondLiquidBottomNavWhiten(base, lightBar: true) : _secondLiquidBottomNavDarkSurface(base);
}

/// Grid kafel fon — truba sirtidan biroz farq qiladi (ajratish uchun).
Color secondLiquidBottomNavTileSurface(BuildContext context, {Color? backgroundColor}) {
  final Color surface = secondLiquidBottomNavSurfaceTint(context, backgroundColor: backgroundColor);
  final bool lightBar = (backgroundColor ?? secondLiquidBottomNavThemePalette(context).backgroundColor).computeLuminance() > 0.5;
  return Color.lerp(surface, lightBar ? const Color(0xFF000000) : const Color(0xFFFFFFFF), lightBar ? 0.05 : 0.1)!;
}

/// Chiziq qalinligi: pikselga mos ince hairline.
double _secondLiquidBottomNavHairlineWidth(BuildContext context) {
  final double dpr = MediaQuery.devicePixelRatioOf(context);
  return (1.0 / dpr).clamp(0.5, 1.0);
}

/// Truba / extra chegarasi — `surfaceTint` va light/dark bar bilan mos, `stroke` temadan emas.
Color _secondLiquidBottomNavEdgeColor(Color surfaceTint, {required bool lightBar}) {
  if (lightBar) {
    return Color.lerp(surfaceTint, const Color.fromARGB(255, 232, 232, 232), 0.5)!;
  }
  return Color.lerp(surfaceTint, const Color.fromARGB(255, 158, 158, 158), 0.2)!;
}

double _secondLiquidBottomNavPulseFromProgress(double value) {
  final double t = value - value.floorToDouble();
  final double pulse = 1 - ((t - 0.5).abs() * 2);
  return pulse.clamp(0.0, 1.0).toDouble();
}

/// Surilmali indikator pill: rang [baseColor] dan biroz ochroq, blur yoqilganda shisha qatlami.
Widget _secondLiquidBottomNavSlidingIndicator({required double x, required double width, required Color baseColor, required bool lightBar, required double indicatorBlurSigma}) {
  final bool useIndBlur = indicatorBlurSigma > 0;
  final Color softer = lightBar ? Color.lerp(Color.lerp(baseColor, const Color.fromARGB(255, 0, 0, 0), 0.12)!, Colors.white, 0.22)! : Color.lerp(baseColor, const Color(0xFF8E8E93), 0.38)!;
  if (useIndBlur) {
    return Transform.translate(
      offset: Offset(x, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(999),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: indicatorBlurSigma, sigmaY: indicatorBlurSigma),
          child: Container(
            width: width,
            margin: const EdgeInsets.symmetric(vertical: 2),
            decoration: BoxDecoration(
              color: softer.withValues(alpha: lightBar ? 0.08 : 0.18),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        ),
      ),
    );
  }
  return Transform.translate(
    offset: Offset(x, 0),
    child: Container(
      width: width,
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(color: softer, borderRadius: BorderRadius.circular(999)),
    ),
  );
}

/// Qoshimcha tugma: [SecondLiquidBottomNav] trubasi bilan bir xil blur va soya (doira).
class _SecondLiquidBottomNavExtraIconButton extends StatelessWidget {
  const _SecondLiquidBottomNavExtraIconButton({
    required this.height,
    required this.icon,
    required this.onTap,
    required this.backgroundColor,
    required this.backgroundBlurSigma,
    required this.iconColor,
    this.semanticLabel,
    this.isActive = false,
  });

  final double height;
  final IconData icon;
  final VoidCallback onTap;
  final Color backgroundColor;
  final double backgroundBlurSigma;
  final Color iconColor;
  final String? semanticLabel;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final bool lightBar = backgroundColor.computeLuminance() > 0.5;
    final bool useBlur = backgroundBlurSigma > 0;
    final double sigma = backgroundBlurSigma;
    final Color surface = lightBar ? _secondLiquidBottomNavWhiten(backgroundColor, lightBar: true) : _secondLiquidBottomNavDarkSurface(backgroundColor);
    final Color fillColor = useBlur ? surface.withValues(alpha: lightBar ? 0.52 : 0.82) : surface;
    final Color barShadow = AppColors.shadow.withValues(alpha: lightBar ? 0.14 : 0.42);
    final BorderRadius pill = BorderRadius.circular(999);
    final double edgeW = _secondLiquidBottomNavHairlineWidth(context);
    final Color edgeColor = _secondLiquidBottomNavEdgeColor(surface, lightBar: lightBar);
    final inner = DecoratedBox(
      decoration: BoxDecoration(
        color: fillColor,
        border: Border.all(color: edgeColor, width: edgeW),
        borderRadius: pill,
      ),
      child: SizedBox(
        width: height,
        height: height,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: pill,
            onTap: onTap,
            splashFactory: NoSplash.splashFactory,
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                switchInCurve: Curves.easeOutBack,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return RotationTransition(
                    turns: Tween<double>(begin: 0.5, end: 1.0).animate(animation),
                    child: FadeTransition(
                      opacity: animation,
                      child: ScaleTransition(
                        scale: animation,
                        child: child,
                      ),
                    ),
                  );
                },
                child: Icon(
                  icon,
                  key: ValueKey<int>(icon.codePoint),
                  color: iconColor,
                  size: height * 0.44,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    final Widget clipped = useBlur
        ? ClipRRect(
            borderRadius: pill,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
              child: inner,
            ),
          )
        : inner;
    final Widget button = Semantics(
      button: true,
      label: semanticLabel ?? 'Menu',
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: pill,
          boxShadow: [BoxShadow(color: barShadow, blurRadius: 20, spreadRadius: -6, offset: const Offset(0, 8))],
        ),
        child: clipped,
      ),
    );
    return button;
  }
}

/// [SecondLiquidBottomNav] ranglari: `Color?` ishlatilganda yoki barcha `null` qoldirilganda
/// [secondLiquidBottomNavThemePalette] yordamida olinadi.
class SecondLiquidBottomNavThemePalette {
  const SecondLiquidBottomNavThemePalette({required this.backgroundColor, required this.selectedColor, required this.unselectedColor, required this.indicatorColor});

  final Color backgroundColor;
  final Color selectedColor;
  final Color unselectedColor;
  final Color indicatorColor;
}

/// Light: oqroq truba, surilmali pill, tanlangan (pill ustida) qora, tanlanmagan kulrang.
/// Dark: ko‘tarilgan qora shisha truba, och kulrang pill, tanlangan/ tanlanmagan iOS uslubida.
SecondLiquidBottomNavThemePalette secondLiquidBottomNavThemePalette(BuildContext context) {
  if (Theme.of(context).brightness == Brightness.dark) {
    return SecondLiquidBottomNavThemePalette(
      backgroundColor: const Color(0xEE1C1C1E),
      selectedColor: const Color(0xFFF2F2F7),
      unselectedColor: const Color(0x99EBEBF5),
      indicatorColor: const Color(0xFF636366),
    );
  }
  return SecondLiquidBottomNavThemePalette(
    backgroundColor: const Color(0xFFFFFFFF),
    selectedColor: AppColors.white,
    unselectedColor: AppColors.textDark.withValues(alpha: 0.45),
    indicatorColor: const Color(0xFF1C1C1E),
  );
}

class SecondLiquidBottomNavItem {
  const SecondLiquidBottomNavItem({this.icon, this.activeIcon, this.iconBuilder, required this.label, this.tooltip})
    : assert(icon != null || iconBuilder != null, 'SecondLiquidBottomNavItem requires icon or iconBuilder');

  /// [iconBuilder] berilganda [Icon] o‘rniga loyiha SVG/tab widgetlari (masalan, [MainBottomNavKitIcons]) ishlatiladi.
  final IconData? icon;
  final IconData? activeIcon;
  final Widget Function(BuildContext context, Color color, double size, bool selected)? iconBuilder;
  final String label;
  final String? tooltip;
}

class SecondLiquidBottomNav extends StatefulWidget {
  const SecondLiquidBottomNav({
    super.key,
    required this.items,
    this.currentIndex,
    this.initialIndex = 0,
    this.onChanged,
    this.height = 64,
    this.borderRadius = 40,
    this.padding = const EdgeInsets.all(6),
    this.margin = const EdgeInsets.all(16),

    /// `null` — [ThemeData.brightness] bo‘yicha: light’da qora truba, dark’da oq; pill va ikkonalar teskariga aylanadi.
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
    this.indicatorColor,
    this.iconSize = 20,
    this.extraButton,

    /// [extraButton] o‘rniga: faqat icon — fon/shisha pastki truba bilan bir xil.
    this.extraActionIcon,
    this.onExtraActionTap,
    this.extraActionSemanticLabel,
    this.extraButtonSpacing = 12,
    this.extraButtonBottomInset = 0,

    /// Orqa kontent: `backgroundBlurSigma` > 0 bo‘lsa `liquid_glass_renderer` liquid glass; `0` — qattiq `backgroundColor`.
    this.backgroundBlurSigma = 20,

    /// Pill blur: `null` — [backgroundBlurSigma] > 0 bo‘lsa `~0.58` omili; `0` — qattiq pill.
    this.indicatorBlurSigma,

    /// Plus bosilganda truba vertikal kengayadi va [expandedContent] ko‘rsatiladi.
    this.isExpanded = false,
    this.expandedContent,
    this.expandedContentHeight,
  }) : assert(items.length > 1, 'Bottom nav should contain at least 2 items.'),
       assert(extraActionIcon == null || onExtraActionTap != null, 'onExtraActionTap is required when extraActionIcon is set.'),
       assert(extraActionIcon == null || extraButton == null, 'Use extraActionIcon or extraButton, not both.');

  final List<SecondLiquidBottomNavItem> items;
  final int? currentIndex;
  final int initialIndex;
  final ValueChanged<int>? onChanged;

  final double height;
  final double borderRadius;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? indicatorColor;
  final double iconSize;

  /// Standalone button rendered outside the navigation bar (right side).
  final Widget? extraButton;

  /// [extraButton] o‘rniga: [IconData] + [onExtraActionTap] — fon pastki truba bilan bir xil yig‘iladi.
  final IconData? extraActionIcon;
  final VoidCallback? onExtraActionTap;
  final String? extraActionSemanticLabel;

  final double extraButtonSpacing;
  final double extraButtonBottomInset;

  /// Blur kuchlari (sigma). `0` bo‘lsa `BackdropFilter` qo‘llanmaydi.
  final double backgroundBlurSigma;

  /// Tanlovdagi pill blur (sigma). [indicatorBlurSigma] orqali alohida sozlash mumkin.
  final double? indicatorBlurSigma;

  /// Truba kengaygan holat (plus menyu ochiq).
  final bool isExpanded;

  /// Kengaygan qismda ko‘rsatiladigan kontent (masalan, grid menyu).
  final Widget? expandedContent;

  /// [expandedContent] balandligi — animatsiya uchun (masalan, [MainExtraActionGrid.preferredHeightFor]).
  final double? expandedContentHeight;

  @override
  State<SecondLiquidBottomNav> createState() => _SecondLiquidBottomNavState();
}

class _SecondLiquidBottomNavState extends State<SecondLiquidBottomNav> {
  late int _internalIndex;
  int _navPulseTick = 0;
  int _extraPulseTick = 0;

  int get _activeIndex => widget.currentIndex ?? _internalIndex;

  @override
  void initState() {
    super.initState();
    _internalIndex = widget.initialIndex.clamp(0, widget.items.length - 1);
  }

  @override
  void didUpdateWidget(covariant SecondLiquidBottomNav oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items.length != widget.items.length) {
      _internalIndex = _internalIndex.clamp(0, widget.items.length - 1);
    }
  }

  void _onTap(int index) {
    setState(() {
      if (widget.currentIndex == null) {
        _internalIndex = index;
      }
      _navPulseTick++;
    });
    widget.onChanged?.call(index);
  }

  void _onExtraButtonPointerDown(PointerDownEvent event) {
    setState(() => _extraPulseTick++);
  }

  @override
  Widget build(BuildContext context) {
    final p = secondLiquidBottomNavThemePalette(context);
    final bool isExpanded = widget.isExpanded && widget.expandedContent != null;
    final Widget? resolvedExtra = widget.extraActionIcon != null
        ? _SecondLiquidBottomNavExtraIconButton(
            height: widget.height,
            icon: isExpanded ? Icons.close : widget.extraActionIcon!,
            onTap: widget.onExtraActionTap!,
            backgroundColor: widget.backgroundColor ?? p.backgroundColor,
            backgroundBlurSigma: widget.backgroundBlurSigma,
            iconColor: widget.unselectedColor ?? p.unselectedColor,
            semanticLabel: widget.extraActionSemanticLabel,
            isActive: isExpanded,
          )
        : widget.extraButton;
    final bool hasExtraButton = resolvedExtra != null;
    final double resolvedIndicatorSigma = widget.indicatorBlurSigma ?? (widget.backgroundBlurSigma > 0 ? widget.backgroundBlurSigma * 0.58 : 0.0);
    return SafeArea(
      top: false,
      child: Padding(
        padding: widget.margin,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: AppLiquidStretch(
                child: _SecondLiquidBottomNavBarContainer(
                  height: widget.height,
                  borderRadius: widget.borderRadius,
                  backgroundColor: widget.backgroundColor ?? p.backgroundColor,
                  backgroundBlurSigma: widget.backgroundBlurSigma,
                  indicatorBlurSigma: resolvedIndicatorSigma,
                  pulseTick: _navPulseTick,
                  padding: widget.padding,
                  items: widget.items,
                  activeIndex: _activeIndex,
                  onTap: _onTap,
                  iconSize: widget.iconSize,
                  selectedColor: widget.selectedColor ?? p.selectedColor,
                  unselectedColor: widget.unselectedColor ?? p.unselectedColor,
                  indicatorColor: widget.indicatorColor ?? p.indicatorColor,
                  isExpanded: isExpanded,
                  expandedContent: widget.expandedContent,
                  expandedContentHeight: widget.expandedContentHeight,
                ),
              ),
            ),
            if (hasExtraButton) ...[
              SizedBox(width: widget.extraButtonSpacing),
              Padding(
                padding: EdgeInsets.only(bottom: widget.extraButtonBottomInset),
                child: AppLiquidStretch.compact(
                  child: Listener(
                    behavior: HitTestBehavior.translucent,
                    onPointerDown: _onExtraButtonPointerDown,
                    child: SingleMotionBuilder(
                      value: _extraPulseTick.toDouble(),
                      motion: const CupertinoMotion.smooth(duration: Duration(milliseconds: 360), extraBounce: 0),
                      builder: (context, animatedTick, child) {
                        final double pulse = _secondLiquidBottomNavPulseFromProgress(animatedTick);
                        return Transform.scale(
                          scale: 1 - (0.028 * pulse),
                          child: SizedBox(
                            width: widget.height,
                            height: widget.height,
                            child: FittedBox(fit: BoxFit.contain, child: child),
                          ),
                        );
                      },
                      child: resolvedExtra,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Surilali pill: gorizontal surish (iOS truba) — barmoq pozitsiyasi bo‘yicha, o‘tkazib yuborish.
/// Indeks surish orqali o‘zgarganda animatsiya surilgan nuqtadan yangi [targetX]ga boshlanadi (orqaga sakrash yo‘q).
class _SecondLiquidBottomNavPillWithTabs extends StatefulWidget {
  const _SecondLiquidBottomNavPillWithTabs({
    required this.itemCount,
    required this.activeIndex,
    required this.items,
    required this.onIndexChanged,
    required this.iconSize,
    required this.selectedColor,
    required this.unselectedColor,
    required this.lightBar,
    required this.indicatorColor,
    required this.indicatorBlurSigma,
  });

  final int itemCount;
  final int activeIndex;
  final List<SecondLiquidBottomNavItem> items;
  final ValueChanged<int> onIndexChanged;
  final double iconSize;
  final Color selectedColor;
  final Color unselectedColor;
  final bool lightBar;
  final Color indicatorColor;
  final double indicatorBlurSigma;

  @override
  State<_SecondLiquidBottomNavPillWithTabs> createState() => _SecondLiquidBottomNavPillWithTabsState();
}

class _SecondLiquidBottomNavPillWithTabsState extends State<_SecondLiquidBottomNavPillWithTabs> {
  static const double _horizontalInset = 2;

  bool _dragging = false;
  double? _dragPillX;
  int _pillMotionKey = 0;
  double? _releaseFromX;

  double _minLeft(double itemWidth) => _horizontalInset;
  double _maxLeft(double itemWidth) => (widget.itemCount - 1) * itemWidth + _horizontalInset;

  double _clampPillX(double localDx, double itemWidth, double indicatorWidth) {
    return (localDx - indicatorWidth / 2).clamp(_minLeft(itemWidth), _maxLeft(itemWidth)).toDouble();
  }

  int _indexFromPillX(double left, double itemWidth) {
    return ((left - _horizontalInset) / itemWidth).round().clamp(0, widget.itemCount - 1);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double itemWidth = constraints.maxWidth / widget.itemCount;
        final double indicatorWidth = itemWidth - (_horizontalInset * 2);
        final double targetX = (widget.activeIndex * itemWidth) + _horizontalInset;
        return SingleMotionBuilder(
          key: ValueKey(_pillMotionKey),
          value: targetX,
          from: _releaseFromX,
          motion: const CupertinoMotion.snappy(duration: Duration(milliseconds: 400), extraBounce: 0.2, snapToEnd: true),
          builder: (context, animatedPillX, child) {
            final double x = _dragging && _dragPillX != null ? _dragPillX! : animatedPillX;
            final int shownIndex = _dragging && _dragPillX != null ? _indexFromPillX(_dragPillX!, itemWidth) : widget.activeIndex;

            return GestureDetector(
              onHorizontalDragStart: (DragStartDetails _) {
                setState(() {
                  _dragging = true;
                  _dragPillX = animatedPillX;
                });
              },
              onHorizontalDragUpdate: (DragUpdateDetails d) {
                if (!_dragging) return;
                setState(() {
                  _dragPillX = _clampPillX(d.localPosition.dx, itemWidth, indicatorWidth);
                });
              },
              onHorizontalDragEnd: (DragEndDetails d) {
                if (!_dragging) {
                  setState(() {
                    _dragging = false;
                    _dragPillX = null;
                  });
                  return;
                }
                var idx = _dragPillX != null ? _indexFromPillX(_dragPillX!, itemWidth) : widget.activeIndex;
                final v = d.velocity.pixelsPerSecond.dx;
                if (v.abs() > 500) {
                  if (v > 0 && idx < widget.itemCount - 1) {
                    idx = idx + 1;
                  } else if (v < 0 && idx > 0) {
                    idx = idx - 1;
                  }
                }
                if (idx != widget.activeIndex) {
                  final double releaseX = _dragPillX!;
                  widget.onIndexChanged(idx);
                  setState(() {
                    _releaseFromX = releaseX;
                    _pillMotionKey += 1;
                    _dragging = false;
                    _dragPillX = null;
                  });
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      setState(() => _releaseFromX = null);
                    }
                  });
                } else {
                  setState(() {
                    _dragging = false;
                    _dragPillX = null;
                  });
                }
              },
              onHorizontalDragCancel: () {
                setState(() {
                  _dragging = false;
                  _dragPillX = null;
                });
              },
              behavior: HitTestBehavior.translucent,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: _secondLiquidBottomNavSlidingIndicator(
                        x: x,
                        width: indicatorWidth,
                        baseColor: widget.indicatorColor,
                        lightBar: widget.lightBar,
                        indicatorBlurSigma: widget.indicatorBlurSigma,
                      ),
                    ),
                  ),
                  Row(
                    children: List.generate(widget.items.length, (index) {
                      return Expanded(
                        child: _SecondLiquidBottomNavTab(
                          item: widget.items[index],
                          isSelected: index == shownIndex,
                          onTap: () => widget.onIndexChanged(index),
                          iconSize: widget.iconSize,
                          selectedColor: widget.selectedColor,
                          unselectedColor: widget.unselectedColor,
                        ),
                      );
                    }),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _SecondLiquidBottomNavBarContainer extends StatefulWidget {
  const _SecondLiquidBottomNavBarContainer({
    required this.height,
    required this.borderRadius,
    required this.backgroundColor,
    required this.backgroundBlurSigma,
    required this.indicatorBlurSigma,
    required this.pulseTick,
    required this.padding,
    required this.items,
    required this.activeIndex,
    required this.onTap,
    required this.iconSize,
    required this.selectedColor,
    required this.unselectedColor,
    required this.indicatorColor,
    this.isExpanded = false,
    this.expandedContent,
    this.expandedContentHeight,
  });

  final double height;
  final double borderRadius;
  final Color backgroundColor;
  final double backgroundBlurSigma;
  final double indicatorBlurSigma;
  final int pulseTick;
  final EdgeInsets padding;
  final List<SecondLiquidBottomNavItem> items;
  final int activeIndex;
  final ValueChanged<int> onTap;
  final double iconSize;
  final Color selectedColor;
  final Color unselectedColor;
  final Color indicatorColor;
  final bool isExpanded;
  final Widget? expandedContent;
  final double? expandedContentHeight;

  @override
  State<_SecondLiquidBottomNavBarContainer> createState() => _SecondLiquidBottomNavBarContainerState();
}

class _SecondLiquidBottomNavBarContainerState extends State<_SecondLiquidBottomNavBarContainer> with SingleTickerProviderStateMixin {
  static const Duration _expandDuration = Duration(milliseconds: 320);

  late final AnimationController _expandController = AnimationController(vsync: this, duration: _expandDuration);
  late final Animation<double> _expandCurve = CurvedAnimation(
    parent: _expandController,
    curve: Curves.easeOutBack,
    reverseCurve: Curves.easeInCubic,
  );
  late final Animation<double> _contentOpacity = CurvedAnimation(
    parent: _expandController,
    curve: const Interval(0.16, 1, curve: Curves.easeOut),
    reverseCurve: const Interval(0, 0.5, curve: Curves.easeIn),
  );
  late final Animation<Offset> _contentSlide = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
    CurvedAnimation(parent: _expandController, curve: Curves.easeOutCubic, reverseCurve: Curves.easeInCubic),
  );

  @override
  void initState() {
    super.initState();
    if (widget.isExpanded) {
      _expandController.value = 1;
    }
  }

  @override
  void didUpdateWidget(covariant _SecondLiquidBottomNavBarContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded && !oldWidget.isExpanded) {
      _expandController.forward();
    } else if (!widget.isExpanded && oldWidget.isExpanded) {
      _expandController.reverse();
    }
  }

  @override
  void dispose() {
    _expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleMotionBuilder(
      value: widget.pulseTick.toDouble(),
      motion: const CupertinoMotion.smooth(duration: Duration(milliseconds: 400), extraBounce: 0),
      builder: (context, animatedTick, child) {
        return AnimatedBuilder(
          animation: _expandController,
          builder: (context, child) {
            return _buildBar(context, pulse: _secondLiquidBottomNavPulseFromProgress(animatedTick), expandT: _expandCurve.value, child: child);
          },
          child: child,
        );
      },
    );
  }

  Widget _buildBar(BuildContext context, {required double pulse, required double expandT, Widget? child}) {
        final bool lightBar = widget.backgroundColor.computeLuminance() > 0.5;
        final Color pulseToward = lightBar ? AppColors.textDark : AppColors.white;
        final Color dynamicBackground = Color.lerp(widget.backgroundColor, pulseToward, 0.08 * pulse)!;
        final Color surfaceTint = lightBar ? _secondLiquidBottomNavWhiten(dynamicBackground, lightBar: true) : _secondLiquidBottomNavDarkSurface(dynamicBackground);
        final Color barShadow = AppColors.shadow.withValues(alpha: lightBar ? 0.14 : 0.42);
        final bool useBlur = widget.backgroundBlurSigma > 0;
        final double sigma = widget.backgroundBlurSigma;
        final bool showExpandedStyle = expandT > 0.001;
        final double resolvedRadius = lerpDouble(widget.borderRadius, 28, expandT) ?? widget.borderRadius;
        final BorderRadius outerRadius = BorderRadius.circular(resolvedRadius);
        final double edgeW = _secondLiquidBottomNavHairlineWidth(context);
        final Color edgeColor = _secondLiquidBottomNavEdgeColor(surfaceTint, lightBar: lightBar);
        final Widget pillTabs = _SecondLiquidBottomNavPillWithTabs(
          itemCount: widget.items.length,
          activeIndex: widget.activeIndex,
          items: widget.items,
          onIndexChanged: widget.onTap,
          iconSize: widget.iconSize,
          selectedColor: widget.selectedColor,
          unselectedColor: widget.unselectedColor,
          lightBar: lightBar,
          indicatorColor: widget.indicatorColor,
          indicatorBlurSigma: widget.indicatorBlurSigma,
        );
        final LiquidGlassSettings glassSettingsLight = LiquidGlassSettings(
          blur: 30,
          thickness: (sigma * 0.45).clamp(10.0, 18.0),
          glassColor: Color.lerp(surfaceTint, Colors.white, 0.55)!.withValues(alpha: 0.42),
          lightIntensity: .62,
          refractiveIndex: 1.08,
          saturation: 0.5,
          ambientStrength: 0.14,
        );
        final LiquidGlassSettings glassSettingsDark = LiquidGlassSettings(
          blur: (sigma * 0.45).clamp(10.0, 18.0),
          thickness: 0.2,
          glassColor: Color.lerp(surfaceTint, Colors.white, 0.51)!.withValues(alpha: 0.2),
          lightIntensity: 0.42,
          refractiveIndex: 1,
          saturation: 0.2,
          ambientStrength: 0.1,
        );
        final Color innerVeilLight = Color.lerp(surfaceTint, Colors.white, 0.65)!.withValues(alpha: 0.36);
        final Color innerVeilDark = Color.lerp(surfaceTint, const Color(0xFF000000), 0.18)!.withValues(alpha: 0.9);

        final Widget tabRow = SizedBox(
          height: widget.height,
          child: Padding(
            padding: widget.padding,
            child: pillTabs,
          ),
        );
        final double expandHeight = widget.expandedContentHeight ?? 0;
        final Widget? expandedSection = widget.expandedContent != null && expandHeight > 0 && (expandT > 0 || _expandController.isAnimating)
            ? SizedBox(
                height: expandHeight * expandT,
                width: double.infinity,
                child: ClipRect(
                  child: OverflowBox(
                    alignment: Alignment.bottomCenter,
                    minHeight: expandHeight,
                    maxHeight: expandHeight,
                    child: FadeTransition(
                      opacity: _contentOpacity,
                      child: SlideTransition(
                        position: _contentSlide,
                        child: widget.expandedContent!,
                      ),
                    ),
                  ),
                ),
              )
            : null;
        final Widget columnBody = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (expandedSection != null) expandedSection,
            tabRow,
          ],
        );
        final Widget barBody = useBlur
            ? ColoredBox(color: lightBar ? innerVeilLight : innerVeilDark, child: columnBody)
            : columnBody;
        final Widget inner = useBlur
            ? LiquidGlassLayer(
                fake: false,
                useBackdropGroup: true,
                settings: lightBar ? glassSettingsLight : glassSettingsDark,
                child: LiquidGlass(
                  shape: LiquidRoundedSuperellipse(
                    borderRadius: resolvedRadius,
                    side: BorderSide(color: edgeColor, width: edgeW),
                  ),
                  child: barBody,
                ),
              )
            : DecoratedBox(
                decoration: BoxDecoration(
                  color: surfaceTint,
                  border: Border.all(color: edgeColor, width: edgeW),
                  borderRadius: outerRadius,
                ),
                child: barBody,
              );
        final Widget clipped = ClipRRect(borderRadius: BorderRadius.circular(resolvedRadius), child: inner);
        return Transform.scale(
          scale: 1 - (0.006 * pulse),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(resolvedRadius),
              boxShadow: [BoxShadow(color: barShadow, blurRadius: 24 - (1.5 * pulse), spreadRadius: -8, offset: Offset(0, 12 - (0.6 * pulse)))],
            ),
            child: Material(
              type: MaterialType.transparency,
              borderRadius: BorderRadius.circular(resolvedRadius),
              clipBehavior: Clip.none,
              child: clipped,
            ),
          ),
        );
  }
}

class _SecondLiquidBottomNavTab extends StatelessWidget {
  const _SecondLiquidBottomNavTab({required this.item, required this.isSelected, required this.onTap, required this.iconSize, required this.selectedColor, required this.unselectedColor});

  final SecondLiquidBottomNavItem item;
  final bool isSelected;
  final VoidCallback onTap;
  final double iconSize;
  final Color selectedColor;
  final Color unselectedColor;

  @override
  Widget build(BuildContext context) {
    final Color contentColor = isSelected ? selectedColor : unselectedColor;
    final IconData? iconData = item.icon;
    final Widget tabIcon;
    if (item.iconBuilder != null) {
      tabIcon = item.iconBuilder!(context, contentColor, iconSize, isSelected);
    } else {
      final IconData resolved = isSelected ? (item.activeIcon ?? iconData!) : iconData!;
      tabIcon = Icon(resolved, size: iconSize, color: contentColor);
    }
    final Widget content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              tabIcon,
              const SizedBox(height: 2),
              Text(
                item.label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: TextStyle(color: contentColor, fontSize: 9, fontWeight: FontWeight.w500, height: 1),
              ),
            ],
          ),
        ),
      ),
    );

    return Semantics(
      button: true,
      label: item.tooltip ?? item.label,
      child: InkWell(
        // borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        // splashFactory: InkRipple.splashFactory,
        splashColor: contentColor.withValues(alpha: 0.86),
        highlightColor: contentColor.withValues(alpha: 0.88),
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) return contentColor.withValues(alpha: 0.90);
          if (states.contains(WidgetState.hovered)) return contentColor.withValues(alpha: 0.96);
          if (states.contains(WidgetState.focused)) return contentColor.withValues(alpha: 0.98);
          return null;
        }),
        child: SizedBox.expand(child: Center(child: content)),
      ),
    );
  }
}

/// Asosiy 4 tab: [MainBottomNavKitIcons] + [MainBottomNavProfileTabIcon].
/// Brand ranglar uchun: `selectedColor: context.appColors.primary`, `unselectedColor: context.appColors.bottomBarTabUnselected` —
/// yoki barcha ranglarni o‘tmasdan default [secondLiquidBottomNavThemePalette] ishlatiladi.
List<SecondLiquidBottomNavItem> mainAppSecondLiquidBottomNavItems(BuildContext context, {required bool isGuestMode}) {
  final l10n = context.l10n;
  final appColors = context.appColors;
  return [
    SecondLiquidBottomNavItem(label: l10n.mainTabHome, iconBuilder: (_, color, size, selected) => MainBottomNavKitIcons.home(color, size, selected)),
    SecondLiquidBottomNavItem(label: l10n.mainTabCourses, iconBuilder: (_, color, size, selected) => MainBottomNavKitIcons.courses(color, size, selected)),
    SecondLiquidBottomNavItem(label: l10n.mainTabLeaderboard, iconBuilder: (_, color, size, selected) => MainBottomNavKitIcons.leaderboard(color, size, selected)),
    SecondLiquidBottomNavItem(
      label: l10n.mainTabProfile,
      iconBuilder: (_, color, size, selected) =>
          MainBottomNavProfileTabIcon(isGuestMode: isGuestMode, selected: selected, selectedColor: appColors.primary, unselectedColor: appColors.bottomBarTabUnselected, iconSize: size),
    ),
  ];
}
