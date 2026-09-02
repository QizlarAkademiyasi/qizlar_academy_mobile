import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/colors.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/theme_extension.dart';

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
    final surface = DecoratedBox(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkOnContainer : AppColors.white,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: edge, width: 0.8),
      ),
      child: Padding(padding: padding, child: child),
    );
    if (onTap == null) return surface;
    return Semantics(
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: surface,
      ),
    );
  }
}
