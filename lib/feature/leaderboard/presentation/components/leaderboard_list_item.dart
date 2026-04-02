import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/leaderboard/domain/model/leaderboard_user_model.dart';

class LeaderboardListItem extends StatelessWidget {
  const LeaderboardListItem({super.key, required this.user, required this.onTap});

  final LeaderboardUserModel user;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Bounce(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: context.appColors.onContainer,
          borderRadius: AppRadius.radiusXl,
          border: Border.all(color: context.appColors.stroke),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 28,
              child: Text('#${user.rank}', style: context.textTheme.heading5.copyWith(color: context.appColors.grey)),
            ),
            const SizedBox(width: 12),
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.appColors.onContainer,
                border: Border.all(color: context.appColors.primary, width: 2),
              ),
              child: AppCachedNetworkImage(imageUrl: user.avatarUrl, fit: BoxFit.cover, fallback: const AppNetworkImageFallbackAvatar(iconSize: 22, errorShowsBackground: false)),
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
                    style: context.textTheme.bodyLargeBold.copyWith(color: context.appColors.text),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(LucideIcons.star, size: 14, color: context.appColors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          _formatCoins(user.coins),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.bodyXSmallRegular.copyWith(color: context.appColors.grey),
                        ),
                      ),
                      if (user.isCurrentUser) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: context.appColors.stroke, borderRadius: BorderRadius.circular(999)),
                          child: Text('Siz', style: context.textTheme.bodyXSmallSemibold.copyWith(color: context.appColors.grey)),
                        ),
                      ],
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

  static String _formatCoins(int coins) {
    return coins.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]} ').trim();
  }
}
