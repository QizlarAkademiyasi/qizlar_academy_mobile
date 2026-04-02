import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

/// Ro‘yxat elementlari uchun umumiy stagger (slide + fade) sozlamalari.
/// Boshqarish: [duration], [staggerDelay], [verticalSlideOffset].
abstract final class AppStaggeredListAnimation {
  AppStaggeredListAnimation._();

  static const Duration duration = Duration(milliseconds: 320);
  static const Duration staggerDelay = Duration(milliseconds: 48);
  static const double verticalSlideOffset = 36;
}

/// Scroll ichidagi stagger faqat birinchi frame’da ishlashi uchun.
/// `CustomScrollView` / `ListView` kabi scrollable’ning bevosita ustidagi ota.
class AppStaggeredScrollLimiter extends StatelessWidget {
  const AppStaggeredScrollLimiter({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => AnimationLimiter(child: child);
}

/// [AnimationConfiguration.staggeredList] + pastdan slide + fade — bitta API.
class AppStaggeredListItem extends StatelessWidget {
  const AppStaggeredListItem({
    required this.position,
    required this.child,
    this.duration,
    this.delay,
    this.verticalOffset,
    super.key,
  });

  final int position;
  final Widget child;
  final Duration? duration;
  final Duration? delay;
  final double? verticalOffset;

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredList(
      position: position,
      duration: duration ?? AppStaggeredListAnimation.duration,
      delay: delay ?? AppStaggeredListAnimation.staggerDelay,
      child: SlideAnimation(
        verticalOffset: verticalOffset ?? AppStaggeredListAnimation.verticalSlideOffset,
        child: FadeInAnimation(child: child),
      ),
    );
  }
}
