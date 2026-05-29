import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/logs/app_logger.dart';
import 'package:qizlar_academy_mobile/feature/store/domain/model/store_category_model.dart';
import 'package:qizlar_academy_mobile/feature/store/domain/model/store_product_item_model.dart';
import 'package:qizlar_academy_mobile/feature/store/domain/repository/store_repository.dart';

part 'store_catalog_event.dart';
part 'store_catalog_state.dart';

class StoreCatalogBloc extends Bloc<StoreCatalogEvent, StoreCatalogState> {
  StoreCatalogBloc(this._repository) : super(const StoreCatalogState()) {
    on<StoreCatalogStarted>(_onStarted);
    on<StoreCatalogRetryRequested>(_onRetryRequested);
    on<StoreCatalogLoadMoreRequested>(_onLoadMoreRequested);
    on<StoreCatalogLoadMoreFailureConsumed>(_onLoadMoreFailureConsumed);
    on<StoreCatalogLikeToggled>(_onLikeToggled);
    on<StoreCatalogCategoryChanged>(_onCategoryChanged);
  }

  final StoreRepository _repository;

  static const int _pageSize = 10;

  Future<void> _onStarted(StoreCatalogStarted event, Emitter<StoreCatalogState> emit) async {
    emit(state.copyWith(status: StoreCatalogStatus.loading, items: const [], clearMessage: true, loadMoreFailed: false, isLoadingMore: false));
    await _loadCategoriesAndFirstPage(emit);
  }

  Future<void> _onRetryRequested(StoreCatalogRetryRequested event, Emitter<StoreCatalogState> emit) async {
    emit(state.copyWith(status: StoreCatalogStatus.loading, clearMessage: true, loadMoreFailed: false));
    await _loadCategoriesAndFirstPage(emit);
  }

