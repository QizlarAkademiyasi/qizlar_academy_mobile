import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_kit/gen/assets.gen.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/theme_extension.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/model/ai_chat_message_model.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/model/ai_chat_quick_reply_model.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/presentation/components/ai_chat_glass_surface.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/presentation/components/ai_chat_message_bubble.dart';

class AiChatMessageList extends StatelessWidget {
  const AiChatMessageList({
    super.key,
    required this.controller,
    required this.messages,
    required this.quickReplies,
    required this.isSending,
    required this.onCourseTap,
    required this.onQuickReplyTap,
    required this.onRetry,
  });

  final ScrollController controller;
  final List<AiChatMessageModel> messages;
  final List<AiChatQuickReplyModel> quickReplies;
  final bool isSending;
  final ValueChanged<String> onCourseTap;
  final ValueChanged<AiChatQuickReplyModel> onQuickReplyTap;
  final ValueChanged<String> onRetry;

  @override
  Widget build(BuildContext context) {
    final showTyping =
        isSending &&
        messages.isNotEmpty &&
        messages.last.role == AiChatMessageRole.user;
    final showQuickReplies = quickReplies.isNotEmpty && !isSending;
    return ListView.separated(
      key: const ValueKey('ai-chat-message-list'),
      controller: controller,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
      itemCount:
          messages.length + (showTyping ? 1 : 0) + (showQuickReplies ? 1 : 0),
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        if (showQuickReplies && index == messages.length) {
          return Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final reply in quickReplies)
                AiChatGlassSurface(
                  radius: 22,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 11,
                  ),
                  onTap: () => onQuickReplyTap(reply),
                  child: Text(
                    reply.label,
                    style: context.textTheme.bodySmallSemibold.copyWith(
                      color: context.appColors.text,
                    ),
                  ),
                ),
            ],
          );
        }
        if (index == messages.length) {
          return Align(
            alignment: Alignment.centerLeft,
            child: Semantics(
              label: context.l10n.aiChatTyping,
              liveRegion: true,
              child: AiChatGlassSurface(
                radius: 22,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 30,
                      height: 18,
                      child: Lottie.asset(
                        UiKitAssets.lottie.typing,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      context.l10n.aiChatTyping,
                      style: context.textTheme.bodySmallMedium.copyWith(
                        color: context.appColors.secondaryGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        final message = messages[index];
        return AiChatMessageBubble(
          key: ValueKey(message.id),
          message: message,
          onCourseTap: onCourseTap,
          onRetry: () => onRetry(message.id),
        );
      },
    );
  }
}
