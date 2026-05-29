import 'package:qizlar_academy_mobile/feature/daily_coin/domain/model/daily_streak_model.dart';

abstract class DailyCoinRepository {
  Future<DailyStreakModel> fetchStreak();

  /// Idempotent on backend — still returns success with `204`.
  Future<void> claimStreak();
}
