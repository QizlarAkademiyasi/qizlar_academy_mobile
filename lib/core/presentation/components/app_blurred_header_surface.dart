import 'dart:ui' show ImageFilter;

import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/theme_extension.dart';

/// Pinned headerlar uchun umumiy glass fon.
///
/// Scroll kontenti [child] ortidan o'tganda theme foni bilan tintlanib,
/// bir xil blur kuchida ko'rinadi.
class AppBlurredHeaderSurface extends StatelessWidget {
  const AppBlurredHeaderSurface({
    super.key,
    required this.child,
    this.blurSigma = 18,
    this.backgroundOpacity = 0.82,
  });

  final Widget child;
  final double blurSigma;
  final double backgroundOpacity;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: ColoredBox(
          color: context.appColors.background.withValues(
            alpha: backgroundOpacity,
          ),
          child: child,
        ),
      ),
    );
  }
}
