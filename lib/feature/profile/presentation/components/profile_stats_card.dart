import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/model/profile_overview_model.dart';

class ProfileStatsCard extends StatelessWidget {
  const ProfileStatsCard({super.key, required this.stats});

  final List<ProfileStatModel> stats;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(stats.length, (index) {
        final stat = stats[index];
        return Expanded(
          child: Container(
            height: 70,
            margin: EdgeInsets.only(right: index == stats.length - 1 ? 0 : 8),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            decoration: BoxDecoration(
              color: context.appColors.onContainer,
              borderRadius: AppRadius.radiusLg,
              border: Border.all(color: context.appColors.stroke),
            ),
            child: _StatItem(stat: stat),
          ),
        );
      }),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.stat});

  final ProfileStatModel stat;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          stat.value,
          style: context.textTheme.bodyLargeBold.copyWith(
            color: context.appColors.text,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          stat.label,
          style: context.textTheme.bodyXSmallRegular.copyWith(
            color: context.appColors.secondaryGrey,
          ),
        ),
      ],
    );
  }
}
