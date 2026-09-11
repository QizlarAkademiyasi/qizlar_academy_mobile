import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/components/home_header_component.dart';

class HomePinnedAppBar extends StatelessWidget {
  const HomePinnedAppBar({
    super.key,
    required this.title,
    required this.collapseProgress,
    required this.onTasksTap,
    required this.onNotificationTap,
    required this.tasksTooltip,
    required this.notificationTooltip,
  });

  static const double toolbarTopPad = 16;

  final String title;
  final double collapseProgress;
  final VoidCallback onTasksTap;
  final VoidCallback onNotificationTap;
  final String tasksTooltip;
  final String notificationTooltip;

  static double contentInset(BuildContext context) =>
      MediaQuery.paddingOf(context).top +
      toolbarTopPad +
      HomeHeaderActionButton.size;

  static double overlayHeight(BuildContext context) => contentInset(context);

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final titleOpacity = collapseProgress.clamp(0.0, 1.0);
    return SizedBox(
      key: const ValueKey('home-pinned-app-bar'),
      height: overlayHeight(context),
      child: Stack(
        fit: StackFit.expand,
        children: [
          AppScrollEdgeBlur(progress: collapseProgress),
          Padding(
            padding: EdgeInsets.fromLTRB(24, top + toolbarTopPad, 24, 0),
            child: SizedBox(
              height: HomeHeaderActionButton.size,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Opacity(
                    opacity: titleOpacity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 56),
                      child: Text(
                        title,
                        key: const ValueKey('home-compact-title'),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.heading6.copyWith(
                          color: context.appColors.text,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      HomeHeaderActionButton(
                        key: const ValueKey('home-notification-button'),
                        icon: LucideIcons.bell,
                        tooltip: notificationTooltip,
                        onTap: onNotificationTap,
                        showIndicator: true,
                      ),
                      HomeHeaderActionButton(
                        key: const ValueKey('home-tasks-button'),
                        icon: LucideIcons.clipboardCheck,
                        tooltip: tasksTooltip,
                        onTap: onTasksTap,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
