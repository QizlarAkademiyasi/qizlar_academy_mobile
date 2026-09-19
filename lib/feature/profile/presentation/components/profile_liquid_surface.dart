import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/components/home_liquid_action_button.dart';

/// Profil kartalari uchun Home bilan bir xil Liquid Glass qobiq.
class ProfileLiquidSurface extends StatelessWidget {
  const ProfileLiquidSurface({
    super.key,
    required this.child,
    this.borderRadius = 24,
    this.padding,
    this.height,
    this.layerKey,
  });

  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final double? height;
  final Key? layerKey;

  @override
  Widget build(BuildContext context) {
    var content = padding != null ? Padding(padding: padding!, child: child) : child;
    if (height != null) {
      content = SizedBox(height: height, child: content);
    }
    return AppLiquidStretch(
      child: LiquidGlassLayer(
        key: layerKey,
        settings: homeLiquidGlassSettings(context.isDarkTheme),
        child: LiquidGlass(
          shape: LiquidRoundedSuperellipse(borderRadius: borderRadius),
          child: content,
        ),
      ),
    );
  }
}
