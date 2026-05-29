import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

class StoreOrderResultModel extends Equatable {
  const StoreOrderResultModel({
    required this.orderId,
    required this.status,
    required this.unitPrice,
    this.promoCode,
  });

  final String orderId;
  final String status;
  final int unitPrice;
  final String? promoCode;

  @override
  List<Object?> get props => [orderId, status, unitPrice, promoCode];
}
