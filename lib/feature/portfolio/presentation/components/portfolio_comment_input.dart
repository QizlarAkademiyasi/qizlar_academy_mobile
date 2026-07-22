import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

class PortfolioCommentInput extends StatelessWidget {
  const PortfolioCommentInput({
    super.key,
    required this.controller,
    required this.isSubmitting,
    required this.onSubmit,
    this.replyToName,
    this.onCancelReply,
  });

  final TextEditingController controller;
  final bool isSubmitting;
  final VoidCallback onSubmit;
  final String? replyToName;
  final VoidCallback? onCancelReply;

  @override
  Widget build(BuildContext context) {
    final replyName = replyToName?.trim();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (replyName != null && replyName.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.fromLTRB(12, 4, 4, 4),
            decoration: BoxDecoration(
              color: context.appColors.primary.withValues(alpha: 0.08),
              borderRadius: AppRadius.radiusSm,
            ),
            child: Row(
              children: [
                Icon(
                  LucideIcons.reply,
                  size: 16,
                  color: context.appColors.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '$replyName ga javob yozilmoqda',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.bodySmallSemibold.copyWith(
                      color: context.appColors.primary,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onCancelReply,
                  tooltip: 'Javobni bekor qilish',
                  visualDensity: VisualDensity.compact,
                  icon: Icon(
                    LucideIcons.x,
                    size: 18,
                    color: context.appColors.secondaryGrey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (context, value, _) {
            final canSubmit = value.text.trim().isNotEmpty && !isSubmitting;

            return TextField(
              controller: controller,
              minLines: 1,
              maxLines: 4,
              maxLength: 1000,
              keyboardType: TextInputType.multiline,
              textCapitalization: TextCapitalization.sentences,
              cursorColor: context.appColors.primary,
              style: context.textTheme.bodyMediumRegular.copyWith(
                color: context.appColors.text,
              ),
              decoration: InputDecoration(
                hintText: 'Izoh yozing...',
                hintStyle: context.textTheme.bodyMediumRegular.copyWith(
                  color: context.appColors.secondaryGrey,
                ),
                counterText: '',
                filled: true,
                fillColor: context.appColors.onContainer,
                isDense: true,
                contentPadding: const EdgeInsets.fromLTRB(16, 14, 4, 14),
                border: OutlineInputBorder(
                  borderRadius: AppRadius.radius2xl,
                  borderSide: BorderSide(color: context.appColors.stroke),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: AppRadius.radius2xl,
                  borderSide: BorderSide(color: context.appColors.stroke),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: AppRadius.radius2xl,
                  borderSide: BorderSide(
                    color: context.appColors.primary,
                    width: 1.5,
                  ),
                ),
                suffixIconConstraints: const BoxConstraints(
                  minWidth: 52,
                  minHeight: 48,
                ),
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(4),
                  child: IconButton.filled(
                    onPressed: canSubmit ? onSubmit : null,
                    tooltip: 'Izohni yuborish',
                    style: IconButton.styleFrom(
                      backgroundColor: context.appColors.primary,
                      foregroundColor: AppColors.white,
                      disabledBackgroundColor: context.appColors.action,
                      disabledForegroundColor: context.appColors.secondaryGrey,
                    ),
                    icon: Icon(
                      isSubmitting
                          ? LucideIcons.loaderCircle
                          : LucideIcons.send,
                      size: 20,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
