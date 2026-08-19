part of 'ai_chat_bloc.dart';

enum AiChatStatus { initial, loading, ready, failure }

class AiChatState extends Equatable {
  const AiChatState({
    this.status = AiChatStatus.initial,
    this.conversationId,
    this.conversationTitle,
    this.messages = const [],
    this.conversations = const [],
    this.conversationsPage = 1,
    this.conversationsHasMore = false,
    this.isSending = false,
    this.isLoadingConversation = false,
    this.isLoadingConversations = false,
    this.isLoadingMoreConversations = false,
    this.conversationLoadFailed = false,
    this.conversationsLoadFailed = false,
    this.loadError,
    this.sendErrorNonce = 0,
  });

  final AiChatStatus status;
  final String? conversationId;
  final String? conversationTitle;
  final List<AiChatMessageModel> messages;
  final List<AiChatConversationModel> conversations;
  final int conversationsPage;
  final bool conversationsHasMore;
  final bool isSending;
  final bool isLoadingConversation;
  final bool isLoadingConversations;
  final bool isLoadingMoreConversations;
  final bool conversationLoadFailed;
  final bool conversationsLoadFailed;
  final String? loadError;
  final int sendErrorNonce;

  bool get isBusy => isSending || isLoadingConversation;

  bool get canStartNewConversation =>
      status == AiChatStatus.ready &&
      !isBusy &&
      (conversationId != null || messages.isNotEmpty);

  AiChatState copyWith({
    AiChatStatus? status,
    String? conversationId,
    String? conversationTitle,
    List<AiChatMessageModel>? messages,
    List<AiChatConversationModel>? conversations,
    int? conversationsPage,
    bool? conversationsHasMore,
    bool? isSending,
    bool? isLoadingConversation,
    bool? isLoadingConversations,
    bool? isLoadingMoreConversations,
    bool? conversationLoadFailed,
    bool? conversationsLoadFailed,
    String? loadError,
    bool clearLoadError = false,
    bool clearConversation = false,
    bool clearConversationTitle = false,
    int? sendErrorNonce,
  }) {
    return AiChatState(
      status: status ?? this.status,
      conversationId: clearConversation
          ? null
          : conversationId ?? this.conversationId,
      conversationTitle: clearConversation
          ? null
          : clearConversationTitle
          ? conversationTitle
          : conversationTitle ?? this.conversationTitle,
      messages: messages ?? this.messages,
      conversations: conversations ?? this.conversations,
      conversationsPage: conversationsPage ?? this.conversationsPage,
      conversationsHasMore: conversationsHasMore ?? this.conversationsHasMore,
      isSending: isSending ?? this.isSending,
      isLoadingConversation:
          isLoadingConversation ?? this.isLoadingConversation,
      isLoadingConversations:
          isLoadingConversations ?? this.isLoadingConversations,
      isLoadingMoreConversations:
          isLoadingMoreConversations ?? this.isLoadingMoreConversations,
      conversationLoadFailed:
          conversationLoadFailed ?? this.conversationLoadFailed,
      conversationsLoadFailed:
          conversationsLoadFailed ?? this.conversationsLoadFailed,
      loadError: clearLoadError ? null : loadError ?? this.loadError,
      sendErrorNonce: sendErrorNonce ?? this.sendErrorNonce,
    );
  }

  @override
  List<Object?> get props => [
    status,
    conversationId,
    conversationTitle,
    messages,
    conversations,
    conversationsPage,
    conversationsHasMore,
    isSending,
    isLoadingConversation,
    isLoadingConversations,
    isLoadingMoreConversations,
    conversationLoadFailed,
    conversationsLoadFailed,
    loadError,
    sendErrorNonce,
  ];
}
