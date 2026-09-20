import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/config/router/app_routes.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/services_hub/config/services_hub_games_config.dart';
import 'package:qizlar_academy_mobile/feature/services_hub/domain/model/game_webview_args.dart';
import 'package:qizlar_academy_mobile/feature/services_hub/domain/model/services_hub_game_item.dart';
import 'package:qizlar_academy_mobile/feature/services_hub/domain/model/services_hub_service_item.dart';
import 'package:qizlar_academy_mobile/feature/services_hub/presentation/components/services_hub_games_section.dart';
import 'package:qizlar_academy_mobile/feature/services_hub/presentation/components/services_hub_service_row.dart';

mixin ServicesHubScreenMixin<T extends StatefulWidget> on State<T> {
  List<ServicesHubServiceItem> buildServiceItems(BuildContext context) {
    final l10n = context.l10n;
    return [
      ServicesHubServiceItem(
        icon: LucideIcons.clipboardCheck,
        iconBackground: const Color(0xFF009689),
        title: l10n.servicesHubPortfolioTitle,
        subtitle: l10n.servicesHubPortfolioSubtitle,
        action: const ServicesHubServiceRouteAction(Routes.portfolio),
      ),
      ServicesHubServiceItem(
        icon: LucideIcons.shoppingBasket,
        iconBackground: const Color(0xFF3F51B2),
        title: l10n.servicesHubStoreTitle,
        subtitle: l10n.servicesHubStoreSubtitle,
        action: const ServicesHubServiceRouteAction(Routes.store),
      ),
      ServicesHubServiceItem(
        icon: LucideIcons.award,
        iconBackground: const Color(0xFFFF5726),
        title: l10n.servicesHubOlympiadTitle,
        subtitle: l10n.servicesHubOlympiadSubtitle,
        action: const ServicesHubServiceComingSoonAction(),
      ),
      ServicesHubServiceItem(
        icon: LucideIcons.briefcaseBusiness,
        iconBackground: const Color(0xFF009689),
        title: l10n.servicesHubVacanciesTitle,
        subtitle: l10n.servicesHubVacanciesSubtitle,
        action: const ServicesHubServiceRouteAction(Routes.vacancies),
      ),
      ServicesHubServiceItem(
        icon: LucideIcons.users,
        iconBackground: const Color(0xFF9D28AC),
        title: l10n.servicesHubTeamTitle,
        subtitle: l10n.servicesHubTeamSubtitle,
        action: const ServicesHubServiceRouteAction(Routes.referral),
      ),
    ];
  }

  List<ServicesHubGameItem> buildGames(BuildContext context) {
    final l10n = context.l10n;
    return ServicesHubGamesConfig.games(
      game2048Description: l10n.servicesHubGame2048Description,
      candyCrashDescription: l10n.servicesHubGameCandyDescription,
    );
  }

  void onServiceItemTap(ServicesHubServiceItem item) {
    switch (item.action) {
      case ServicesHubServiceRouteAction(:final route):
        context.push(route);
      case ServicesHubServiceComingSoonAction():
        AppToast.info(context, message: context.l10n.servicesHubComingSoon);
    }
  }

  void onPlayGameTap(ServicesHubGameItem game) {
    final uri = Uri.tryParse(game.playUrl);
    if (uri == null || !ServicesHubGamesConfig.isAllowedGameUrl(uri)) {
      AppToast.error(context, message: context.l10n.connectionErrorMessage);
      return;
    }
    context.push(
      Routes.gameWebView,
      extra: GameWebViewArgs(
        gameId: game.id,
        title: game.title,
        url: game.playUrl,
      ),
    );
  }

  Widget buildServicesHubBody(
    BuildContext context, {
    double bottomContentInset = 120,
  }) {
    final l10n = context.l10n;
    final services = buildServiceItems(context);
    final games = buildGames(context);

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20, 8, 20, bottomContentInset),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.servicesHubAllServicesTitle,
            style: context.textTheme.bodyLargeBold.copyWith(
              color: context.appColors.text,
            ),
          ),
          const SizedBox(height: 12),
          Column(
            children: [
              for (var i = 0; i < services.length; i++) ...[
                if (i > 0) const SizedBox(height: 10),
                ServicesHubServiceRow(
                  icon: services[i].icon,
                  iconBackground: services[i].iconBackground,
                  title: services[i].title,
                  subtitle: services[i].subtitle,
                  onTap: () => onServiceItemTap(services[i]),
                ),
              ],
            ],
          ),
          const SizedBox(height: 24),
          ServicesHubGamesSection(
            sectionTitle: l10n.servicesHubGamesTitle,
            games: games,
            onPlayGame: onPlayGameTap,
            revealBottomInset: bottomContentInset,
          ),
        ],
      ),
    );
  }
}
