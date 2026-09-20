import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

sealed class ServicesHubServiceAction {
  const ServicesHubServiceAction();
}

final class ServicesHubServiceRouteAction extends ServicesHubServiceAction {
  const ServicesHubServiceRouteAction(this.route);

  final String route;
}

final class ServicesHubServiceComingSoonAction extends ServicesHubServiceAction {
  const ServicesHubServiceComingSoonAction();
}

class ServicesHubServiceItem {
  const ServicesHubServiceItem({
    required this.icon,
    required this.iconBackground,
    required this.title,
    required this.subtitle,
    required this.action,
  });

  final IconData icon;
  final Color iconBackground;
  final String title;
  final String subtitle;
  final ServicesHubServiceAction action;
}
