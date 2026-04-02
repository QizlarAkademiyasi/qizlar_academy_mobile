import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_padding.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

/// Xato holatlarida `.tgs` animatsiya bilan birga ko'rsatiladigan kontent.
class TgsFailureContent extends StatelessWidget {
  const TgsFailureContent({
    super.key,
    this.message,
    required this.onRetry,
    this.retryLabel,
    this.tgsAsset,
    this.animationHeight = 180,
  });

  final String? message;
  final VoidCallback onRetry;
  final String? retryLabel;
  final String? tgsAsset;
  final double animationHeight;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tgsAssetPath = tgsAsset ?? UiKitAssets.lottie.rabbit.cryedRabbit;
    return Center(
      child: Padding(
        padding: AppPadding.paddingXl,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 240,
              height: animationHeight,
              child: Lottie.asset(tgsAssetPath, fit: BoxFit.contain),
            ),
            const SizedBox(height: 12),
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
