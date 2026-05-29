import 'package:flutter/material.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

/// Xato holatlarida Lottie quyon bilan ko‘rsatish. [AppFailureState] uchun ixcham qoplama.
class TgsFailureContent extends StatelessWidget {
  const TgsFailureContent({super.key, this.message, required this.onRetry, this.retryLabel, this.tgsAsset, this.animationHeight = 180});

  final String? message;
  final VoidCallback onRetry;
  final String? retryLabel;
  final String? tgsAsset;
  final double animationHeight;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppFailureState(
      message: message ?? l10n.errorGeneric,
      onRetry: onRetry,
      retryLabel: retryLabel,
      lottieAssetPath: tgsAsset,
      animationHeight: animationHeight,
    );
  }
}
