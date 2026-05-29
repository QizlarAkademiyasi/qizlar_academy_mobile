import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/apis.dart';
import 'package:qizlar_academy_mobile/core/format/phone_display_format.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/model/profile_overview_model.dart';
import 'package:qizlar_academy_mobile/feature/profile/presentation/components/profile_full_name_with_badge.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.user, this.avatarImageGeneration = 0, this.loading = false, this.onBadgeTap});

  final ProfileUserModel user;
  final int avatarImageGeneration;

  /// `true` bo‘lsa backenddan keladigan qismlar [Bone] ko‘rinishida ([Skeletonizer.zone] ichida bo‘lishi kerak).
  final bool loading;

  final VoidCallback? onBadgeTap;

  static const double _badgeSize = 24;
  static const double _badgeGap = 8;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 86,
            height: 86,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: context.appColors.primary, width: 3),
            ),
            child: Center(child: Bone.circle(size: 74)),
          ),
          const SizedBox(height: 12),
          Bone.text(words: 3, fontSize: 18),
          const SizedBox(height: 4),
          Bone.text(words: 2, fontSize: 13),
        ],
      );
    }
    final rawAvatar = user.avatarUrl.trim();
    var resolvedAvatar = rawAvatar.isEmpty ? '' : Apis.resolveUrl(rawAvatar);
    if (resolvedAvatar.isNotEmpty && avatarImageGeneration != 0) {
      resolvedAvatar = resolvedAvatar.contains('?') ? '$resolvedAvatar&v=$avatarImageGeneration' : '$resolvedAvatar?v=$avatarImageGeneration';
    }
    final nameStyle = context.textTheme.bodyLargeSemibold.copyWith(color: context.appColors.text);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppTappableProfileAvatar(
          size: 86,
          borderWidth: 3,
          heroId: 'profile_header_expanded_${user.userId}',
          resolvedNetworkUrl: resolvedAvatar,
          placeholder: Container(
            color: context.appColors.stroke,
            alignment: Alignment.center,
            child: Icon(LucideIcons.user, color: context.appColors.grey, size: 40),
          ),
        ),
        const SizedBox(height: 12),
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
        const SizedBox(height: 4),
        Text(
          profilePhoneSubtitleLine(user.phoneNumber),
          textAlign: TextAlign.center,
          style: context.textTheme.bodySmallRegular.copyWith(color: context.appColors.secondaryGrey),
        ),
      ],
    );
  }
}
