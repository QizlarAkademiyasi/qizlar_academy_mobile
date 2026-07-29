import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/colors.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/theme_extension.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';

/// 7 kunlik streak qadamlari: [streakCount] gacha yulduz, keyin raqamlar.
class DailyCoinStreakRow extends StatelessWidget {
  const DailyCoinStreakRow({super.key, required this.streakCount});

  /// Backend qiymati UI uchun `0..7` oralig‘iga cheklanadi.
  final int streakCount;

  static String _dayLabel(BuildContext context, int dayNumber) {
    switch (dayNumber) {
      case 1:
        return context.l10n.dailyCoinDayToday;
      case 2:
        return context.l10n.dailyCoinDayTomorrow;
      default:
        return context.l10n.dailyCoinDayNumber(dayNumber);
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveStreak = streakCount.clamp(0, 7);

    const cellOuter = 40.0;
    const gap = 6.0;

    return SizedBox(
      height: 76,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: List.generate(7, (index) {
            final showStar = index < effectiveStreak;
            final number = index + 1;
            final dayLabel = _dayLabel(context, number);

            final greyFill = context.appColors.iconSecondary;

            return Padding(
              padding: EdgeInsets.only(right: index == 6 ? 0 : gap),
              child: SizedBox(
                width: cellOuter,
                child: Column(
                  children: [
                    Text(
                      dayLabel,
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                      style: context.textTheme.bodyXSmallRegular.copyWith(
                        color: context.appColors.text.withValues(alpha: 0.85),
                      ),
                    ),
                    const SizedBox(height: 8),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: showStar
                            ? greyFill
                            : context.appColors.onContainer,
                        // border: Border.all(color: showStar ? AppColors.otherOrange.withValues(alpha: 0.55) : pendingBorder, width: showStar ? 2 : 1),
                        // boxShadow: showStar
                        //     ? [
                        //         BoxShadow(
                        //           color: AppColors.otherOrange.withValues(alpha: 0.28),
                        //           blurRadius: 10,
                        //           spreadRadius: 0,
                        //         ),
                        //       ]
                        //     : null,
                      ),
                      child: SizedBox(
                        width: 36,
                        height: 36,
                        child: Center(
                          child: showStar
                              ? Icon(
                                  LucideIcons.circleStar,
                                  size: 18,
                                  color: AppColors.otherOrange,
                                )
                              : Text(
                                  '$number',
                                  style: context.textTheme.bodySmallBold
                                      .copyWith(color: context.appColors.text),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
