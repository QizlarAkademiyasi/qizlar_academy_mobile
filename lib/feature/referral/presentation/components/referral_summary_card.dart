import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/referral/domain/model/referral_code_model.dart';
import 'package:qizlar_academy_mobile/feature/referral/domain/model/referral_leaderboard_user_model.dart';

class ReferralSummaryCard extends StatelessWidget {
  const ReferralSummaryCard({
    super.key,
    required this.code,
    required this.currentUser,
    required this.onCopyTap,
    required this.onShareTap,
  });

  final ReferralCodeModel code;
  final ReferralLeaderboardUserModel? currentUser;
  final VoidCallback onCopyTap;
  final VoidCallback onShareTap;

  @override
  Widget build(BuildContext context) {
    final rankText = currentUser == null ? '-' : '#${currentUser!.rank}';
    final certificates = currentUser?.certificatesEarned ?? 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.appColors.onContainer,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Takliflar dasturi',
                style: context.textTheme.bodySmallRegular.copyWith(
                  color: context.appColors.grey,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: context.appColors.primary,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  "O'rin $rankText",
                  style: context.textTheme.bodySmallSemibold.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Sizning natijangiz',
            style: context.textTheme.bodyXLargeSemibold.copyWith(
              color: context.appColors.text,
            ),
          ),
          const SizedBox(height: 14),
          _StatTile(
            label: 'Takliflar',
            value: '$certificates',
            valueColor: context.appColors.primary,
          ),
          const SizedBox(height: 14),
          Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: context.appColors.background,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: context.appColors.stroke),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    code.referralLink,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.bodyMediumRegular.copyWith(
                      color: context.appColors.text,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Bounce(
                  onTap: onCopyTap,
                  child: Icon(
                    LucideIcons.copy,
                    size: 18,
                    color: context.appColors.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          PrimaryButton.elevated(
            label: 'Havolani ulashish',
            leading: const Icon(
              LucideIcons.share2,
              size: 18,
              color: AppColors.white,
            ),
            onPressed: onShareTap,
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      decoration: BoxDecoration(
        color: context.appColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.appColors.stroke),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.heading4.copyWith(color: valueColor),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.bodySmallRegular.copyWith(
              color: context.appColors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
