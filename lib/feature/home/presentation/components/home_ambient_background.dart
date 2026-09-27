import 'dart:ui' show ImageFilter;

import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

class HomeAmbientBackground extends StatelessWidget {
  const HomeAmbientBackground({super.key, this.blurSigma = 90});

  final double blurSigma;

  @override
  Widget build(BuildContext context) {
    final content = SizedBox(
      height: 550,
      child: Stack(
        children: [
          Positioned(
            left: -170,
            top: 0,
            width: 460,
            height: 440,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    const Color(
                      0xFFFF8EBC,
                    ).withValues(alpha: context.isDarkTheme ? .12 : .65),
                    const Color(0x00F4CFE1),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            right: -170,
            top: -90,
            width: 400,
            height: 430,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    const Color(
                      0xFFC6F23F,
                    ).withValues(alpha: context.isDarkTheme ? .12 : .75),
                    const Color(0x00EBF6C9),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    return IgnorePointer(
      child: blurSigma > 0
          ? ImageFiltered(
              imageFilter: ImageFilter.blur(
                sigmaX: blurSigma,
                sigmaY: blurSigma,
              ),
              child: content,
            )
          : content,
    );
  }
}
