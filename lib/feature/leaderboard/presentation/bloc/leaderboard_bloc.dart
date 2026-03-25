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
      final list = await _repository.getLeaderboard(
        timeframe: state.timeframe,
        courseId: courseId,
      );
      final topThree = list.take(3).toList();
      emit(state.copyWith(
        status: LeaderboardStatus.success,
        courseOptions: courses,
        selectedCourseId: courseId,
        topThree: topThree,
        fullList: list,
      ));
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
    emit(state.copyWith(status: LeaderboardStatus.loading, timeframe: event.timeframe));
    try {
      final list = await _repository.getLeaderboard(
        timeframe: event.timeframe,
        courseId: courseId,
      );
      final topThree = list.take(3).toList();
      emit(state.copyWith(
        status: LeaderboardStatus.success,
        topThree: topThree,
        fullList: list,
      ));
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
    emit(state.copyWith(
      status: LeaderboardStatus.loading,
      selectedCourseId: event.courseId,
    ));
    try {
      final list = await _repository.getLeaderboard(
        timeframe: state.timeframe,
        courseId: event.courseId,
      );
      final topThree = list.take(3).toList();
      emit(state.copyWith(
        status: LeaderboardStatus.success,
        topThree: topThree,
        fullList: list,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: LeaderboardStatus.failure,
        message: 'Reytingni yuklashda xatolik.',
      ));
    }
  }
}
