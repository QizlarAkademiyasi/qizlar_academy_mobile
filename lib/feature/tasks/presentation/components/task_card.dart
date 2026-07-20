import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/tasks/domain/model/task_item_model.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.task, required this.onTap});

  final TaskItemModel task;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final hasProgress = task.hasProgress && !task.isCompleted;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: task.isCompleted
          ? null
          : () {
              Gaimon.selection();
              onTap();
            },
      child: Container(
        height: hasProgress ? 100 : 80,
        decoration: BoxDecoration(
          color: context.appColors.onContainer,
          borderRadius: AppRadius.radiusXl,
          border: Border.all(color: context.appColors.stroke),
          boxShadow: context.isLightTheme
              ? [
                  BoxShadow(
                    color: AppColors.shadow.withValues(alpha: 0.04),
                    blurRadius: 2,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            if (hasProgress)
              Positioned(
                left: 12,
                top: 0,
                child: LayoutBuilder(
                  builder: (context, constraints) => Container(
                    width: (270 * task.progress).clamp(4, 270),
                    height: 3,
                    color: AppColors.primary,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
              child: Row(
                children: [
                  _TaskIcon(task: task),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            task.title,
                            maxLines: 1,
                            style: context.textTheme.bodyLargeBold.copyWith(
                              color: context.appColors.text,
                              fontSize: 15,
                              height: 1.15,
                            ),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          task.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.bodyMediumRegular.copyWith(
                            color: context.appColors.text,
                            fontSize: 13,
                            height: 1.2,
                          ),
                        ),
                        if (hasProgress) ...[
                          const SizedBox(height: 3),
                          Text(
                            '${task.completedCount}/${task.requiredCount}',
                            style: context.textTheme.bodyMediumSemibold
                                .copyWith(
                                  color: context.appColors.text,
                                  height: 1.15,
                                ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  task.isCompleted
                      ? const _CompletedBadge()
                      : _RewardBadge(coins: task.coins),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskIcon extends StatelessWidget {
  const _TaskIcon({required this.task});

  final TaskItemModel task;

  @override
  Widget build(BuildContext context) {
    final uri = Uri.tryParse(task.icon);
    final isRemote =
        uri != null &&
        uri.hasScheme &&
        (uri.isScheme('https') || uri.isScheme('http'));
    final fallback = Icon(_taskIcon(task), size: 20, color: AppColors.primary);

    return Container(
      width: 32,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: AppRadius.radiusXs,
        color: context.isDarkTheme
            ? const Color(0xFF303030)
            : const Color(0xFFE9E9E9),
      ),
      clipBehavior: Clip.antiAlias,
      child: isRemote
          ? Padding(
              padding: const EdgeInsets.all(6),
              child: AppCachedNetworkImage(
                imageUrl: task.icon,
                width: 20,
                height: 20,
                fit: BoxFit.contain,
                placeholder: (_, _) => fallback,
                errorWidget: (_, _, _) => fallback,
              ),
            )
          : fallback,
    );
  }

  IconData _taskIcon(TaskItemModel task) {
    final iconHint = task.icon.toLowerCase();
    final titleHint = task.title.toLowerCase();
    if (iconHint.contains('user-plus') ||
        iconHint.contains('user_plus') ||
        titleHint.contains('refer')) {
      return LucideIcons.userRoundPlus;
    }
    return switch (task.event) {
      TaskEvent.profileFill => LucideIcons.circleUserRound,
      TaskEvent.courseComplete => LucideIcons.circlePlay,
      TaskEvent.writeCommitToCourse => LucideIcons.squarePen,
      TaskEvent.createPortfolio => LucideIcons.fileUser,
      TaskEvent.getCertificate => LucideIcons.trophy,
      TaskEvent.unknown => LucideIcons.circleStar,
    };
  }
}

class _CompletedBadge extends StatelessWidget {
  const _CompletedBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.quizSuccess.withValues(
          alpha: context.isDarkTheme ? 0.10 : 0.08,
        ),
      ),
      child: const Icon(
        LucideIcons.check,
        size: 20,
        color: AppColors.quizSuccess,
      ),
    );
  }
}

class _RewardBadge extends StatelessWidget {
  const _RewardBadge({required this.coins});

  final int coins;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      padding: const EdgeInsets.only(left: 9, right: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(
          alpha: context.isDarkTheme ? 0.14 : 0.10,
        ),
        borderRadius: AppRadius.radiusLg,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            LucideIcons.circleStar,
            size: 18,
            color: AppColors.primary,
          ),
          const SizedBox(width: 6),
          Text(
            '$coins',
            style: context.textTheme.bodyMediumSemibold.copyWith(
              color: context.appColors.text,
            ),
          ),
          const SizedBox(width: 6),
          Container(
            width: 20,
            height: 20,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary,
            ),
            child: const Icon(
              LucideIcons.chevronRight,
              size: 15,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}
