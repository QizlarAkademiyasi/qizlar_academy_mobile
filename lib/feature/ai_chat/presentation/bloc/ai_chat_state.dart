part of 'ai_chat_bloc.dart';

enum AiChatStatus { initial, loading, ready, failure }

class AiChatState extends Equatable {
  const AiChatState({
    this.status = AiChatStatus.initial,
    this.conversationId,
    this.messages = const [],
    this.quickReplies = const [],
    this.isSending = false,
    this.loadError,
    this.sendErrorNonce = 0,
  });

  final AiChatStatus status;
  final String? conversationId;
  final List<AiChatMessageModel> messages;
  final List<AiChatQuickReplyModel> quickReplies;
  final bool isSending;
  final String? loadError;
  final int sendErrorNonce;

  AiChatState copyWith({
    AiChatStatus? status,
    String? conversationId,
    List<AiChatMessageModel>? messages,
    List<AiChatQuickReplyModel>? quickReplies,
    bool? isSending,
    String? loadError,
    bool clearLoadError = false,
    int? sendErrorNonce,
  }) {
    return AiChatState(
      status: status ?? this.status,
      conversationId: conversationId ?? this.conversationId,
      messages: messages ?? this.messages,
      quickReplies: quickReplies ?? this.quickReplies,
      isSending: isSending ?? this.isSending,
      loadError: clearLoadError ? null : loadError ?? this.loadError,
      sendErrorNonce: sendErrorNonce ?? this.sendErrorNonce,
    );
  }

  @override
  List<Object?> get props => [
    status,
    conversationId,
    messages,
    quickReplies,
    isSending,
    loadError,
    sendErrorNonce,
  ];
}
