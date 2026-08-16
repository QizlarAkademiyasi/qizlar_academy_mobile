import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

enum StoryItemType { story, birthday }

class StoryModel extends Equatable {
  const StoryModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.thumbnailUrl,
    this.isViewed = false,
    this.type = StoryItemType.story,
  });

  final String id;
  final String name;
  final String imageUrl;
  final String thumbnailUrl;
  final bool isViewed;
  final StoryItemType type;

  bool get isBirthday => type == StoryItemType.birthday;
  bool get canTrackView =>
      type == StoryItemType.story || type == StoryItemType.birthday;

  @override
  List<Object?> get props => [id, name, imageUrl, thumbnailUrl, isViewed, type];
}
