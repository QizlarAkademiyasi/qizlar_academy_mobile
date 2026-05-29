import 'package:qizlar_academy_kit/ext_shimmer.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/theme_extension.dart';

/// Tarmoq rasm yuklanishi: silliq chiziqli “shimmer” (gradient sweep).
class AppImageShimmer extends StatelessWidget {
  const AppImageShimmer({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
    this.baseColor,
    this.highlightColor,
    this.period = const Duration(milliseconds: 1200),
  });

  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final BoxShape shape;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration period;

  @override
  Widget build(BuildContext context) {
    final defaultBase = context.appColors.onSecondaryContainer;
    final base = baseColor ?? defaultBase;
    final highlight =
        highlightColor ?? Color.lerp(base, context.appColors.background, 0.55) ?? base;

    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: highlight,
      period: period,
      child: _fill(
        child: _inner(base),
      ),
    );
  }

  /// To‘g‘ri o‘lcham — [CachedNetworkImage] placeholder’lari bilan mos.
  Widget _fill({required Widget child}) {
    if (width != null || height != null) {
      return SizedBox(width: width, height: height, child: child);
    }
    return child;
  }

  Widget _inner(Color base) {
    if (shape == BoxShape.circle) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(color: base, shape: BoxShape.circle),
      );
    }
    return DecoratedBox(
      decoration: BoxDecoration(color: base, borderRadius: borderRadius),
      child: const SizedBox.expand(),
    );
  }
}
