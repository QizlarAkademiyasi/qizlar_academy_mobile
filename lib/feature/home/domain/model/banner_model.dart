import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

class BannerModel extends Equatable {
  const BannerModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    this.targetId = '',
    this.link = '',
  });

  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final String targetId;
  final String link;

  @override
  List<Object?> get props => [id, title, subtitle, imageUrl, targetId, link];
}
