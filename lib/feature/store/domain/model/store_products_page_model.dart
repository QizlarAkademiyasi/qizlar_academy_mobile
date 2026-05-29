import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/feature/store/domain/model/store_pagination_model.dart';
import 'package:qizlar_academy_mobile/feature/store/domain/model/store_product_item_model.dart';

class StoreProductsPageModel extends Equatable {
  const StoreProductsPageModel({required this.items, required this.pagination});

  final List<StoreProductItemModel> items;
  final StorePaginationModel pagination;

  @override
  List<Object?> get props => [items, pagination];
}
