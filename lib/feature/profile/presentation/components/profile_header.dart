import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/apis.dart';
import 'package:qizlar_academy_mobile/core/format/phone_display_format.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/model/profile_overview_model.dart';
import 'package:qizlar_academy_mobile/feature/profile/presentation/components/profile_full_name_with_badge.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.user, this.avatarImageGeneration = 0});

  final ProfileUserModel user;
  final int avatarImageGeneration;

  static const double _badgeSize = 24;
  static const double _badgeGap = 8;

  @override
  Widget build(BuildContext context) {
    final rawAvatar = user.avatarUrl.trim();
    final resolvedAvatar = rawAvatar.isEmpty ? '' : Apis.resolveUrl(rawAvatar);
    final nameStyle = context.textTheme.bodyLargeSemibold.copyWith(color: context.appColors.text);
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
          child: ClipOval(
            child: resolvedAvatar.isEmpty
                ? Container(
                    color: context.appColors.stroke,
                    alignment: Alignment.center,
                    child: Icon(LucideIcons.user, color: context.appColors.grey, size: 40),
                  )
                : AppCachedNetworkImage(
                    imageUrl: resolvedAvatar,
                    cacheKey: '$resolvedAvatar#$avatarImageGeneration',
                    fit: BoxFit.cover,
                    fallback: const AppNetworkImageFallbackAvatar(iconSize: 40, placeholderShowsIcon: false),
                  ),
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
