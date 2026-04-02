import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_padding.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/leaderboard/domain/model/leaderboard_user_model.dart';

class LeaderboardTopPerformersCard extends StatelessWidget {
  const LeaderboardTopPerformersCard({super.key, required this.topThree, required this.onUserTap});

  /// Tartib: [0]=1-o'rin, [1]=2-o'rin, [2]=3-o'rin. Podium: chap=2, o'rta=1, o'ng=3.
  final List<LeaderboardUserModel> topThree;
  final ValueChanged<LeaderboardUserModel> onUserTap;

  @override
  Widget build(BuildContext context) {
    final first = topThree.isNotEmpty ? topThree[0] : null;
    final second = topThree.length > 1 ? topThree[1] : null;
    final third = topThree.length > 2 ? topThree[2] : null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: context.appColors.onContainer,
        borderRadius: AppRadius.radius3xl,
        border: Border.all(color: context.appColors.stroke),
        gradient: LinearGradient(
          colors: [context.appColors.primary.withValues(alpha: 0.3), context.appColors.onContainer.withValues(alpha: 0.05), context.appColors.primary.withValues(alpha: 0.3)],
          stops: [0.0, 0.5, 1.0],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (second != null)
            Expanded(
              child: _PodiumItem(user: second, rank: 2, isFirst: false, onTap: () => onUserTap(second)),
            ),
          if (first != null) ...[
            const SizedBox(width: 8),
            Expanded(
              child: _PodiumItem(user: first, rank: 1, isFirst: true, onTap: () => onUserTap(first)),
            ),
            const SizedBox(width: 8),
          ],
          if (third != null)
            Expanded(
              child: _PodiumItem(user: third, rank: 3, isFirst: false, onTap: () => onUserTap(third)),
            ),
        ],
      ),
    );
  }
}

class _PodiumItem extends StatelessWidget {
  const _PodiumItem({required this.user, required this.rank, required this.isFirst, required this.onTap});

  final LeaderboardUserModel user;
  final int rank;
  final bool isFirst;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final size = isFirst ? 80.0 : 56.0;
    final displayName = user.fullName.split(' ').first;

    return Bounce(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isFirst) Icon(LucideIcons.crown, color: const Color(0xFFFFD700), size: 28),
          if (isFirst) const SizedBox(height: 6),
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                padding: AppPadding.paddingZero,
                width: size,
                height: size,

                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.appColors.onContainer,
                  border: Border.all(
                    color: rank == 1
                        ? AppColors.otherYellow
                        : rank == 2
                        ? AppColors.otherOrange
                        : AppColors.grey,
                    width: 3,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: AppRadius.radius5xl,
                  child: AppCachedNetworkImage(
                    imageUrl: user.avatarUrl,
                    fit: BoxFit.cover,
                    fallback: AppNetworkImageFallbackAvatar(iconSize: size * 0.5, errorShowsBackground: false),
                  ),
                ),
              ),
              Positioned(
                bottom: -8,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: rank == 1
                        ? AppColors.otherYellow
                        : rank == 2
                        ? AppColors.otherOrange
                        : AppColors.grey,
                    shape: BoxShape.circle,
                    border: Border.all(color: context.appColors.stroke),
                  ),
                  alignment: Alignment.center,
                  child: Text('$rank', style: context.textTheme.bodyXSmallBold.copyWith(color: rank == 1 ? AppColors.textDark : context.appColors.text)),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            displayName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMediumBold.copyWith(color: context.appColors.text),
          ),
          const SizedBox(height: 4),
          Text('$rank-o\'rin', style: context.textTheme.bodyXSmallSemibold.copyWith(color: context.appColors.grey)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(999)),
            child: Text(_formatCoins(user.coins), style: context.textTheme.bodySmallBold.copyWith(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  static String _formatCoins(int coins) {
    return coins.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]} ').trim();
  }
}
