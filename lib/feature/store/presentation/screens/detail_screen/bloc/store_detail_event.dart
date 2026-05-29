part of 'store_detail_bloc.dart';

sealed class StoreDetailEvent extends Equatable {
  const StoreDetailEvent();

  @override
  List<Object?> get props => [];
}

class StoreDetailStarted extends StoreDetailEvent {
  const StoreDetailStarted({required this.productId});

  final String productId;

  @override
  List<Object?> get props => [productId];
}

class StoreDetailRetryRequested extends StoreDetailEvent {
  const StoreDetailRetryRequested();
}

class StoreDetailVariantSelected extends StoreDetailEvent {
  const StoreDetailVariantSelected({required this.variantId});

  final String variantId;

  @override
  List<Object?> get props => [variantId];
}

class StoreDetailOrderRequested extends StoreDetailEvent {
  const StoreDetailOrderRequested();
}

class StoreDetailLikeToggled extends StoreDetailEvent {
  const StoreDetailLikeToggled();
}

class StoreDetailOrderResultConsumed extends StoreDetailEvent {
  const StoreDetailOrderResultConsumed();
}
