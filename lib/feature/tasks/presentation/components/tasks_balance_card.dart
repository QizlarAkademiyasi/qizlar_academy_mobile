import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

class TasksBalanceCard extends StatelessWidget {
  const TasksBalanceCard({super.key, required this.balance, this.streakCount});

  final int balance;
  final int? streakCount;

  @override
  Widget build(BuildContext context) {
    final streak = streakCount;
    return Container(
      height: 88,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: context.appColors.onContainer,
        borderRadius: AppRadius.radiusXl,
        boxShadow: context.isLightTheme
            ? [
                BoxShadow(
                  color: AppColors.shadow.withValues(alpha: 0.05),
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.isDarkTheme
                  ? const Color(0xFF2D2D2D)
                  : const Color(0xFFE8E8E8),
            ),
            child: const Icon(
              LucideIcons.coins,
              size: 24,
              color: Color(0xFFFFD600),
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.tasksBalanceLabel,
                  style: context.textTheme.bodyXSmallBold.copyWith(
                    color: context.appColors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: NumberFormat.decimalPattern().format(balance),
                          style: context.textTheme.heading4.copyWith(
                            color: context.appColors.text,
                          ),
                        ),
                        TextSpan(
                          text: ' ${context.l10n.tasksCoinLabel}',
                          style: context.textTheme.bodyLargeBold.copyWith(
                            color: const Color(0xFFFFD600),
                          ),
                        ),
                      ],
                    ),
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
          if (streak != null && streak > 0) ...[
            const SizedBox(width: 8),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          LucideIcons.flame,
                          color: AppColors.primary,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          context.l10n.tasksStreakTitle(streak),
                          style: context.textTheme.bodyLargeBold.copyWith(
                            color: AppColors.primary,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    context.l10n.tasksStreakSubtitle,
                    style: context.textTheme.bodySmallRegular.copyWith(
                      color: context.appColors.secondaryGrey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
