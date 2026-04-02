import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_gap.dart';
import 'package:qizlar_academy_mobile/config/constants/app_padding.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/feature/about_us/domain/model/about_social_platform.dart';
import 'package:qizlar_academy_mobile/feature/about_us/domain/model/about_us_page_model.dart';
import 'package:qizlar_academy_mobile/feature/about_us/presentation/components/about_us_logo_card.dart';
import 'package:qizlar_academy_mobile/feature/about_us/presentation/components/about_us_project_body.dart';
import 'package:qizlar_academy_mobile/feature/about_us/presentation/components/about_us_section_header.dart';
import 'package:qizlar_academy_mobile/feature/about_us/presentation/components/about_us_social_tile.dart';
import 'package:qizlar_academy_mobile/feature/about_us/presentation/components/about_us_supporter_card.dart';

mixin AboutUsScreenMixin<T extends StatefulWidget> on State<T> {
  void onAboutUsBackTap(BuildContext context) {
    Gaimon.light();
    context.pop();
  }

  Future<void> onAboutUsSocialTap(BuildContext context, String url) async {
    Gaimon.light();
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.aboutUsLinkOpenError), behavior: SnackBarBehavior.floating));
    }
  }

  (String name, String role) aboutSupporterCopy(AppLocalizations l10n, String id) {
    switch (id) {
      case 'sadulla':
        return (l10n.aboutSupporterSadullaName, l10n.aboutSupporterSadullaRole);
      case 'kattaxon':
        return (l10n.aboutSupporterKattaxonName, l10n.aboutSupporterKattaxonRole);
      default:
        return ('', '');
    }
  }

  (String title, String subtitle) aboutSocialCopy(AppLocalizations l10n, AboutSocialPlatform platform) {
    switch (platform) {
      case AboutSocialPlatform.instagram:
        return (l10n.aboutSocialInstagramTitle, l10n.aboutSocialInstagramSubtitle);
      case AboutSocialPlatform.telegram:
        return (l10n.aboutSocialTelegramTitle, l10n.aboutSocialTelegramSubtitle);
      case AboutSocialPlatform.youtube:
        return (l10n.aboutSocialYoutubeTitle, l10n.aboutSocialYoutubeSubtitle);
    }
  }

  Widget buildAboutUsBody(BuildContext context, {required AboutUsPageModel model}) {
    final l10n = context.l10n;
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        Padding(
          padding: AppPadding.paddingHorizontalLg,
          child: AboutUsLogoCard(brandTitle: l10n.aboutBrandTitle),
        ),
        const SizedBox(height: AppGap.gapXl),
        Padding(
          padding: AppPadding.paddingHorizontalLg,
          child: AboutUsSectionHeader(title: l10n.aboutSectionProjectTitle),
        ),
        const SizedBox(height: AppGap.gapXl),
        Padding(
          padding: AppPadding.paddingHorizontalLg,
          child: AboutUsProjectBody(lead: l10n.aboutProjectLead, body: l10n.aboutProjectBody),
        ),
        const SizedBox(height: AppGap.gapXl),
        Padding(
          padding: AppPadding.paddingHorizontalLg,
          child: AboutUsSectionHeader(title: l10n.aboutSectionSupportersTitle),
        ),
        const SizedBox(height: AppGap.gapXl),
        SizedBox(
          height: 300,
          child: ListView.separated(
            padding: AppPadding.paddingHorizontalLg,
            scrollDirection: Axis.horizontal,
            itemCount: model.supporters.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final s = model.supporters[index];
              final copy = aboutSupporterCopy(l10n, s.id);
              return AboutUsSupporterCard(name: copy.$1, role: copy.$2, imageUrl: s.imageUrl);
            },
          ),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: AppPadding.paddingHorizontalLg,
          child: AboutUsSectionHeader(title: l10n.aboutSectionSocialTitle),
        ),
        const SizedBox(height: 14),
        ...model.socialLinks.map((link) {
          final copy = aboutSocialCopy(l10n, link.platform);
          return Padding(
            padding: AppPadding.paddingXs,
            child: AboutUsSocialTile(platform: link.platform, title: copy.$1, subtitle: copy.$2, onTap: () => onAboutUsSocialTap(context, link.url)),
          );
        }),
      ],
    );
  }
}
