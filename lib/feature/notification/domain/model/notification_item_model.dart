import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

enum NotificationChannelType { push, global }

extension NotificationChannelTypeX on NotificationChannelType {
  String get apiValue => name;
}

enum NotificationListTab { platform, community }

extension NotificationListTabX on NotificationListTab {
  NotificationChannelType get channelType =>
      this == NotificationListTab.platform
      ? NotificationChannelType.push
      : NotificationChannelType.global;
}

enum NotificationCategory {
  postLiked,
  postCommented,
  commentReplied,
  unknown;

  bool get isPostActivity => this != NotificationCategory.unknown;

  static NotificationCategory fromApi(dynamic raw) {
    return switch (raw?.toString().trim().toUpperCase()) {
      'POST_LIKED' => NotificationCategory.postLiked,
      'POST_COMMENTED' => NotificationCategory.postCommented,
      'COMMENT_REPLIED' => NotificationCategory.commentReplied,
      _ => NotificationCategory.unknown,
    };
  }
}

class NotificationActorModel extends Equatable {
  const NotificationActorModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.photoUrl,
  });

  final String id;
  final String firstName;
  final String lastName;
  final String? photoUrl;

  String get fullName => '$firstName $lastName'.trim();

  @override
  List<Object?> get props => [id, firstName, lastName, photoUrl];
}

class NotificationPostModel extends Equatable {
  const NotificationPostModel({required this.id, this.thumbnailUrl});

  final String id;
  final String? thumbnailUrl;

  @override
  List<Object?> get props => [id, thumbnailUrl];
}

class NotificationPaginationModel extends Equatable {
  const NotificationPaginationModel({
    required this.pageNumber,
    required this.pageSize,
    required this.count,
    required this.pageCount,
  });

  final int pageNumber;
  final int pageSize;
  final int count;
  final int pageCount;

  bool get hasNextPage => pageNumber < pageCount;

  @override
  List<Object?> get props => [pageNumber, pageSize, count, pageCount];
}

class NotificationItemModel extends Equatable {
  const NotificationItemModel({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.channelType,
    required this.isRead,
    this.avatarUrl,
    this.targetId,
    this.category = NotificationCategory.unknown,
    this.actors = const [],
    this.post,
  });

  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  final NotificationChannelType channelType;
  final bool isRead;
  final String? avatarUrl;
  final String? targetId;
  final NotificationCategory category;
  final List<NotificationActorModel> actors;
  final NotificationPostModel? post;

  bool get isPostActivity => category.isPostActivity;
  String get listText => isPostActivity && description.trim().isNotEmpty
      ? description
      : title;
  String? get destinationPostId {
    final postId = post?.id.trim() ?? '';
    if (postId.isNotEmpty) return postId;
    final fallback = targetId?.trim() ?? '';
    return fallback.isEmpty ? null : fallback;
  }

  NotificationItemModel copyWith({bool? isRead}) {
    return NotificationItemModel(
      id: id,
      title: title,
      description: description,
      createdAt: createdAt,
      channelType: channelType,
      isRead: isRead ?? this.isRead,
      avatarUrl: avatarUrl,
      targetId: targetId,
      category: category,
      actors: actors,
      post: post,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    createdAt,
    channelType,
    isRead,
    avatarUrl,
    targetId,
    category,
    actors,
    post,
  ];
}

class NotificationPageModel extends Equatable {
  const NotificationPageModel({required this.items, required this.pagination});

  final List<NotificationItemModel> items;
  final NotificationPaginationModel pagination;

  @override
  List<Object?> get props => [items, pagination];
}

class NotificationSectionModel extends Equatable {
  const NotificationSectionModel({required this.title, required this.items});

  final String title;
  final List<NotificationItemModel> items;

  @override
  List<Object?> get props => [title, items];
}
