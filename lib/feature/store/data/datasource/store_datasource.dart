import 'package:qizlar_academy_mobile/feature/store/domain/model/store_order_model.dart';
import 'package:qizlar_academy_mobile/feature/store/domain/model/store_order_result_model.dart';
import 'package:qizlar_academy_mobile/feature/store/domain/model/store_orders_page_model.dart';
import 'package:qizlar_academy_mobile/feature/store/domain/model/store_category_model.dart';
import 'package:qizlar_academy_mobile/feature/store/domain/model/store_product_detail_model.dart';
import 'package:qizlar_academy_mobile/feature/store/domain/model/store_products_page_model.dart';

abstract class StoreDatasource {
  Future<List<StoreCategoryModel>> fetchCategories();

  Future<StoreProductsPageModel> fetchProducts({required int pageNumber, required int pageSize, String? categoryId});

  Future<StoreProductDetailModel> fetchProductById(String id);

  Future<void> toggleLike(String productId);

  Future<StoreOrderResultModel> createOrder({required String variantId});

  Future<StoreOrdersPageModel> fetchMyOrders({required int pageNumber, required int pageSize});

  Future<StoreOrderModel> fetchOrderById(String orderId);
}
