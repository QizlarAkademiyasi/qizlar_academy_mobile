import 'dart:math' as math;

import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/colors.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/theme_extension.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/feature/my_activity/domain/model/activity_stats_model.dart';
import 'package:qizlar_academy_mobile/feature/my_activity/presentation/utils/activity_minutes_format.dart';

/// Haftalik grafik kartasi (bar chart).
class ActivityWeeklyChartCard extends StatelessWidget {
  const ActivityWeeklyChartCard({super.key, required this.stats});

  final ActivityStatsModel stats;

  static const double _chartHeight = 148;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bars = stats.bars;
    final maxMinutes = bars.fold<int>(
      1,
      (m, b) => math.max(m, b.durationMinutes),
    );

    final colors = context.appColors;
    final surface = colors.onContainer;
    final track = colors.iconSecondary;
    final fillIdle = colors.grey.withValues(alpha: 0.35);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: colors.stroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ActivityMinutesFormat.weeklyRangeLabel(DateTime.now()),
            style: context.textTheme.bodySmallRegular.copyWith(
              color: colors.secondaryGrey,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            ActivityMinutesFormat.label(l10n, stats.totalDurationMinutes),
            style: context.textTheme.heading5.copyWith(color: colors.text),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: _chartHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var i = 0; i < bars.length; i++) ...[
                  if (i != 0) const SizedBox(width: 6),
                  Expanded(
                    child: _WeekBar(
                      label: bars[i].label,
                      durationMinutes: bars[i].durationMinutes,
                      maxMinutes: maxMinutes,
                      isToday: bars[i].isToday,
                      trackColor: track,
                      idleFill: fillIdle,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WeekBar extends StatelessWidget {
  const _WeekBar({
    required this.label,
    required this.durationMinutes,
    required this.maxMinutes,
    required this.isToday,
    required this.trackColor,
    required this.idleFill,
  });

  final String label;
  final int durationMinutes;
  final int maxMinutes;
  final bool isToday;
  final Color trackColor;
  final Color idleFill;

  @override
  Widget build(BuildContext context) {
    final fillFraction = maxMinutes <= 0
        ? 0.0
        : (durationMinutes / maxMinutes).clamp(0.0, 1.0);
    final fillColor = isToday ? AppColors.primary : idleFill;

    return Column(
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final trackH = constraints.maxHeight - 22;
              final fillH = trackH * fillFraction;
              return Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    width: double.infinity,
                    height: trackH,
                    decoration: BoxDecoration(
                      color: trackColor.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 320),
                      curve: Curves.easeOutCubic,
                      width: double.infinity,
                      height: fillH.clamp(0.0, trackH),
                      decoration: BoxDecoration(
                        color: fillColor,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: context.textTheme.bodyXSmallRegular.copyWith(
            color: context.appColors.text,
          ),
        ),
      ],
    );
  }
}
