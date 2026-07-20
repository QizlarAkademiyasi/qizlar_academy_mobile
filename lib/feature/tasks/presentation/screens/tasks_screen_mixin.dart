import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/config/router/app_routes.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/exception_screens/presentation/components/tgs_failure_content.dart';
import 'package:qizlar_academy_mobile/feature/tasks/domain/model/task_item_model.dart';
import 'package:qizlar_academy_mobile/feature/tasks/presentation/bloc/tasks_bloc.dart';
import 'package:qizlar_academy_mobile/feature/tasks/presentation/components/tasks_screen_skeleton.dart';
import 'package:qizlar_academy_mobile/feature/tasks/presentation/components/tasks_success_content.dart';

mixin TasksScreenMixin<T extends StatefulWidget> on State<T> {
  Widget buildBody(
    BuildContext context,
    TasksState state, {
    double bottomContentInset = 0,
  }) {
    return switch (state.status) {
      TasksStatus.initial || TasksStatus.loading => const TasksScreenSkeleton(),
      TasksStatus.failure => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: TgsFailureContent(
            message: context.l10n.tasksLoadError,
            onRetry: () => context.read<TasksBloc>().add(const TasksStarted()),
          ),
        ),
      ),
      TasksStatus.success => TasksSuccessContent(
        balance: state.balance,
        streakCount: state.streakCount,
        todayTasks: state.todayTasks,
        otherTasks: state.otherTasks,
        onTaskTap: (task) => onTaskTap(context, task),
        onRefresh: () => onRefresh(context),
        bottomContentInset: bottomContentInset,
      ),
    };
  }

  Future<void> onRefresh(BuildContext context) async {
    final bloc = context.read<TasksBloc>();
    bloc.add(const TasksRefreshRequested());
    await bloc.stream.firstWhere(
      (state) =>
          state.status == TasksStatus.success ||
          state.status == TasksStatus.failure,
    );
  }

  Future<void> onTaskTap(BuildContext context, TaskItemModel task) async {
    if (task.isCompleted) return;
    if (task.link.isNotEmpty) {
      final didOpen = await _openTaskLink(context, task.link);
      if (didOpen) return;
    }

    if (!context.mounted) return;
    final route = switch (task.event) {
      TaskEvent.profileFill => Routes.profileInformation,
      TaskEvent.createPortfolio => Routes.portfolioCreate,
      TaskEvent.getCertificate ||
      TaskEvent.courseComplete ||
      TaskEvent.writeCommitToCourse => Routes.myCourses,
      TaskEvent.unknown => null,
    };
    if (route == null) {
      AppToast.info(context, message: context.l10n.tasksActionUnavailable);
      return;
    }
    context.push(route);
  }

  Future<bool> _openTaskLink(BuildContext context, String rawLink) async {
    final link = rawLink.trim();
    if (link.startsWith('/')) {
      context.push(link);
      return true;
    }

    final uri = Uri.tryParse(link);
    if (uri == null || !uri.hasScheme) return false;

    if (uri.scheme == 'qizlaracademy' && uri.path.isNotEmpty) {
      context.push(uri.path);
      return true;
    }

    final canOpen = await canLaunchUrl(uri);
    if (!canOpen) return false;
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
