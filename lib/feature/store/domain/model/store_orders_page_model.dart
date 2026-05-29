import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/feature/store/domain/model/store_order_model.dart';
import 'package:qizlar_academy_mobile/feature/store/domain/model/store_pagination_model.dart';

class StoreOrdersPageModel extends Equatable {
  const StoreOrdersPageModel({required this.items, required this.pagination});

  final List<StoreOrderModel> items;
  final StorePaginationModel pagination;

  @override
  List<Object?> get props => [items, pagination];
}
