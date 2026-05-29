import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/logs/app_logger.dart';
import 'package:qizlar_academy_mobile/feature/daily_coin/domain/model/daily_streak_model.dart';
import 'package:qizlar_academy_mobile/feature/daily_coin/domain/repository/daily_coin_repository.dart';

part 'daily_coin_event.dart';
part 'daily_coin_state.dart';

class DailyCoinBloc extends Bloc<DailyCoinEvent, DailyCoinState> {
  DailyCoinBloc(this._repository) : super(const DailyCoinState()) {
    on<DailyCoinStarted>(_onStarted);
    on<DailyCoinRefreshed>(_onRefreshed);
    on<DailyCoinClaimPressed>(_onClaimPressed);
  }

  final DailyCoinRepository _repository;

  Future<void> _onStarted(
    DailyCoinStarted event,
    Emitter<DailyCoinState> emit,
  ) async {
    await _loadStreak(emit);
  }

  Future<void> _onRefreshed(
    DailyCoinRefreshed event,
    Emitter<DailyCoinState> emit,
  ) async {
    await _loadStreak(emit);
  }

  Future<void> _loadStreak(Emitter<DailyCoinState> emit) async {
    emit(state.copyWith(status: DailyCoinStatus.loading, clearMessage: true));
    try {
      final streak = await _repository.fetchStreak();
      emit(state.copyWith(status: DailyCoinStatus.success, streak: streak));
    } catch (error, stackTrace) {
      AppLogger.e(
        'DailyCoinBloc: fetch streak failed',
        error: error,
        stackTrace: stackTrace,
      );
      emit(
        state.copyWith(status: DailyCoinStatus.failure, message: 'load_failed'),
      );
    }
  }

  Future<void> _onClaimPressed(
    DailyCoinClaimPressed event,
    Emitter<DailyCoinState> emit,
  ) async {
    if (state.streak?.isClaimed == true) return;
    emit(state.copyWith(status: DailyCoinStatus.claiming, clearMessage: true));
    try {
      await _repository.claimStreak();
      final streak = await _repository.fetchStreak();
      emit(state.copyWith(status: DailyCoinStatus.success, streak: streak));
    } catch (error, stackTrace) {
      AppLogger.e(
        'DailyCoinBloc: claim failed',
        error: error,
        stackTrace: stackTrace,
      );
      emit(
        state.copyWith(
          status: DailyCoinStatus.failure,
          message: 'claim_failed',
        ),
      );
    }
  }
}
