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
    return AppLiquidStretch(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Gaimon.light();
          onTap();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: user.isCurrentUser ? context.appColors.primary.withValues(alpha: 0.12) : context.appColors.onContainer,
            borderRadius: AppRadius.radiusXl,
            border: Border.all(
              color: user.isCurrentUser ? context.appColors.primary : context.appColors.stroke,
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double rankGap = (constraints.maxWidth < 360) ? 8 : 10;
              final double avatarGap = (constraints.maxWidth < 360) ? 10 : 12;

              return Row(
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 40, maxWidth: 56),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '#${user.rank}',
                          maxLines: 1,
                          style: context.textTheme.heading5.copyWith(
                            color: context.appColors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: rankGap),
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
                  SizedBox(width: avatarGap),
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
              );
            },
          ),
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
