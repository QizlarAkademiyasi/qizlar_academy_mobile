import 'package:qizlar_academy_mobile/feature/leaderboard/domain/model/leaderboard_course_option_model.dart';
import 'package:qizlar_academy_mobile/feature/leaderboard/domain/model/leaderboard_user_model.dart';

/// Reyting vaqt oralig'i — API filter parametriga mos.
enum LeaderboardTimeframe {
  overall,
  weekly,
  monthly,
}

abstract class LeaderboardRepository {
  /// Kurslar ro'yxati (dropdown uchun). API: GET /courses yoki /leaderboard/courses.
  Future<List<LeaderboardCourseOptionModel>> getCourseOptions();

  /// Berilgan vaqt va kurs bo'yicha reyting. API: GET /leaderboard?timeframe=&courseId=
  Future<List<LeaderboardUserModel>> getLeaderboard({
    required LeaderboardTimeframe timeframe,
    String? courseId,
  });
}
