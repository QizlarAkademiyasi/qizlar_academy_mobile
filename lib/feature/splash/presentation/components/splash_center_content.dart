import 'package:flutter/material.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

/// Splash ekranining markaziy qismi — asosiy logo.
/// `splash_logo.png` o‘lchami 717×165 (keng), kvadrat emas — kenglik va nisbat saqlanadi.
class SplashCenterContent extends StatelessWidget {
  const SplashCenterContent({super.key});

  /// Kit PNG/Pixel ratio ([UiKitAssets.images.splashLogoPng] bilan bir xil nisbat).
  static const double _assetWidth = 717;
  static const double _assetHeight = 165;
  static const double _aspect = _assetWidth / _assetHeight;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final logoW = (w - 48).clamp(210.0, 265.0);
    final logoH = logoW / _aspect;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        UiKitAssets.images.splashLogoSvg.svg(
          width: logoW,
          height: logoH,
          colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
        ),
      ],
    );
  }
}
