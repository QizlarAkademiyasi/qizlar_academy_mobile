import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/logs/app_logger.dart';
import 'package:qizlar_academy_mobile/feature/daily_coin/domain/model/daily_streak_model.dart';
import 'package:qizlar_academy_mobile/feature/daily_coin/domain/repository/daily_coin_repository.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/home_stats_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/repository/home_repository.dart';
import 'package:qizlar_academy_mobile/feature/tasks/domain/model/task_item_model.dart';
import 'package:qizlar_academy_mobile/feature/tasks/domain/repository/tasks_repository.dart';

part 'tasks_event.dart';
part 'tasks_state.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  TasksBloc(
    this._tasksRepository,
    this._homeRepository,
    this._dailyCoinRepository,
  ) : super(const TasksState()) {
    on<TasksStarted>(_onStarted);
    on<TasksRefreshRequested>(_onRefreshRequested);
  }

  static const int _pageSize = 100;

  final TasksRepository _tasksRepository;
  final HomeRepository _homeRepository;
  final DailyCoinRepository _dailyCoinRepository;

  Future<void> _onStarted(TasksStarted event, Emitter<TasksState> emit) =>
      _load(emit, showLoading: true);

  Future<void> _onRefreshRequested(
    TasksRefreshRequested event,
    Emitter<TasksState> emit,
  ) => _load(emit, showLoading: false);

  Future<void> _load(
    Emitter<TasksState> emit, {
    required bool showLoading,
  }) async {
    if (showLoading) {
      emit(state.copyWith(status: TasksStatus.loading, clearMessage: true));
    }

    final statsFuture = _loadStats();
    final streakFuture = _loadStreak();

    try {
      final page = await _tasksRepository.fetchTasks(
        pageNumber: 1,
        pageSize: _pageSize,
      );
      final stats = await statsFuture;
      final streak = await streakFuture;
      emit(
        state.copyWith(
          status: TasksStatus.success,
          tasks: page.items,
          balance: stats?.coins ?? state.balance,
          streakCount: streak?.streakCount,
          clearStreakCount: streak == null,
          pageNumber: page.pagination.pageNumber,
          pageCount: page.pagination.pageCount,
          clearMessage: true,
        ),
      );
    } catch (error, stackTrace) {
      AppLogger.e(
        'TasksBloc: tasks load failed',
        error: error,
        stackTrace: stackTrace,
      );
      await statsFuture;
      await streakFuture;
      emit(
        state.copyWith(
          status: TasksStatus.failure,
          message: 'tasks_load_failed',
        ),
      );
    }
  }

  Future<HomeStatsModel?> _loadStats() async {
    try {
      return await _homeRepository.getStats();
    } catch (error, stackTrace) {
      AppLogger.w(
        'TasksBloc: balance load failed',
        error: error,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  Future<DailyStreakModel?> _loadStreak() async {
    try {
      return await _dailyCoinRepository.fetchStreak();
    } catch (error, stackTrace) {
      AppLogger.w(
        'TasksBloc: streak load failed',
        error: error,
        stackTrace: stackTrace,
      );
      return null;
    }
  }
}
