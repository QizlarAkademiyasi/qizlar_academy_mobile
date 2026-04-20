import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/leaderboard/domain/model/leaderboard_user_model.dart';

class LeaderboardListItem extends StatelessWidget {
  const LeaderboardListItem({
    super.key,
    required this.user,
    required this.onTap,
  });

  final LeaderboardUserModel user;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Bounce(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: user.isCurrentUser
              ? context.appColors.primary.withValues(alpha: 0.12)
              : context.appColors.onContainer,
          borderRadius: AppRadius.radiusXl,
          border: Border.all(
            color: user.isCurrentUser
                ? context.appColors.primary
                : context.appColors.stroke,
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 32,
              child: Text(
                '#${user.rank}',
                textAlign: TextAlign.start,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.heading5.copyWith(
                  color: context.appColors.grey,
                ),
              ),
            ),
            const SizedBox(width: 12),
            AppTappableProfileAvatar(
              size: 52,
              borderWidth: 2,
              heroId: 'leader_row_${user.id}',
              resolvedNetworkUrl: user.avatarUrl,
              placeholder: ColoredBox(
                color: context.appColors.stroke,
                child: Icon(
                  LucideIcons.user,
                  size: 22,
                  color: context.appColors.grey,
                ),
              ),
            ),
            const SizedBox(width: 12),
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
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        LucideIcons.star,
                        size: 14,
                        color: context.appColors.grey,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          _formatRating(user.rating),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.bodyXSmallRegular.copyWith(
                            color: context.appColors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }

  static String _formatRating(double rating) {
    if (rating == rating.truncateToDouble()) {
      return rating.toInt().toString();
    }
    return rating.toStringAsFixed(1);
  }
}
