import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/my_activity/domain/model/activity_stats_model.dart';
import 'package:qizlar_academy_mobile/feature/my_activity/presentation/utils/activity_minutes_format.dart';

class ActivityStatGrid extends StatelessWidget {
  const ActivityStatGrid({super.key, required this.stats});

  final ActivityStatsModel stats;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final cards = [
      _StatCardSpec(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _cardColors(context, const Color(0xFF0E3D38)),
        ),
        value: ActivityMinutesFormat.label(l10n, stats.totalDurationMinutes),
        caption: l10n.activityStatTotalTime,
      ),
      _StatCardSpec(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _cardColors(context, const Color(0xFF3D2C14)),
        ),
        value: ActivityMinutesFormat.label(l10n, stats.averageDurationMinutes),
        caption: l10n.activityStatAverageTime,
      ),
      _StatCardSpec(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _cardColors(context, const Color(0xFF153924)),
        ),
        value: ActivityMinutesFormat.label(l10n, stats.dailyRecordMinutes),
        caption: l10n.activityStatDailyRecord,
      ),
      _StatCardSpec(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _cardColors(context, const Color(0xFF2E1745)),
        ),
        value: l10n.activityCompletedCourses(stats.completedCourses),
        caption: l10n.activityStatCoursesCompleted,
      ),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.05,
      children: cards.map((c) => _ActivityStatTile(spec: c)).toList(),
    );
  }

  List<Color> _cardColors(BuildContext context, Color accent) {
    if (context.isDarkTheme) {
      return [accent, const Color(0xFF070708)];
    }
    final surface = context.appColors.onContainer;
    return [Color.alphaBlend(accent.withValues(alpha: 0.12), surface), surface];
  }
}

class _StatCardSpec {
  const _StatCardSpec({
    required this.gradient,
    required this.value,
    required this.caption,
  });

  final Gradient gradient;
  final String value;
  final String caption;
}

class _ActivityStatTile extends StatelessWidget {
  const _ActivityStatTile({required this.spec});

  final _StatCardSpec spec;

  @override
  Widget build(BuildContext context) {
    return AppLiquidStretch.compact(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: spec.gradient,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: context.appColors.stroke),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary, width: 2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Icon(
                    LucideIcons.clock3,
                    size: 16,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                spec.value,
                style: context.textTheme.bodyLargeBold.copyWith(
                  color: context.appColors.text,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                spec.caption,
                style: context.textTheme.bodyXSmallRegular.copyWith(
                  color: context.appColors.secondaryGrey,
                  height: 1.25,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
