import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/logs/app_logger.dart';
import 'package:qizlar_academy_mobile/feature/my_activity/domain/model/activity_stats_model.dart';
import 'package:qizlar_academy_mobile/feature/my_activity/domain/repository/my_activity_repository.dart';

part 'my_activity_event.dart';
part 'my_activity_state.dart';

class MyActivityBloc extends Bloc<MyActivityEvent, MyActivityState> {
  MyActivityBloc(this._repository) : super(const MyActivityState()) {
    on<MyActivityStarted>(_onStarted);
    on<MyActivityRetryRequested>(_onRetryRequested);
    on<MyActivityScopeChanged>(_onScopeChanged);
  }

  final MyActivityRepository _repository;

  Future<void> _onStarted(
    MyActivityStarted event,
    Emitter<MyActivityState> emit,
  ) async {
    await _load(emit);
  }

  Future<void> _onRetryRequested(
    MyActivityRetryRequested event,
    Emitter<MyActivityState> emit,
  ) async {
    await _load(emit);
  }

  Future<void> _load(Emitter<MyActivityState> emit) async {
    emit(state.copyWith(status: MyActivityStatus.loading, clearMessage: true));
    try {
      final weeklyMonthly = await Future.wait([
        _repository.fetchStats(MyActivityStatsScope.weekly),
        _repository.fetchStats(MyActivityStatsScope.monthly),
      ]);
      emit(
        state.copyWith(
          status: MyActivityStatus.success,
          weekly: weeklyMonthly[0],
          monthly: weeklyMonthly[1],
        ),
      );
    } catch (error, stackTrace) {
      AppLogger.e(
        'MyActivityBloc: load failed',
        error: error,
        stackTrace: stackTrace,
      );
      emit(
        state.copyWith(
          status: MyActivityStatus.failure,
          message: 'load_failed',
        ),
      );
    }
  }

  void _onScopeChanged(
    MyActivityScopeChanged event,
    Emitter<MyActivityState> emit,
  ) {
    emit(state.copyWith(selectedScope: event.scope));
  }
}
