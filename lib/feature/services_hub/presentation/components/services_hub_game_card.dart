import 'package:qizlar_academy_kit/gen/assets.gen.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/colors.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/theme_extension.dart';
import 'package:qizlar_academy_mobile/feature/services_hub/domain/model/services_hub_game_item.dart';
class ServicesHubGameCard extends StatelessWidget {
  const ServicesHubGameCard({
    super.key,
    required this.game,
    required this.isExpanded,
    required this.onCardTap,
    required this.onPlayTap,
  });

  static const double collapsedHeight = 176;
  static const double expandedHeight = 300;
  static const double borderRadius = 24;
  static const Duration _contentAnimationDuration = Duration(milliseconds: 450);
  static const Curve _contentAnimationCurve = Curves.easeOutCubic;

  final ServicesHubGameItem game;
  final bool isExpanded;
  final VoidCallback onCardTap;
  final VoidCallback onPlayTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onCardTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Stack(
              fit: StackFit.expand,
              children: [
                SvgPicture.asset(
                  game.backgroundAsset,
                  fit: BoxFit.cover,
                  package: 'qizlar_academy_kit',
                ),
                AnimatedPositioned(
                  duration: _contentAnimationDuration,
                  curve: _contentAnimationCurve,
                  left: 18,
                  top: 18,
                  child: SvgPicture.asset(
                    UiKitAssets.images.servicesHub.academyLogo.path,
                    width: 16,
                    height: 18,
                    package: 'qizlar_academy_kit',
                  ),
                ),
                AnimatedPositioned(
                  duration: _contentAnimationDuration,
                  curve: _contentAnimationCurve,
                  left: 16,
                  right: 16,
                  top: isExpanded ? 56 : 48,
                  child: Text(
                    game.title,
                    textAlign: TextAlign.center,
                    style: context.textTheme.heading4.copyWith(
                      color: colors.text,
                    ),
                  ),
                ),
                AnimatedPositioned(
                  duration: _contentAnimationDuration,
                  curve: _contentAnimationCurve,
                  left: 20,
                  right: 20,
                  top: isExpanded ? 100 : 78,
                  child: AnimatedOpacity(
                    opacity: isExpanded ? 1 : 0,
                    duration: const Duration(milliseconds: 280),
                    child: IgnorePointer(
                      ignoring: !isExpanded,
                      child: Text(
                        game.description,
                        textAlign: TextAlign.center,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.bodySmallRegular.copyWith(
                          color: colors.text,
                        ),
                      ),
                    ),
                  ),
                ),
                AnimatedPositioned(
                  duration: _contentAnimationDuration,
                  curve: _contentAnimationCurve,
                  left: 0,
                  right: 0,
                  bottom: isExpanded ? 18 : 10,
                  child: AnimatedOpacity(
                    opacity: isExpanded ? 1 : 0,
                    duration: const Duration(milliseconds: 280),
                    child: AnimatedScale(
                      scale: isExpanded ? 1 : 0.85,
                      duration: const Duration(milliseconds: 280),
                      curve: _contentAnimationCurve,
                      child: IgnorePointer(
                        ignoring: !isExpanded,
                        child: Center(
                          child: Material(
                            color: colors.primary,
                            borderRadius: BorderRadius.circular(14),
                            child: InkWell(
                              onTap: () {
                                Gaimon.medium();
                                onPlayTap();
                              },
                              borderRadius: BorderRadius.circular(14),
                              child: SizedBox(
                                width: 64,
                                height: 64,
                                child: Center(
                                  child: Text(
                                    game.playButtonLabel,
                                    style: context.textTheme.bodyXLargeBold
                                        .copyWith(color: AppColors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}
