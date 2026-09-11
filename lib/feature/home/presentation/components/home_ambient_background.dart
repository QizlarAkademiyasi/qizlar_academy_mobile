import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

class HomeAmbientBackground extends StatelessWidget {
  const HomeAmbientBackground({super.key});
  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: SizedBox(
      height: 440,
      child: Stack(
        children: [
          Positioned(
            left: -100,
            top: 0,
            width: 460,
            height: 440,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    const Color(
                      0xFFF4CFE1,
                    ).withValues(alpha: context.isDarkTheme ? .12 : .65),
                    const Color(0x00F4CFE1),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            right: -100,
            top: -90,
            width: 400,
            height: 430,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    const Color(
                      0xFFEBF6C9,
                    ).withValues(alpha: context.isDarkTheme ? .12 : .75),
                    const Color(0x00EBF6C9),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
