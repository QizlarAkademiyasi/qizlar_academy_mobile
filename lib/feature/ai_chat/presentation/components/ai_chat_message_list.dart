import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_kit/gen/assets.gen.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/theme_extension.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/model/ai_chat_message_model.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/presentation/components/ai_chat_bubble_metrics.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/presentation/components/ai_chat_glass_surface.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/presentation/components/ai_chat_message_bubble.dart';

class AiChatMessageList extends StatelessWidget {
  const AiChatMessageList({
    super.key,
    required this.controller,
    required this.messages,
    required this.isSending,
    required this.onCourseTap,
    required this.onRetry,
    this.flyingMessageId,
    this.flightTargetKey,
    this.settledRevealIds,
    this.onRevealSettled,
    this.onStreamingTick,
  });

  final ScrollController controller;
  final List<AiChatMessageModel> messages;
  final bool isSending;
  final ValueChanged<String> onCourseTap;
  final ValueChanged<String> onRetry;
  final String? flyingMessageId;
  final GlobalKey? flightTargetKey;
  final Set<String>? settledRevealIds;
  final ValueChanged<String>? onRevealSettled;
  final VoidCallback? onStreamingTick;

  @override
  Widget build(BuildContext context) {
    final showTyping =
        isSending &&
        messages.isNotEmpty &&
        messages.last.role == AiChatMessageRole.user;
    return ListView.builder(
      key: const ValueKey('ai-chat-message-list'),
      controller: controller,
      reverse: true,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.fromLTRB(
        AiChatBubbleMetrics.listInset,
        AiChatBubbleMetrics.listTopPadding,
        AiChatBubbleMetrics.listInset,
        AiChatBubbleMetrics.listBottomPadding,
      ),
      cacheExtent: 1200,
      itemCount: messages.length + (showTyping ? 1 : 0),
      itemBuilder: (context, index) {
        if (showTyping && index == 0) {
          return const Padding(
            padding: EdgeInsets.only(top: AiChatBubbleMetrics.groupSpacing),
            child: _TypingIndicator(),
          );
        }
        final chronologicalIndex =
            messages.length - 1 - (showTyping ? index - 1 : index);
        final message = messages[chronologicalIndex];
        final group = AiChatBubbleMetrics.groupingAt(
          messages,
          chronologicalIndex,
        );
        return RepaintBoundary(
          child: Padding(
            padding: EdgeInsets.only(top: group.spacingBefore),
            child: _KeepAliveMessage(
              key: ValueKey(message.id),
              child: AiChatMessageBubble(
                message: message,
                isGroupStart: group.isGroupStart,
                isGroupEnd: group.isGroupEnd,
                hideDuringFlight: message.id == flyingMessageId,
                flightTargetKey: message.id == flyingMessageId
                    ? flightTargetKey
                    : null,
                onCourseTap: onCourseTap,
                onRetry: () => onRetry(message.id),
                settledRevealIds: settledRevealIds,
                onRevealSettled: onRevealSettled,
                onStreamingTick: onStreamingTick,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Semantics(
        label: context.l10n.aiChatTyping,
        liveRegion: true,
        child: AiChatGlassSurface(
          radius: AiChatBubbleMetrics.corner,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
}

class _KeepAliveMessage extends StatefulWidget {
  const _KeepAliveMessage({super.key, required this.child});

  final Widget child;

  @override
  State<_KeepAliveMessage> createState() => _KeepAliveMessageState();
}

class _KeepAliveMessageState extends State<_KeepAliveMessage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
