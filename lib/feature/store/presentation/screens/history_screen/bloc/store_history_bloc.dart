import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/logs/app_logger.dart';
import 'package:qizlar_academy_mobile/feature/store/domain/model/store_order_model.dart';
import 'package:qizlar_academy_mobile/feature/store/domain/repository/store_repository.dart';

part 'store_history_event.dart';
part 'store_history_state.dart';

class StoreHistoryBloc extends Bloc<StoreHistoryEvent, StoreHistoryState> {
  StoreHistoryBloc(this._repository) : super(const StoreHistoryState()) {
    on<StoreHistoryStarted>(_onStarted);
    on<StoreHistoryRetryRequested>(_onRetryRequested);
    on<StoreHistoryLoadMoreRequested>(_onLoadMoreRequested);
    on<StoreHistoryLoadMoreFailureConsumed>(_onLoadMoreFailureConsumed);
  }

  final StoreRepository _repository;

  static const int _pageSize = 10;

  Future<void> _onStarted(StoreHistoryStarted event, Emitter<StoreHistoryState> emit) async {
    emit(state.copyWith(status: StoreHistoryStatus.loading, items: const [], clearMessage: true, loadMoreFailed: false, isLoadingMore: false));
    await _loadFirstPage(emit);
  }

  Future<void> _onRetryRequested(StoreHistoryRetryRequested event, Emitter<StoreHistoryState> emit) async {
    emit(state.copyWith(status: StoreHistoryStatus.loading, clearMessage: true, loadMoreFailed: false));
    await _loadFirstPage(emit);
  }

  Future<void> _loadFirstPage(Emitter<StoreHistoryState> emit) async {
    try {
      final page = await _repository.fetchMyOrders(pageNumber: 1, pageSize: _pageSize);
      emit(state.copyWith(
        status: StoreHistoryStatus.success,
        items: page.items,
        pageNumber: page.pagination.pageNumber,
        pageCount: page.pagination.pageCount,
        pageSize: page.pagination.pageSize,
        hasMore: page.pagination.hasNextPage,
        clearMessage: true,
        loadMoreFailed: false,
        isLoadingMore: false,
      ));
    } catch (e, st) {
      AppLogger.e('StoreHistoryBloc: first page failed', error: e, stackTrace: st);
      emit(state.copyWith(status: StoreHistoryStatus.failure, items: const [], hasMore: false, clearMessage: true));
    }
  }

  Future<void> _onLoadMoreRequested(StoreHistoryLoadMoreRequested event, Emitter<StoreHistoryState> emit) async {
    if (state.status != StoreHistoryStatus.success) return;
    if (!state.hasMore || state.isLoadingMore) return;

    emit(state.copyWith(isLoadingMore: true, loadMoreFailed: false));

    final nextPage = state.pageNumber + 1;
    try {
      final page = await _repository.fetchMyOrders(pageNumber: nextPage, pageSize: state.pageSize);
      final merged = List<StoreOrderModel>.from(state.items)..addAll(page.items);
      emit(state.copyWith(
        status: StoreHistoryStatus.success,
        items: merged,
        pageNumber: page.pagination.pageNumber,
        pageCount: page.pagination.pageCount,
        pageSize: page.pagination.pageSize,
        hasMore: page.pagination.hasNextPage,
        isLoadingMore: false,
        loadMoreFailed: false,
      ));
    } catch (e, st) {
      AppLogger.e('StoreHistoryBloc: load more failed', error: e, stackTrace: st);
      emit(state.copyWith(isLoadingMore: false, loadMoreFailed: true));
    }
  }

  void _onLoadMoreFailureConsumed(StoreHistoryLoadMoreFailureConsumed event, Emitter<StoreHistoryState> emit) {
    emit(state.copyWith(loadMoreFailed: false));
  }
}
