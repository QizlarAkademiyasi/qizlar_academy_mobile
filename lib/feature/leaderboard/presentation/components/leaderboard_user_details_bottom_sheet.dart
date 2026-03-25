import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/leaderboard/domain/model/leaderboard_user_model.dart';

class LeaderboardUserDetailsBottomSheet extends StatelessWidget {
  const LeaderboardUserDetailsBottomSheet({
    super.key,
    required this.user,
  });

  final LeaderboardUserModel user;

  @override
  Widget build(BuildContext context) {
    return AppBottomSheetContainer(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              ClipOval(
                child: SizedBox(
                  width: 64,
                  height: 64,
                  child: CachedNetworkImage(
                    imageUrl: user.avatarUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: context.appColors.stroke,
                      child: Icon(
                        LucideIcons.user,
                        color: context.appColors.grey,
                        size: 30,
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(
                      LucideIcons.user,
                      color: context.appColors.grey,
                      size: 30,
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
                      style: context.textTheme.bodyXLargeSemibold.copyWith(
                        color: context.appColors.text,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'id: ${user.userCode}',
                      style: context.textTheme.bodyMediumRegular.copyWith(
                        color: context.appColors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  value: '${user.finishedCoursesCount}',
                  label: 'Kurslar',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatCard(
                  value: user.rating.toStringAsFixed(0),
                  label: 'Bahosi',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _StatCard(
            value: '${user.certificatesCount}',
            label: 'Sertifikatlar',
            fullWidth: true,
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.value,
    required this.label,
    this.fullWidth = false,
  });

  final String value;
  final String label;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: fullWidth ? double.infinity : null,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: context.appColors.onContainer.withValues(alpha: 0.65),
        borderRadius: AppRadius.radiusXl,
        border: Border.all(color: context.appColors.stroke),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: context.textTheme.heading5.copyWith(
              color: context.appColors.text,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: context.textTheme.bodyMediumRegular.copyWith(
              color: context.appColors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
