import 'package:qizlar_academy_mobile/feature/leaderboard/data/datasource/leaderboard_api_datasource.dart';
import 'package:qizlar_academy_mobile/feature/leaderboard/domain/model/leaderboard_course_option_model.dart';
import 'package:qizlar_academy_mobile/feature/leaderboard/domain/model/leaderboard_user_model.dart';
import 'package:qizlar_academy_mobile/feature/leaderboard/domain/repository/leaderboard_repository.dart';

class LeaderboardRepositoryImpl implements LeaderboardRepository {
  LeaderboardRepositoryImpl({
    required LeaderboardApiDatasource apiDatasource,
  }) : _apiDatasource = apiDatasource;

  final LeaderboardApiDatasource _apiDatasource;

  @override
  Future<List<LeaderboardCourseOptionModel>> getCourseOptions() =>
      _apiDatasource.getCourseOptions();

  @override
  Future<List<LeaderboardUserModel>> getLeaderboard({
    required LeaderboardTimeframe timeframe,
    String? courseId,
  }) => _apiDatasource.getLeaderboard(
    timeframe: timeframe,
    courseId: courseId,
  );
}
