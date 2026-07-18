import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/apis.dart';
import 'package:qizlar_academy_mobile/config/logs/app_logger.dart';
import 'package:qizlar_academy_mobile/feature/tasks/domain/model/task_item_model.dart';
import 'package:qizlar_academy_mobile/feature/tasks/domain/model/tasks_page_model.dart';
import 'package:qizlar_academy_mobile/feature/tasks/domain/model/tasks_pagination_model.dart';

abstract interface class TasksRemoteDatasource {
  Future<TasksPageModel> fetchTasks({
    required int pageNumber,
    required int pageSize,
  });
}

class TasksApiDatasource implements TasksRemoteDatasource {
  const TasksApiDatasource(this._dio);

  final Dio _dio;

  @override
  Future<TasksPageModel> fetchTasks({
    required int pageNumber,
    required int pageSize,
  }) async {
    final response = await _dio.get<dynamic>(
      UserApis.tasksClient,
      queryParameters: <String, dynamic>{
        'pageNumber': pageNumber,
        'pageSize': pageSize,
      },
    );
    final envelope = _asMap(response.data);
    final data = _asMap(envelope['data']);
    final items = _asList(data['data'])
        .map(TaskItemModel.fromJson)
        .where((task) => task.id.isNotEmpty && task.isActive)
        .toList(growable: false);
    final meta = _asMap(data['meta']);
    final pagination = _asMap(meta['pagination']);

    return TasksPageModel(
      items: items,
      pagination: TasksPaginationModel(
        pageNumber: _parseInt(pagination['pageNumber'], fallback: pageNumber),
        pageSize: _parseInt(pagination['pageSize'], fallback: pageSize),
        count: _parseInt(pagination['count'], fallback: items.length),
        pageCount: _parseInt(pagination['pageCount'], fallback: 1),
      ),
    );
  }

  Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      return value.map((key, item) => MapEntry(key.toString(), item));
    }
    if (value != null) {
      AppLogger.w('TasksApiDatasource: expected map, got ${value.runtimeType}');
    }
    return <String, dynamic>{};
  }

  List<Map<String, dynamic>> _asList(dynamic value) {
    if (value is! List) return const [];
    return value
        .map(_asMap)
        .where((item) => item.isNotEmpty)
        .toList(growable: false);
  }

  int _parseInt(dynamic value, {required int fallback}) {
    return int.tryParse('${value ?? fallback}') ?? fallback;
  }
}
