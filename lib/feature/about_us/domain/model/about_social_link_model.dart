import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/feature/about_us/domain/model/about_social_platform.dart';

class AboutSocialLinkModel extends Equatable {
  const AboutSocialLinkModel({required this.platform, required this.url});

  final AboutSocialPlatform platform;
  final String url;

  @override
  List<Object?> get props => [platform, url];
}
