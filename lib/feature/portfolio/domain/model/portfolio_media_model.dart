import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

enum PortfolioMediaType {
  image,
  video;

  static PortfolioMediaType fromApi(String value) {
    return value.trim().toUpperCase() == 'VIDEO' ? video : image;
  }

  String get apiValue => this == video ? 'VIDEO' : 'IMAGE';
}

class PortfolioMediaModel extends Equatable {
  const PortfolioMediaModel({
    required this.id,
    required this.type,
    required this.url,
    required this.thumbnailUrl,
    required this.duration,
    required this.orderIndex,
  });

  final String id;
  final PortfolioMediaType type;
  final String url;
  final String thumbnailUrl;
  final int? duration;
  final int orderIndex;

  bool get isVideo => type == PortfolioMediaType.video;
  String get previewUrl => thumbnailUrl.trim().isNotEmpty ? thumbnailUrl : url;

  @override
  List<Object?> get props => [
    id,
    type,
    url,
    thumbnailUrl,
    duration,
    orderIndex,
  ];
}