  Future<void> _onCategoryChanged(StoreCatalogCategoryChanged event, Emitter<StoreCatalogState> emit) async {
    final sameCategory = event.categoryId == state.selectedCategoryId;
    if (sameCategory) return;

    final cached = state.categoryCache[event.categoryId];
    if (cached != null) {
      emit(
        state.copyWith(
          status: StoreCatalogStatus.success,
          selectedCategoryId: event.categoryId,
          clearSelectedCategory: event.categoryId == null,
          items: cached.items,
          pageNumber: cached.pageNumber,
          pageCount: cached.pageCount,
          pageSize: cached.pageSize,
          hasMore: cached.hasMore,
          clearMessage: true,
          loadMoreFailed: false,
          isLoadingMore: false,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: StoreCatalogStatus.loading,
        selectedCategoryId: event.categoryId,
        clearSelectedCategory: event.categoryId == null,
        items: const [],
        clearMessage: true,
        loadMoreFailed: false,
        isLoadingMore: false,
      ),
    );
    await _loadFirstPage(emit);
  }

  Future<void> _loadCategoriesAndFirstPage(Emitter<StoreCatalogState> emit) async {
    try {
      final categories = await _repository.fetchCategories();
      final selectedCategory = _resolveSelectedCategory(state.selectedCategoryId, categories);
      final page = await _repository.fetchProducts(pageNumber: 1, pageSize: _pageSize, categoryId: selectedCategory);
      final cacheEntry = _StoreCategoryCacheEntry(
        items: page.items,
        pageNumber: page.pagination.pageNumber,
        pageCount: page.pagination.pageCount,
        pageSize: page.pagination.pageSize,
        hasMore: page.pagination.hasNextPage,
      );
      final nextCache = Map<String?, _StoreCategoryCacheEntry>.from(state.categoryCache)..[selectedCategory] = cacheEntry;
      emit(
        state.copyWith(
          status: StoreCatalogStatus.success,
          categories: categories,
          selectedCategoryId: selectedCategory,
          items: page.items,
          pageNumber: page.pagination.pageNumber,
          pageCount: page.pagination.pageCount,
          pageSize: page.pagination.pageSize,
          hasMore: page.pagination.hasNextPage,
          categoryCache: nextCache,
          clearMessage: true,
          loadMoreFailed: false,
          isLoadingMore: false,
        ),
      );
    } catch (e, st) {
      AppLogger.e('StoreCatalogBloc: first page failed', error: e, stackTrace: st);
      emit(state.copyWith(status: StoreCatalogStatus.failure, items: const [], hasMore: false, clearMessage: true));
    }
  }

  Future<void> _loadFirstPage(Emitter<StoreCatalogState> emit) async {
    try {
      final page = await _repository.fetchProducts(pageNumber: 1, pageSize: _pageSize, categoryId: state.selectedCategoryId);
      final cacheEntry = _StoreCategoryCacheEntry(
        items: page.items,
        pageNumber: page.pagination.pageNumber,
        pageCount: page.pagination.pageCount,
        pageSize: page.pagination.pageSize,
        hasMore: page.pagination.hasNextPage,
      );
      final nextCache = Map<String?, _StoreCategoryCacheEntry>.from(state.categoryCache)..[state.selectedCategoryId] = cacheEntry;
      emit(
        state.copyWith(
          status: StoreCatalogStatus.success,
          items: page.items,
          pageNumber: page.pagination.pageNumber,
          pageCount: page.pagination.pageCount,
          pageSize: page.pagination.pageSize,
          hasMore: page.pagination.hasNextPage,
          categoryCache: nextCache,
          clearMessage: true,
          loadMoreFailed: false,
          isLoadingMore: false,
        ),
      );
    } catch (e, st) {
      AppLogger.e('StoreCatalogBloc: first page failed', error: e, stackTrace: st);
      emit(state.copyWith(status: StoreCatalogStatus.failure, items: const [], hasMore: false, clearMessage: true));
    }
  }

  String? _resolveSelectedCategory(String? selectedCategoryId, List<StoreCategoryModel> categories) {
    if (selectedCategoryId == null || selectedCategoryId.isEmpty) return null;
    final exists = categories.any((c) => c.id == selectedCategoryId);
    return exists ? selectedCategoryId : null;
  }

  Future<void> _onLoadMoreRequested(StoreCatalogLoadMoreRequested event, Emitter<StoreCatalogState> emit) async {
    if (state.status != StoreCatalogStatus.success) return;
    if (!state.hasMore || state.isLoadingMore) return;

    emit(state.copyWith(isLoadingMore: true, loadMoreFailed: false));

    final nextPage = state.pageNumber + 1;
    try {
      final page = await _repository.fetchProducts(pageNumber: nextPage, pageSize: state.pageSize, categoryId: state.selectedCategoryId);
      final merged = List<StoreProductItemModel>.from(state.items)..addAll(page.items);
      final cacheEntry = _StoreCategoryCacheEntry(
        items: merged,
        pageNumber: page.pagination.pageNumber,
        pageCount: page.pagination.pageCount,
        pageSize: page.pagination.pageSize,
        hasMore: page.pagination.hasNextPage,
      );
      final nextCache = Map<String?, _StoreCategoryCacheEntry>.from(state.categoryCache)..[state.selectedCategoryId] = cacheEntry;
      emit(
        state.copyWith(
          status: StoreCatalogStatus.success,
          items: merged,
          pageNumber: page.pagination.pageNumber,
          pageCount: page.pagination.pageCount,
          pageSize: page.pagination.pageSize,
          hasMore: page.pagination.hasNextPage,
          isLoadingMore: false,
          loadMoreFailed: false,
          categoryCache: nextCache,
        ),
      );
    } catch (e, st) {
      AppLogger.e('StoreCatalogBloc: load more failed', error: e, stackTrace: st);
      emit(state.copyWith(isLoadingMore: false, loadMoreFailed: true));
    }
  }

  void _onLoadMoreFailureConsumed(StoreCatalogLoadMoreFailureConsumed event, Emitter<StoreCatalogState> emit) {
    emit(state.copyWith(loadMoreFailed: false));
  }

  Future<void> _onLikeToggled(StoreCatalogLikeToggled event, Emitter<StoreCatalogState> emit) async {
    final index = state.items.indexWhere((p) => p.id == event.productId);
    if (index == -1) return;

    final updated = List<StoreProductItemModel>.from(state.items);
    updated[index] = updated[index].copyWith(isLiked: !updated[index].isLiked);
    emit(state.copyWith(items: updated));

    try {
      await _repository.toggleLike(event.productId);
    } catch (e, st) {
      AppLogger.e('StoreCatalogBloc: like toggle failed', error: e, stackTrace: st);
      final reverted = List<StoreProductItemModel>.from(state.items);
      reverted[index] = reverted[index].copyWith(isLiked: !reverted[index].isLiked);
      emit(state.copyWith(items: reverted));
    }
  }
}
