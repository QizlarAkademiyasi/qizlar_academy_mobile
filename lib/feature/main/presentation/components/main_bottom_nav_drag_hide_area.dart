import 'dart:math' as math;

import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/colors.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/theme_extension.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/feature/main/presentation/components/liquid_bottom_nav_second.dart';

/// Holatni almashtirish uchun drag qancha o'tishi kerak (bar balandligiga nisbatan).
const double _mainBottomNavDismissFraction = 0.16;

/// Dismiss masofasining yuqori chegarasi (piksel) — baland barda ham qisqa qoladi.
const double _mainBottomNavDismissDistanceMax = 22;

/// Fling deb hisoblanadigan tezlik (piksel/sekund).
const double _mainBottomNavHideVelocity = 180;

/// Bar hali o'lchanmaganda ishlatiladigan zaxira balandlik.
const double _mainBottomNavFallbackExtent = 120;

/// Soya ham ekran ostida qolishi uchun qo'shimcha siljish.
const double _mainBottomNavHideSlack = 16;

/// Grabber shu progressdan keyin ko'rina boshlaydi.
const double _mainBottomNavHandleRevealStart = 0.6;

const CupertinoMotion _mainBottomNavHideMotion = CupertinoMotion.smooth(
  duration: Duration(milliseconds: 420),
  extraBounce: 0.12,
  snapToEnd: true,
);

/// Pastga dismiss harakati aniqlanganda [MainBottomNavDragHideArea.onDismissIntent]
/// ga beriladigan ma'lumot.
class MainBottomNavDragDismissDetails {
  const MainBottomNavDragDismissDetails({
    required this.travel,
    required this.velocityY,
  });

  /// Drag boshlangan nuqtadan qo'yib yuborilgunga qadar bosib o'tilgan masofa.
  final double travel;

  final double velocityY;
}

/// Dismiss harakatini bar yashirilishidan oldin qabul qilib olish uchun.
/// `true` qaytsa bar joyida qoladi.
typedef MainBottomNavDragDismissHandler =
    bool Function(MainBottomNavDragDismissDetails details);

/// Pastki navigatsiyani (va u bilan birga AI Chat pillini) vertikal drag orqali
/// ekran ostiga yashiradi; yashiringanda pastda grabber chiqadi va uni bosish
/// yoki yuqoriga tortish barni qaytaradi.
class MainBottomNavDragHideArea extends StatefulWidget {
  const MainBottomNavDragHideArea({
    super.key,
    required this.navigation,
    this.navigationOffset = Offset.zero,
    this.floatingPill,
    this.onDismissIntent,
  });

  final Widget navigation;

  /// Platformaga qarab barga qo'llanadigan mavjud siljish.
  final Offset navigationOffset;

  /// Bar ustidagi overlay (`Positioned` qaytaruvchi widget) — bar bilan birga yo'qoladi.
  final Widget? floatingPill;

  /// Pastga dismiss aniqlanganda bar yashirilishidan oldin chaqiriladi —
  /// masalan ochiq modal sheetni yopish uchun.
  final MainBottomNavDragDismissHandler? onDismissIntent;

  @override
  State<MainBottomNavDragHideArea> createState() =>
      _MainBottomNavDragHideAreaState();
}

class _MainBottomNavDragHideAreaState extends State<MainBottomNavDragHideArea> {
  final GlobalKey _navigationKey = GlobalKey();

  double _extent = _mainBottomNavFallbackExtent;
  double _targetDy = 0;
  double? _dragDy;
  double _dragOriginDy = 0;
  double? _releaseFromDy;
  int _motionKey = 0;
  bool _extentSyncScheduled = false;

  bool get _isHidden => _targetDy > 0;

  /// Sheet kabi: holatni almashtirish uchun uzun emas, qisqa siljish yetarli.
  double get _dismissDistance => math.min(
    _extent * _mainBottomNavDismissFraction,
    _mainBottomNavDismissDistanceMax,
  );

