import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/feature/about_us/domain/model/about_social_link_model.dart';
import 'package:qizlar_academy_mobile/feature/about_us/domain/model/about_supporter_model.dart';

class AboutUsPageModel extends Equatable {
  const AboutUsPageModel({required this.supporters, required this.socialLinks});

  final List<AboutSupporterModel> supporters;
  final List<AboutSocialLinkModel> socialLinks;

  @override
  List<Object?> get props => [supporters, socialLinks];
}
