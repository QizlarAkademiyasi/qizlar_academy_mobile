import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

/// Home AppBar fade rasmi. Joyini o‘zgartirish uchun pastdagi sonlarni tahrirlang.
class HomeAppBarBackground extends StatelessWidget {
  const HomeAppBarBackground({super.key, required this.progress});

  final double progress;

  static const double top = -20;
  static const double left = 0;
  static const double right = 0;
  static const double? bottom = null;
  static const double height = 100;
  static const BoxFit fit = BoxFit.fill;
  static const Alignment alignment = Alignment.topCenter;

  @override
  Widget build(BuildContext context) {
    final opacity = progress.clamp(0.0, 1.0);
    if (opacity <= 0.001) {
      return const SizedBox.expand(
        key: ValueKey('home-app-bar-background-inactive'),
      );
    }

    final asset = context.isDarkTheme
        ? UiKitAssets.appBarBackgounds.backgroundDark
        : UiKitAssets.appBarBackgounds.backgroundLight;

    return IgnorePointer(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            key: const ValueKey('home-app-bar-background'),
            top: top,
            left: left,
            right: right,
            bottom: bottom,
            height: bottom == null ? height : null,
            child: Opacity(
              opacity: opacity,
              child: asset.image(fit: fit, alignment: alignment),
            ),
          ),
        ],
      ),
    );
  }
}
