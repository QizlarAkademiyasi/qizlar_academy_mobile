import 'package:qizlar_academy_mobile/feature/daily_coin/data/datasource/daily_coin_api_datasource.dart';
import 'package:qizlar_academy_mobile/feature/daily_coin/domain/model/daily_streak_model.dart';
import 'package:qizlar_academy_mobile/feature/daily_coin/domain/repository/daily_coin_repository.dart';

class DailyCoinRepositoryImpl implements DailyCoinRepository {
  DailyCoinRepositoryImpl({required DailyCoinApiDatasource apiDatasource})
    : _api = apiDatasource;

  final DailyCoinApiDatasource _api;

  @override
  Future<DailyStreakModel> fetchStreak() => _api.getStreak();

  @override
  Future<void> claimStreak() => _api.claimStreak();
}
