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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: context.appColors.onContainer,
          borderRadius: AppRadius.radiusXl,
          border: Border.all(color: context.appColors.stroke),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 28,
              child: Text(
                '#${user.rank}',
                style: context.textTheme.bodyLargeSemibold.copyWith(
                  color: context.appColors.grey,
                ),
              ),
            ),
            const SizedBox(width: 12),
            ClipOval(
              child: SizedBox(
                width: 44,
                height: 44,
                child: CachedNetworkImage(
                  imageUrl: user.avatarUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: context.appColors.stroke,
                    child: Icon(
                      LucideIcons.user,
                      color: context.appColors.grey,
                      size: 22,
                    ),
                  ),
                  errorWidget: (context, url, error) => Icon(
                    LucideIcons.user,
                    color: context.appColors.grey,
                    size: 22,
                  ),
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
                    style: context.textTheme.bodyMediumSemibold.copyWith(
                      color: context.appColors.text,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.courseName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.bodyXSmallRegular.copyWith(
                      color: context.appColors.grey,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        LucideIcons.users,
                        size: 14,
                        color: context.appColors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        user.followerCount,
                        style: context.textTheme.bodyXSmallRegular.copyWith(
                          color: context.appColors.grey,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        LucideIcons.star,
                        size: 14,
                        color: context.appColors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        user.rating.toStringAsFixed(1),
                        style: context.textTheme.bodyXSmallRegular.copyWith(
                          color: context.appColors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              _formatScore(user.score),
              style: context.textTheme.bodyMediumBold.copyWith(
                color: context.appColors.text,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _formatScore(int score) {
    return score
        .toString()
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]} ',
        )
        .trim();
  }
}
