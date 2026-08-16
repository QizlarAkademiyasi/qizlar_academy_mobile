import 'dart:math' as math;
import 'dart:ui' show ImageFilter, lerpDouble;

import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/colors.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/theme_extension.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_liquid_stretch.dart';
import 'package:qizlar_academy_mobile/feature/main/presentation/components/main_bottom_nav_kit_icons.dart';
import 'package:qizlar_academy_mobile/feature/main/presentation/components/main_bottom_nav_profile_tab_icon.dart';
import 'package:qizlar_academy_mobile/feature/main/presentation/components/main_extra_menu_items.dart';

Color _secondLiquidBottomNavWhiten(Color base, {required bool lightBar}) {
  return Color.lerp(base, const Color(0xFFFFFFFF), lightBar ? 0.38 : 0.72)!;
}

/// Dark truba: biroz yoritilgan qora/kulrang sirt (oq emas).
Color _secondLiquidBottomNavDarkSurface(Color base) {
  return Color.lerp(base, const Color(0xFF3A3A3C), 0.28)!;
}

/// Kengaygan grid va tashqi komponentlar uchun truba sirt rangi.
Color secondLiquidBottomNavSurfaceTint(
  BuildContext context, {
  Color? backgroundColor,
}) {
  final Color base =
      backgroundColor ??
      secondLiquidBottomNavThemePalette(context).backgroundColor;
  final bool lightBar = base.computeLuminance() > 0.5;
  return lightBar
      ? _secondLiquidBottomNavWhiten(base, lightBar: true)
      : _secondLiquidBottomNavDarkSurface(base);
}

/// Grid kafel fon — truba sirtidan biroz farq qiladi (ajratish uchun).
Color secondLiquidBottomNavTileSurface(
  BuildContext context, {
  Color? backgroundColor,
}) {
  final Color surface = secondLiquidBottomNavSurfaceTint(
    context,
    backgroundColor: backgroundColor,
  );
  final bool lightBar =
      (backgroundColor ??
              secondLiquidBottomNavThemePalette(context).backgroundColor)
          .computeLuminance() >
      0.5;
  return Color.lerp(
    surface,
    lightBar ? const Color(0xFF000000) : const Color(0xFFFFFFFF),
    lightBar ? 0.05 : 0.1,
  )!;
}

/// Chiziq qalinligi: pikselga mos ince hairline.
double _secondLiquidBottomNavHairlineWidth(BuildContext context) {
  final double dpr = MediaQuery.devicePixelRatioOf(context);
  return (1.0 / dpr).clamp(0.5, 1.0);
}

/// Truba / extra chegarasi — `surfaceTint` va light/dark bar bilan mos, `stroke` temadan emas.
Color _secondLiquidBottomNavEdgeColor(
  Color surfaceTint, {
  required bool lightBar,
}) {
  if (lightBar) {
    return Color.lerp(
      surfaceTint,
      const Color.fromARGB(255, 232, 232, 232),
      0.5,
    )!;
  }
  return Color.lerp(
    surfaceTint,
    const Color.fromARGB(255, 158, 158, 158),
    0.2,
  )!;
}

LiquidGlassSettings _secondLiquidBottomNavGlassSettings({
  required Color surfaceTint,
  required bool lightBar,
  required double blurSigma,
  bool isActive = false,
}) {
  final Color tint = lightBar
      ? Color.lerp(surfaceTint, AppColors.white, 0.7)!
      : Color.lerp(surfaceTint, const Color(0xFF48484A), 0.2)!;
  return LiquidGlassSettings(
    blur: blurSigma.clamp(14.0, 30.0),
    thickness: (lightBar ? 14.0 : 10.0) + (isActive ? 1.5 : 0),
    glassColor: tint.withValues(
      alpha: lightBar ? (isActive ? 0.44 : 0.36) : (isActive ? 0.46 : 0.38),
    ),
    lightIntensity: lightBar ? 0.68 : 0.48,
    ambientStrength: lightBar ? 0.15 : 0.11,
    refractiveIndex: lightBar ? 1.09 : 1.07,
    saturation: lightBar ? 0.92 : 0.82,
    chromaticAberration: 0.006,
  );
}

