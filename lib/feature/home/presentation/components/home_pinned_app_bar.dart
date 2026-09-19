import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/components/home_app_bar_background.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/components/home_app_bar_logo.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/components/home_liquid_action_button.dart';

class HomePinnedAppBar extends StatelessWidget {
  const HomePinnedAppBar({
    super.key,
    required this.collapseProgress,
    required this.onTasksTap,
    required this.onNotificationTap,
    required this.tasksTooltip,
    required this.notificationTooltip,
  });

  static const double toolbarHeight = 44;
  static const double horizontalInset = 24;
  static const double fadePocket = 72;

  final double collapseProgress;
  final VoidCallback onTasksTap;
  final VoidCallback onNotificationTap;
  final String tasksTooltip;
  final String notificationTooltip;

  static double contentInset(BuildContext context) =>
      MediaQuery.paddingOf(context).top + toolbarHeight;

  static double overlayHeight(BuildContext context) =>
      contentInset(context) + fadePocket;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    return SizedBox(
      key: const ValueKey('home-pinned-app-bar'),
      height: overlayHeight(context),
      child: Stack(
        fit: StackFit.expand,
        children: [
          HomeAppBarBackground(progress: collapseProgress),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: top + toolbarHeight,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                horizontalInset,
                top,
                horizontalInset,
                0,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 56),
                    child: HomeAppBarLogo(),
                  ),
                  HomeLiquidActionLayer(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        HomeLiquidActionButton(
                          key: const ValueKey('home-notification-button'),
                          icon: CupertinoIcons.bell,
                          tooltip: notificationTooltip,
                          onTap: onNotificationTap,
                          showIndicator: true,
                        ),
                        HomeLiquidActionButton(
                          key: const ValueKey('home-tasks-button'),
                          icon: CupertinoIcons.doc_checkmark,
                          tooltip: tasksTooltip,
                          onTap: onTasksTap,
                        ),
                      ],
                    ),
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
