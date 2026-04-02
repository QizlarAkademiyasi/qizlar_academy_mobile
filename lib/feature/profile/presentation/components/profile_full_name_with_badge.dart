import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/feature/profile/data/profile_badge_catalog_loader.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/model/profile_badge_definition.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/model/profile_overview_model.dart';

/// Profil ismi va `user.badgeId` bo‘yicha TGS badge (o‘ngda).
class ProfileFullNameWithBadge extends StatelessWidget {
  const ProfileFullNameWithBadge({
    super.key,
    required this.user,
    required this.nameStyle,
    this.badgeSize = 40,
    this.badgeGap = 8,
    this.maxLines = 2,
    required this.fallbackTextAlign,
    required this.rowMainAxisAlignment,
  });

  final ProfileUserModel user;
  final TextStyle nameStyle;
  final double badgeSize;
  final double badgeGap;
  final int maxLines;
  /// Badge yo‘q yoki katalog yuklanmaguncha.
  final TextAlign fallbackTextAlign;
  /// Badge bilan qator tartibi.
  final MainAxisAlignment rowMainAxisAlignment;

  static ProfileBadgeDefinition? _resolvedBadge(
    ProfileUserModel user,
    List<ProfileBadgeDefinition> catalog,
  ) {
    if (catalog.isEmpty) return null;
    final id = ProfileBadgeCatalogLoader.coerceSelection(user.badgeId, catalog);
    for (final b in catalog) {
      if (b.id == id) return b;
    }
    return catalog.first;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProfileBadgeDefinition>>(
      future: ProfileBadgeCatalogLoader.load(),
      builder: (context, snapshot) {
        final catalog = snapshot.data;
        final badge = catalog == null ? null : _resolvedBadge(user, catalog);

        if (badge == null) {
          return Text(
            user.fullName,
            textAlign: fallbackTextAlign,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            style: nameStyle,
          );
        }

        return Row(
          mainAxisAlignment: rowMainAxisAlignment,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                user.fullName,
                textAlign: TextAlign.right,
                maxLines: maxLines,
                overflow: TextOverflow.ellipsis,
                style: nameStyle,
              ),
            ),
            SizedBox(width: badgeGap),
            SizedBox(
              width: badgeSize,
              height: badgeSize,
              child: Lottie.asset(
                badge.packageAssetPath,
                fit: BoxFit.contain,
                repeat: true,
              ),
            ),
          ],
        );
      },
    );
  }
}
