import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/feature/tasks/domain/model/task_item_model.dart';
import 'package:qizlar_academy_mobile/feature/tasks/domain/model/tasks_pagination_model.dart';

class TasksPageModel extends Equatable {
  const TasksPageModel({required this.items, required this.pagination});

  final List<TaskItemModel> items;
  final TasksPaginationModel pagination;

  @override
  List<Object?> get props => [items, pagination];
}
