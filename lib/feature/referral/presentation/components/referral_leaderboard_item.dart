import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/referral/domain/model/referral_leaderboard_user_model.dart';

class ReferralLeaderboardItem extends StatelessWidget {
  const ReferralLeaderboardItem({super.key, required this.user});

  final ReferralLeaderboardUserModel user;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: user.isCurrentUser
            ? context.appColors.primary.withValues(alpha: 0.12)
            : context.appColors.onContainer,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: user.isCurrentUser
              ? context.appColors.primary.withValues(alpha: 0.45)
              : context.appColors.stroke.withValues(alpha: 0.55),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 52,
            child: Align(
              alignment: Alignment.centerLeft,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  '#${user.rank}',
                  maxLines: 1,
                  softWrap: false,
                  style: context.textTheme.heading5.copyWith(
                    color: context.appColors.grey,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          _ListAvatar(imageUrl: user.photoUrl, initials: user.initials),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.fullName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodyLargeBold.copyWith(
                    color: context.appColors.text,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${user.certificatesEarned}',
                style: context.textTheme.bodyXLargeSemibold.copyWith(
                  color: context.appColors.text,
                ),
              ),
              Text(
                'Takliflar',
                style: context.textTheme.bodySmallRegular.copyWith(
                  color: context.appColors.text,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ListAvatar extends StatelessWidget {
  const _ListAvatar({required this.imageUrl, required this.initials});

  final String? imageUrl;
  final String initials;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: context.appColors.stroke, width: 1.5),
      ),
      child: ClipOval(
        child: (imageUrl ?? '').trim().isEmpty
            ? ColoredBox(
                color: context.appColors.stroke,
                child: Center(
                  child: Text(
                    initials,
                    style: context.textTheme.bodySmallBold.copyWith(
                      color: context.appColors.text,
                    ),
                  ),
                ),
              )
            : AppCachedNetworkImage(imageUrl: imageUrl!, fit: BoxFit.cover),
      ),
    );
  }
}
