import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_padding.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/about_us/domain/model/about_social_platform.dart';

class AboutUsSocialTile extends StatelessWidget {
  const AboutUsSocialTile({super.key, required this.platform, required this.title, required this.subtitle, required this.onTap});

  final AboutSocialPlatform platform;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final style = _iconStyle(platform);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: AppRadius.radiusLg,
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: AppPadding.paddingXl,
          decoration: BoxDecoration(
            color: context.appColors.onContainer,
            borderRadius: AppRadius.radiusLg,
            border: Border.all(color: context.appColors.stroke),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(color: style.background, shape: BoxShape.circle),
                    alignment: Alignment.center,
                    child: style.icon,
                  ),
                  Icon(LucideIcons.squareArrowOutUpRight, size: 18, color: context.appColors.grey),
                ],
              ),
              const SizedBox(height: 14),
              Text(title, style: context.textTheme.heading6.copyWith(color: context.appColors.text)),
              const SizedBox(height: 4),
              Text(subtitle, style: context.textTheme.bodyMediumRegular.copyWith(color: context.appColors.secondaryGrey, height: 1.35)),
            ],
          ),
        ),
      ),
    );
  }

  _SocialIconStyle _iconStyle(AboutSocialPlatform platform) {
    Widget assetIcon(AssetGenImage asset) {
      return asset.image(width: 48, height: 48, fit: BoxFit.fill);
    }

    switch (platform) {
      case AboutSocialPlatform.instagram:
        return _SocialIconStyle(icon: assetIcon(UiKitAssets.images.instagramPng), background: const Color(0x33E4405F));
      case AboutSocialPlatform.telegram:
        return _SocialIconStyle(icon: assetIcon(UiKitAssets.images.telegramPng), background: const Color(0x330088CC));
      case AboutSocialPlatform.youtube:
        return _SocialIconStyle(icon: assetIcon(UiKitAssets.images.youTubePng), background: const Color(0x33FF0000));
    }
  }
}

class _SocialIconStyle {
  const _SocialIconStyle({required this.icon, required this.background});

  final Widget icon;
  final Color background;
}
