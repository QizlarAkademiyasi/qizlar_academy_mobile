import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/logs/app_logger.dart';
import 'package:qizlar_academy_mobile/feature/vacancy/domain/model/vacancy_item_model.dart';
import 'package:qizlar_academy_mobile/feature/vacancy/domain/repository/vacancy_repository.dart';

part 'vacancy_event.dart';
part 'vacancy_state.dart';

class VacancyBloc extends Bloc<VacancyEvent, VacancyState> {
  VacancyBloc(this._repository) : super(const VacancyState()) {
    on<VacancyStarted>(_onStarted);
    on<VacancyRetryRequested>(_onRetryRequested);
    on<VacancyLoadMoreRequested>(_onLoadMoreRequested);
    on<VacancyLoadMoreFailureConsumed>(_onLoadMoreFailureConsumed);
  }

  final VacancyRepository _repository;

  static const int _pageSize = 10;

  Future<void> _onStarted(VacancyStarted event, Emitter<VacancyState> emit) async {
    emit(state.copyWith(status: VacancyStatus.loading, items: const [], clearMessage: true, loadMoreFailed: false, isLoadingMore: false));
    await _loadFirstPage(emit);
  }

  Future<void> _onRetryRequested(VacancyRetryRequested event, Emitter<VacancyState> emit) async {
    emit(state.copyWith(status: VacancyStatus.loading, clearMessage: true, loadMoreFailed: false));
    await _loadFirstPage(emit);
  }

  Future<void> _loadFirstPage(Emitter<VacancyState> emit) async {
    try {
      final page = await _repository.fetchPage(pageNumber: 1, pageSize: _pageSize);
      emit(
        state.copyWith(
          status: VacancyStatus.success,
          items: page.items,
          pageNumber: page.pagination.pageNumber,
          pageCount: page.pagination.pageCount,
          pageSize: page.pagination.pageSize,
          hasMore: page.pagination.hasNextPage,
          clearMessage: true,
          loadMoreFailed: false,
          isLoadingMore: false,
        ),
      );
    } catch (e, st) {
      AppLogger.e('VacancyBloc: first page failed', error: e, stackTrace: st);
      emit(state.copyWith(status: VacancyStatus.failure, items: const [], hasMore: false, clearMessage: true));
    }
  }

  Future<void> _onLoadMoreRequested(VacancyLoadMoreRequested event, Emitter<VacancyState> emit) async {
    if (state.status != VacancyStatus.success) return;
    if (!state.hasMore || state.isLoadingMore) return;

    emit(state.copyWith(isLoadingMore: true, loadMoreFailed: false));

    final nextPage = state.pageNumber + 1;
    try {
      final page = await _repository.fetchPage(pageNumber: nextPage, pageSize: state.pageSize);
      final merged = List<VacancyItemModel>.from(state.items)..addAll(page.items);
      emit(
        state.copyWith(
          status: VacancyStatus.success,
          items: merged,
          pageNumber: page.pagination.pageNumber,
          pageCount: page.pagination.pageCount,
          pageSize: page.pagination.pageSize,
          hasMore: page.pagination.hasNextPage,
          isLoadingMore: false,
          loadMoreFailed: false,
        ),
      );
    } catch (e, st) {
      AppLogger.e('VacancyBloc: load more failed', error: e, stackTrace: st);
      emit(state.copyWith(isLoadingMore: false, loadMoreFailed: true));
    }
  }

  void _onLoadMoreFailureConsumed(VacancyLoadMoreFailureConsumed event, Emitter<VacancyState> emit) {
    emit(state.copyWith(loadMoreFailed: false));
  }
}
