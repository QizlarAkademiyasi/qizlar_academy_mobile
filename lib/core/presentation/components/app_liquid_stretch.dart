import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

/// Barmoqni bosganda yengil kichrayish va tortganda shaklni shu yo‘nalishda “suyultirish”.
///
/// Istalgan [child] ustiga o‘raydi; [liquid_glass_renderer] [LiquidStretch]ning loyiha
/// sozlamalari bilan o‘ralgani. Pastki truba, plitalar, alohida tugmalar kabi UI uchun qulay.
class AppLiquidStretch extends StatelessWidget {
  const AppLiquidStretch({
    super.key,
    required this.child,
    this.stretch = 0.56,
    this.resistance = 0.052,
    this.interactionScale = 0.982,
    this.hitTestBehavior = HitTestBehavior.translucent,
  });

  /// Kichik elementlar (ikona, qo‘shimcha action) — cho‘zilish biroz yengil, bosilish sezilarli.
  factory AppLiquidStretch.compact({Key? key, required Widget child}) {
    return AppLiquidStretch(
      key: key,
      stretch: 0.42,
      resistance: 0.06,
      interactionScale: 0.975,
      child: child,
    );
  }

  final Widget child;
  final double stretch;
  final double resistance;
  final double interactionScale;
  final HitTestBehavior hitTestBehavior;

  @override
  Widget build(BuildContext context) {
    return LiquidStretch(
      stretch: stretch,
      resistance: resistance,
      interactionScale: interactionScale,
      hitTestBehavior: hitTestBehavior,
      child: child,
    );
  }
}
