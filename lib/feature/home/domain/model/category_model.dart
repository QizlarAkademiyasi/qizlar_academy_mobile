import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

class StoryModel extends Equatable {
  const StoryModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.thumbnailUrl,
  });

  final String id;
  final String name;
  final String imageUrl;
  final String thumbnailUrl;

  @override
  List<Object?> get props => [id, name, imageUrl, thumbnailUrl];
}
