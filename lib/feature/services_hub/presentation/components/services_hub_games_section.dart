import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/theme_extension.dart';
import 'package:qizlar_academy_mobile/feature/services_hub/domain/model/services_hub_game_item.dart';
import 'package:qizlar_academy_mobile/feature/services_hub/presentation/components/services_hub_game_deck.dart';

class ServicesHubGamesSection extends StatelessWidget {
  const ServicesHubGamesSection({
    super.key,
    required this.sectionTitle,
    required this.games,
    required this.onPlayGame,
    this.revealBottomInset = 0,
  });

  final String sectionTitle;
  final List<ServicesHubGameItem> games;
  final ValueChanged<ServicesHubGameItem> onPlayGame;
  final double revealBottomInset;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          sectionTitle,
          style: context.textTheme.bodyLargeBold.copyWith(
            color: context.appColors.text,
          ),
        ),
        const SizedBox(height: 14),
        Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 8),
          child: ServicesHubGameDeck(
            games: games,
            onPlayGame: onPlayGame,
            revealBottomInset: revealBottomInset,
          ),
        ),
      ],
    );
  }
}