const double _secondLiquidBottomNavIndicatorInset = 2;
const double _secondLiquidBottomNavExpandedVisualRadius = 28;
const double _secondLiquidBottomNavContentRevealStart = 0.22;
const double _secondLiquidBottomNavContentRevealEnd = 0.88;
const CupertinoMotion _secondLiquidBottomNavFlowMotion = CupertinoMotion.snappy(
  duration: Duration(milliseconds: 400),
  extraBounce: 0.2,
  snapToEnd: true,
);
const CupertinoMotion _secondLiquidBottomNavMinimizeMotion =
    CupertinoMotion.smooth(
      duration: Duration(milliseconds: 560),
      extraBounce: 0.18,
      snapToEnd: true,
    );

/// Indikator yoyini kengaygan barning tashqi burchagidan xavfsiz masofada saqlaydi.
/// Radius `height` va `padding`dan hisoblangani uchun custom o'lchamlarda ham kesishmaydi.
double _secondLiquidBottomNavSafeExpandedRadius({
  required double height,
  required EdgeInsets padding,
}) {
  final double indicatorHeight = math.max(
    0,
    height - padding.vertical - (_secondLiquidBottomNavIndicatorInset * 2),
  );
  final double indicatorRadius = indicatorHeight / 2;
  final double largestPadding = math.max(
    math.max(padding.left, padding.right),
    math.max(padding.top, padding.bottom),
  );
  final double concentricRadius =
      indicatorRadius + largestPadding + _secondLiquidBottomNavIndicatorInset;
  return math.max(_secondLiquidBottomNavExpandedVisualRadius, concentricRadius);
}

double _secondLiquidBottomNavPulseFromProgress(double value) {
  final double t = value - value.floorToDouble();
  final double pulse = 1 - ((t - 0.5).abs() * 2);
  return pulse.clamp(0.0, 1.0).toDouble();
}

