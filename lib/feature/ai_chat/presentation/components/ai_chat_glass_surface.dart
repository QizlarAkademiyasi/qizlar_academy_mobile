import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/colors.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/theme_extension.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_liquid_stretch.dart';

class AiChatGlassSurface extends StatelessWidget {
  const AiChatGlassSurface({
    super.key,
    required this.child,
    this.radius = 28,
    this.padding = EdgeInsets.zero,
    this.onTap,
  });

  final Widget child;
  final double radius;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkTheme;
    final edge = (isDark ? AppColors.white : AppColors.textDark).withValues(
      alpha: isDark ? 0.22 : 0.12,
    );
    final tint = (isDark ? const Color(0xFF2B2529) : AppColors.white)
        .withValues(alpha: isDark ? 0.40 : 0.62);
    final glass = LiquidGlass.withOwnLayer(
      settings: LiquidGlassSettings(
        blur: 16,
        thickness: isDark ? 6 : 12,
        glassColor: tint,
        lightIntensity: isDark ? 0.38 : 0.58,
        ambientStrength: 0.12,
        refractiveIndex: 1.06,
        saturation: 0.84,
      ),
      shape: LiquidRoundedSuperellipse(
        borderRadius: radius,
        side: BorderSide(color: edge, width: 0.8),
      ),
      child: Padding(padding: padding, child: child),
    );
    if (onTap == null) return glass;
    return Semantics(
      button: true,
      child: AppLiquidStretch(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: glass,
        ),
      ),
    );
  }
}
