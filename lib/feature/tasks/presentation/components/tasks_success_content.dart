import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/exception_screens/presentation/components/tgs_empty_content.dart';
import 'package:qizlar_academy_mobile/feature/tasks/domain/model/task_item_model.dart';
import 'package:qizlar_academy_mobile/feature/tasks/presentation/components/task_card.dart';
import 'package:qizlar_academy_mobile/feature/tasks/presentation/components/tasks_balance_card.dart';

class TasksSuccessContent extends StatelessWidget {
  const TasksSuccessContent({
    super.key,
    required this.balance,
    required this.streakCount,
    required this.todayTasks,
    required this.otherTasks,
    required this.onBalanceTap,
    required this.onTaskTap,
    required this.onRefresh,
    this.bottomContentInset = 0,
  });

  final int balance;
  final int? streakCount;
  final List<TaskItemModel> todayTasks;
  final List<TaskItemModel> otherTasks;
  final VoidCallback onBalanceTap;
  final ValueChanged<TaskItemModel> onTaskTap;
  final Future<void> Function() onRefresh;
  final double bottomContentInset;

  @override
  Widget build(BuildContext context) {
    final isEmpty = todayTasks.isEmpty && otherTasks.isEmpty;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          24,
          26,
          24,
          24 + bottomInset + bottomContentInset,
        ),
        children: [
          TasksBalanceCard(
            balance: balance,
            streakCount: streakCount,
            onTap: onBalanceTap,
          ),
          if (isEmpty) ...[
            const SizedBox(height: 80),
            TgsEmptyContent(
              message: context.l10n.tasksEmptyTitle,
              subtitle: context.l10n.tasksEmptySubtitle,
              animationSize: 100,
            ),
          ] else ...[
            if (todayTasks.isNotEmpty) ...[
              const SizedBox(height: 26),
              _TaskSection(
                title: context.l10n.tasksTodayTitle,
                tasks: todayTasks,
                onTaskTap: onTaskTap,
              ),
            ],
            if (otherTasks.isNotEmpty) ...[
              SizedBox(height: todayTasks.isEmpty ? 26 : 24),
              _TaskSection(
                title: context.l10n.tasksOtherTitle,
                tasks: otherTasks,
                onTaskTap: onTaskTap,
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _TaskSection extends StatelessWidget {
  const _TaskSection({
    required this.title,
    required this.tasks,
    required this.onTaskTap,
  });

  final String title;
  final List<TaskItemModel> tasks;
  final ValueChanged<TaskItemModel> onTaskTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: context.textTheme.bodyLargeBold.copyWith(
            color: context.appColors.text,
          ),
        ),
        const SizedBox(height: 19),
        ...List.generate(
          tasks.length,
          (index) => Padding(
            padding: EdgeInsets.only(bottom: index == tasks.length - 1 ? 0 : 9),
            child: TaskCard(
              task: tasks[index],
              onTap: () => onTaskTap(tasks[index]),
            ),
          ),
        ),
      ],
    );
  }
}
