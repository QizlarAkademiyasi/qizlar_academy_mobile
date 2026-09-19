import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/profile/data/profile_badge_catalog_loader.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/model/profile_badge_definition.dart';

class HomeHeaderComponent extends StatelessWidget {
  const HomeHeaderComponent({
    super.key,
    required this.title,
    this.userBadgeId = 0,
    this.showBadge = true,
  });

  final String title;
  final int userBadgeId;
  final bool showBadge;

  static const double _badgeSize = 36;

  static ProfileBadgeDefinition? _resolvedBadge(
    int badgeId,
    List<ProfileBadgeDefinition> catalog,
  ) {
    if (catalog.isEmpty) return null;
    final id = ProfileBadgeCatalogLoader.coerceSelection(badgeId, catalog);
    for (final b in catalog) {
      if (b.id == id) return b;
    }
    return catalog.first;
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = context.textTheme.heading4.copyWith(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      height: 1.25,
      color: context.appColors.text,
    );

    if (!showBadge || userBadgeId <= 0) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            key: const ValueKey('home-large-greeting'),
            style: textStyle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: FutureBuilder<List<ProfileBadgeDefinition>>(
          future: ProfileBadgeCatalogLoader.load(),
          builder: (context, snapshot) {
            final catalog = snapshot.data;
            final badge =
                catalog == null ? null : _resolvedBadge(userBadgeId, catalog);

            if (badge == null) {
              return Text(
                title,
                key: const ValueKey('home-large-greeting'),
                style: textStyle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Text(
                    title,
                    key: const ValueKey('home-large-greeting'),
                    style: textStyle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 4),
                SizedBox(
                  width: _badgeSize,
                  height: _badgeSize,
                  child: Lottie.asset(
                    badge.packageAssetPath,
                    key: const ValueKey('home-greeting-badge'),
                    fit: BoxFit.contain,
                    repeat: true,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
