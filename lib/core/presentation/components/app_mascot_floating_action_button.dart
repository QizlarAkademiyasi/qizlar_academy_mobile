import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/colors.dart';
import 'package:qizlar_academy_mobile/core/assets/assets.gen.dart';

/// Dumaloq FAB: berilgan Lottie (.tgs) maskot + yorqin fon. Sertifikatlar / jamoat CTA kabi joylar uchun.
class AppMascotFloatingActionButton extends StatelessWidget {
  const AppMascotFloatingActionButton({super.key, required this.onPressed, this.size = 64, this.backgroundColor, this.lottieAssetPath, this.lottiePadding = 0, this.elevation = 8});

  final VoidCallback onPressed;
  final double size;
  final Color? backgroundColor;

  /// `.tgs` uchun to‘liq package path (masalan [UiKitAssets.lottie.rabbit.cuttyRabbit]).
  final String? lottieAssetPath;
  final double lottiePadding;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? AppColors.primary;
    final asset = lottieAssetPath ?? UiKitAssets.lottie.rabbit.cuttyRabbit;
    return Material(
      elevation: elevation,
      shape: const CircleBorder(),
      color: bg,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: size,
          height: size,
          child: Padding(
            padding: EdgeInsets.all(lottiePadding),
            child: Lottie.asset(asset, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}
