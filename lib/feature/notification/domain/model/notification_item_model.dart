import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

enum NotificationSenderType { user, system }

class NotificationItemModel extends Equatable {
  const NotificationItemModel({
    required this.id,
    required this.title,
    required this.description,
    required this.timeLabel,
    required this.createdAt,
    required this.senderType,
    required this.isRead,
    this.avatarUrl,
  });

  final String id;
  final String title;
  final String description;
  final String timeLabel;
  final DateTime createdAt;
  final NotificationSenderType senderType;
  final bool isRead;
  final String? avatarUrl;

  NotificationItemModel copyWith({
    String? id,
    String? title,
    String? description,
    String? timeLabel,
    DateTime? createdAt,
    NotificationSenderType? senderType,
    bool? isRead,
    String? avatarUrl,
  }) {
    return NotificationItemModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      timeLabel: timeLabel ?? this.timeLabel,
      createdAt: createdAt ?? this.createdAt,
      senderType: senderType ?? this.senderType,
      isRead: isRead ?? this.isRead,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    timeLabel,
    createdAt,
    senderType,
    isRead,
    avatarUrl,
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
