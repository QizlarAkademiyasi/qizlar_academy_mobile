import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_padding.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

/// Sahifa xato yoki muvaffaqiyatsiz yuklanish holatida ko'rsatiladigan kontent.
/// Ikona, xabar va "Qayta urinish" tugmasi.
class FailureContent extends StatelessWidget {
  const FailureContent({
    super.key,
    this.message,
    required this.onRetry,
    this.retryLabel,
  });

  final String? message;
  final VoidCallback onRetry;
  final String? retryLabel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Center(
      child: Padding(
        padding: AppPadding.paddingXl,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.circleX, color: context.appColors.error, size: 28),
            const SizedBox(height: 10),
            Text(
              message ?? l10n.errorGeneric,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMediumMedium.copyWith(
                color: context.appColors.text,
              ),
            ),
            const SizedBox(height: 14),
            FilledButton(
              onPressed: onRetry,
              child: Text(
                retryLabel ?? l10n.retry,
                style: context.textTheme.bodyMediumMedium.copyWith(
                  color: context.appColors.text,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
