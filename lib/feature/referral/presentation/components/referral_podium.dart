import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/referral/domain/model/referral_leaderboard_user_model.dart';

class ReferralPodium extends StatelessWidget {
  const ReferralPodium({super.key, required this.items});

  final List<ReferralLeaderboardUserModel> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    final first = _findByRank(1) ?? items.first;
    final second = _findByRank(2);
    final third = _findByRank(3);

    return SizedBox(
      height: 240,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: _PodiumUserCard(user: second, podiumRank: 2, height: 108),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _PodiumUserCard(user: first, podiumRank: 1, height: 138),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _PodiumUserCard(user: third, podiumRank: 3, height: 108),
          ),
        ],
      ),
    );
  }

  ReferralLeaderboardUserModel? _findByRank(int rank) {
    for (final item in items) {
      if (item.rank == rank) return item;
    }
    return null;
  }
}

class _PodiumUserCard extends StatelessWidget {
  const _PodiumUserCard({
    required this.user,
    required this.podiumRank,
    required this.height,
  });

  final ReferralLeaderboardUserModel? user;
  final int podiumRank;
  final double height;

  @override
  Widget build(BuildContext context) {
    if (user == null) return const SizedBox.shrink();
    final data = user!;
    const borderColor = Color(0xFFF5B100);

    final avatarSize = podiumRank == 1 ? 84.0 : 66.0;
    // _ReferralAvatar: doira + pastdagi rank badge (bottom: -8, badge ~22) — podium bilan bir xil overlap uchun yig‘indiqiyosiy balandlik.
    final avatarColumnHeight = avatarSize + 24;

    return LayoutBuilder(
      builder: (context, constraints) {
        final stackH = constraints.maxHeight;
        final podiumTop = stackH - height;
        // 1-o‘rin: top ≈ 0 bo‘lishi uchun overlap 6 (240px cell, podium 138, avatar ~108).
        const overlapWithPodium = 6.0;
        final avatarTop = (podiumTop + overlapWithPodium - avatarColumnHeight)
            .clamp(0.0, stackH);

        return Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Positioned(
              top: avatarTop,
              child: _ReferralAvatar(
                initials: data.initials,
                imageUrl: data.photoUrl,
                size: avatarSize,
                borderColor: borderColor,
                rank: podiumRank,
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: height,
                padding: EdgeInsets.fromLTRB(
                  8,
                  podiumRank == 1 ? 56 : 48,
                  8,
                  10,
                ),
                decoration: BoxDecoration(
                  color: context.appColors.primary,
                  borderRadius: BorderRadius.vertical(
                    top: const Radius.circular(20),
                    bottom: Radius.circular(podiumRank == 1 ? 0 : 14),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      data.shortName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: context.textTheme.bodyLargeBold.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      '${data.certificatesEarned} Takliflar',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.bodySmallRegular.copyWith(
                        color: podiumRank == 1
                            ? const Color(0xFFF5B100)
                            : AppColors.white.withValues(alpha: 0.92),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ReferralAvatar extends StatelessWidget {
  const _ReferralAvatar({
    required this.initials,
    required this.imageUrl,
    required this.size,
    required this.borderColor,
    required this.rank,
  });

  final String initials;
  final String? imageUrl;
  final double size;
  final Color borderColor;
  final int rank;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: context.appColors.onContainer,
            shape: BoxShape.circle,
            border: Border.all(color: borderColor, width: 3),
          ),
          child: ClipOval(
            child: (imageUrl ?? '').trim().isNotEmpty
                ? AppCachedNetworkImage(imageUrl: imageUrl!, fit: BoxFit.cover)
                : _InitialsAvatar(initials: initials),
          ),
        ),
        Positioned(
          bottom: -8,
          child: Container(
            width: 22,
            height: 22,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: borderColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: context.appColors.onContainer,
                width: 2,
              ),
            ),
            child: Text(
              '$rank',
              style: context.textTheme.bodyXSmallBold.copyWith(
                color: AppColors.textDark,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _InitialsAvatar extends StatelessWidget {
  const _InitialsAvatar({required this.initials});

  final String initials;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.appColors.primary.withValues(alpha: 0.95),
            const Color(0xFF7C3AED),
          ],
        ),
      ),
      child: Center(
        child: Text(
          initials,
          style: context.textTheme.bodyMediumBold.copyWith(
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}
