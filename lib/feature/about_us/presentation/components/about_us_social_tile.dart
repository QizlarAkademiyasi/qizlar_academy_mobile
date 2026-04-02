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
          height: 185,
          padding: AppPadding.paddingMd,
          decoration: BoxDecoration(
            color: context.appColors.onContainer,
            borderRadius: AppRadius.radiusLg,
            border: Border.all(color: context.appColors.stroke),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(color: style.background, borderRadius: AppRadius.radiusSm),
                child: Icon(style.icon, color: style.iconColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: context.textTheme.bodyMediumSemibold.copyWith(color: context.appColors.text)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: context.textTheme.bodyXSmallRegular.copyWith(color: context.appColors.secondaryGrey, height: 1.35)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Icon(LucideIcons.squareArrowOutUpRight, size: 18, color: context.appColors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _SocialIconStyle _iconStyle(AboutSocialPlatform platform) {
    switch (platform) {
      case AboutSocialPlatform.instagram:
        return const _SocialIconStyle(icon: LucideIcons.instagram, background: Color(0x33E4405F), iconColor: Color(0xFFE4405F));
      case AboutSocialPlatform.telegram:
        return const _SocialIconStyle(icon: LucideIcons.send, background: Color(0x330088CC), iconColor: Color(0xFF0088CC));
      case AboutSocialPlatform.youtube:
        return const _SocialIconStyle(icon: LucideIcons.youtube, background: Color(0x33FF0000), iconColor: Color(0xFFFF0000));
    }
  }
}

class _SocialIconStyle {
  const _SocialIconStyle({required this.icon, required this.background, required this.iconColor});

  final IconData icon;
  final Color background;
  final Color iconColor;
}
