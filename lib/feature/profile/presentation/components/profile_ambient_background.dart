import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

/// Profil yuqori qismi uchun Figma blur zonasi (~340px).
class ProfileAmbientBackground extends StatelessWidget {
  const ProfileAmbientBackground({super.key});

  static const double height = 340;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: SizedBox(
        height: height,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: -80,
              top: 0,
              width: 550,
              height: height,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.centerLeft,
                    radius: 1.1,
                    colors: [
                      const Color(0xFFF4CFE1)
                          .withValues(alpha: context.isDarkTheme ? .12 : .55),
                      const Color(0x00F4CFE1),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              right: -80,
              top: -40,
              width: 400,
              height: height + 40,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.topRight,
                    radius: 1.0,
                    colors: [
                      const Color(0xFFEBF6C9)
                          .withValues(alpha: context.isDarkTheme ? .12 : .65),
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
}
