import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

class HomeHeaderComponent extends StatelessWidget {
  const HomeHeaderComponent({
    super.key,
    required this.title,
    required this.onTasksTap,
    required this.onNotificationTap,
    required this.tasksTooltip,
    required this.notificationTooltip,
  });

  final String title;
  final VoidCallback onTasksTap;
  final VoidCallback onNotificationTap;
  final String tasksTooltip;
  final String notificationTooltip;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _HomeHeaderActionButton(
                key: const ValueKey('home-notification-button'),
                icon: LucideIcons.bell,
                tooltip: notificationTooltip,
                onTap: onNotificationTap,
                showIndicator: true,
              ),
              _HomeHeaderActionButton(
                key: const ValueKey('home-tasks-button'),
                icon: LucideIcons.clipboardCheck,
                tooltip: tasksTooltip,
                onTap: onTasksTap,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: context.textTheme.heading4.copyWith(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              height: 1.25,
              color: context.appColors.text,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _HomeHeaderActionButton extends StatelessWidget {
  const _HomeHeaderActionButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.showIndicator = false,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final bool showIndicator;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Bounce(
        tilt: false,
        onTap: () {
          Gaimon.selection();
          onTap();
        },
        child: Stack(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.appColors.onContainer.withValues(alpha: 0.28),
                boxShadow: [
                  BoxShadow(
                    color: context.appColors.shadow.withValues(alpha: 0.005),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
                border: Border.all(
                  color: context.appColors.onContainer.withValues(alpha: 0.85),
                ),
              ),
              child: Icon(icon, size: 22, color: context.appColors.text),
            ),
            if (showIndicator)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
