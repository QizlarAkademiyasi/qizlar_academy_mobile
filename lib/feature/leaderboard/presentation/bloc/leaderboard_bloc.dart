import 'package:qizlar_academy_mobile/feature/leaderboard/domain/model/leaderboard_course_option_model.dart';
import 'package:qizlar_academy_mobile/feature/leaderboard/domain/model/leaderboard_user_model.dart';
import 'package:qizlar_academy_mobile/feature/leaderboard/domain/repository/leaderboard_repository.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

part 'leaderboard_event.dart';
part 'leaderboard_state.dart';

class LeaderboardBloc extends Bloc<LeaderboardEvent, LeaderboardState> {
  LeaderboardBloc(this._repository) : super(const LeaderboardState()) {
    on<LeaderboardStarted>(_onStarted);
    on<LeaderboardTimeframeChanged>(_onTimeframeChanged);
    on<LeaderboardCourseSelected>(_onCourseSelected);
  }

  final LeaderboardRepository _repository;

  String _cacheKey({
    required String courseId,
    required LeaderboardTimeframe timeframe,
  }) =>
      '$courseId|${timeframe.name}';

  LeaderboardState _stateFromList(LeaderboardState current, List<LeaderboardUserModel> list) {
    final topThree = list.take(3).toList();
    return current.copyWith(
      status: LeaderboardStatus.success,
      topThree: topThree,
      fullList: list,
      message: null,
    );
  }

  Future<void> _onStarted(
    LeaderboardStarted event,
    Emitter<LeaderboardState> emit,
  ) async {
    emit(state.copyWith(status: LeaderboardStatus.loading, message: null));
    try {
      final courses = await _repository.getCourseOptions();
      final courseId = courses.isEmpty ? null : courses.first.id;
      if (courseId == null) {
        emit(state.copyWith(
          status: LeaderboardStatus.success,
          courseOptions: courses,
          topThree: [],
          fullList: [],
        ));
        return;
      }
      final timeframe = state.timeframe;
      final list = await _repository.getLeaderboard(timeframe: timeframe, courseId: courseId);
      final key = _cacheKey(courseId: courseId, timeframe: timeframe);
      final nextCache = Map<String, List<LeaderboardUserModel>>.from(state.leaderboardCache)..[key] = list;
      emit(
        _stateFromList(
          state.copyWith(
            courseOptions: courses,
            selectedCourseId: courseId,
            timeframe: timeframe,
            leaderboardCache: nextCache,
          ),
          list,
        ),
      );
    } catch (e) {
      emit(state.copyWith(
        status: LeaderboardStatus.failure,
        message: 'Reytingni yuklashda xatolik.',
      ));
    }
  }

  Future<void> _onTimeframeChanged(
    LeaderboardTimeframeChanged event,
    Emitter<LeaderboardState> emit,
  ) async {
    if (state.timeframe == event.timeframe) return;
    final courseId = state.selectedCourseId;
    if (courseId == null) {
      emit(state.copyWith(timeframe: event.timeframe));
      return;
    }
    // Tab o'zgarganda har safar yuklamaymiz: cache bo'lsa shu bilan ko'rsatamiz.
    final key = _cacheKey(courseId: courseId, timeframe: event.timeframe);
    final cached = state.leaderboardCache[key];
    if (cached != null) {
      emit(_stateFromList(state.copyWith(timeframe: event.timeframe), cached));
      return;
    }

    emit(state.copyWith(status: LeaderboardStatus.loading, timeframe: event.timeframe, message: null));
    try {
      final list = await _repository.getLeaderboard(
        timeframe: event.timeframe,
        courseId: courseId,
      );
      final nextCache = Map<String, List<LeaderboardUserModel>>.from(state.leaderboardCache)..[key] = list;
      emit(
        _stateFromList(
          state.copyWith(leaderboardCache: nextCache),
          list,
        ),
      );
    } catch (e) {
      emit(state.copyWith(
        status: LeaderboardStatus.failure,
        message: 'Reytingni yangilashda xatolik.',
      ));
    }
  }

  Future<void> _onCourseSelected(
    LeaderboardCourseSelected event,
    Emitter<LeaderboardState> emit,
  ) async {
    if (state.selectedCourseId == event.courseId) return;
    final timeframe = state.timeframe;
    final key = _cacheKey(courseId: event.courseId, timeframe: timeframe);
    final cached = state.leaderboardCache[key];
    if (cached != null) {
      emit(_stateFromList(state.copyWith(selectedCourseId: event.courseId), cached));
      return;
    }

    emit(
      state.copyWith(
        status: LeaderboardStatus.loading,
        selectedCourseId: event.courseId,
        message: null,
      ),
    );
    try {
      final list = await _repository.getLeaderboard(
        timeframe: state.timeframe,
        courseId: event.courseId,
      );
      final nextCache = Map<String, List<LeaderboardUserModel>>.from(state.leaderboardCache)..[key] = list;
      emit(
        _stateFromList(
          state.copyWith(leaderboardCache: nextCache),
          list,
        ),
      );
    } catch (e) {
      emit(state.copyWith(
        status: LeaderboardStatus.failure,
        message: 'Reytingni yuklashda xatolik.',
      ));
    }
  }
}
