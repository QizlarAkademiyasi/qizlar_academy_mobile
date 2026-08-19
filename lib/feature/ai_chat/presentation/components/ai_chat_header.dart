import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/theme_extension.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';

class AiChatHeader extends StatelessWidget {
  const AiChatHeader({
    super.key,
    required this.onOpenDrawer,
    required this.onClose,
    this.title,
  });

  final String? title;
  final VoidCallback onOpenDrawer;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 12, 8),
      child: Row(
        children: [
          IconButton(
            key: const ValueKey('ai-chat-open-drawer'),
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            onPressed: onOpenDrawer,
            icon: Icon(
              LucideIcons.menu,
              size: 26,
              color: context.appColors.text,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              (title ?? '').trim().isEmpty
                  ? context.l10n.aiChatTitle
                  : title!.trim(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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
