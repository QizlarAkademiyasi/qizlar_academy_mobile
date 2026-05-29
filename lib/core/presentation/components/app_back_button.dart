import 'dart:ui';

import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/router/app_routes.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

enum AppBackButtonType { plain, glass }

/// [AppBackButtonType.plain] uchun: chegarali, to‘liq fon yoki fon/chegara yo‘q (faqat ikonka).
enum AppBackButtonVariant { outlined, filled, ghost }

class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key, this.type = AppBackButtonType.plain, this.variant = AppBackButtonVariant.outlined, this.onTap, this.iconColor, this.icon, this.tooltip});

  const AppBackButton.filled({super.key, this.onTap, this.iconColor, this.icon, this.tooltip}) : type = AppBackButtonType.plain, variant = AppBackButtonVariant.filled;

  /// Fon va chegara yo‘q — faqat ikonka; Material splash / hover va [AppLiquidStretch] yo‘q.
  const AppBackButton.ghost({super.key, this.onTap, this.iconColor, this.icon, this.tooltip}) : type = AppBackButtonType.plain, variant = AppBackButtonVariant.ghost;

  const AppBackButton.glass({super.key, this.onTap, this.iconColor, this.icon, this.tooltip}) : type = AppBackButtonType.glass, variant = AppBackButtonVariant.outlined;

  final AppBackButtonType type;
  final AppBackButtonVariant variant;
  final VoidCallback? onTap;
  final Color? iconColor;

  /// `null` bo‘lsa — [LucideIcons.chevronLeft] (rasmdagi orqaga strelka).
  final IconData? icon;

  final String? tooltip;

  static const double _diameter = 44;
  static const double _iconSize = 22;

  void _handleBack(BuildContext context) {
    if (onTap != null) {
      onTap!();
      return;
    }
    final router = GoRouter.of(context);
    if (router.canPop()) {
      router.pop();
      return;
    }
    router.go(Routes.main);
  }

  @override
  Widget build(BuildContext context) {
    if (type == AppBackButtonType.glass) {
      Widget glass = Bounce(
        onTap: () {
          Gaimon.light();
          _handleBack(context);
        },
        child: ClipOval(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              width: _diameter,
              height: _diameter,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.black.withValues(alpha: 0.22),
                border: Border.all(color: AppColors.white.withValues(alpha: 0.14)),
                shape: BoxShape.circle,
              ),
              child: Icon(icon ?? LucideIcons.arrowLeft, color: iconColor ?? AppColors.white, size: 20),
            ),
          ),
        ),
      );
      if (tooltip != null && tooltip!.isNotEmpty) {
        glass = Tooltip(message: tooltip!, child: glass);
      }
      return glass;
    }

    final stroke = context.appColors.stroke;
    final effectiveIcon = icon ?? LucideIcons.chevronLeft;
    final effectiveIconColor = iconColor ?? context.appColors.text;

    if (variant == AppBackButtonVariant.ghost) {
      Widget ghost = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Gaimon.light();
          _handleBack(context);
        },
        child: SizedBox(
          width: _diameter,
          height: _diameter,
          child: Center(child: Icon(effectiveIcon, color: effectiveIconColor, size: _iconSize)),
        ),
      );
      if (tooltip != null && tooltip!.isNotEmpty) {
        ghost = Tooltip(message: tooltip!, child: ghost);
      }
      return ghost;
    }

    final BoxDecoration inkDecoration = variant == AppBackButtonVariant.filled
        ? BoxDecoration(shape: BoxShape.circle, color: stroke)
        : BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.transparent,
            border: Border.all(color: stroke, width: 1),
          );

    Widget circle = AppLiquidStretch.compact(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Gaimon.light();
            _handleBack(context);
          },
          customBorder: const CircleBorder(),
          child: Ink(
            width: _diameter,
            height: _diameter,
            decoration: inkDecoration,
            child: Icon(effectiveIcon, color: effectiveIconColor, size: _iconSize),
          ),
        ),
      ),
    );

    if (tooltip != null && tooltip!.isNotEmpty) {
      circle = Tooltip(message: tooltip!, child: circle);
    }

    return circle;
  }
}
