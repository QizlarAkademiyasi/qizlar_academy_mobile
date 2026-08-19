import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/model/ai_chat_course_model.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/model/ai_chat_message_model.dart';

class AiChatBootstrapModel extends Equatable {
  const AiChatBootstrapModel({
    required this.conversationId,
    required this.messages,
    this.title,
  });

  final String? conversationId;
  final String? title;
  final List<AiChatMessageModel> messages;

  AiChatBootstrapModel copyWith({List<AiChatMessageModel>? messages}) {
    return AiChatBootstrapModel(
      conversationId: conversationId,
      title: title,
      messages: messages ?? this.messages,
    );
  }

  @override
  List<Object?> get props => [conversationId, title, messages];
}

class AiChatSendResultModel extends Equatable {
  const AiChatSendResultModel({
    required this.conversationId,
    required this.clientMessageId,
    required this.reply,
    this.title,
    this.recommendedCourses = const [],
    this.needsMoreInfo = false,
  });

  final String conversationId;
  final String? title;
  final String clientMessageId;
  final String reply;
  final List<AiChatCourseModel> recommendedCourses;
  final bool needsMoreInfo;

  AiChatMessageModel toAssistantMessage({DateTime? createdAt}) {
    return AiChatMessageModel(
      id: 'assistant-$clientMessageId',
      role: AiChatMessageRole.assistant,
      content: reply,
      createdAt: createdAt ?? DateTime.now(),
      courses: recommendedCourses,
      recommendedCourseIds: recommendedCourses
          .map((course) => course.id)
          .toList(growable: false),
      animateReveal: true,
    );
  }

  @override
  List<Object?> get props => [
    conversationId,
    title,
    clientMessageId,
    reply,
    recommendedCourses,
    needsMoreInfo,
  ];
}
