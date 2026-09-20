import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/feature/services_hub/presentation/components/services_hub_game_prewarm_layer.dart';
import 'package:qizlar_academy_mobile/feature/services_hub/presentation/screens/services_hub_screen_mixin.dart';

/// Main shell PageView ichidagi Services Hub (AppPageScaffold / back yo‘q).
class ServicesHubMainTabPage extends StatefulWidget {
  const ServicesHubMainTabPage({
    super.key,
    this.bottomContentInset = 120,
  });

  final double bottomContentInset;

  @override
  State<ServicesHubMainTabPage> createState() => _ServicesHubMainTabPageState();
}

class _ServicesHubMainTabPageState extends State<ServicesHubMainTabPage>
    with ServicesHubScreenMixin<ServicesHubMainTabPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          buildServicesHubBody(
            context,
            bottomContentInset: widget.bottomContentInset,
          ),
          ServicesHubGamePrewarmLayer(games: buildGames(context)),
        ],
      ),
    );
  }
}
