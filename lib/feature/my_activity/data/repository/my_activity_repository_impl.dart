import 'package:qizlar_academy_mobile/feature/my_activity/data/datasource/my_activity_api_datasource.dart';
import 'package:qizlar_academy_mobile/feature/my_activity/domain/model/activity_stats_model.dart';
import 'package:qizlar_academy_mobile/feature/my_activity/domain/repository/my_activity_repository.dart';

class MyActivityRepositoryImpl implements MyActivityRepository {
  MyActivityRepositoryImpl({required MyActivityApiDatasource apiDatasource})
    : _api = apiDatasource;

  final MyActivityApiDatasource _api;

  @override
  Future<ActivityStatsModel> fetchStats(MyActivityStatsScope scope) =>
      _api.fetchStats(scope);
}
