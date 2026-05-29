import 'package:qizlar_academy_mobile/feature/leaderboard/data/datasource/leaderboard_api_datasource.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/bloc/auth_session_cubit.dart';
import 'package:qizlar_academy_mobile/feature/leaderboard/domain/model/leaderboard_course_option_model.dart';
import 'package:qizlar_academy_mobile/feature/leaderboard/domain/model/leaderboard_user_model.dart';
import 'package:qizlar_academy_mobile/feature/leaderboard/domain/repository/leaderboard_repository.dart';

class LeaderboardRepositoryImpl implements LeaderboardRepository {
  LeaderboardRepositoryImpl({
    required LeaderboardApiDatasource apiDatasource,
    required AuthSessionCubit authSessionCubit,
  }) : _apiDatasource = apiDatasource,
       _authSessionCubit = authSessionCubit;

  final LeaderboardApiDatasource _apiDatasource;
  final AuthSessionCubit _authSessionCubit;

  @override
  Future<List<LeaderboardCourseOptionModel>> getCourseOptions() =>
      _apiDatasource.getCourseOptionsByUserType(
        userType: _authSessionCubit.state.userType,
      );

  @override
  Future<List<LeaderboardUserModel>> getLeaderboard({
    required LeaderboardTimeframe timeframe,
    String? courseId,
  }) => _apiDatasource.getLeaderboardByUserType(
    userType: _authSessionCubit.state.userType,
    timeframe: timeframe,
    courseId: courseId,
  );
}
