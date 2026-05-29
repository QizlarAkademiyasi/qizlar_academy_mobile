import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/logs/app_logger.dart';
import 'package:qizlar_academy_mobile/feature/store/domain/model/store_order_model.dart';
import 'package:qizlar_academy_mobile/feature/store/domain/repository/store_repository.dart';

part 'store_order_detail_event.dart';
part 'store_order_detail_state.dart';

class StoreOrderDetailBloc extends Bloc<StoreOrderDetailEvent, StoreOrderDetailState> {
  StoreOrderDetailBloc(this._repository) : super(const StoreOrderDetailState()) {
    on<StoreOrderDetailStarted>(_onStarted);
    on<StoreOrderDetailRetryRequested>(_onRetryRequested);
  }

  final StoreRepository _repository;

  Future<void> _onStarted(StoreOrderDetailStarted event, Emitter<StoreOrderDetailState> emit) async {
    emit(state.copyWith(status: StoreOrderDetailStatus.loading, clearMessage: true));
    await _load(event.orderId, emit);
  }

  Future<void> _onRetryRequested(StoreOrderDetailRetryRequested event, Emitter<StoreOrderDetailState> emit) async {
    if (state.orderId.isEmpty) return;
    emit(state.copyWith(status: StoreOrderDetailStatus.loading, clearMessage: true));
    await _load(state.orderId, emit);
  }

  Future<void> _load(String orderId, Emitter<StoreOrderDetailState> emit) async {
    try {
      final order = await _repository.fetchOrderById(orderId);
      emit(state.copyWith(status: StoreOrderDetailStatus.success, orderId: orderId, order: order, clearMessage: true));
    } catch (e, st) {
      AppLogger.e('StoreOrderDetailBloc: load failed', error: e, stackTrace: st);
      emit(state.copyWith(status: StoreOrderDetailStatus.failure, orderId: orderId, message: e.toString()));
    }
  }
}
