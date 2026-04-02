import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

/// Bo'sh holatlar uchun `.tgs` animatsiyali ixcham kontent.
///
/// Statik ikon o'rnida doim [Lottie.asset] orqali quyon `.tgs` ishlatiladi
/// (`UiKitAssets.lottie.rabbit.*`). [subtitle] berilganda [message] sarlavha
/// uslubida, [subtitle] ikkilamchi matn sifatida ko'rinadi.
class TgsEmptyContent extends StatelessWidget {
  const TgsEmptyContent({
    super.key,
    required this.message,
    this.subtitle,
    this.tgsAsset,
    this.animationSize = 72,
  });

  final String message;
  final String? subtitle;
  final String? tgsAsset;
  final double animationSize;

  @override
  Widget build(BuildContext context) {
    final tgsAssetPath = tgsAsset ?? UiKitAssets.lottie.rabbit.boredRabbit;
    final hasSubtitle = subtitle != null && subtitle!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: animationSize,
          height: animationSize,
          child: Lottie.asset(tgsAssetPath, fit: BoxFit.contain),
        ),
        const SizedBox(height: 12),
        Text(
          message,
          textAlign: TextAlign.center,
          style: hasSubtitle
              ? context.textTheme.bodyLargeSemibold.copyWith(
                  color: context.appColors.text,
                )
              : context.textTheme.bodyMediumBold.copyWith(
                  color: context.appColors.grey,
                ),
        ),
        if (hasSubtitle) ...[
          const SizedBox(height: 6),
          Text(
            subtitle!,
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMediumRegular.copyWith(
              color: context.appColors.secondaryGrey,
            ),
          ),
        ],
      ],
    );
  }
}
