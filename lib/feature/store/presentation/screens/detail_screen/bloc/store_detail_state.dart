part of 'store_detail_bloc.dart';

enum StoreDetailStatus { initial, loading, success, failure }

class StoreDetailState extends Equatable {
  const StoreDetailState({
    this.status = StoreDetailStatus.initial,
    this.product,
    this.selectedVariant,
    this.isOrdering = false,
    this.orderResult,
    this.orderError,
  });

  final StoreDetailStatus status;
  final StoreProductDetailModel? product;
  final StoreVariantModel? selectedVariant;
  final bool isOrdering;
  final StoreOrderResultModel? orderResult;
  final String? orderError;

  StoreDetailState copyWith({
    StoreDetailStatus? status,
    StoreProductDetailModel? product,
    StoreVariantModel? selectedVariant,
    bool? isOrdering,
    StoreOrderResultModel? orderResult,
    bool clearOrderResult = false,
    String? orderError,
    bool clearOrderError = false,
  }) {
    return StoreDetailState(
      status: status ?? this.status,
      product: product ?? this.product,
      selectedVariant: selectedVariant ?? this.selectedVariant,
      isOrdering: isOrdering ?? this.isOrdering,
      orderResult: clearOrderResult ? null : (orderResult ?? this.orderResult),
      orderError: clearOrderError ? null : (orderError ?? this.orderError),
    );
  }

  @override
  List<Object?> get props => [status, product, selectedVariant, isOrdering, orderResult, orderError];
}
