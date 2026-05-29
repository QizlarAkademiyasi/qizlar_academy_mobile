part of 'store_catalog_bloc.dart';

enum StoreCatalogStatus { initial, loading, success, failure }

class _StoreCategoryCacheEntry extends Equatable {
  const _StoreCategoryCacheEntry({
    required this.items,
    required this.pageNumber,
    required this.pageCount,
    required this.pageSize,
    required this.hasMore,
  });

  final List<StoreProductItemModel> items;
  final int pageNumber;
  final int pageCount;
  final int pageSize;
  final bool hasMore;

  @override
  List<Object?> get props => [items, pageNumber, pageCount, pageSize, hasMore];
}

class StoreCatalogState extends Equatable {
  const StoreCatalogState({
    this.status = StoreCatalogStatus.initial,
    this.categories = const [],
    this.items = const [],
    this.pageNumber = 1,
    this.pageCount = 1,
    this.pageSize = 10,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.loadMoreFailed = false,
    this.selectedCategoryId,
    this.categoryCache = const {},
    this.message,
  });

  final StoreCatalogStatus status;
  final List<StoreCategoryModel> categories;
  final List<StoreProductItemModel> items;
  final int pageNumber;
  final int pageCount;
  final int pageSize;
  final bool hasMore;
  final bool isLoadingMore;
  final bool loadMoreFailed;
  final String? selectedCategoryId;
  final Map<String?, _StoreCategoryCacheEntry> categoryCache;
  final String? message;

  StoreCatalogState copyWith({
    StoreCatalogStatus? status,
    List<StoreCategoryModel>? categories,
    List<StoreProductItemModel>? items,
    int? pageNumber,
    int? pageCount,
    int? pageSize,
    bool? hasMore,
    bool? isLoadingMore,
    bool? loadMoreFailed,
    String? selectedCategoryId,
    bool clearSelectedCategory = false,
    Map<String?, _StoreCategoryCacheEntry>? categoryCache,
    String? message,
    bool clearMessage = false,
  }) {
    return StoreCatalogState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      items: items ?? this.items,
      pageNumber: pageNumber ?? this.pageNumber,
      pageCount: pageCount ?? this.pageCount,
      pageSize: pageSize ?? this.pageSize,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      loadMoreFailed: loadMoreFailed ?? this.loadMoreFailed,
      selectedCategoryId: clearSelectedCategory ? null : (selectedCategoryId ?? this.selectedCategoryId),
      categoryCache: categoryCache ?? this.categoryCache,
      message: clearMessage ? null : (message ?? this.message),
    );
  }

  @override
  List<Object?> get props => [status, categories, items, pageNumber, pageCount, pageSize, hasMore, isLoadingMore, loadMoreFailed, selectedCategoryId, categoryCache, message];
}
