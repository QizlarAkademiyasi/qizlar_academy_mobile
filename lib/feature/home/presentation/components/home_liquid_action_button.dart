import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

LiquidGlassSettings homeLiquidGlassSettings(bool isDark) {
  return LiquidGlassSettings(
    glassColor: Colors.white.withValues(alpha: isDark ? 0.12 : 0.28),
    thickness: isDark ? 20 : 18,
    blur: isDark ? 2 : 2,
    chromaticAberration: isDark ? 0.015 : 0.01,
    lightIntensity: isDark ? 0.8 : 0.9,
    ambientStrength: isDark ? 0.2 : 0.32,
    refractiveIndex: isDark ? 1.22 : 1.18,
    saturation: isDark ? 1.12 : 1.15,
  );
}

/// Home toolbar actionlari uchun umumiy iOS 26 Liquid Glass layer.
///
/// Ikki action bir xil fon snapshotidan foydalanadi, lekin [LiquidGlass]
/// surface'lari mustaqil bo'lib qoladi.
class HomeLiquidActionLayer extends StatelessWidget {
  const HomeLiquidActionLayer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LiquidGlassLayer(
      key: const ValueKey('home-liquid-action-layer'),
      settings: homeLiquidGlassSettings(context.isDarkTheme),
      child: child,
    );
  }
}

/// iOS 26 toolbar metrikalaridagi mustaqil circular Liquid Glass action.
class HomeLiquidActionButton extends StatelessWidget {
  const HomeLiquidActionButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.showIndicator = false,
  });

  static const double size = 44;
  static const double iconSize = 20;
  static const double indicatorSize = 8;

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final bool showIndicator;

  @override
  Widget build(BuildContext context) {
    final shadow = context.appColors.shadow.withValues(
      alpha: context.isDarkTheme ? 0.3 : 0.14,
    );

    return Tooltip(
      message: tooltip,
      child: Semantics(
        button: true,
        label: tooltip,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            Gaimon.selection();
            onTap();
          },
          child: AppLiquidStretch.compact(
            child: SizedBox.square(
              dimension: size,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: shadow,
                            blurRadius: 18,
                            spreadRadius: -6,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: LiquidGlass(
                        shape: const LiquidOval(),
                        child: Center(
                          child: Icon(
                            icon,
                            size: iconSize,
                            color: context.appColors.text,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (showIndicator)
                    Positioned(
                      key: const ValueKey('home-notification-indicator'),
                      top: 4,
                      right: 4,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFFF3B30),
                          border: Border.all(
                            color: context.appColors.background.withValues(
                              alpha: 0.9,
                            ),
                            width: 1.5,
                          ),
                        ),
                        child: const SizedBox.square(dimension: indicatorSize),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
