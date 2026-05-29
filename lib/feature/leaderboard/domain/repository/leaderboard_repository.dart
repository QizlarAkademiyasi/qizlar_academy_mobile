import 'package:qizlar_academy_mobile/feature/leaderboard/domain/model/leaderboard_course_option_model.dart';
import 'package:qizlar_academy_mobile/feature/leaderboard/domain/model/leaderboard_user_model.dart';

/// Reyting vaqt oralig'i — API filter parametriga mos.
enum LeaderboardTimeframe { overall, weekly, monthly }

abstract class LeaderboardRepository {
  /// Kurslar ro'yxati (dropdown uchun).
  /// Guest: GET /api/v1/course/client/public
  /// User:  GET /api/v1/course/client
  Future<List<LeaderboardCourseOptionModel>> getCourseOptions();

  /// Berilgan vaqt va kurs bo'yicha reyting.
  /// Guest: GET /api/v1/course/leaderboard/public?period=&courseId=&pageNumber=&pageSize=
  /// User:  GET /api/v1/course/leaderboard?period=&courseId=&pageNumber=&pageSize=
  Future<List<LeaderboardUserModel>> getLeaderboard({
    required LeaderboardTimeframe timeframe,
    String? courseId,
  });
}
