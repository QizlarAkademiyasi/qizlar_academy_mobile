import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

class StoreStockModel extends Equatable {
  const StoreStockModel({required this.quantity, required this.reserved, required this.available});

  final int quantity;
  final int reserved;
  final int available;

  bool get isSoldOut => available <= 0;

  @override
  List<Object?> get props => [quantity, reserved, available];
}
