import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/feature/notification/domain/model/notification_item_model.dart';

class NotificationTopicModel extends Equatable {
  const NotificationTopicModel({
    required this.id,
    required this.topic,
    required this.isSubscribed,
  });

  final String id;
  final String topic;
  final bool isSubscribed;

  NotificationTopicModel copyWith({bool? isSubscribed}) {
    return NotificationTopicModel(
      id: id,
      topic: topic,
      isSubscribed: isSubscribed ?? this.isSubscribed,
    );
  }

  @override
  List<Object?> get props => [id, topic, isSubscribed];
}

class NotificationTopicPageModel extends Equatable {
  const NotificationTopicPageModel({
    required this.items,
    required this.pagination,
  });

  final List<NotificationTopicModel> items;
  final NotificationPaginationModel pagination;

  @override
  List<Object?> get props => [items, pagination];
}
