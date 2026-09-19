import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/components/home_liquid_action_button.dart';

class ProfilePartnersSection extends StatelessWidget {
  const ProfilePartnersSection({super.key});

  static const double _chipHeight = 54;

  /// Gorizontal `ListView` bo‘yicha cheksiz kenglik — logo uchun aniq o‘lcham kerak.
  static Widget _partnerLogo(
    AssetGenImage asset, {
    required Key key,
    required double width,
    required double height,
  }) {
    return SizedBox(
      width: width,
      height: height,
      child: asset.image(key: key, fit: BoxFit.contain),
    );
  }

  @override
  Widget build(BuildContext context) {
    final partners = <Widget>[
      _partnerLogo(
        UiKitAssets.images.partners.agentlikLogo,
        key: const ValueKey('profile-partner-agentlik'),
        width: 92,
        height: 22,
      ),
      _partnerLogo(
        UiKitAssets.images.partners.qomitaLogo,
        key: const ValueKey('profile-partner-qomita'),
        width: 107,
        height: 24,
      ),
      _partnerLogo(
        UiKitAssets.images.partners.qizlarOvoziLogo,
        key: const ValueKey('profile-partner-qizlar-ovozi'),
        width: 103,
        height: 24,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.profileSectionPartners.toUpperCase(),
          style: context.textTheme.bodyMediumSemibold.copyWith(
            fontSize: 11,
            height: 16 / 11,
            letterSpacing: 0.6,
            color: context.appColors.secondaryGrey,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: _chipHeight,
          child: AppLiquidStretch(
            child: LiquidGlassLayer(
              key: const ValueKey('profile-partners-liquid-layer'),
              settings: homeLiquidGlassSettings(context.isDarkTheme),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: partners.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  return LiquidGlass(
                    shape: const LiquidRoundedSuperellipse(borderRadius: 24),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      child: Center(child: partners[index]),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
