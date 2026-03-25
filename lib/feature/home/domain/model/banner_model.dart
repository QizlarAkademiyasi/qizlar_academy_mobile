import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

class BannerModel extends Equatable {
  const BannerModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  });

  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;

  @override
  List<Object?> get props => [id, title, subtitle, imageUrl];
}

