import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/colors.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/theme_extension.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/model/ai_chat_message_model.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/presentation/components/ai_chat_course_card.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/presentation/components/ai_chat_glass_surface.dart';

class AiChatMessageBubble extends StatelessWidget {
  const AiChatMessageBubble({
    super.key,
    required this.message,
    required this.onCourseTap,
    required this.onRetry,
  });

  final AiChatMessageModel message;
  final ValueChanged<String> onCourseTap;
  final VoidCallback onRetry;

  bool get _isUser => message.role == AiChatMessageRole.user;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: _isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * (_isUser ? 0.82 : 0.9),
        ),
        child: Column(
          crossAxisAlignment: _isUser
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (message.content.isNotEmpty)
              _isUser
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: context.appColors.primary,
                        borderRadius: BorderRadius.circular(26),
                      ),
                      child: Text(
                        message.content,
                        style: context.textTheme.bodyLargeMedium.copyWith(
                          color: AppColors.white,
                          height: 1.35,
                        ),
                      ),
                    )
                  : AiChatGlassSurface(
                      radius: 26,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 14,
                      ),
                      child: Text(
                        message.content,
                        style: context.textTheme.bodyLargeMedium.copyWith(
                          color: context.appColors.text,
                          height: 1.35,
                        ),
                      ),
                    ),
            if (message.courses.isNotEmpty) ...[
              if (message.content.isNotEmpty) const SizedBox(height: 10),
              for (var index = 0; index < message.courses.length; index++) ...[
                if (index > 0) const SizedBox(height: 10),
                AiChatCourseCard(
                  course: message.courses[index],
                  onTap: () => onCourseTap(message.courses[index].id),
                ),
              ],
            ],
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
    );
  }
}
