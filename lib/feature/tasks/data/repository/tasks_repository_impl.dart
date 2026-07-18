import 'package:qizlar_academy_mobile/feature/tasks/data/datasource/tasks_api_datasource.dart';
import 'package:qizlar_academy_mobile/feature/tasks/domain/model/tasks_page_model.dart';
import 'package:qizlar_academy_mobile/feature/tasks/domain/repository/tasks_repository.dart';

class TasksRepositoryImpl implements TasksRepository {
  const TasksRepositoryImpl({required TasksRemoteDatasource remoteDatasource})
    : _remoteDatasource = remoteDatasource;

  final TasksRemoteDatasource _remoteDatasource;

  @override
  Future<TasksPageModel> fetchTasks({
    required int pageNumber,
    required int pageSize,
  }) {
    return _remoteDatasource.fetchTasks(
      pageNumber: pageNumber,
      pageSize: pageSize,
    );
  }
}
