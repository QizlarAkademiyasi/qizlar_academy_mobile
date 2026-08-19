import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/colors.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/theme_extension.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/model/ai_chat_course_model.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/model/ai_chat_message_model.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/presentation/components/ai_chat_bubble_metrics.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/presentation/components/ai_chat_course_card.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/presentation/components/ai_chat_glass_surface.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/presentation/components/ai_chat_streaming_text.dart';

class AiChatMessageBubble extends StatelessWidget {
  const AiChatMessageBubble({
    super.key,
    required this.message,
    required this.onCourseTap,
    required this.onRetry,
    this.isGroupStart = true,
    this.isGroupEnd = true,
    this.hideDuringFlight = false,
    this.flightTargetKey,
    this.settledRevealIds,
    this.onRevealSettled,
    this.onStreamingTick,
  });

  final AiChatMessageModel message;
  final ValueChanged<String> onCourseTap;
  final VoidCallback onRetry;
  final bool isGroupStart;
  final bool isGroupEnd;
  final bool hideDuringFlight;
  final GlobalKey? flightTargetKey;
  final Set<String>? settledRevealIds;
  final ValueChanged<String>? onRevealSettled;
  final VoidCallback? onStreamingTick;

  bool get _isUser => message.role == AiChatMessageRole.user;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: _isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth:
              MediaQuery.sizeOf(context).width *
              (_isUser
                  ? AiChatBubbleMetrics.outgoingMaxWidthFactor
                  : AiChatBubbleMetrics.incomingMaxWidthFactor),
        ),
        child: Opacity(
          opacity: hideDuringFlight ? 0 : 1,
          child: Column(
            crossAxisAlignment: _isUser
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_isUser && message.content.isNotEmpty)
                Container(
                  key: flightTargetKey,
                  padding: AiChatBubbleMetrics.textPadding,
                  decoration: BoxDecoration(
                    color: context.appColors.primary,
                    borderRadius: AiChatBubbleMetrics.outgoing(
                      isGroupStart: isGroupStart,
                      isGroupEnd: isGroupEnd,
                    ),
                  ),
                  child: Text(
                    message.content,
                    style: context.textTheme.bodyLargeMedium.copyWith(
                      color: AppColors.white,
                      height: 1.35,
                    ),
                  ),
                )
              else if (!_isUser)
                _AssistantReply(
                  messageId: message.id,
                  text: message.content,
                  courses: message.courses,
                  animate: message.animateReveal,
                  isGroupStart: isGroupStart,
                  isGroupEnd: isGroupEnd,
                  settledRevealIds: settledRevealIds,
                  onRevealSettled: onRevealSettled,
                  onCourseTap: onCourseTap,
                  onStreamingTick: onStreamingTick,
                ),
              if (message.delivery == AiChatMessageDelivery.sending) ...[
                const SizedBox(height: 5),
                Text(
                  context.l10n.aiChatSending,
                  style: context.textTheme.bodyXSmallRegular.copyWith(
                    color: context.appColors.secondaryGrey,
                  ),
                ),
              ],
              if (message.delivery == AiChatMessageDelivery.failed) ...[
                const SizedBox(height: 6),
                TextButton.icon(
                  onPressed: onRetry,
                  style: TextButton.styleFrom(
                    foregroundColor: context.appColors.primary,
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                  ),
                  icon: const Icon(LucideIcons.refreshCw, size: 14),
                  label: Text(context.l10n.aiChatRetrySend),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _AssistantReply extends StatefulWidget {
  const _AssistantReply({
    required this.messageId,
    required this.text,
    required this.courses,
    required this.animate,
    required this.isGroupStart,
    required this.isGroupEnd,
    required this.onCourseTap,
    this.settledRevealIds,
    this.onRevealSettled,
    this.onStreamingTick,
  });

  final String messageId;
  final String text;
  final List<AiChatCourseModel> courses;
  final bool animate;
  final bool isGroupStart;
  final bool isGroupEnd;
  final Set<String>? settledRevealIds;
  final ValueChanged<String>? onRevealSettled;
  final ValueChanged<String> onCourseTap;
  final VoidCallback? onStreamingTick;

  @override
  State<_AssistantReply> createState() => _AssistantReplyState();
}

class _AssistantReplyState extends State<_AssistantReply>
    with AutomaticKeepAliveClientMixin {
  late final bool _playAnimate;
  late bool _showCourses;

  @override
  void initState() {
    super.initState();
    final alreadySettled =
        widget.settledRevealIds?.contains(widget.messageId) ?? false;
    _playAnimate = widget.animate && !alreadySettled;
    if (widget.animate) {
      widget.settledRevealIds?.add(widget.messageId);
    }
    _showCourses = !_playAnimate || widget.text.isEmpty;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.text.isNotEmpty)
          ClipRRect(
            borderRadius: AiChatBubbleMetrics.incoming(
              isGroupStart: widget.isGroupStart,
              isGroupEnd: widget.isGroupEnd,
            ),
            clipBehavior: Clip.antiAlias,
            child: AiChatGlassSurface(
              radius: AiChatBubbleMetrics.corner,
              padding: AiChatBubbleMetrics.textPadding,
              child: AiChatStreamingText(
                text: widget.text,
                animate: _playAnimate,
                style: context.textTheme.bodyLargeMedium.copyWith(
                  color: context.appColors.text,
                  height: 1.35,
                ),
                caretColor: context.appColors.primary,
                onTick: widget.onStreamingTick,
                onComplete: _onRevealComplete,
              ),
            ),
          ),
        if (_showCourses && widget.courses.isNotEmpty) ...[
          if (widget.text.isNotEmpty) const SizedBox(height: 10),
          for (var index = 0; index < widget.courses.length; index++) ...[
            if (index > 0) const SizedBox(height: 10),
            AiChatCourseCard(
              course: widget.courses[index],
              onTap: () => widget.onCourseTap(widget.courses[index].id),
            ),
          ],
        ],
      ],
    );
  }

  void _onRevealComplete() {
    widget.onRevealSettled?.call(widget.messageId);
    if (!mounted || _showCourses) return;
    setState(() => _showCourses = true);
    widget.onStreamingTick?.call();
  }
}
