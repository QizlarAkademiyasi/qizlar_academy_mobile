import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/model/ai_chat_message_model.dart';

class AiChatConversationModel extends Equatable {
  const AiChatConversationModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.title,
  });

  final String id;
  final String? title;
  final DateTime createdAt;
  final DateTime updatedAt;

  AiChatConversationModel copyWith({
    String? title,
    bool clearTitle = false,
    DateTime? updatedAt,
  }) {
    return AiChatConversationModel(
      id: id,
      title: clearTitle ? null : title ?? this.title,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, title, createdAt, updatedAt];
}

class AiChatConversationsPageModel extends Equatable {
  const AiChatConversationsPageModel({
    required this.items,
    required this.pageNumber,
    required this.hasMore,
  });

  final List<AiChatConversationModel> items;
  final int pageNumber;
  final bool hasMore;

  @override
  List<Object?> get props => [items, pageNumber, hasMore];
}

class AiChatMessagesPageModel extends Equatable {
  const AiChatMessagesPageModel({
    required this.messages,
    required this.pageNumber,
    required this.pageCount,
  });

  final List<AiChatMessageModel> messages;
  final int pageNumber;
  final int pageCount;

  @override
  List<Object?> get props => [messages, pageNumber, pageCount];
}
