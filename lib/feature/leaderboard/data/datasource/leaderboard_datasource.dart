import 'package:qizlar_academy_mobile/feature/leaderboard/domain/model/leaderboard_course_option_model.dart';
import 'package:qizlar_academy_mobile/feature/leaderboard/domain/model/leaderboard_user_model.dart';
import 'package:qizlar_academy_mobile/feature/leaderboard/domain/repository/leaderboard_repository.dart';

abstract interface class LeaderboardDatasource {
  Future<List<LeaderboardCourseOptionModel>> getCourseOptions();

  Future<List<LeaderboardUserModel>> getLeaderboard({
    required LeaderboardTimeframe timeframe,
    String? courseId,
  });
}
