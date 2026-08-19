import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/colors.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/theme_extension.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/presentation/components/ai_chat_glass_surface.dart';

class AiChatComposer extends StatelessWidget {
  const AiChatComposer({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.isEnabled,
    required this.isSending,
    required this.onSend,
    this.inputKey,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isEnabled;
  final bool isSending;
  final VoidCallback onSend;
  final GlobalKey? inputKey;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: AiChatGlassSurface(
        radius: 31,
        padding: const EdgeInsets.fromLTRB(18, 6, 7, 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: KeyedSubtree(
                key: const ValueKey('ai-chat-input'),
                child: TextField(
                  key: inputKey,
                  controller: controller,
                  focusNode: focusNode,
                  enabled: isEnabled,
                  minLines: 1,
                  maxLines: 4,
                  maxLength: 1000,
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  style: context.textTheme.bodyLargeRegular.copyWith(
                    color: context.appColors.text,
                  ),
                  decoration: InputDecoration(
                    hintText: context.l10n.aiChatInputHint,
                    hintStyle: context.textTheme.bodyLargeRegular.copyWith(
                      color: context.appColors.secondaryGrey,
                    ),
                    counterText: '',
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 11),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder: (context, value, _) {
                final enabled =
                    isEnabled && value.text.trim().isNotEmpty && !isSending;
                return Semantics(
                  button: true,
                  enabled: enabled,
                  label: context.l10n.aiChatSend,
                  child: IconButton.filled(
                    key: const ValueKey('ai-chat-send'),
                    onPressed: enabled ? onSend : null,
                    style: IconButton.styleFrom(
                      backgroundColor: context.appColors.primary,
                      disabledBackgroundColor: context.appColors.primary
                          .withValues(alpha: 0.34),
                      foregroundColor: AppColors.white,
                      minimumSize: const Size.square(46),
                    ),
                    icon: Icon(
                      isSending ? LucideIcons.ellipsis : LucideIcons.send,
                      size: 21,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
