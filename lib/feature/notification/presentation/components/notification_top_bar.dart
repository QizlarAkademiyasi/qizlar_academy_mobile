import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

class NotificationTopBar extends StatelessWidget {
  const NotificationTopBar({super.key, required this.onBackTap, required this.onMarkAllTap, required this.enableMarkAll});

  final VoidCallback onBackTap;
  final VoidCallback onMarkAllTap;
  final bool enableMarkAll;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 6, 12, 8),
      child: Row(
        children: [
          AppBackButton.ghost(onTap: onBackTap),
          Expanded(
            child: Text(context.l10n.notificationsTitle, style: context.textTheme.heading6.copyWith(color: context.appColors.text)),
          ),
          IconButton(
            onPressed: enableMarkAll ? onMarkAllTap : null,
            splashRadius: 20,
            icon: Icon(LucideIcons.checkCheck, color: enableMarkAll ? context.appColors.text : context.appColors.secondaryGrey),
          ),
        ],
      ),
    );
  }
}
