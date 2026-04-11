import 'package:flutter/material.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

/// [AppFailureState] bilan bir xil ko‘rinish (Lottie + qayta urinish). Eski importlarni buzmaslik uchun saqlanadi.
class FailureContent extends StatelessWidget {
  const FailureContent({super.key, this.message, required this.onRetry, this.retryLabel});

  final String? message;
  final VoidCallback onRetry;
  final String? retryLabel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppFailureState(
      message: message ?? l10n.errorGeneric,
      onRetry: onRetry,
      retryLabel: retryLabel,
    );
  }
}
