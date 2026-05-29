part of 'store_catalog_bloc.dart';

sealed class StoreCatalogEvent extends Equatable {
  const StoreCatalogEvent();

  @override
  List<Object?> get props => [];
}

class StoreCatalogStarted extends StoreCatalogEvent {
  const StoreCatalogStarted();
}

class StoreCatalogRetryRequested extends StoreCatalogEvent {
  const StoreCatalogRetryRequested();
}

class StoreCatalogLoadMoreRequested extends StoreCatalogEvent {
  const StoreCatalogLoadMoreRequested();
}

class StoreCatalogLoadMoreFailureConsumed extends StoreCatalogEvent {
  const StoreCatalogLoadMoreFailureConsumed();
}

class StoreCatalogLikeToggled extends StoreCatalogEvent {
  const StoreCatalogLikeToggled({required this.productId});

  final String productId;

  @override
  List<Object?> get props => [productId];
}

class StoreCatalogCategoryChanged extends StoreCatalogEvent {
  const StoreCatalogCategoryChanged({this.categoryId});

  final String? categoryId;

  @override
  List<Object?> get props => [categoryId];
}
