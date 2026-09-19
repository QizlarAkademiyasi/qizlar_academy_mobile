import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/apis.dart';
import 'package:qizlar_academy_mobile/core/format/phone_display_format.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/model/profile_overview_model.dart';
import 'package:qizlar_academy_mobile/feature/profile/presentation/components/profile_full_name_with_badge.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.user,
    this.avatarImageGeneration = 0,
    this.loading = false,
    this.onBadgeTap,
  });

  final ProfileUserModel user;
  final int avatarImageGeneration;
  final bool loading;
  final VoidCallback? onBadgeTap;

  static const double _avatarSize = 80;
  static const double _badgeSize = 36;
  static const double _badgeGap = 4;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: _avatarSize,
            height: _avatarSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: context.appColors.primary, width: 3),
            ),
            child: Center(child: Bone.circle(size: 68)),
          ),
          const SizedBox(height: 14),
          Bone.text(words: 3, fontSize: 20),
          const SizedBox(height: 4),
          Bone.text(words: 2, fontSize: 14),
        ],
      );
    }
    final rawAvatar = user.avatarUrl.trim();
    var resolvedAvatar = rawAvatar.isEmpty ? '' : Apis.resolveUrl(rawAvatar);
    if (resolvedAvatar.isNotEmpty && avatarImageGeneration != 0) {
      resolvedAvatar = resolvedAvatar.contains('?')
          ? '$resolvedAvatar&v=$avatarImageGeneration'
          : '$resolvedAvatar&v=$avatarImageGeneration';
    }
    final nameStyle = context.textTheme.bodyLargeBold.copyWith(
      fontSize: 20,
      color: context.appColors.text,
    );
    final phoneSubtitle = profileHeaderPhoneSubtitle(user.phoneNumber);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppTappableProfileAvatar(
          size: _avatarSize,
          borderWidth: 3,
          heroId: 'profile_header_expanded_${user.userId}',
          resolvedNetworkUrl: resolvedAvatar,
          placeholder: Container(
            color: context.appColors.stroke,
            alignment: Alignment.center,
            child: Icon(
              LucideIcons.user,
              color: context.appColors.grey,
              size: 36,
            ),
          ),
        ),
        const SizedBox(height: 14),
        ProfileFullNameWithBadge(
          user: user,
          nameStyle: nameStyle,
          badgeSize: _badgeSize,
          badgeGap: _badgeGap,
          maxLines: 2,
          fallbackTextAlign: TextAlign.center,
          rowMainAxisAlignment: MainAxisAlignment.center,
          onBadgeTap: onBadgeTap,
        ),
        if (phoneSubtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            phoneSubtitle,
            textAlign: TextAlign.center,
            style: context.textTheme.bodySmallRegular.copyWith(
              fontSize: 14,
              height: 20 / 14,
              color: context.appColors.grey,
            ),
          ),
        ],
      ],
    );
  }
}
