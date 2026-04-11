import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

/// API `type`: `push` — «Platforma», `global` — «Jamiyat».
enum NotificationChannelType { push, global }

/// Bildirishnomalar ekrani yorlig‘i.
enum NotificationListTab { platform, community }

class NotificationItemModel extends Equatable {
  const NotificationItemModel({
    required this.id,
    required this.title,
    required this.description,
    required this.timeLabel,
    required this.createdAt,
    required this.channelType,
    required this.isRead,
    this.avatarUrl,
    this.targetId,
  });

  final String id;
  final String title;
  final String description;
  final String timeLabel;
  final DateTime createdAt;
  final NotificationChannelType channelType;
  final bool isRead;
  final String? avatarUrl;
  final String? targetId;

  NotificationItemModel copyWith({
    String? id,
    String? title,
    String? description,
    String? timeLabel,
    DateTime? createdAt,
    NotificationChannelType? channelType,
    bool? isRead,
    String? avatarUrl,
    String? targetId,
  }) {
    return NotificationItemModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      timeLabel: timeLabel ?? this.timeLabel,
      createdAt: createdAt ?? this.createdAt,
      channelType: channelType ?? this.channelType,
      isRead: isRead ?? this.isRead,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      targetId: targetId ?? this.targetId,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    timeLabel,
    createdAt,
    channelType,
    isRead,
    avatarUrl,
    targetId,
  ];
}

class NotificationSectionModel extends Equatable {
  const NotificationSectionModel({required this.title, required this.items});

  final String title;
  final List<NotificationItemModel> items;

  NotificationSectionModel copyWith({
    String? title,
    List<NotificationItemModel>? items,
  }) {
    return NotificationSectionModel(
      title: title ?? this.title,
      items: items ?? this.items,
    );
  }

  @override
  List<Object?> get props => [title, items];
}
