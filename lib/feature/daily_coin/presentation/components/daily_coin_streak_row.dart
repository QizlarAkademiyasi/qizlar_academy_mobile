import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/colors.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/theme_extension.dart';

/// 10 kunlik musobaqa qadamlari: [streakCount] gacha yulduz, keyin raqamlar (sikl 1→10 tangalar).
class DailyCoinStreakRow extends StatelessWidget {
  const DailyCoinStreakRow({super.key, required this.streakCount});

  /// `1..10` — backend [DailyStreakModel.streakCount].
  final int streakCount;

  static String _weekdayShort(BuildContext context, DateTime day) {
    final localeTag = Localizations.localeOf(context).toLanguageTag();
    final fmt = DateFormat('EEE', localeTag);
    var s = fmt.format(day);
    if (s.endsWith('.')) {
      s = s.substring(0, s.length - 1);
    }
    return s;
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final start = today.subtract(const Duration(days: 9));
    final effectiveStreak = streakCount.clamp(0, 10);

    const cellOuter = 40.0;
    const gap = 6.0;

    return SizedBox(
      height: 76,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: List.generate(10, (index) {
            final day = start.add(Duration(days: index));
            final weekday = _weekdayShort(context, day);
            final showStar = index < effectiveStreak;
            final number = index + 1;

            final greyFill = context.appColors.iconSecondary;

            return Padding(
              padding: EdgeInsets.only(right: index == 9 ? 0 : gap),
              child: SizedBox(
                width: cellOuter,
                child: Column(
                  children: [
                    Text(
                      weekday,
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
