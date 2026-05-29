import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/model/profile_overview_model.dart';

class ProfileStatsCard extends StatelessWidget {
  const ProfileStatsCard({super.key, required this.stats, this.loading = false});

  final List<ProfileStatModel> stats;

  /// Backend sonlari hali yo‘q — uchta karta [Bone] bilan.
  final bool loading;

  static const int _skeletonCardCount = 3;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Row(
        children: List.generate(_skeletonCardCount, (index) {
          return Expanded(
            child: Container(
              height: 76,
              margin: EdgeInsets.only(right: index == _skeletonCardCount - 1 ? 0 : 8),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
              decoration: BoxDecoration(
                color: context.appColors.onContainer,
                borderRadius: AppRadius.radiusLg,
                border: Border.all(color: context.appColors.stroke),
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Bone.text(words: 1, fontSize: 20),
                  const SizedBox(height: 4),
                  Bone.text(words: 2, fontSize: 12),
                ],
              ),
            ),
          );
        }),
      );
    }
    return Row(
      children: List.generate(stats.length, (index) {
        final stat = stats[index];
        return Expanded(
          child: Container(
            height: 76,
            margin: EdgeInsets.only(right: index == stats.length - 1 ? 0 : 8),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
            decoration: BoxDecoration(
              color: context.appColors.onContainer,
              borderRadius: AppRadius.radiusLg,
              border: Border.all(color: context.appColors.stroke),
            ),
            alignment: Alignment.center,
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
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          stat.value,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.textTheme.heading5.copyWith(
            color: context.appColors.text,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          stat.label,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: context.textTheme.bodySmallRegular.copyWith(
            color: context.appColors.secondaryGrey,
          ),
        ),
      ],
    );
  }
}
