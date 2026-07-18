import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/colors.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/theme_extension.dart';
import 'package:qizlar_academy_mobile/feature/my_activity/domain/model/activity_stats_model.dart';
import 'package:qizlar_academy_mobile/feature/my_activity/presentation/utils/activity_minutes_format.dart';

/// Oy ko‘rinishi — aktiv kunlar pushti doira bilan ajratiladi.
class ActivityMonthCalendarCard extends StatelessWidget {
  const ActivityMonthCalendarCard({super.key, required this.stats});

  final ActivityStatsModel stats;

  static const List<String> _weekdayUz = [
    'Du',
    'Se',
    'Ch',
    'Pa',
    'Ju',
    'Sh',
    'Ya',
  ];

  Map<int, int> _activeMinutesByDay() {
    final map = <int, int>{};
    for (final b in stats.bars) {
      final day = int.tryParse(b.label.trim());
      if (day != null && day > 0) {
        map[day] = (map[day] ?? 0) + b.durationMinutes;
      }
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month);
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final pad = monthStart.weekday - DateTime.monday;
    final active = _activeMinutesByDay();

    final heading = ActivityMinutesFormat.monthHeading(context, monthStart);

    final colors = context.appColors;

    final totalCells = pad + daysInMonth;
    final rowCount = (totalCells / 7).ceil();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 14),
      decoration: BoxDecoration(
        color: colors.onContainer,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: colors.stroke),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: null,
                visualDensity: VisualDensity.compact,
                icon: Icon(
                  LucideIcons.chevronLeft,
                  color: colors.secondaryGrey.withValues(alpha: 0.35),
                ),
              ),
              Expanded(
                child: Text(
                  heading,
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodyLargeBold.copyWith(
                    color: colors.text,
                  ),
                ),
              ),
              IconButton(
                onPressed: null,
                visualDensity: VisualDensity.compact,
                icon: Icon(
                  LucideIcons.chevronRight,
                  color: colors.secondaryGrey.withValues(alpha: 0.35),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: _weekdayUz
                .map(
                  (d) => Expanded(
                    child: Text(
                      d,
                      textAlign: TextAlign.center,
                      style: context.textTheme.bodyXSmallRegular.copyWith(
                        color: colors.secondaryGrey,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: rowCount * 7,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              final dayIndex = index - pad + 1;
              if (index < pad || dayIndex < 1 || dayIndex > daysInMonth) {
                return const SizedBox.shrink();
              }
              final isActive = (active[dayIndex] ?? 0) > 0;
              return _DayCell(day: dayIndex, active: isActive);
            },
          ),
        ],
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({required this.day, required this.active});

  final int day;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final bg = active
        ? context.appColors.primary
        : context.appColors.iconSecondary;
    final fg = active ? AppColors.white : context.appColors.text;

    return DecoratedBox(
      decoration: BoxDecoration(shape: BoxShape.circle, color: bg),
      child: Center(
        child: Text(
          '$day',
          style: context.textTheme.bodySmallBold.copyWith(color: fg),
        ),
      ),
    );
  }
}
