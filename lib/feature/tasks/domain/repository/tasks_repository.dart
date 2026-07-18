import 'package:qizlar_academy_mobile/feature/tasks/domain/model/tasks_page_model.dart';

abstract interface class TasksRepository {
  Future<TasksPageModel> fetchTasks({
    required int pageNumber,
    required int pageSize,
  });
}
