import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/logs/app_logger.dart';
import 'package:qizlar_academy_mobile/feature/certificates/domain/model/certificate_item_model.dart';
import 'package:qizlar_academy_mobile/feature/certificates/domain/repository/my_certificates_repository.dart';

part 'my_certificates_event.dart';
part 'my_certificates_state.dart';

class MyCertificatesBloc extends Bloc<MyCertificatesEvent, MyCertificatesState> {
  MyCertificatesBloc(this._repository) : super(const MyCertificatesState()) {
    on<MyCertificatesStarted>(_onStarted);
    on<MyCertificatesRetryRequested>(_onRetryRequested);
    on<MyCertificatesLoadMoreRequested>(_onLoadMoreRequested);
    on<MyCertificatesLoadMoreFailureConsumed>(_onLoadMoreFailureConsumed);
  }

  final MyCertificatesRepository _repository;

  static const int _pageSize = 10;

  Future<void> _onStarted(MyCertificatesStarted event, Emitter<MyCertificatesState> emit) async {
    emit(state.copyWith(status: MyCertificatesStatus.loading, items: const [], loadMoreFailed: false, isLoadingMore: false));
    await _loadFirstPage(emit);
  }

  Future<void> _onRetryRequested(MyCertificatesRetryRequested event, Emitter<MyCertificatesState> emit) async {
    emit(state.copyWith(status: MyCertificatesStatus.loading, loadMoreFailed: false));
    await _loadFirstPage(emit);
  }

  Future<void> _loadFirstPage(Emitter<MyCertificatesState> emit) async {
    try {
      final page = await _repository.fetchPage(pageNumber: 1, pageSize: _pageSize);
      emit(
        state.copyWith(
          status: MyCertificatesStatus.success,
          items: page.items,
          pageNumber: page.pagination.pageNumber,
          pageCount: page.pagination.pageCount,
          pageSize: page.pagination.pageSize,
          hasMore: page.pagination.hasNextPage,
          loadMoreFailed: false,
          isLoadingMore: false,
        ),
      );
    } catch (e, st) {
      AppLogger.e('MyCertificatesBloc: first page failed', error: e, stackTrace: st);
      emit(state.copyWith(status: MyCertificatesStatus.failure, items: const [], hasMore: false));
    }
  }

  Future<void> _onLoadMoreRequested(MyCertificatesLoadMoreRequested event, Emitter<MyCertificatesState> emit) async {
    if (state.status != MyCertificatesStatus.success) return;
    if (!state.hasMore || state.isLoadingMore) return;

    emit(state.copyWith(isLoadingMore: true, loadMoreFailed: false));

    final nextPage = state.pageNumber + 1;
    try {
      final page = await _repository.fetchPage(pageNumber: nextPage, pageSize: state.pageSize);
      final merged = List<CertificateItemModel>.from(state.items)..addAll(page.items);
      emit(
        state.copyWith(
          status: MyCertificatesStatus.success,
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
      AppLogger.e('MyCertificatesBloc: load more failed', error: e, stackTrace: st);
      emit(state.copyWith(isLoadingMore: false, loadMoreFailed: true));
    }
  }

  void _onLoadMoreFailureConsumed(MyCertificatesLoadMoreFailureConsumed event, Emitter<MyCertificatesState> emit) {
    emit(state.copyWith(loadMoreFailed: false));
  }
}
