import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

/// Bo'sh holatlar uchun `.tgs` animatsiyali ixcham kontent.
class TgsEmptyContent extends StatelessWidget {
  const TgsEmptyContent({
    super.key,
    required this.message,
    this.tgsAsset,
    this.animationSize = 72,
  });

  final String message;
  final String? tgsAsset;
  final double animationSize;

  @override
  Widget build(BuildContext context) {
    final tgsAssetPath = tgsAsset ?? UiKitAssets.lottie.rabbit.boredRabbit;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: animationSize,
          height: animationSize,
          child: Lottie.asset(tgsAssetPath, fit: BoxFit.contain),
        ),
        const SizedBox(height: 12),
        Text(
          message,
          style: context.textTheme.bodyMediumBold.copyWith(
            color: context.appColors.grey,
          ),
        ),
      ],
    );
  }
}