  @override
  void initState() {
    super.initState();
    _scheduleExtentSync();
  }

  void _scheduleExtentSync() {
    if (_extentSyncScheduled) return;
    _extentSyncScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _extentSyncScheduled = false;
      if (!mounted) return;
      final RenderObject? renderObject = _navigationKey.currentContext
          ?.findRenderObject();
      if (renderObject is! RenderBox || !renderObject.hasSize) return;
      final double measured = renderObject.size.height + _mainBottomNavHideSlack;
      if (measured <= 0 || (measured - _extent).abs() < 0.5) return;
      setState(() {
        _extent = measured;
        if (_isHidden) {
          _targetDy = measured;
        }
      });
    });
  }

  void _onDragStart(DragStartDetails details) {
    setState(() {
      _dragOriginDy = _targetDy;
      _dragDy = _targetDy;
    });
  }

  void _onDragUpdate(DragUpdateDetails details) {
    final double current = _dragDy ?? _targetDy;
    setState(() {
      _dragDy = (current + details.delta.dy).clamp(0.0, _extent);
    });
  }

  void _onDragEnd(DragEndDetails details) {
    final double released = _dragDy ?? _targetDy;
    final double travel = released - _dragOriginDy;
    final double velocity = details.velocity.pixelsPerSecond.dy;
    final bool hidden;
    if (velocity > _mainBottomNavHideVelocity) {
      hidden = true;
    } else if (velocity < -_mainBottomNavHideVelocity) {
      hidden = false;
    } else if (travel.abs() >= _dismissDistance) {
      hidden = travel > 0;
    } else {
      hidden = _isHidden;
    }

    // Ochiq modal sheet bar yashirilishidan ustun: u yopilsa bar joyida qoladi.
    final handler = widget.onDismissIntent;
    if (hidden && !_isHidden && handler != null) {
      final handled = handler(
        MainBottomNavDragDismissDetails(travel: travel, velocityY: velocity),
      );
      if (handled) {
        _settle(hidden: false, from: released);
        return;
      }
    }

    _settle(hidden: hidden, from: released);
  }

  void _onDragCancel() {
    _settle(hidden: _isHidden, from: _dragDy ?? _targetDy);
  }

  void _reveal() => _settle(hidden: false, from: _dragDy ?? _targetDy);

  void _settle({required bool hidden, required double from}) {
    if (hidden != _isHidden) {
      Gaimon.light();
    }
    setState(() {
      _targetDy = hidden ? _extent : 0;
      _releaseFromDy = from;
      _motionKey += 1;
      _dragDy = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleMotionBuilder(
      key: ValueKey<int>(_motionKey),
      value: _targetDy,
      from: _releaseFromDy,
      motion: _mainBottomNavHideMotion,
      builder: (context, animatedDy, child) {
        // Drag paytida barmoq bilan 1:1, qo'yib yuborilgandan keyin spring —
        // ochilishdagi kichik overshoot ko'rinib turishi uchun manfiy chekka.
        final double dy = _dragDy ?? animatedDy.clamp(-6.0, _extent);
        final double progress = _extent > 0
            ? (dy / _extent).clamp(0.0, 1.0)
            : 0.0;
        return Positioned.fill(
          child: Stack(
            children: [
              Positioned.fill(
                child: Transform.translate(
                  offset: Offset(0, dy),
                  child: Stack(
                    children: [
                      if (widget.floatingPill != null)
                        Positioned.fill(
                          child: IgnorePointer(
                            ignoring: progress > 0.02,
                            child: Opacity(
                              opacity: 1 - progress,
                              // `deferToChild` — drag faqat pill ustida boshlanadi,
                              // uning atrofidagi bo'sh joy kontentga tegmaydi.
                              child: _buildDragCatcher(
                                behavior: HitTestBehavior.deferToChild,
                                child: Stack(children: [widget.floatingPill!]),
                              ),
                            ),
                          ),
                        ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Transform.translate(
                          offset: widget.navigationOffset,
                          child: _buildDraggableNavigation(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _MainBottomNavRestoreHandle(
                progress: progress,
                enabled: _isHidden,
                onTap: _reveal,
                onDragStart: _onDragStart,
                onDragUpdate: _onDragUpdate,
                onDragEnd: _onDragEnd,
                onDragCancel: _onDragCancel,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDraggableNavigation() {
    return NotificationListener<SizeChangedLayoutNotification>(
      onNotification: (_) {
        _scheduleExtentSync();
        return false;
      },
      child: SizeChangedLayoutNotifier(
        child: KeyedSubtree(
          key: _navigationKey,
          // `translucent` — bar chetidagi margin va pastki safe-area zonasi ham
          // ushlanadi, ortidagi kontent esa tap'larni olishda davom etadi.
          child: _buildDragCatcher(
            behavior: HitTestBehavior.translucent,
            child: widget.navigation,
          ),
        ),
      ),
    );
  }

  Widget _buildDragCatcher({
    required HitTestBehavior behavior,
    required Widget child,
  }) {
    return GestureDetector(
      behavior: behavior,
      // `down` — touch slop ham siljishga qo'shiladi, shuning uchun bar barmoq
      // bilan 1:1 yuradi va qisqa drag ham dismiss masofasiga yetadi.
      dragStartBehavior: DragStartBehavior.down,
      onVerticalDragStart: _onDragStart,
      onVerticalDragUpdate: _onDragUpdate,
      onVerticalDragEnd: _onDragEnd,
      onVerticalDragCancel: _onDragCancel,
      child: child,
    );
  }
}

/// Bar yashiringanda pastda markazda turadigan tortish tutqichi.
class _MainBottomNavRestoreHandle extends StatelessWidget {
  const _MainBottomNavRestoreHandle({
    required this.progress,
    required this.enabled,
    required this.onTap,
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
    required this.onDragCancel,
  });

  final double progress;
  final bool enabled;
  final VoidCallback onTap;
  final GestureDragStartCallback onDragStart;
  final GestureDragUpdateCallback onDragUpdate;
  final GestureDragEndCallback onDragEnd;
  final GestureDragCancelCallback onDragCancel;

  @override
  Widget build(BuildContext context) {
    final double opacity =
        ((progress - _mainBottomNavHandleRevealStart) /
                (1 - _mainBottomNavHandleRevealStart))
            .clamp(0.0, 1.0);
    if (opacity <= 0) return const SizedBox.shrink();

    final bool isDark = context.isDarkTheme;
    final Color surface = secondLiquidBottomNavSurfaceTint(context);
    return Positioned(
      left: 0,
      right: 0,
      bottom: MediaQuery.paddingOf(context).bottom + 8,
      child: Center(
        child: IgnorePointer(
          ignoring: !enabled,
          child: Opacity(
            opacity: opacity,
            child: Semantics(
              button: true,
              label: context.l10n.mainBottomNavShow,
              child: GestureDetector(
                key: const ValueKey('main-bottom-nav-restore-handle'),
                behavior: HitTestBehavior.opaque,
                dragStartBehavior: DragStartBehavior.down,
                onTap: onTap,
                onVerticalDragStart: onDragStart,
                onVerticalDragUpdate: onDragUpdate,
                onVerticalDragEnd: onDragEnd,
                onVerticalDragCancel: onDragCancel,
                child: Container(
                  width: 72,
                  height: 24,
                  decoration: BoxDecoration(
                    color: surface,
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadow.withValues(
                          alpha: isDark ? 0.42 : 0.18,
                        ),
                        blurRadius: 18,
                        spreadRadius: -6,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: 34,
                      height: 4,
                      decoration: BoxDecoration(
                        color: context.appColors.bottomBarTabUnselected,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
