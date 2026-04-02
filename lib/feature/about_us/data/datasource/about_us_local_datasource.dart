import 'package:qizlar_academy_mobile/feature/about_us/domain/model/about_social_link_model.dart';
import 'package:qizlar_academy_mobile/feature/about_us/domain/model/about_social_platform.dart';
import 'package:qizlar_academy_mobile/feature/about_us/domain/model/about_supporter_model.dart';
import 'package:qizlar_academy_mobile/feature/about_us/domain/model/about_us_page_model.dart';

/// Statik kontent — keyinchalik API yoki Remote Config bilan almashtirish oson.
class AboutUsLocalDatasource {
  const AboutUsLocalDatasource();

  AboutUsPageModel fetch() {
    return AboutUsPageModel(
      supporters: const [
        AboutSupporterModel(
          id: 'sadulla',
          imageUrl: 'https://gov.uz/_next/image?url=https%3A%2F%2Fapi-portal.gov.uz%2Fuploads%2F64%2F2024%2F02%2F13%2F3a0037b3-815d-39f9-bc08-f7ae8a3b711a_guide_.png&w=128&q=75',
        ),
        AboutSupporterModel(
          id: 'kattaxon',
          imageUrl: 'https://gov.uz/_next/image?url=https%3A%2F%2Fapi-portal.gov.uz%2Fuploads%2F64%2F2025%2F03%2F20%2Fb50fc7bd-383b-77a9-cba0-70626f071061_guide_1002.jpeg&w=1080&q=75',
        ),
      ],
      socialLinks: const [
        AboutSocialLinkModel(platform: AboutSocialPlatform.instagram, url: 'https://www.instagram.com/qizlarakademiyasi'),
        AboutSocialLinkModel(platform: AboutSocialPlatform.telegram, url: 'https://t.me/qizlarakademiyasi'),
        AboutSocialLinkModel(platform: AboutSocialPlatform.youtube, url: 'https://www.youtube.com/@qizlarakademiyasi'),
      ],
    );
  }
}
