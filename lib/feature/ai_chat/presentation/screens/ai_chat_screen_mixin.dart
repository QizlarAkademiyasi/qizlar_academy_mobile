import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/colors.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/theme_extension.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/config/router/app_routes.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_toast.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/model/ai_chat_message_model.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/presentation/bloc/ai_chat_bloc.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/presentation/components/ai_chat_bubble_metrics.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/presentation/components/ai_chat_composer.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/presentation/components/ai_chat_header.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/presentation/components/ai_chat_loading_skeleton.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/presentation/components/ai_chat_message_list.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/presentation/components/ai_chat_send_flight.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/presentation/components/ai_chat_side_drawer.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/presentation/components/ai_chat_welcome_content.dart';
import 'package:qizlar_academy_mobile/feature/exception_screens/presentation/components/tgs_failure_content.dart';

class _PendingSendFlight {
  const _PendingSendFlight({
    required this.text,
    required this.sourceRect,
    required this.textStyle,
    required this.bubbleColor,
  });

  final String text;
  final Rect? sourceRect;
  final TextStyle textStyle;
  final Color bubbleColor;
}

mixin AiChatScreenMixin<T extends StatefulWidget>
    on State<T>, TickerProviderStateMixin<T> {
  late final TextEditingController messageController;
  late final FocusNode messageFocusNode;
  late final ScrollController messagesScrollController;
  late final AnimationController drawerController;
  late final AiChatSendFlight _sendFlight;
  final GlobalKey composerInputKey = GlobalKey();
  final GlobalKey flightTargetKey = GlobalKey();
  final Set<String> _settledRevealIds = <String>{};
  int _lastShownSendErrorNonce = 0;
  String? _flyingMessageId;
  _PendingSendFlight? _pendingFlight;

  @override
  void initState() {
    super.initState();
    messageController = TextEditingController();
    messageFocusNode = FocusNode();
    messagesScrollController = ScrollController();
    drawerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 340),
      reverseDuration: const Duration(milliseconds: 280),
    );
    _sendFlight = AiChatSendFlight(this);
  }

  @override
  void dispose() {
    _sendFlight.dispose();
    messageController.dispose();
    messageFocusNode.dispose();
    messagesScrollController.dispose();
    drawerController.dispose();
    super.dispose();
  }

  void aiChatBlocListener(BuildContext context, AiChatState state) {
    if (state.messages.isEmpty) {
      messageController.clear();
      _flyingMessageId = null;
      _pendingFlight = null;
    }
    if (state.sendErrorNonce > _lastShownSendErrorNonce) {
      _lastShownSendErrorNonce = state.sendErrorNonce;
      AppToast.error(context, message: context.l10n.aiChatSendError);
    }
    _maybeStartSendFlight(state);
  }

  bool get isDrawerVisible => drawerController.value > 0.001;

  void openDrawer() {
    messageFocusNode.unfocus();
    drawerController.animateTo(1, curve: Curves.easeOutCubic);
  }

  void closeDrawer() {
    drawerController.animateBack(0, curve: Curves.easeOutCubic);
  }

  void handleDrawerDragStart(DragStartDetails details) {
    drawerController.stop();
  }

  void handleDrawerDragUpdate(
    DragUpdateDetails details, {
    required double drawerWidth,
  }) {
    final delta = details.primaryDelta ?? 0;
    drawerController.value = (drawerController.value + delta / drawerWidth)
        .clamp(0, 1);
  }

  void handleDrawerDragEnd(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    final shouldOpen = velocity.abs() >= 500
        ? velocity > 0
        : drawerController.value >= 0.5;
    if (shouldOpen) {
      openDrawer();
    } else {
      closeDrawer();
    }
  }

  void handleSystemBack(bool didPop) {
    if (!didPop && isDrawerVisible) closeDrawer();
  }

  void closeAiChat() => context.pop();

  void retryLoad() {
    _settledRevealIds.clear();
    context.read<AiChatBloc>().add(const AiChatStarted());
  }

  void retryConversations() =>
      context.read<AiChatBloc>().add(const AiChatConversationsRequested());

  void loadMoreConversations() => context.read<AiChatBloc>().add(
    const AiChatConversationsLoadMoreRequested(),
  );

  void startNewConversation() {
    closeDrawer();
    _settledRevealIds.clear();
    _flyingMessageId = null;
    _pendingFlight = null;
    _sendFlight.dispose();
    context.read<AiChatBloc>().add(const AiChatNewConversationRequested());
  }

  void selectConversation(String conversationId) {
    closeDrawer();
    final current = context.read<AiChatBloc>().state.conversationId;
    if (current != conversationId) {
      _settledRevealIds.clear();
      _flyingMessageId = null;
      _pendingFlight = null;
      _sendFlight.dispose();
    }
    context.read<AiChatBloc>().add(
      AiChatConversationSelected(conversationId: conversationId),
    );
  }

  void retrySelectedConversation() {
    final conversationId = context.read<AiChatBloc>().state.conversationId;
    if (conversationId == null || conversationId.isEmpty) {
      retryLoad();
      return;
    }
    context.read<AiChatBloc>().add(
      AiChatConversationSelected(conversationId: conversationId),
    );
  }

  void sendCurrentMessage() {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    final inputBox =
        composerInputKey.currentContext?.findRenderObject() as RenderBox?;
    Rect? sourceRect;
    if (inputBox != null && inputBox.hasSize) {
      final origin = inputBox.localToGlobal(Offset.zero);
      final maxWidth = inputBox.size.width;
      final measured = AiChatBubbleMetrics.measureText(
        text: text,
        style: context.textTheme.bodyLargeRegular.copyWith(
          color: context.appColors.text,
          height: 1.35,
        ),
        maxWidth: maxWidth,
      );
      final textTop =
          origin.dy + ((inputBox.size.height - measured.height) / 2);
      sourceRect = AiChatBubbleMetrics.inflateTextRect(
        Rect.fromLTWH(origin.dx, textTop, measured.width, measured.height),
      );
    }

    _pendingFlight = _PendingSendFlight(
      text: text,
      sourceRect: sourceRect,
      textStyle: context.textTheme.bodyLargeMedium.copyWith(
        color: AppColors.white,
        height: 1.35,
      ),
      bubbleColor: context.appColors.primary,
    );

    context.read<AiChatBloc>().add(AiChatMessageSubmitted(message: text));
    messageController.clear();
    messageFocusNode.requestFocus();
    _jumpToLatest();
  }

  void retryMessage(String messageId) {
    context.read<AiChatBloc>().add(
      AiChatFailedMessageRetried(messageId: messageId),
    );
  }

  void followStreamingReply() => _jumpToLatest(onlyIfNearBottom: true);

  void settleMessageReveal(String messageId) {
    _settledRevealIds.add(messageId);
    context.read<AiChatBloc>().add(
      AiChatMessageRevealSettled(messageId: messageId),
    );
  }

  void openCourse(String courseId) {
    if (courseId.trim().isEmpty) return;
    messageFocusNode.unfocus();
    context.push(Routes.courseDetails(courseId));
  }

  Widget buildHeader(BuildContext context, AiChatState state) => AiChatHeader(
    title: state.conversationTitle,
    onOpenDrawer: openDrawer,
    onClose: closeAiChat,
  );

  Widget buildSideDrawer(BuildContext context, AiChatState state) {
    return AiChatSideDrawer(
      progress: drawerController.value,
      canStartNewConversation: state.canStartNewConversation,
      conversations: state.conversations,
      selectedConversationId: state.conversationId,
      isLoadingConversations: state.isLoadingConversations,
      isLoadingMoreConversations: state.isLoadingMoreConversations,
      conversationsLoadFailed: state.conversationsLoadFailed,
      onNewConversation: startNewConversation,
      onSelectConversation: selectConversation,
      onRetryConversations: retryConversations,
      onLoadMoreConversations: loadMoreConversations,
      onCloseChat: closeAiChat,
    );
  }

  Widget buildBody(BuildContext context, AiChatState state) {
    return switch (state.status) {
      AiChatStatus.initial ||
      AiChatStatus.loading => const AiChatLoadingSkeleton(),
      AiChatStatus.failure => Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: TgsFailureContent(
            message: context.l10n.aiChatLoadError,
            onRetry: retryLoad,
            animationHeight: 140,
          ),
        ),
      ),
      AiChatStatus.ready when state.isLoadingConversation =>
        const AiChatLoadingSkeleton(),
      AiChatStatus.ready when state.conversationLoadFailed => Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: TgsFailureContent(
            message: context.l10n.aiChatLoadError,
            onRetry: retrySelectedConversation,
            animationHeight: 140,
          ),
        ),
      ),
      AiChatStatus.ready when state.messages.isEmpty =>
        const AiChatWelcomeContent(),
      AiChatStatus.ready => AiChatMessageList(
        controller: messagesScrollController,
        messages: state.messages,
        isSending: state.isSending,
        flyingMessageId: _flyingMessageId,
        flightTargetKey: flightTargetKey,
        onCourseTap: openCourse,
        onRetry: retryMessage,
        settledRevealIds: _settledRevealIds,
        onRevealSettled: settleMessageReveal,
        onStreamingTick: followStreamingReply,
      ),
    };
  }

  Widget buildComposer(BuildContext context, AiChatState state) {
    return AiChatComposer(
      controller: messageController,
      focusNode: messageFocusNode,
      inputKey: composerInputKey,
      isEnabled:
          state.status == AiChatStatus.ready &&
          !state.isLoadingConversation &&
          !state.conversationLoadFailed,
      isSending: state.isSending,
      onSend: sendCurrentMessage,
    );
  }

  void _maybeStartSendFlight(AiChatState state) {
    final pending = _pendingFlight;
    if (pending == null) return;
    AiChatMessageModel? outgoing;
    for (var index = state.messages.length - 1; index >= 0; index--) {
      final message = state.messages[index];
      if (message.role == AiChatMessageRole.user &&
          message.content == pending.text) {
        outgoing = message;
        break;
      }
    }
    if (outgoing == null) return;
    _pendingFlight = null;
    _flyingMessageId = outgoing.id;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _playSendFlight(pending);
    });
  }

  Future<void> _playSendFlight(_PendingSendFlight pending) async {
    if (!mounted) return;
    final destBox =
        flightTargetKey.currentContext?.findRenderObject() as RenderBox?;
    Rect destRect;
    if (destBox != null && destBox.hasSize) {
      destRect = destBox.localToGlobal(Offset.zero) & destBox.size;
    } else {
      destRect = _estimateDestination(pending.text, pending.textStyle);
    }
    final sourceRect = pending.sourceRect ?? destRect;
    final messages = context.read<AiChatBloc>().state.messages;
    final index = messages.indexWhere(
      (message) => message.id == _flyingMessageId,
    );
    final group = index < 0
        ? const AiChatBubbleGroup(
            isGroupStart: true,
            isGroupEnd: true,
            spacingBefore: 0,
          )
        : AiChatBubbleMetrics.groupingAt(messages, index);
    await _sendFlight.play(
      context: context,
      text: pending.text,
      textStyle: pending.textStyle,
      bubbleColor: pending.bubbleColor,
      sourceRect: sourceRect,
      destRect: destRect,
      endRadius: AiChatBubbleMetrics.outgoing(
        isGroupStart: group.isGroupStart,
        isGroupEnd: group.isGroupEnd,
      ),
    );
    if (!mounted) return;
    setState(() => _flyingMessageId = null);
  }

  Rect _estimateDestination(String text, TextStyle style) {
    final size = MediaQuery.sizeOf(context);
    final maxWidth = size.width * AiChatBubbleMetrics.outgoingMaxWidthFactor;
    final measured = AiChatBubbleMetrics.measureText(
      text: text,
      style: style,
      maxWidth: maxWidth - AiChatBubbleMetrics.textPadding.horizontal,
    );
    final bubble = AiChatBubbleMetrics.inflateTextRect(
      Rect.fromLTWH(0, 0, measured.width, measured.height),
    );
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;
    final bottom =
        size.height - keyboard - 72 - AiChatBubbleMetrics.listBottomPadding;
    final right = size.width - AiChatBubbleMetrics.listInset;
    return Rect.fromLTWH(
      right - bubble.width,
      bottom - bubble.height,
      bubble.width,
      bubble.height,
    );
  }

  void _jumpToLatest({bool onlyIfNearBottom = false}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !messagesScrollController.hasClients) return;
      final position = messagesScrollController.position;
      if (onlyIfNearBottom && position.pixels > 96) return;
      if (position.pixels == 0) return;
      messagesScrollController.jumpTo(0);
    });
  }
}
