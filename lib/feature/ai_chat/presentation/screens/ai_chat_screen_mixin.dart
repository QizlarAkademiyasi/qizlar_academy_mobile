import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/config/router/app_routes.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_toast.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/model/ai_chat_quick_reply_model.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/presentation/bloc/ai_chat_bloc.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/presentation/components/ai_chat_composer.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/presentation/components/ai_chat_header.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/presentation/components/ai_chat_loading_skeleton.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/presentation/components/ai_chat_message_list.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/presentation/components/ai_chat_welcome_content.dart';
import 'package:qizlar_academy_mobile/feature/exception_screens/presentation/components/tgs_failure_content.dart';

mixin AiChatScreenMixin<T extends StatefulWidget> on State<T> {
  late final TextEditingController messageController;
  late final FocusNode messageFocusNode;
  late final ScrollController messagesScrollController;
  int _lastShownSendErrorNonce = 0;

  @override
  void initState() {
    super.initState();
    messageController = TextEditingController();
    messageFocusNode = FocusNode();
    messagesScrollController = ScrollController();
  }

  @override
  void dispose() {
    messageController.dispose();
    messageFocusNode.dispose();
    messagesScrollController.dispose();
    super.dispose();
  }

  void aiChatBlocListener(BuildContext context, AiChatState state) {
    _scrollToLatest();
    if (state.sendErrorNonce > _lastShownSendErrorNonce) {
      _lastShownSendErrorNonce = state.sendErrorNonce;
      AppToast.error(context, message: context.l10n.aiChatSendError);
    }
  }

  void closeAiChat() => context.pop();

  void retryLoad() => context.read<AiChatBloc>().add(const AiChatStarted());

  void sendCurrentMessage() {
    final text = messageController.text.trim();
    if (text.isEmpty) return;
    context.read<AiChatBloc>().add(
      AiChatMessageSubmitted(
        message: text,
        locale: Localizations.localeOf(context).languageCode,
        timezone: DateTime.now().timeZoneName,
      ),
    );
    messageController.clear();
    messageFocusNode.requestFocus();
    _scrollToLatest();
  }

  void sendQuickReply(AiChatQuickReplyModel reply) {
    context.read<AiChatBloc>().add(
      AiChatMessageSubmitted(
        message: reply.prompt,
        locale: Localizations.localeOf(context).languageCode,
        timezone: DateTime.now().timeZoneName,
      ),
    );
  }

  void retryMessage(String messageId) {
    context.read<AiChatBloc>().add(
      AiChatFailedMessageRetried(
        messageId: messageId,
        locale: Localizations.localeOf(context).languageCode,
        timezone: DateTime.now().timeZoneName,
      ),
    );
  }

  void openCourse(String courseId) {
    if (courseId.trim().isEmpty) return;
    messageFocusNode.unfocus();
    context.push(Routes.courseDetails(courseId));
  }

  Widget buildHeader(BuildContext context) =>
      AiChatHeader(onClose: closeAiChat);

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
      AiChatStatus.ready when state.messages.isEmpty => AiChatWelcomeContent(
        quickReplies: state.quickReplies,
        onQuickReplyTap: sendQuickReply,
      ),
      AiChatStatus.ready => AiChatMessageList(
        controller: messagesScrollController,
        messages: state.messages,
        quickReplies: state.quickReplies,
        isSending: state.isSending,
        onCourseTap: openCourse,
        onQuickReplyTap: sendQuickReply,
        onRetry: retryMessage,
      ),
    };
  }

  Widget buildComposer(BuildContext context, AiChatState state) {
    return AiChatComposer(
      controller: messageController,
      focusNode: messageFocusNode,
      isEnabled: state.status == AiChatStatus.ready,
      isSending: state.isSending,
      onSend: sendCurrentMessage,
    );
  }

  void _scrollToLatest() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !messagesScrollController.hasClients) return;
      messagesScrollController.animateTo(
        messagesScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
    });
  }
}
