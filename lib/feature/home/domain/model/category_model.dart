import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

class StoryModel extends Equatable {
  const StoryModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.thumbnailUrl,
    this.isViewed = false,
  });

  final String id;
  final String name;
  final String imageUrl;
  final String thumbnailUrl;
  final bool isViewed;

  @override
  List<Object?> get props => [id, name, imageUrl, thumbnailUrl, isViewed];
}
