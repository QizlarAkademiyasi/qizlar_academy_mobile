import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_padding.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/theme_extension.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/assets/assets.gen.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_tablet_max_width.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/primary_button.dart';

/// Umumiy xato / qayta urinish holati. Faqat foydalanuvchiga tushunarli matn ko‘rsating ([message] — odatda `context.l10n.*`).
/// Texnik xabarlar (_Exception_, API matni va hokazo) hech qachon berilmasin.
class AppFailureState extends StatelessWidget {
  const AppFailureState({
    super.key,
    required this.message,
    required this.onRetry,
    this.retryLabel,
    this.lottieAssetPath,
    this.animationWidth = 240,
    this.animationHeight = 180,
    this.illustration,
    this.padding,
  });

  final String message;
  final VoidCallback onRetry;
  final String? retryLabel;
  final String? lottieAssetPath;
  final double animationWidth;
  final double animationHeight;
  final Widget? illustration;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final resolvedIllustration =
        illustration ??
        SizedBox(
          width: animationWidth,
          height: animationHeight,
          child: Lottie.asset(lottieAssetPath ?? UiKitAssets.lottie.rabbit.cryedRabbit, fit: BoxFit.contain),
        );

    return Center(
      child: AppTabletMaxWidth(
        child: Padding(
          padding: padding ?? AppPadding.paddingXl,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              resolvedIllustration,
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: context.textTheme.bodyMediumMedium.copyWith(color: context.appColors.text),
              ),
              const SizedBox(height: 14),
              PrimaryButton.elevated(label: retryLabel ?? l10n.retry, onPressed: onRetry),
            ],
          ),
        ),
      ),
    );
  }
}
