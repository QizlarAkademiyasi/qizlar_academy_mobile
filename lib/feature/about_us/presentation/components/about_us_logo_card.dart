import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_padding.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

class AboutUsLogoCard extends StatelessWidget {
  const AboutUsLogoCard({super.key, required this.brandTitle});

  final String brandTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppPadding.paddingXl,
      decoration: BoxDecoration(
        color: context.appColors.onContainer,
        borderRadius: AppRadius.radiusLg,
        border: Border.all(color: context.appColors.stroke),
      ),
      child: Padding(
        padding: AppPadding.paddingXl,
        child: UiKitAssets.images.splashLogoSvg.svg(colorFilter: ColorFilter.mode(context.appColors.text, BlendMode.srcIn)),
      ),
    );
  }
}
