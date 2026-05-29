part of 'store_order_detail_bloc.dart';

enum StoreOrderDetailStatus { initial, loading, success, failure }

class StoreOrderDetailState extends Equatable {
  const StoreOrderDetailState({
    this.status = StoreOrderDetailStatus.initial,
    this.orderId = '',
    this.order,
    this.message,
  });

  final StoreOrderDetailStatus status;
  final String orderId;
  final StoreOrderModel? order;
  final String? message;

  StoreOrderDetailState copyWith({
    StoreOrderDetailStatus? status,
    String? orderId,
    StoreOrderModel? order,
    String? message,
    bool clearMessage = false,
  }) {
    return StoreOrderDetailState(
      status: status ?? this.status,
      orderId: orderId ?? this.orderId,
      order: order ?? this.order,
      message: clearMessage ? null : (message ?? this.message),
    );
  }

  @override
  List<Object?> get props => [status, orderId, order, message];
}
