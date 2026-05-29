part of 'store_order_detail_bloc.dart';

sealed class StoreOrderDetailEvent extends Equatable {
  const StoreOrderDetailEvent();

  @override
  List<Object?> get props => [];
}

class StoreOrderDetailStarted extends StoreOrderDetailEvent {
  const StoreOrderDetailStarted({required this.orderId});

  final String orderId;

  @override
  List<Object?> get props => [orderId];
}

class StoreOrderDetailRetryRequested extends StoreOrderDetailEvent {
  const StoreOrderDetailRetryRequested();
}
