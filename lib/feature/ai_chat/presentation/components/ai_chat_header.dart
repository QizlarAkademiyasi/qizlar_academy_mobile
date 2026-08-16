import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/theme_extension.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';

class AiChatHeader extends StatelessWidget {
  const AiChatHeader({super.key, required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 12, 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              context.l10n.aiChatTitle,
              style: context.textTheme.heading4.copyWith(
                color: context.appColors.text,
              ),
            ),
          ),
          IconButton(
            tooltip: context.l10n.aiChatClose,
            onPressed: onClose,
            icon: Icon(LucideIcons.x, size: 30, color: context.appColors.text),
          ),
        ],
      ),
    );
  }
}
