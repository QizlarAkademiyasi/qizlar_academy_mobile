import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

class HomeHeaderComponent extends StatelessWidget {
  const HomeHeaderComponent({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTasksTap,
    required this.onNotificationTap,
    required this.tasksTooltip,
    required this.notificationTooltip,
    this.expandedProgress = 1,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTasksTap;
  final VoidCallback onNotificationTap;
  final String tasksTooltip;
  final String notificationTooltip;
  final double expandedProgress;

  @override
  Widget build(BuildContext context) {
    final progress = expandedProgress.clamp(0.0, 1.0);

    return Container(
      height: kToolbarHeight + 8,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      color: Colors.transparent,
      child: Row(
        children: [
          Expanded(
            child: IgnorePointer(
              ignoring: progress < 0.05,
              child: Opacity(
                key: const ValueKey('home-header-name-opacity'),
                opacity: progress,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subtitle,
                        style: context.textTheme.bodyMediumMedium.copyWith(
                          color: context.appColors.grey,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        title,
                        maxLines: 1,
                        style: context.textTheme.heading4.copyWith(
                          overflow: TextOverflow.ellipsis,
                          color: context.appColors.text,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          _HomeHeaderActionButton(
            key: const ValueKey('home-tasks-button'),
            icon: LucideIcons.clipboardCheck,
            tooltip: tasksTooltip,
            onTap: onTasksTap,
          ),
          const SizedBox(width: 8),
          _HomeHeaderActionButton(
            key: const ValueKey('home-notification-button'),
            icon: LucideIcons.bell,
            tooltip: notificationTooltip,
            onTap: onNotificationTap,
            showIndicator: true,
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
                color: context.appColors.onContainer,
                boxShadow: [
                  BoxShadow(
                    color: context.appColors.shadow.withValues(alpha: 0.005),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
                border: Border.all(color: context.appColors.stroke),
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
