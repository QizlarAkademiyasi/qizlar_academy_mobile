import 'package:qizlar_academy_mobile/feature/my_activity/domain/model/activity_stats_model.dart';

enum MyActivityStatsScope {
  weekly('weekly'),
  monthly('monthly');

  const MyActivityStatsScope(this.queryValue);
  final String queryValue;
}

abstract class MyActivityRepository {
  Future<ActivityStatsModel> fetchStats(MyActivityStatsScope scope);
}
