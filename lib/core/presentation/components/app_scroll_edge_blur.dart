import 'dart:ui' show ImageFilter, lerpDouble;

import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/theme_extension.dart';

/// iOS 26 Scroll Edge Effect (soft): yuqorida blur, pastga fade.
///
/// [ShaderMask] `dstOut` + [BackdropFilter] tartibi uniform blur ni
/// pastki chetda yo‘qotadi; alohida scrim scaffold rangidan olinadi.
class AppScrollEdgeBlur extends StatelessWidget {
  const AppScrollEdgeBlur({
    super.key,
    required this.progress,
    this.maxSigma = 28,
    this.minSigma = 0,
    this.maxScrimOpacity = 0.92,
    this.minScrimOpacity = 0,
  });

  /// 0 = shaffof, 1 = to‘liq edge effect.
  final double progress;
  final double maxSigma;
  final double minSigma;
  final double maxScrimOpacity;
  final double minScrimOpacity;

  @override
  Widget build(BuildContext context) {
    final t = progress.clamp(0.0, 1.0);
    if (t <= 0.001) return const SizedBox.expand();

    final sigma = lerpDouble(minSigma, maxSigma, t) ?? maxSigma;
    final scrim =
        lerpDouble(minScrimOpacity, maxScrimOpacity, t) ?? maxScrimOpacity;
    final color = context.appColors.background;

    return IgnorePointer(
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRect(
            child: ShaderMask(
              blendMode: BlendMode.dstOut,
              shaderCallback: (bounds) => const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x00000000), Color(0xFF000000)],
                stops: [0.78, 1],
              ).createShader(bounds),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
                child: ColoredBox(
                  color: const Color(0xFFFFFFFF).withValues(alpha: 0.01),
                  child: const SizedBox.expand(),
                ),
              ),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  color.withValues(alpha: scrim),
                  color.withValues(alpha: scrim * 0.78),
                  color.withValues(alpha: 0),
                ],
                stops: const [0.0, 0.72, 1],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