/// Surilmali indikator pill: rang [baseColor] dan biroz ochroq, blur yoqilganda shisha qatlami.
Widget _secondLiquidBottomNavSlidingIndicator({
  required double x,
  required double width,
  required Color baseColor,
  required bool lightBar,
  required double indicatorBlurSigma,
}) {
  final bool useIndBlur = indicatorBlurSigma > 0;
  final Color softer = lightBar
      ? Color.lerp(
          Color.lerp(baseColor, const Color.fromARGB(255, 0, 0, 0), 0.12)!,
          Colors.white,
          0.22,
        )!
      : Color.lerp(baseColor, const Color(0xFF8E8E93), 0.38)!;
  if (useIndBlur) {
    return Transform.translate(
      offset: Offset(x, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(999),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: indicatorBlurSigma,
            sigmaY: indicatorBlurSigma,
          ),
          child: Container(
            width: width,
            margin: const EdgeInsets.symmetric(
              vertical: _secondLiquidBottomNavIndicatorInset,
            ),
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
      margin: const EdgeInsets.symmetric(
        vertical: _secondLiquidBottomNavIndicatorInset,
      ),
      decoration: BoxDecoration(
        color: softer,
        borderRadius: BorderRadius.circular(999),
      ),
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
    final Color surface = lightBar
        ? _secondLiquidBottomNavWhiten(backgroundColor, lightBar: true)
        : _secondLiquidBottomNavDarkSurface(backgroundColor);
    final Color barShadow = AppColors.shadow.withValues(
      alpha: lightBar ? 0.18 : 0.42,
    );
    final BorderRadius pill = BorderRadius.circular(999);
    final double edgeW = _secondLiquidBottomNavHairlineWidth(context);
    final Color edgeColor = _secondLiquidBottomNavEdgeColor(
      surface,
      lightBar: lightBar,
    );
    final inner = SizedBox(
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
              duration: const Duration(milliseconds: 420),
              reverseDuration: const Duration(milliseconds: 360),
              switchInCurve: const Cubic(0.16, 1, 0.3, 1),
              switchOutCurve: const Cubic(0.4, 0, 0.7, 1),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return RotationTransition(
                  turns: Tween<double>(begin: 0.18, end: 0).animate(animation),
                  child: FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(
                      scale: Tween<double>(
                        begin: 0.86,
                        end: 1,
                      ).animate(animation),
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
    );
    final Widget glassSurface = useBlur
        ? LiquidGlass.withOwnLayer(
            key: const ValueKey('second-bottom-nav-extra-liquid-glass'),
            settings: _secondLiquidBottomNavGlassSettings(
              surfaceTint: surface,
              lightBar: lightBar,
              blurSigma: backgroundBlurSigma,
              isActive: isActive,
            ),
            shape: LiquidRoundedSuperellipse(
              borderRadius: height / 2,
              side: BorderSide(color: edgeColor, width: edgeW),
            ),
            child: ColoredBox(
              color: (lightBar ? AppColors.white : AppColors.black).withValues(
                alpha: lightBar ? 0.06 : 0.14,
              ),
              child: inner,
            ),
          )
        : DecoratedBox(
            decoration: BoxDecoration(
              color: surface,
              border: Border.all(color: edgeColor, width: edgeW),
              borderRadius: pill,
            ),
            child: inner,
          );
    final Widget button = Semantics(
      button: true,
      label: semanticLabel ?? 'Menu',
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: pill,
          boxShadow: [
            BoxShadow(
              color: barShadow,
              blurRadius: lightBar ? 26 : 20,
              spreadRadius: lightBar ? -5 : -6,
              offset: lightBar ? const Offset(0, 9) : const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(borderRadius: pill, child: glassSurface),
      ),
    );
    return button;
  }
}

/// [SecondLiquidBottomNav] ranglari: `Color?` ishlatilganda yoki barcha `null` qoldirilganda
/// [secondLiquidBottomNavThemePalette] yordamida olinadi.
class SecondLiquidBottomNavThemePalette {
  const SecondLiquidBottomNavThemePalette({
    required this.backgroundColor,
    required this.selectedColor,
    required this.unselectedColor,
    required this.indicatorColor,
  });

  final Color backgroundColor;
  final Color selectedColor;
  final Color unselectedColor;
  final Color indicatorColor;
}

/// Light: oqroq truba, surilmali pill, tanlangan (pill ustida) qora, tanlanmagan kulrang.
/// Dark: ko‘tarilgan qora shisha truba, och kulrang pill, tanlangan/ tanlanmagan iOS uslubida.
SecondLiquidBottomNavThemePalette secondLiquidBottomNavThemePalette(
  BuildContext context,
) {
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
  const SecondLiquidBottomNavItem({
    this.icon,
    this.activeIcon,
    this.iconBuilder,
    required this.label,
    this.tooltip,
    this.labelTrailingIcon,
  }) : assert(
         icon != null || iconBuilder != null,
         'SecondLiquidBottomNavItem requires icon or iconBuilder',
       );

  /// [iconBuilder] berilganda [Icon] o‘rniga loyiha SVG/tab widgetlari (masalan, [MainBottomNavKitIcons]) ishlatiladi.
  final IconData? icon;
  final IconData? activeIcon;
  final Widget Function(
    BuildContext context,
    Color color,
    double size,
    bool selected,
  )?
  iconBuilder;
  final String label;
  final String? tooltip;

  /// Tab labelidan keyin tanlangan va tanlanmagan holatda ko‘rinadigan indikator.
  final IconData? labelTrailingIcon;
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
    this.extraActionShowsCloseWhenExpanded = true,
    this.extraButtonSpacing = 12,
    this.extraButtonBottomInset = 0,

    /// Orqa kontent: `backgroundBlurSigma` > 0 bo‘lsa `liquid_glass_renderer` liquid glass; `0` — qattiq `backgroundColor`.
    this.backgroundBlurSigma = 20,

    /// Pill blur: `null` — [backgroundBlurSigma] > 0 bo‘lsa `~0.58` omili; `0` — qattiq pill.
    this.indicatorBlurSigma,

    /// Plus bosilganda truba vertikal kengayadi va [expandedContent] ko‘rsatiladi.
    this.isExpanded = false,
    this.isMinimized = false,
    this.expandedContent,
    this.expandedContentHeight,
  }) : assert(items.length > 1, 'Bottom nav should contain at least 2 items.'),
       assert(
         extraActionIcon == null || onExtraActionTap != null,
         'onExtraActionTap is required when extraActionIcon is set.',
       ),
       assert(
         extraActionIcon == null || extraButton == null,
         'Use extraActionIcon or extraButton, not both.',
       );

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

  /// Kengaygan holatda extra action ikonkasi close ikoniga almashishini boshqaradi.
  final bool extraActionShowsCloseWhenExpanded;

  final double extraButtonSpacing;
  final double extraButtonBottomInset;

  /// Blur kuchlari (sigma). `0` bo‘lsa Liquid Glass o‘rniga qattiq sirt ishlatiladi.
  final double backgroundBlurSigma;

  /// Tanlovdagi pill blur (sigma). [indicatorBlurSigma] orqali alohida sozlash mumkin.
  final double? indicatorBlurSigma;

  /// Truba kengaygan holat (plus menyu ochiq).
  final bool isExpanded;

  /// Scroll vaqtida label va tashqi bo'shliqlarni ixcham ko'rinishga o'tkazadi.
  final bool isMinimized;

  /// Kengaygan qismda ko‘rsatiladigan kontent (masalan, grid menyu).
  final Widget? expandedContent;

  /// [expandedContent] balandligi — animatsiya uchun (masalan, [MainExtraActionGrid.preferredHeightFor]).
  final double? expandedContentHeight;

  @override
  State<SecondLiquidBottomNav> createState() => _SecondLiquidBottomNavState();
}

class _SecondLiquidBottomNavState extends State<SecondLiquidBottomNav> {
  late int _internalIndex;
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
    });
    widget.onChanged?.call(index);
  }

  void _onExtraButtonPointerDown(PointerDownEvent event) {
    setState(() => _extraPulseTick++);
  }

  @override
  Widget build(BuildContext context) {
    final palette = secondLiquidBottomNavThemePalette(context);
    final bool isExpanded = widget.isExpanded && widget.expandedContent != null;
    final bool shouldMinimize = widget.isMinimized && !isExpanded;

    return SingleMotionBuilder(
      value: shouldMinimize ? 1 : 0,
      motion: _secondLiquidBottomNavMinimizeMotion,
      builder: (context, minimizeT, child) {
        return _buildNavigation(
          context,
          palette: palette,
          isExpanded: isExpanded,
          minimizeT: minimizeT,
        );
      },
    );
  }

  Widget _buildNavigation(
    BuildContext context, {
    required SecondLiquidBottomNavThemePalette palette,
    required bool isExpanded,
    required double minimizeT,
  }) {
    // Layoutdagi kichik overshoot spring bounce'ni ko'rsatadi. Opacity va
    // content esa valid diapazonda qolishi uchun alohida settle qilinadi.
    final layoutMinimizeT = minimizeT.clamp(-0.08, 1.1);
    final settledMinimizeT = minimizeT.clamp(0.0, 1.0);
    final marginMinimizeT = layoutMinimizeT.clamp(0.0, 1.1);
    final compactHeight = math.max(48.0, widget.height - 14);
    final rawHeight =
        lerpDouble(widget.height, compactHeight, layoutMinimizeT) ??
        widget.height;
    final resolvedHeight = math.max(0.0, rawHeight);
    final compactMargin = EdgeInsets.fromLTRB(
      widget.margin.left + 28,
      math.max(0, widget.margin.top - 8),
      widget.margin.right + 28,
      math.max(0, widget.margin.bottom - 8),
    );
    final rawResolvedMargin =
        EdgeInsets.lerp(widget.margin, compactMargin, marginMinimizeT) ??
        widget.margin;
    final resolvedMargin = EdgeInsets.fromLTRB(
      math.max(0.0, rawResolvedMargin.left),
      math.max(0.0, rawResolvedMargin.top),
      math.max(0.0, rawResolvedMargin.right),
      math.max(0.0, rawResolvedMargin.bottom),
    );
    final rawExtraSpacing =
        lerpDouble(widget.extraButtonSpacing, 8, layoutMinimizeT) ??
        widget.extraButtonSpacing;
    final resolvedExtraSpacing = math.max(0.0, rawExtraSpacing);
    final Widget? resolvedExtra = widget.extraActionIcon != null
        ? _SecondLiquidBottomNavExtraIconButton(
            height: resolvedHeight,
            icon: isExpanded && widget.extraActionShowsCloseWhenExpanded
                ? Icons.close
                : widget.extraActionIcon!,
            onTap: widget.onExtraActionTap!,
            backgroundColor: widget.backgroundColor ?? palette.backgroundColor,
            backgroundBlurSigma: widget.backgroundBlurSigma,
            iconColor: widget.unselectedColor ?? palette.unselectedColor,
            semanticLabel: widget.extraActionSemanticLabel,
            isActive: isExpanded,
          )
        : widget.extraButton;
    final bool hasExtraButton = resolvedExtra != null;
    final double resolvedIndicatorSigma =
        widget.indicatorBlurSigma ??
        (widget.backgroundBlurSigma > 0
            ? widget.backgroundBlurSigma * 0.58
            : 0.0);
    return SafeArea(
      top: false,
      child: Padding(
        padding: resolvedMargin,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: AppLiquidStretch(
                stretch: 0.56,
                resistance: 0.052,
                interactionScale: 0.988,
                child: _SecondLiquidBottomNavBarContainer(
                  height: resolvedHeight,
                  borderRadius: widget.borderRadius,
                  backgroundColor:
                      widget.backgroundColor ?? palette.backgroundColor,
                  backgroundBlurSigma: widget.backgroundBlurSigma,
                  indicatorBlurSigma: resolvedIndicatorSigma,
                  padding: widget.padding,
                  items: widget.items,
                  activeIndex: _activeIndex,
                  onTap: _onTap,
                  iconSize: widget.iconSize,
                  selectedColor: widget.selectedColor ?? palette.selectedColor,
                  unselectedColor:
                      widget.unselectedColor ?? palette.unselectedColor,
                  indicatorColor:
                      widget.indicatorColor ?? palette.indicatorColor,
                  minimizeT: settledMinimizeT,
                  isExpanded: isExpanded,
                  expandedContent: widget.expandedContent,
                  expandedContentHeight: widget.expandedContentHeight,
                ),
              ),
            ),
            if (hasExtraButton) ...[
              SizedBox(width: resolvedExtraSpacing),
              Padding(
                padding: EdgeInsets.only(bottom: widget.extraButtonBottomInset),
                child: AppLiquidStretch.compact(
                  child: Listener(
                    behavior: HitTestBehavior.translucent,
                    onPointerDown: _onExtraButtonPointerDown,
                    child: SingleMotionBuilder(
                      value: _extraPulseTick.toDouble(),
                      motion: const CupertinoMotion.smooth(
                        duration: Duration(milliseconds: 440),
                        extraBounce: 0.04,
                      ),
                      builder: (context, animatedTick, child) {
                        final double pulse =
                            _secondLiquidBottomNavPulseFromProgress(
                              animatedTick,
                            );
                        return Transform.scale(
                          scale: 1 - (0.018 * pulse),
                          child: SizedBox(
                            width: resolvedHeight,
                            height: resolvedHeight,
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
    required this.minimizeT,
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
  final double minimizeT;

  @override
  State<_SecondLiquidBottomNavPillWithTabs> createState() =>
      _SecondLiquidBottomNavPillWithTabsState();
}

class _SecondLiquidBottomNavPillWithTabsState
    extends State<_SecondLiquidBottomNavPillWithTabs> {
  bool _dragging = false;
  double? _dragPillX;
  int _pillMotionKey = 0;
  double? _releaseFromX;

  double _minLeft(double itemWidth) => _secondLiquidBottomNavIndicatorInset;
  double _maxLeft(double itemWidth) =>
      (widget.itemCount - 1) * itemWidth + _secondLiquidBottomNavIndicatorInset;

  double _clampPillX(double localDx, double itemWidth, double indicatorWidth) {
    return (localDx - indicatorWidth / 2)
        .clamp(_minLeft(itemWidth), _maxLeft(itemWidth))
        .toDouble();
  }

  int _indexFromPillX(double left, double itemWidth) {
    return ((left - _secondLiquidBottomNavIndicatorInset) / itemWidth)
        .round()
        .clamp(0, widget.itemCount - 1);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double itemWidth = constraints.maxWidth / widget.itemCount;
        final double indicatorWidth =
            itemWidth - (_secondLiquidBottomNavIndicatorInset * 2);
        final double targetX =
            (widget.activeIndex * itemWidth) +
            _secondLiquidBottomNavIndicatorInset;
        return SingleMotionBuilder(
          key: ValueKey(_pillMotionKey),
          value: targetX,
          from: _releaseFromX,
          motion: _secondLiquidBottomNavFlowMotion,
          builder: (context, animatedPillX, child) {
            final double x = _dragging && _dragPillX != null
                ? _dragPillX!
                : animatedPillX;
            final int shownIndex = _dragging && _dragPillX != null
                ? _indexFromPillX(_dragPillX!, itemWidth)
                : widget.activeIndex;

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
                  _dragPillX = _clampPillX(
                    d.localPosition.dx,
                    itemWidth,
                    indicatorWidth,
                  );
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
                var idx = _dragPillX != null
                    ? _indexFromPillX(_dragPillX!, itemWidth)
                    : widget.activeIndex;
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
                          minimizeT: widget.minimizeT,
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
    required this.padding,
    required this.items,
    required this.activeIndex,
    required this.onTap,
    required this.iconSize,
    required this.selectedColor,
    required this.unselectedColor,
    required this.indicatorColor,
    required this.minimizeT,
    this.isExpanded = false,
    this.expandedContent,
    this.expandedContentHeight,
  });

  final double height;
  final double borderRadius;
  final Color backgroundColor;
  final double backgroundBlurSigma;
  final double indicatorBlurSigma;
  final EdgeInsets padding;
  final List<SecondLiquidBottomNavItem> items;
  final int activeIndex;
  final ValueChanged<int> onTap;
  final double iconSize;
  final Color selectedColor;
  final Color unselectedColor;
  final Color indicatorColor;
  final double minimizeT;
  final bool isExpanded;
  final Widget? expandedContent;
  final double? expandedContentHeight;

  @override
  State<_SecondLiquidBottomNavBarContainer> createState() =>
      _SecondLiquidBottomNavBarContainerState();
}

class _SecondLiquidBottomNavBarContainerState
    extends State<_SecondLiquidBottomNavBarContainer> {
  @override
  Widget build(BuildContext context) {
    return SingleMotionBuilder(
      value: widget.isExpanded ? 1 : 0,
      motion: _secondLiquidBottomNavFlowMotion,
      builder: (context, animatedExpandT, child) {
        return _buildBar(context, expandT: animatedExpandT, child: child);
      },
      child: widget.expandedContent,
    );
  }

  Widget _buildBar(
    BuildContext context, {
    required double expandT,
    Widget? child,
  }) {
    final double settledExpandT = expandT.clamp(0.0, 1.0);

    // Spring overshoot layoutda seziladi, lekin grid balandligini buzmasligi
    // uchun vertikal bounce 8% bilan cheklanadi.
    final double layoutExpandT = expandT.clamp(0.0, 1.08);

    // Liquid-glass sirt avval ochiladi, body esa bir necha frame keyin kiradi.
    // Reverse'da buning aksi bo'lib, body background'dan oldin yo'qoladi.
    final double contentT = Curves.easeOutCubic.transform(
      ((settledExpandT - _secondLiquidBottomNavContentRevealStart) /
              (_secondLiquidBottomNavContentRevealEnd -
                  _secondLiquidBottomNavContentRevealStart))
          .clamp(0.0, 1.0),
    );
    final bool lightBar = widget.backgroundColor.computeLuminance() > 0.5;
    final Color surfaceTint = lightBar
        ? _secondLiquidBottomNavWhiten(widget.backgroundColor, lightBar: true)
        : _secondLiquidBottomNavDarkSurface(widget.backgroundColor);
    final Color barShadow = AppColors.shadow.withValues(
      alpha: lightBar ? 0.18 : 0.42,
    );
    final bool useBlur = widget.backgroundBlurSigma > 0;
    final double sigma = widget.backgroundBlurSigma;
    final double safeExpandedRadius = _secondLiquidBottomNavSafeExpandedRadius(
      height: widget.height,
      padding: widget.padding,
    );
    final double resolvedRadius =
        lerpDouble(widget.borderRadius, safeExpandedRadius, settledExpandT) ??
        widget.borderRadius;
    final BorderRadius outerRadius = BorderRadius.circular(resolvedRadius);
    final double edgeW = _secondLiquidBottomNavHairlineWidth(context);
    final Color edgeColor = _secondLiquidBottomNavEdgeColor(
      surfaceTint,
      lightBar: lightBar,
    );
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
      minimizeT: widget.minimizeT,
    );
    final LiquidGlassSettings glassSettings =
        _secondLiquidBottomNavGlassSettings(
          surfaceTint: surfaceTint,
          lightBar: lightBar,
          blurSigma: sigma,
          isActive: widget.isExpanded,
        );

    final Widget tabRow = SizedBox(
      height: widget.height,
      child: Padding(padding: widget.padding, child: pillTabs),
    );
    final double expandHeight = widget.expandedContentHeight ?? 0;
    final Widget? expandedSection =
        widget.expandedContent != null && expandHeight > 0
        ? SizedBox(
            height: expandHeight * layoutExpandT,
            width: double.infinity,
            child: ClipRect(
              child: OverflowBox(
                alignment: Alignment.bottomCenter,
                minHeight: expandHeight,
                maxHeight: expandHeight,
                child: Opacity(
                  opacity: contentT,
                  child: FractionalTranslation(
                    translation: Offset(0, 0.12 * (1 - contentT)),
                    child: child!,
                  ),
                ),
              ),
            ),
          )
        : null;
    final Widget columnBody = Column(
      mainAxisSize: MainAxisSize.min,
      children: [?expandedSection, tabRow],
    );
    final Widget barBody = useBlur
        ? ColoredBox(
            color: (lightBar ? AppColors.white : AppColors.black).withValues(
              alpha: lightBar ? 0.06 : 0.14,
            ),
            child: columnBody,
          )
        : columnBody;
    final Widget inner = useBlur
        ? LiquidGlass.withOwnLayer(
            key: const ValueKey('second-bottom-nav-liquid-glass'),
            settings: glassSettings,
            shape: LiquidRoundedSuperellipse(
              borderRadius: resolvedRadius,
              side: BorderSide(color: edgeColor, width: edgeW),
            ),
            child: barBody,
          )
        : DecoratedBox(
            decoration: BoxDecoration(
              color: surfaceTint,
              border: Border.all(color: edgeColor, width: edgeW),
              borderRadius: outerRadius,
            ),
            child: barBody,
          );
    final Widget clipped = ClipRRect(
      borderRadius: BorderRadius.circular(resolvedRadius),
      child: inner,
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(resolvedRadius),
        boxShadow: [
          BoxShadow(
            color: barShadow,
            blurRadius: lightBar ? 30 : 24,
            spreadRadius: lightBar ? -7 : -8,
            offset: lightBar ? const Offset(0, 10) : const Offset(0, 12),
          ),
        ],
      ),
      child: Material(
        type: MaterialType.transparency,
        borderRadius: BorderRadius.circular(resolvedRadius),
        clipBehavior: Clip.none,
        child: clipped,
      ),
    );
  }
}

class _SecondLiquidBottomNavTab extends StatelessWidget {
  const _SecondLiquidBottomNavTab({
    required this.item,
    required this.isSelected,
    required this.onTap,
    required this.iconSize,
    required this.selectedColor,
    required this.unselectedColor,
    required this.minimizeT,
  });

  final SecondLiquidBottomNavItem item;
  final bool isSelected;
  final VoidCallback onTap;
  final double iconSize;
  final Color selectedColor;
  final Color unselectedColor;
  final double minimizeT;

  @override
  Widget build(BuildContext context) {
    final Color contentColor = isSelected ? selectedColor : unselectedColor;
    final IconData? iconData = item.icon;
    final Widget tabIcon;
    if (item.iconBuilder != null) {
      tabIcon = item.iconBuilder!(context, contentColor, iconSize, isSelected);
    } else {
      final IconData resolved = isSelected
          ? (item.activeIcon ?? iconData!)
          : iconData!;
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
              ClipRect(
                child: Align(
                  heightFactor: 1 - minimizeT,
                  child: Opacity(
                    opacity: 1 - minimizeT,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            item.label,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            style: TextStyle(
                              color: contentColor,
                              fontSize: 9,
                              fontWeight: FontWeight.w500,
                              height: 1,
                            ),
                          ),
                          if (item.labelTrailingIcon != null) ...[
                            const SizedBox(width: 1),
                            Icon(
                              item.labelTrailingIcon,
                              color: contentColor,
                              size: 12,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
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
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        splashFactory: NoSplash.splashFactory,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        child: SizedBox.expand(child: Center(child: content)),
      ),
    );
  }
}

/// Asosiy 4 tab: dastlab More, extra menyudan item tanlangandan keyin esa
/// oxirgi tanlangan item va menu arrowi ko‘rsatiladi.
/// Brand ranglar uchun: `selectedColor: context.appColors.primary`, `unselectedColor: context.appColors.bottomBarTabUnselected` —
/// yoki barcha ranglarni o‘tmasdan default [secondLiquidBottomNavThemePalette] ishlatiladi.
List<SecondLiquidBottomNavItem> mainAppSecondLiquidBottomNavItems(
  BuildContext context, {
  required bool isGuestMode,
  required MainExtraMenuItem? selectedExtraMenuItem,
  bool isProfileMenuExpanded = false,
}) {
  final l10n = context.l10n;
  final appColors = context.appColors;
  final isProfileSelected =
      selectedExtraMenuItem is MainExtraTabMenuItem &&
      selectedExtraMenuItem.tabIndex == kMainProfileTabIndex;
  return [
    SecondLiquidBottomNavItem(
      label: l10n.mainTabHome,
      iconBuilder: (_, color, size, selected) =>
          MainBottomNavKitIcons.home(color, size, selected),
    ),
    SecondLiquidBottomNavItem(
      label: l10n.storeTitle,
      iconBuilder: (_, color, size, selected) =>
          Icon(LucideIcons.store, color: color, size: size),
    ),
    SecondLiquidBottomNavItem(
      label: l10n.mainTabLeaderboard,
      iconBuilder: (_, color, size, selected) =>
          MainBottomNavKitIcons.leaderboard(color, size, selected),
    ),
    if (selectedExtraMenuItem != null)
      SecondLiquidBottomNavItem(
        label: isProfileSelected
            ? l10n.mainTabProfile
            : selectedExtraMenuItem.label,
        labelTrailingIcon: isProfileMenuExpanded
            ? Icons.keyboard_arrow_down_rounded
            : Icons.keyboard_arrow_up_rounded,
        iconBuilder: (_, color, size, selected) => isProfileSelected
            ? MainBottomNavProfileTabIcon(
                isGuestMode: isGuestMode,
                selected: selected,
                selectedColor: appColors.primary,
                unselectedColor: appColors.bottomBarTabUnselected,
                iconSize: size,
              )
            : Icon(selectedExtraMenuItem.icon, color: color, size: size),
      )
    else
      SecondLiquidBottomNavItem(
        label: l10n.mainTabMore,
        iconBuilder: (_, color, size, selected) =>
            Icon(LucideIcons.ellipsis, color: color, size: size),
      ),
  ];
}
